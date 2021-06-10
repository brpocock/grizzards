(in-package :Skyline-Tool)

(defvar *machine* :unknown)
(defvar *fixed-banks*)
(defvar *text-banks*)
(defvar *music-banks*)
(defvar *maps-banks*)
(defvar *max-banks*)

(define-constant +exits-order+
    '(north south east west door1 door2)
  :test 'equalp)

(define-constant +facing-order+
    '(right left down up)
  :test 'equalp)

(defstruct board
  tmx
  specials
  layout
  pf-colors
  bk-color
  exits
  layout-tiles*)

(defun layout-equal (board-a board-b)
  (let ((layout-a (board-layout board-a))
        (layout-b (board-layout board-b)))
    (dotimes (y 8)
      (dotimes (x 8)
        (unless (equal (aref layout-a x y) (aref layout-b x y))
          (return-from layout-equal nil)))))
  t)

(defun bitmap-vector (bitmap)
  (loop 
     with num-bits = (reduce #'* (array-dimensions bitmap))
     with vector = (make-array num-bits :element-type 'bit)
     for i from 0 upto num-bits
     do (setf (elt vector i) (row-major-aref bitmap i))
     finally (return vector)))

(eval-when (:compile-toplevel)
  (defun a-an (s)
    "“a” or  “an” depending  on whether S  begins with a vowel or H."
    (if-let (c (find-if #'alpha-char-p (princ-to-string s)))
      (if (find (char-downcase c) "aoeuih")
          "an"
          "a")
      "a")))

(defmacro define-find-unique (thing type)
  (let ((cache-name (format-symbol *package* "*~a-CACHE*" thing))
        (counter-name (format-symbol *package* "*~a-NEXT-ID*" thing)))
    `(progn
       (defvar ,cache-name (make-hash-table :test 'equalp))
       (defvar ,counter-name 0)
       (defun ,(format-symbol *package* "FIND-~a" thing) (,thing)
         (check-type ,thing ,type
                     ,(format nil "a ~:(~a~) — which is ~a ~s"
                              thing (a-an type) type))
         (or (gethash ,thing ,cache-name)
             (setf (gethash ,thing ,cache-name) (incf ,counter-name)))))))

(define-find-unique tile-bitmap (array * (4 7)))
(define-find-unique sprite-bitmap (array * (8 7)))

(defun flip-bitmap (bitmap)
  "Reverse a bitmap horizontally. DESTRUCTIVE."
  (let ((width (array-dimension bitmap 0)))
    (assert (evenp width) (bitmap)
            "FLIP-BITMAP requires an even width; bitmap's width is ~:dpx" 
            width)
    (dotimes (y (array-dimension bitmap 1))
      (dotimes (x (/ width 2))
        (rotatef (aref bitmap x y) (aref bitmap (- width x) y)))))
  bitmap)

(defun flip-bitmap-if (boolean bitmap)
  (if boolean
      (flip-bitmap bitmap)
      bitmap))

(defun combine-tiles-bitmap (one other left-or-right)
  (let ((left (flip-bitmap-if (eql left-or-right :right)
                              (find-tile-bitmap one)))
        (right (flip-bitmap-if (eql left-or-right :left)
                               (find-tile-bitmap other))))
    (let ((combined (make-array (list (* 2 (tile-width))
                                      (tile-height))
                                :element-type 'bit)))
      (dotimes (y (tile-height))
        (dotimes (x (tile-width))
          (setf (aref combined x y) 
                (aref (if (eql left-or-right :left) left right) x y)
                
                (aref combined (+ x 4) y)
                (aref (if (eql left-or-right :left) right left) x y))))
      combined)))

(defun find-2600-tile (one-tile other-tile left-or-right)
  (check-type left-or-right (member :left :right))
  (find-tile-bitmap (combine-tiles-bitmap one-tile other-tile left-or-right)))

(defmethod board-layout-tiles :before ((board board))
  (if (and (slot-boundp board 'layout-tiles*)
           (slot-value board 'layout-tiles*))
      
      (slot-value board 'layout-tiles*) 
      (let ((grid (board-layout board))
            (tiles nil))
        (assert (= (tile-width) 4))
        (dotimes (y (tile-height))
          (dolist (tile
                    (list
                     (find-2600-tile (aref grid 0 y) (aref grid 1 y) :left)
                     (find-2600-tile (aref grid 2 y) (aref grid 3 y) :right)
                     (find-2600-tile (aref grid 4 y) (aref grid 5 y) :left)
                     (find-2600-tile (aref grid 6 y) (aref grid 7 y) :right)))
            (pushnew tile tiles :test 'equal)))
        (setf (slot-value board 'layout-tiles*) tiles))))

(defun tile-hash (left right big-endian-p)
  (check-type left (integer 0 *))
  (check-type right (integer 0 *))
  (list left right (!! big-endian-p)))

(defun board-empty-p (board)
  (dotimes (y (array-dimension board 1))
    (dotimes (x (array-dimension board 0))
      (when (plusp (aref board x y))
        (return-from board-empty-p nil))))
  t)

(defun extract-pf-colors-for-layout (grid)
  (multiple-value-bind (background rendered)
      (extract-bk-color-for-layout grid)
    (loop for row from 0 to 7
       collecting (most-popular-color-in-hash
                   (let ((hash (color-popularity-in-region
                                rendered
                                0 (1- (* 8 8))
                                (* 7 row) (1- (* 7 (1+ row))))))
                     (setf (gethash background hash) -1))))))

(defun color-popularity-in-region (pixels 
                                   &optional (x₀ 0) (y₀ 0)
                                             (x₁ (array-dimension pixels 0)) 
                                             (y₁ (array-dimension pixels 1)))
  (let ((popularity (make-hash-table :test 'equalp)))
    (loop for x from x₀ upto x₁
       do
         (loop for y from y₀ upto y₁
            do (incf 
                (gethash (apply #'find-nearest-in-palette
                                (machine-palette)
                                (aref pixels x y))
                         popularity 0))))))

(defun |Make| (&rest args)
  (run-program (cons "make" args)
               :output *standard-output*
               :error-output *error-output*))

(defun ensure-tileset-png-is-fresh ()
  (let ((png-written (file-write-date "art/tilesets/Tiles.tia.png"))
        (xcf-written (file-write-date "art/tilesets/Tiles.tia.xcf")))
    (unless (>= png-written xcf-written)
      (|Make| "art/tilesets/Tiles.tia.png"))))

(defun most-popular-color-in-hash (popularity-hash)
  (let ((most-popular nil) (most-popular-count 0))
    (maphash (lambda (color popularity)
               (when (> popularity most-popular-count)
                 (setf most-popular color
                       most-popular-count popularity))) 
             popularity-hash)
    most-popular))

(defun find-tile-bitmaps ()
  (ensure-tileset-png-is-fresh)
  (let ((tiles.png (png-read:read-png-file "art/tilesets/Tiles.tia.png")))
    (let* ((tiles-width (/ (png-read:width tiles.png) 4))
           (tiles-height (/ (png-read:height tiles.png) 7))
           (pixels (png->palette tiles-height tiles-width
                                 (png-read:image-data tiles.png)))
           (tiles (make-array (* tiles-width tiles-height)))
           (i 0))
      (dotimes (y tiles-height)
        (dotimes (x tiles-width)
          (setf (aref tiles i) (aref pixels x y))
          (incf i)))
      tiles)))

(defun set-tile (pixels tile-x tile-y tiles which-tile)
  (dotimes (y 7)
    (dotimes (x 4)
      (setf (aref pixels (+ x (* 4 tile-x)) (+ y (* 7 tile-y)))
            (aref (aref tiles which-tile) x y)))))

(defun tile-grid->bitmap (grid)
  (let ((pixels (make-array (list (* 4 (array-dimension grid 0))
                                  (* 7 (array-dimension grid 1))
                                  4)))
        (tile-bitmaps (find-tile-bitmaps)))
    (dotimes (y (array-dimension grid 1))
      (dotimes (x (array-dimension grid 0)) 
        (set-tile pixels x y tile-bitmaps (aref grid x y))))
    pixels))

(defun extract-bk-color-for-layout (grid)
  (let* ((rendered (tile-grid->bitmap grid))
         (popularity 
          (color-popularity-in-region rendered)))
    (values (most-popular-color-in-hash popularity)
            rendered)))

(defun make-board-if-layout-present (layout)
  (unless (board-empty-p layout)
    (make-board 
     :layout layout
     :pf-colors (extract-pf-colors-for-layout layout)
     :bk-color (extract-bk-color-for-layout layout))))

(defun compute-default-exits (boards-grid x y &key boards-x boards-y)
  (list (unless (or (= y 0)
                    (null (aref boards-grid x (1- y))))
          (+ (* (1- y) boards-x) x))
        (unless (or (= y (1- boards-y))
                    (null (aref boards-grid x (1+ y))))
          (+ (* (1+ y) boards-x) x))
        (unless (or (= x 0)
                    (null (aref boards-grid (1- x) y)))
          (+ (* y boards-x) (1- x)))
        (unless (or (= x (1- boards-y))
                    (null (aref boards-grid (1+ x) y)))
          (+ (* y boards-x) (1+ x)))))

(defun boards-from-levels (levels board-width board-height)
  (check-type levels cons)
  (check-type board-width (integer 1 *))
  (check-type board-height (integer 1 *))
  (let ((boards nil))
    (dolist (level levels)
      (let* ((grid (level-grid level))
             (grid-width (array-dimension grid 0))
             (grid-height (array-dimension grid 1))
             (boards-x (floor grid-width board-width))
             (boards-y (floor grid-height board-height))
             (boards-grid (make-array (list boards-x boards-y)))) 
        (check-type grid array)
        (assert (= 2 (length (array-dimensions grid))))
        (dotimes (y boards-y)
          (dotimes (x boards-x)
            (setf (aref boards-grid x y)
                  (copy-rect grid (* x board-width) (* y board-height)
                             board-width board-height))))
        (unless (and (zerop (mod grid-width board-width))
                     (zerop (mod grid-height board-height)))
          (warn "After extracting ~:d ~:d×~:d board~p split from level “~a,”
~[~:;~:* ~r column~:p at the right~[~:;, and~]~:*~]~
~[~:;~:* ~r row~:p at the bottom~] were left behind"
                (length boards)
                board-width board-height
                (length boards)
                (level-name level)
                (mod grid-width board-width)
                (mod grid-height board-height)))
        (dotimes (y boards-y)
          (dotimes (x boards-x)        
            (setf (aref boards-grid x y)
                  (make-board-if-layout-present
                   (aref boards-grid x y)))))
        (dotimes (y boards-y)
          (dotimes (x boards-x)
            (when (aref boards-grid x y)
              (setf (board-exits (aref boards-grid x y))
                    (compute-default-exits boards-grid x y 
                                           :boards-x boards-x
                                           :boards-y boards-y)))))
        (remove-if #'null
                   (loop for i from 0 below (* boards-x boards-y) 
                      collect (row-major-aref boards-grid i)))))))

(defconstant +size-of-board+ (+
                              1 ; layout
                              8 ; playfield colors
                              1 ; background color 
                              6 ; exits
                              1 ; sprite list
                              8 ; walls
                              2 ; doors 
                              ))

(defun sprite-animation-facings (sprite)
  (/ (array-dimension sprite 0) 8))

(defun facing-index (facing)
  (or (position facing +facing-order+)
      (error "Not a valid facing symbol: ~s" facing)))

(defun bitmap-region-empty-p (bitmap  x₀ y₀ x₁ y₁)
  (loop for y from y₀ upto y₁
     do
       (loop for x from x₀ upto x₁
          unless (zerop (aref bitmap x y))
          do (return nil)
          finally (return t))))

(define-constant +sprite-dimensions+
    '(
      2 (21 24)                         ; software
      8 (8 8)                           ; hardware
      20 (16 16)                        ; software
      64 (24 21)                        ; hardware
      128 (24 21)                       ; hardware
      264 (16 16)                       ; software
      16 (16 16)                        ; hardware
      
      2600 (8 7) ; 8 bit wide  player, software support locked to 7 scan
                                        ; lines
      )
  :documentation "Size  of hardware sprite capability;  not counting MOB
  blobbing. When there are no hardware sprites, the size of the software
  sprite system."
  :test 'equalp)

(defun sprite-height ()
  (elt (getf +sprite-dimensions+ *machine*) 1))

(defun sprite-width ()
  (elt (getf +sprite-dimensions+ *machine*) 0))

(define-constant +tile-dimensions+
    '(
      2 (7 8)  
      8 (8 8)  
      20 (8 8)
      64 (8 8)
      128 (8 8)
      264 (8 8)
      16 (8 8) 
      2600 (4 7)) 
  :test 'equalp)

(defun tile-height ()
  (elt (getf +tile-dimensions+ *machine*) 1))

(defun tile-width ()
  (elt (getf +tile-dimensions+ *machine*) 0))

(defun count-animation-frames (sprite facing)
  "Count frames with at least one pixel present"
  (let* ((x₀ (* (sprite-width) (facing-index facing)))
         (x₁ (1- (* (sprite-width) (1+ x₀)))))
    (loop for frame downfrom (/ (1- (array-dimension sprite 1))
                                (sprite-height)) 
       for y₀ = (* (sprite-height) frame)
       for y₁ = (+ (1- (sprite-height)) y₀)
       unless (bitmap-region-empty-p sprite x₀ y₀ x₁ y₁)
       do (return (1+ frame))
       ;; even if there are no non-empty frames, we still have to record
       ;; the one frame
       finally (return 1))))

(defun sprite-animation-frames (sprite facing)
  (let ((x (* (sprite-width) (facing-index facing))))
    (dotimes (frame (count-animation-frames sprite facing))
      (let ((y (* (sprite-height) frame)))
        (copy-rect sprite x y
                   (+ x (1- (sprite-width))) (+ y (1- (sprite-height))))))))

(defun sprite-frames (sprite)
  (case (sprite-animation-facings sprite)
    (1 (sprite-animation-frames sprite nil))
    (2 (concatenate 'list
                    (sprite-animation-frames sprite :left)
                    (sprite-animation-frames sprite :right)))
    (4 (concatenate 'list
                    (sprite-animation-frames sprite :left)
                    (sprite-animation-frames sprite :right)
                    (sprite-animation-frames sprite :up)
                    (sprite-animation-frames sprite :down)))))

(defun sprite-animation-table-cost (sprite)
  (+ 1                               ; num facing directions: 1, 2, or 4
     (* (+ 1                         ; num frames
           (length (sprite-frames sprite))))))

(defun sprite-unique-frames (sprite)
  (remove-duplicates (sprite-frames sprite) :test 'equalp))

(defun board-sprites (board)
  "All sprite graphics frames (sprites × facings × frames) on a board."
  (do-collect (sprite in (board-sprite-list board))
    (sprite-frames sprite)))

(defun sprite-file<-tmx-gid (gid tmx)
  (tmx-gid-decode tmx gid))

(defun tmx-gid-decode (tmx gid)
  (error "Can't decode TMX GID yet"))

(defstruct sprite
  tmx board
  x y
  graphic
  type properties)

(define-constant +sprite-controller-types+
    '(character	"CharacterControllerFn"
      pussy	"PussyControllerFn"
      frog	"FrogControllerFn"
      wolf	"WolfControllerFn"
      nazi	"NaziControllerFn"
      twirl	"TwirlControllerFn"
      dancer	"DancerControllerFn"
      item	"InventoryItemControllerFn"
      unique	"UniqueItemControllerFn"
      door	"DoorControllerFn"
      locked-door	"LockedDoorControllerFn"
      fern	"FernControllerFn")
  :test 'equalp)

(defun sprite-type-symbol (sprite)
  (intern (string-upcase (sprite-type sprite))))

(defun sprite-controller (sprite)
  (or (getf +sprite-controller-types+ (sprite-type-symbol sprite))
      (progn
        (warn "Sprite type not supported: ~a" (sprite-type sprite))
        "FernControllerFn")))

(defun sprite-source-file (sprite)
  (let ((art-file (sprite-graphic sprite)))
    (make-pathname :directory '(:relative "Object" "Art")
                   :type "s"
                   :name (concatenate 'string "mob." 
                                      (pathname-name art-file)))))

(defun sprite<-object (object board)
  (when (tmx-object-sprite-p object)
    (make-sprite
     :tmx object	:board board
     :graphic (sprite-file<-tmx-gid (tmx-object-graphic object)
                                    (board-tmx board))
     :type (tmx-object-type object)
     :properties (tmx-object-properties object))))

(defun board-sprite-list (board)
  (do-collect (special in (board-specials board))
    (sprite<-object special board)))

(defun board-collection-sprite-lists (boards)
  (reduce (curry #'concatenate 'list)
          (mapcar #'board-sprite-list boards)))

(defun board-collection-sprites (boards)
  (reduce (curry #'concatenate 'list)
          (mapcar #'board-sprites boards)))

(defun board-collection-unique-sprite-lists (boards)
  (remove-duplicates (board-collection-sprite-lists boards) :test 'equalp))

(defun board-collection-unique-sprites (boards)
  (remove-duplicates (board-collection-sprites boards) :test 'equalp))

(defun board-collection-sprite-lists-cost (boards)
  (+ (* 5 (length (board-collection-unique-sprite-lists boards)))
     (reduce #'+ (mapcar #'sprite-animation-table-cost 
                         (board-collection-unique-sprites boards)))
     (* 16
        (length (remove-duplicates 
                 (mapcar #'sprite-frames 
                         (board-collection-unique-sprites boards))
                 :test 'equalp)))))

(defun board-collection-unique-layouts (boards)
  (remove-duplicates (mapcar #'board-layout boards) :test #'equalp))

(defun board-tiles (board)
  (reduce (curry #'concatenate 'list)
          (dotimes (y 8)
            (list
             (find-2600-tile (aref board 0 y) (aref board 1 y) :left)
             (find-2600-tile (aref board 2 y) (aref board 3 y) :right)
             (find-2600-tile (aref board 4 y) (aref board 5 y) :left)
             (find-2600-tile (aref board 6 y) (aref board 7 y) :right)))))

(defun board-collection-unique-tiles (boards)
  (remove-duplicates (reduce (curry #'concatenate 'list) 
                             (mapcar #'board-tiles boards)) :test #'=))

(defun board-collection-cost (boards)
  (+ (* 64 (length (board-collection-unique-layouts boards)))
     (* 7 (length (board-collection-unique-tiles boards)))
     (board-collection-sprite-lists-cost boards) 
     (* +size-of-board+ (length boards))))

(defun extract-8×8-boards (levels)
  "Pull 8×8 boards from levels"
  (boards-from-levels levels 8 8))

(defun identifier-char-p (char)
  (or (char<= #\A char #\Z)
      (char<= #\a char #\z)
      (char= #\_ char)
      (char= #\$ char)))

(defun identifier-char-string (char)
  (cond
    ((identifier-char-p char)
     (string char))
    (t
     (case char
       (#\= "_eql_")
       (#\! "_bang_")
       (#\# "_num_")
       (#\Space "__")
       (#\% "_pct_")
       (#\& "_and_")
       (#\? "_p_")
       (#\/ "_or_")
       (#\+ "_plus_")
       (#\- "_tac_")
       (#\* "_star_")
       (#\< "_lt_")
       (#\> "_gt_")
       (#\© "_copr_")
       (#\√ "_sqrt_")
       (#\≠ "_neql_")
       (#\¬ "_not_")
       (#\@ "_at_")
       (#\; "_sem_")
       (#\: "_colon_")
       (#\. "_dot_")
       (#\, "_comma_")
       (otherwise (format nil "_x~{~x~}_" (char-code char)))))))

(defun make-identifier (string)
  (with-output-to-string (identifier (make-string 0))
    (let ((first-char (char string 0)))
      (cond ((char<= #\A first-char #\Z)
             (princ (char-upcase first-char) identifier))
            ((char<= #\a first-char #\z)
             (princ (char-upcase first-char) identifier))
            (t
             (princ #\X identifier)
             (princ #\_ identifier)
             (princ (identifier-char-string first-char) identifier)))
      (loop for char on (subseq string 1)
         do (princ (identifier-char-string char) identifier))
      (unless (< 4 (length string))
        (princ "__" identifier)))))

(defun write-map-bank-header-2600 (min-board boards)
  (check-type min-board (integer 0 *)) 
  (format t "~%	.include \"map-mode-drawing-bank.s\"

          BankMapMin = ~a	; ~:*$~x
          BankMapMax = ~a	; ~:*$~x

"
          min-board (+ min-board (length boards) -1)))


(defun write-world-sprite-includes-tia (levels)
  (format t ";;; 
;;; Sprite bitmaps

          .include \"mob.player.tia.s\"
~{          .include \"mob.~:*~a.tia.s\"~}
"
          (remove-duplicates (mapcar #'level-sprites levels)
                             :test #'string-equal)))

(defgeneric write-maps-bank (machine bank min-board boards)
  (:method (machine bank min boards)
    (let ((*machine* machine))
      (error "~&No method to write bank ~:d for ~a"
             bank (machine-short-name)))))

(defun tia-tile-set-file-for-world (world)
  (check-type world string)
  (make-pathname :directory (list :relative "Object" "Art")
                 :name (concatenate 'string "tiles." world ".tia")
                 :type "png"))

(defun bitp (bit)
  (check-type bit bit))

(defun make-nybble (bits)
  (assert (= 4 (length bits)))
  (assert (every #'bitp bits))
  (logior (nth 0 bits)
          (ash (nth 1 bits) 1)
          (ash (nth 2 bits) 2)
          (ash (nth 3 bits) 3)))

(defvar *tile-sets* (make-hash-table :test 'equal))

(defun tile-set-read-bits/tia (rgbα)
  (check-type rgbα array)
  (assert (= 3 (length (array-dimensions rgbα))))
  (assert (= 4 (array-dimension rgbα 2)))
  (let* ((width (array-dimension rgbα 0))
         (height (array-dimension rgbα 1))
         (num-tiles (* (/ width 4)
                       (/ height 7))))
    (assert (zerop (mod width 4)))
    (assert (zerop (mod height 7)))
    (let ((tile-nybbles (make-array (list num-tiles 7)
                                    :element-type '(unsigned-byte 4)
                                    :initial-element 0))
          (tile-fg-colors (make-array (list num-tiles 7)
                                      :element-type '(unsigned-byte 8)
                                      :initial-element 0)))
      (dotimes (y (/ height 7))
        (dotimes (x (/ width 4))
          (let ((i (+ x (* y (/ width 4)))))
            (dotimes (y0 7)
              (setf (aref tile-nybbles i y0)
                    (make-nybble (maptimes (x0 4)
                                   (if (< #x80 (aref rgbα
                                                     (+ (* x 4) x0)
                                                     (+ (* y 7) y0)
                                                     3))
                                       0 1))))
              (setf (aref tile-fg-colors i y0)
                    (apply #'rgb->palette
                           (color-average (maptimes (x0 4)
                                            (maptimes (channel 3)
                                              (aref rgbα
                                                    (+ (* x 4) x0)
                                                    (+ (* y 7) y0)
                                                    channel))))))))))
      (assert (= (array-dimension tile-nybbles 0)
                 (array-dimension tile-fg-colors 0)))
      (format *trace-output* "… Read ~:d (~:*$~x) tile nybble~:p ~
 and their averaged colours"
              (array-dimension tile-nybbles 0))
      (list tile-nybbles tile-fg-colors))))

(defun load-tia-tile-set (world)
  (let ((png-file (tia-tile-set-file-for-world world)))
    (assert (probe-file png-file))
    (format *trace-output* "~& Loading TIA tile set for ~:(~a~) from ~a"
            world png-file)
    (let ((whole-set (png-read:read-png-file png-file)))
      (let ((width (png-read:width whole-set))
            (height (png-read:height whole-set)))
        (assert (zerop (mod width 4)))
        (assert (zerop (mod height 7)))
        (let ((rgbα (png-read:image-data whole-set)))
          (tile-set-read-bits/tia rgbα))))))

(defun find-tia-tile-set (world)
  (check-type world string)
  (or (gethash world *tile-sets*)
      (setf (gethash world *tile-sets*) (load-tia-tile-set world))))

(defgeneric write-filler-bank (machine bank-number))

(defmethod write-filler-bank ((machine (eql 2600)) bank-number)
  (format *trace-output* "~& Writing bank ~d ($~:*~x) for filler …" bank-number)
  (force-output *trace-output*)
  (with-output-to-memory-bank-file (bank-number)
    (format t "~%BankInit:	jmp GoBank0~%")))

(defun write-boards-layout-pointers (boards layout-assignments)
  (format t "~%MapLayouts:~
~{~%          .byte ~3d~^, ~3d~^, ~3d~^, ~3d~^,    ~3d~^, ~3d~^, ~3d~^, ~3d~}
          BankMapsCount = * - MapLayouts
          BankMapMax = BankMapsCount BankMapMin - 1~%"
          (mapcar (lambda (board)
                    (position (board-layout board) layout-assignments
                              :test #'equalp))
                  boards)))
(defun write-boards-playfield-colors (boards)
  (format t "~%MapColors:
~{~{~%          .byte $~2,'0x~^, $~2,'0x~^, $~2,'0x~^, $~2,'0x~^,    ~
$~2,'0x~^, $~2,'0x~^, $~2,'0x~^, $~2,'0x~}~}
"
          (mapcar #'board-pf-colors boards)))
(defun write-boards-background-colors (boards)
  (format t "~%MapBackgrounds:
~{~%          .byte $~2,'0x~^, $~2,'0x~^, $~2,'0x~^, $~2,'0x~^,    ~
$~2,'0x~^, $~2,'0x~^, $~2,'0x~^, $~2,'0x~}
"
          (mapcar #'board-bk-color boards)))
(defun write-boards-exit-pointers (boards)
  (loop for exit in +exits-order+
     for i from 0
     do (progn
          (format t "~%MapExit~:(~a~):
~{~%          .byte ~3d~^, ~3d~^, ~3d~^, ~3d~^,    ~3d~^, ~3d~^, ~3d~^, ~3d~}
" 
                  exit (mapcar (lambda (board)
                                 (elt (board-exits board) i))
                               boards)))))

(defun random-byte () (random 256))

(defgeneric sprite-controller-parameter (sprite-type sprite)
  (:method (general-type sprite) (random-byte)))

(defgeneric sprite-initial-datum (sprite-type sprite)
  (:method (general-type sprite) (random-byte)))

(defun data-values<-sprite (sprite sprite-assignments)
  (list (sprite-x sprite)
        (sprite-y sprite)
        (sprite-animation-list-id sprite)
        (sprite-initial-datum (sprite-type-symbol sprite) sprite)
        (sprite-controller sprite)
        (sprite-controller-parameter (sprite-type-symbol sprite) sprite)))

(defun write-boards-sprite-lists (boards)
  (let ((sprite-assignments (board-collection-sprite-lists boards)))
    (format t "~%MapSprites:
~{~{
          .byte $~2,'0x	; x position
          .byte $~2,'0x	; y position
          .byte ~d	; animation list
          .byte $~2,'0x	; datum (initial)
          .byte ~a	; controller
	.byte $~2,'0x	; controller parameter
~}
          .byte $ff
~}"
            (mapcar (lambda (list)
                      (mapcar (curry #'data-values<-sprite sprite-assignments)
                              list))
                    (board-collection-unique-sprite-lists boards)))))

(defun sprite-animation-list (sprite)
  (loop for facing in +facing-order+
     for i from 0 
     collecting (sprite-animation-frames sprite facing)))

(defun write-boards-sprite-animation-tables (boards)
  (format t "~%SpriteAnimationTable:
~{          ;; begin sprite
~{          ;; — facing ~a
~{~^          .byte ~3d~^, ~3d~^, ~3d~^, ~3d~^,    ~3d~^, ~3d~^, ~3d~^, ~3d~}
          .byte $ff
~}~}"
          (mapcar #'sprite-animation-list
                  (board-collection-unique-sprites boards))))

(defun write-boards-sprite-graphics-pointers (boards)
  (error "TODO"))

(defun write-boards-sprite-includes (boards)
  (format t "~&;;;~|~%
~{~%          .include \"~a\"~}~%"
          (mapcar #'sprite-source-file 
                  (board-collection-unique-sprites boards))))

(defun boards-using-layout (layout boards)
  (remove-if-not (lambda (board)
                   (equalp layout
                           (board-layout board)))
                 boards))

(defun write-boards-layouts (min-board boards 
                             layout-assignments)
  (format t "~%MapTiles:")
  (loop for layout in layout-assignments
     for i from min-board
     do (format t "~%          ;; layout ~d
~{          ;; used by: ~d~^, ~d~^, ~d~^, ~d~^, ~d~^, ~d~^, ~d~^, ~d~^,~}
"
                i 
                (mapcar (compose (rcurry #'position boards)
                                 (curry #'+ min-board))
                        (boards-using-layout layout boards)))))

(defun random-64-characters ()
  (coerce (loop repeat 64
             collecting (code-char (+ #x3f (random #x40))))
          'string))

(defun board-walls-bitmaps (board)
  (warn "TODO")
  (loop repeat 8 collect 0))

(defun write-boards-walls (min-board boards)
  (format t "~%MapWalls:~{
~%          ;; map ~d~{
	.byte %~8,'0b~}~}"
          (loop for board in boards
             for i from min-board
             collecting (list i
                              (board-walls-bitmaps board)))))

(defun random-off-screen-coordinates ()
  (logior (ash (+ 8 (random 7)) 4)
          (+ 8 (random 7))))

(defun board-door-location (board door-number)
  (check-type door-number (member 1 2))
  (warn "TODO")
  (random-off-screen-coordinates))

(defun write-boards-door-coordinates (min-board boards door-number)
  (format t "~%MapDoor~d:~{
          .byte ~2,'0x	; map ~d~}"
          door-number
          (loop for board in boards
             for i from min-board
             collecting (list i (or (board-door-location board door-number)
                                    #xff)))))

(defun bitmap-row-bits (bitmap row)
  (reduce #'logior
          (do-collect (bit below (array-dimension bitmap 0))
            (if (plusp (aref bitmap bit row))
                (expt 2 bit)
                0))))

(defun write-boards-tiles (tile-assignments)
  (format t "~%Tiles:
~{
          ;;; tile art row ~d~{
          .byte %~8,'0b~}~}"
          (loop for row below (tile-height)
             collecting (list row
                              (mapcar (rcurry #'bitmap-row-bits row)
                                      tile-assignments)))))

(defmethod write-maps-bank ((machine (eql 2600)) 
                            bank-number min-board boards)
  (let ((max-board (+ min-board (length boards)))
        (layout-assignments (board-collection-unique-layouts boards))
        (tile-assignments (board-collection-unique-tiles boards)))
    (format *trace-output* "~& Writing bank ~d ($~:*~2,'0x) for boards ~d-~d …"
            bank-number min-board max-board)
    (force-output *trace-output*)
    (with-output-to-memory-bank-file (bank-number)
      (format t "~2%	;; Start of Map Bank code from TMX~%")
      (write-map-bank-header-2600 min-board boards)
      (write-boards-layout-pointers boards layout-assignments)
      (write-boards-playfield-colors boards)
      (write-boards-background-colors boards)
      (write-boards-exit-pointers boards)
      (write-boards-walls min-board boards)
      (write-boards-door-coordinates min-board boards 1)
      (write-boards-door-coordinates min-board boards 2)
      (write-boards-sprite-lists boards)
      (write-boards-sprite-animation-tables boards)
      (write-boards-sprite-graphics-pointers boards)
      (write-boards-sprite-includes boards)
      (format t "~%~|~%          .align $100, \"~a\"~2%"
              (random-64-characters))
      (write-boards-layouts min-board boards layout-assignments)
      (write-boards-tiles tile-assignments) 
      (format t "~2%	;; End of Map Bank code from TMX~%"))))

(defun machine-sources-wildcard ()
  (make-pathname :directory (list :relative "src" (princ-to-string *machine*))
                 :name :wild :type "s"))

(defgeneric find-fixed-banks (machine))

(defun find-banks-containing-text (text &key not-containing-p)
  (loop for file in (directory (machine-sources-wildcard))
     for name = (pathname-name file)
     when (and (= 5 (length name))
               (string= name "bank" :end1 4)
               (let ((contents (read-file-into-string file)))
                 (every (lambda (text-bit)
                          (funcall (if not-containing-p
                                       #'not #'identity)
                                   (search text-bit contents)))
                        text)))
     collect (digit-char-p (last-elt name))))

(defmethod find-fixed-banks ((machine (eql 2600)))
  (find-banks-containing-text '("map-mode-drawing-bank.s"
                                "dialog-macros.s"
                                "music.s") 
                              :not-containing-p t))

(defgeneric collect-text-banks (machine))

(defgeneric collect-music-banks (machine))

(defmethod collect-text-banks ((machine (eql 2600)))
  (find-banks-containing-text '("dialog-macros.s")))

(defmethod collect-music-banks ((machine (eql 2600)))
  (find-banks-containing-text '("music-macros.s")))

(defmacro for-all-worlds (&body body)
  `(dolist (world *all-worlds*) ,@body))

(defmacro for-all-levels (&body body)
  `(dolist (level *all-levels*) ,@body))

(defgeneric collect-maps-banks (machine))

(define-simple-class tmx-map ()
  ((height :reader :type integer)
   (width :reader :type integer)
   (tile-height :reader :type integer)
   (tile-width :reader :type integer)
   (layers :reader)
   (objects :reader)))

(define-simple-class tmx-layer ()
  ((height :reader :type integer)
   (width :reader :type integer)
   (grid :reader)
   (name :reader)))

(defmethod print-object ((layer tmx-layer) s)
  (format s "#<TMX-LAYER named “~a” (~:d×~:d) >" (tmx-layer-name layer)
          (tmx-layer-width layer) (tmx-layer-height layer)))

(define-simple-class tmx-object ()
  ((name :reader)
   (type :reader)
   (graphic :reader)
   (x :reader :type number)
   (y :reader :type number)
   (width :reader :type number)
   (height :reader :type number)
   (properties :reader)))

(defun get-assoc (alist key &optional cdrp)
  (funcall (if cdrp #'cdr #'second) (assoc key alist :test #'equal)))

(defun plist<-tmx-properties (tag)
  (let ((alist (second tag)))
    (list (make-keyword (string-upcase (get-assoc alist "name")))
          (get-assoc alist "value"))))

(defun tmx-object<-tag (object)
  (assert (equal "object" (car object)))
  (labels ((numb (name)
             (parse-number (get-assoc (second object) name))))
    (let* ((gid? (assoc "gid" (second object) :test #'equal))
           (gid (and gid? (parse-number (second gid?))))
           (x (/ (numb "x") 32)) 
           (y (/ (numb "y") 32))
           (height (/ (numb "height") 32)) 
           (width (/ (numb "width") 32))
           (name (second (assoc "name" (second object))))
           (type (second (assoc "name" (second object))))
           (properties (mapcan #'plist<-tmx-properties
                               (cdr (get-assoc (cddr object) "properties" t)))))
      (make-instance 'tmx-object
                     :graphic gid
                     :x x :y y :width width :height height
                     :name name :type type
                     :properties properties))))

(defun read-tmx-file (file-basename)
  (format *trace-output* "~&Reading ~a.tmx…" file-basename)
  (xmls:parse
   (read-file-into-string
    (make-pathname :directory '(:relative "maps")
                   :name file-basename :type "tmx"))))

(defvar *unique-names* (make-hash-table :test 'equal))
(defun ensure-unique-name (name)
  (prog1 (if-let (repeats (gethash name *unique-names*))
           (format nil "~a ~:d" name repeats))
    (incf (gethash name *unique-names* 0))))

(defgeneric tmx-layer-decode (encoding data width height name))

(defmethod tmx-layer-decode ((encoding (eql :|csv|)) data width height name)
  (let ((grid (make-array (list width height)
                          :element-type 'fixnum :initial-element 0))
        (split-lines (split-string (first data) #(#\Newline))))
    (assert (= (length split-lines) height)
            (height data encoding)
            "The layer height should be ~:D tile~:p ~
but the data contains ~:d row~:p~2%~a"
            height (length split-lines) data)
    (loop for line in split-lines
       for y from 0 below height
       do (loop for column in (split-string line #(#\,))
             for x from 0 below width
             do (if column
                    (setf (aref grid x y) (parse-integer column))
                    (warn "Unset tile at (~d, ~d)" x y))))
    (make-instance 'tmx-layer
                   :height height :width width
                   :grid grid :name (ensure-unique-name name))))

(defun tmx-layer<-tag (layer)
  (let* ((height (parse-number (get-assoc (second layer) "height")))
         (width (parse-number (get-assoc (second layer) "width")))
         (data (get-assoc (cddr layer) "data" t))
         (name (get-assoc (second layer) "name"))
         (encoding (get-assoc (car data) "encoding")))
    (format *trace-output* "~&Parsing layer “~a” (~:d×~:d tiles)…"
            name width height)
    (tmx-layer-decode (make-keyword encoding) (cdr data) width height name)))

(defun tmx-map<-file (file)
  (let* ((tmx-s (read-tmx-file file))
         (map (cdr tmx-s))
         (map-attribs (cadr tmx-s)))
    (check-type map-attribs list)
    (assert (equalp (assoc "orientation" map-attribs :test #'equal)
                    '("orientation" "orthogonal")))
    (assert (equalp (assoc "renderorder" map-attribs :test #'equal)
                    '("renderorder" "right-down")))
    (assert (equalp (assoc "version" map-attribs :test #'equal)
                    '("version" "1.0")))
    (make-instance 'tmx-map
                   :height (parse-number (get-assoc map-attribs "height"))
                   :width (parse-number (get-assoc map-attribs "width"))
                   :tile-height (parse-number (get-assoc map-attribs "tileheight"))
                   :tile-width (parse-number (get-assoc map-attribs "tilewidth"))
                   :layers (mapcar #'tmx-layer<-tag
                                   (remove-if-not (lambda (tag) (equal (car tag) "layer"))
                                                  (cdr map)))
                   :objects (mapcar #'tmx-object<-tag
                                    (cddr (assoc "objectgroup" (cddr map)
                                                 :test #'equal))))))

(assert (equalp (group-by #'digit-char-p '(#\a #\b #\9 #\8 #\c #\d #\7 #\6))
                '((#\9 #\8 #\7 #\6) (#\a #\b #\c #\d))))

(define-constant +sprite-types+
    '(:character :item :wardrobe)
  :test 'equalp)

(defun sprite-type-p (type)
  (member type +sprite-types+ :test 'string-equal))

(defun tmx-object-sprite-p (object)
  (and (tmx-object-graphic object)
       (sprite-type-p (tmx-object-type object))))

(defgeneric sprite<-tmx/machine (machine tmx-object)
  (:method (machine tmx-object)
    (error "Sprites not being parsed on ~a yet" machine)))

(defun sprite<-tmx (object)
  (sprite<-tmx/machine *machine* object))

(defgeneric special<-tmx/machine (machine tmx-object)
  (:method (machine tmx-object)
    (let ((*machine* machine))
      (warn "Specials not being parsed on ~a yet" (machine-short-name)))))

(defun special<-tmx (object)
  (special<-tmx/machine *machine* object))

(defun level<-tmx (tmx-level)
  (assert (= 1 (length (tmx-map-layers tmx-level))))
  (destructuring-bind (sprites specials)
      (group-by #'tmx-object-sprite-p (tmx-map-objects tmx-level))
    (make-instance 'level
                   :name (ensure-unique-name "level")
                   :grid (tmx-layer-grid (first (tmx-map-layers tmx-level)))
                   :sprites (mapcar #'sprite<-tmx sprites)
                   :objects (mapcar #'special<-tmx specials))))

(defun collect-boards/2600 ()
  (dolist (file (directory "maps/*.tmx"))
    (level<-tmx (tmx-map<-file file))))

(defconstant +board-assignment-max-passes+ 10
  "The maximum  number of times to  try to assign boards  to memory banks.
  Once  this  number  of  passes  has  been  reached,  we  require  user
  intervention to proceed.")

(defvar *bytes-free-in-empty-map-bank*)

(defun compile-empty-map-bank-and-find-size ()
  (find-size-of-bank "map-mode-drawing-bank.s"))

(defun bytes-free-in-empty-map-bank ()
  (memoize *bytes-free-in-empty-map-bank*
           (- #x1000
              (compile-empty-map-bank-and-find-size)
              #x100)))

(defun sort-and-split-boards/2600% (boards) 
  (let* ((bank-count (atari-2600-number-of-banks))
         (assigned (make-array bank-count)))
    (dolist (bank (find-fixed-banks 2600))
      (setf (elt assigned bank) :fixed))
    
    (dolist (board boards)
      (catch 'bank-assigned
        (loop for bank below bank-count
           when (and (not (eql :fixed (elt assigned bank)))
                     (< (board-collection-cost (cons board (elt assigned bank)))
                        (bytes-free-in-empty-map-bank)))
           do (progn
                (push board (elt assigned bank))
                (throw 'bank-assigned t)))))
    assigned))

(defun sort-and-split-boards/2600 (boards)
  "Given  a set  of boards  in the  same world,  try to  split them  up so
they'll fit into maps banks."
  (check-type boards list)
  (let (start-time (prior-time 0) (total-passes 0))
    (loop 
       (setf start-time (get-universal-time))
       (dotimes (pass +board-assignment-max-passes+)
         (when-let (assignments (sort-and-split-boards/2600% boards))
           (return assignments))) 
       (incf prior-time (- (get-universal-time) start-time))
       (incf total-passes +board-assignment-max-passes+)
       (unless 
           (and (or #+sbcl (SB-UNIX:UNIX-ISATTY
                            (SB-SYS:FD-STREAM-FD *query-io*)) t)
                (y-or-n-p "~2& After ~:d passes, could not fit all boards ~
into memory banks. Total of ~a spent so far. Continue trying for another ~
~:d passes? ⇒" 
                          total-passes (pretty-duration prior-time)))
         (error "Could not find a solution")))
    ))

#+doa
(defmethod collect-maps-banks ((machine (eql 2600)))
  (let (map-banks)
    (for-all-worlds
      (push (cons world
                  (sort-and-split-boards/2600
                   (mapcar (curry #'collect-boards/2600 world)
                           *all-levels*)))
            map-banks))
    (reverse map-banks)))

(defvar *map-clicker*)

(define-condition boards-overflow ()
  ((boards :initarg :boards :reader overflowed-boards)))

(defun move-boards-to-other-bank (boards-banks boards-to-push)
  (let ((from-bank (first boards-banks)))
    (check-type boards-to-push list "list of indices")
    (assert (every #'integerp boards-to-push) (boards-to-push)
            "Must supply a list of integers (indices), not ~a" boards-to-push)
    (assert (every (complement #'minusp) boards-to-push) (boards-to-push)
            "Must supply a list of integers (indices), not ~a" boards-to-push)
    (assert (every (curry #'< (1- (length from-bank))) boards-to-push)
            (boards-to-push)
            "Indices must be in range, 0 … ~d" (- (length from-bank) 2))
    (format *trace-output* "~&Pushing ~d board~:p into future bank"
            (length boards-to-push))
    (let* ((same-world-banks (remove-if-not
                              (lambda (bank)
                                (equal (car bank)
                                       (car from-bank)))
                              (remove from-bank boards-banks)))
           (target-bank (or (and same-world-banks
                                 (progn (format *trace-output* "Moving board~p to next ~a bank"
                                                (length boards-to-push) (car from-bank))
                                        (first same-world-banks)))
                            (progn (format *trace-output* "Creating a new ~a bank" (car from-bank))
                                   (cons (car from-bank) nil)))))
      (removef boards-banks target-bank)
      (dolist (index boards-to-push)
        (let ((board (elt (cdr from-bank) index)))
          (removef from-bank board)
          (appendf board target-bank))))))



#+doa
(defun prompt-for-boards-to-move (maps-banks)
  (check-type maps-banks list)
  (format *query-io*
          "Here are the boards that could be moved:
~{~%~{~d. ~a~}~^~40t~{~d. ~a~}~}
Enter the list of indices to push back in Lisp form: (1 2 3) ~% ⇒"
          (numbered (mapcar (rcurry #'cons nil)
                            (rest (first boards-banks)))))
  (read *query-io*))

#+doa
(defun build-one-memory-bank% (bank-number)
  (cond
    ((member bank-number *fixed-banks* :test #'=)
     (copy-file (machine-source-file (format nil "bank~d" bank-number))
                (machine-generated-file
                 (format nil "bank-~2,'0x" bank-number))))

    (*text-banks*
     (write-text-bank *machine* bank-number (first *text-banks*))
     (pop *text-banks*))

    (*maps-banks*
     (write-maps-bank *machine* bank-number (first *maps-banks*))
     (pop *maps-banks*))

    (t (write-filler-bank *machine* bank-number))))
#+xxx
(defun build-one-memory-bank (bank-number)
  ;; This is actually where the restarts and stuff live.
  ;; BUILD-ONE-MEMORY-BANK% is where the good parts are.
  (tagbody top
     (restart-case
         (handler-case (build-one-memory-bank% bank-number)
           (boards-overflow (boards-to-push)
             (invoke-restart 'push-boards-bank boards-to-push)))
       (restart-bank ()
         :report (lambda (s)
                   (format s "Restart writing bank ~d for ~a"
                           bank-number (machine-short-name)))
         (go top))
       (push-boards-bank (boards-to-push)
         :report (lambda (s)
                   (format s "Push some boards into a later bank to free up resources"))
         :interactive (lambda () (prompt-for-boards-to-move *maps-banks*))
         (move-boards-to-other-bank *maps-banks* boards-to-push)
         (go top)))))

(defun build-banking (machine-type)
  "Build the banking structures for MACHINE-TYPE

This reads the boards and scripts  and tile data, and builds the assembler
files  for the  various memory  banks. MACHINE-TYPE  uses the  numerical
codes that match the subdirectories of obj/

"
  (let ((*machine* (parse-integer machine-type))
        (*map-clicker* 0))
    (format *trace-output* "~&Build banking files for ~a" (machine-long-name))
    (let ((*fixed-banks* (find-fixed-banks *machine*))
          (*text-banks* (collect-text-banks *machine*))
          (*maps-banks* (collect-maps-banks *machine*))
          (max-banks (max-banks *machine*)))
      (format *trace-output* "~&Fixed banks: ~d (~{~a~^, ~})
Text banks: ~d
Maps banks: ~d"
              (length *fixed-banks*) *fixed-banks*
              (length *text-banks*)
              (length *maps-banks*))
      (assert (plusp (length *maps-banks*))
              (*maps-banks*)
              "At least one map is required; none were found")
      (dotimes (bank-number max-banks)
        (build-one-memory-bank bank-number)))))
