(in-package :skyline-tool)

(defclass level ()
  ((sprites :accessor level-sprites :initarg :sprites)
   (grid :accessor level-grid :initarg :grid)
   (objects :accessor level-objects :initarg :objects)
   (name :reader level-name :initarg :name)))

(defvar *screen-ticker* 0)

(defclass grid/tia ()
  ((tiles :reader grid-tiles :initarg :tiles)
   (colors :reader grid-row-colors :initarg :colors)
   (background-color :reader grid-background-color :initarg :background-color)
   (id :reader grid-id :initform (incf *screen-ticker*))))

(defgeneric list-grid-row-colors (grid))
(defgeneric list-grid-tiles (grid))

(defmethod list-grid-row-colors ((grid grid/tia))
  (coerce (grid-row-colors grid) 'list))

(defun list-grid-row-palette-colors (grid)
  (mapcar (curry #'apply #'rgb->palette)
          (apply #'concatenate 'list (list-grid-row-colors grid))))

(defmethod list-grid-tiles ((grid grid/tia))
  (let (list
        (tiles (grid-tiles grid)))
    (dotimes (y 8)
      (dotimes (x 4)
        (push (aref tiles x y) list)))
    (nreverse list)))

(defun assocdr (key alist &optional (errorp t))
  (or (second (assoc key alist :test #'equalp))
      (when errorp 
        (error "Could not find ~a in ~s" key alist))))

(defun pin (n min max)
  (min max (max min n)))

(defun parse-tile-animation-sets (tileset)
  (let ((animations (list)))
    (dolist (tile-data (cddr tileset))
      (when (equal "tile" (car tile-data))
        (let ((tile-id (parse-integer (assocdr "id" (second tile-data)))))
          (dolist (animation (cddr tile-data))
            (when (equal "animation" (car animation))
              (let ((sequence (list)))
                (dolist (frame (cddr animation))
                  (assert (equal "frame" (car frame)))
                  (let ((frame-tile (parse-integer (assocdr "tileid" (second frame))))
                        (duration (/ (parse-integer (assocdr "duration" (second frame)))
                                     1000 1/60)))
                    (push frame-tile sequence)
                    (push duration sequence)))
                (push (list tile-id (reverse sequence)) animations)))))))
    animations))

(defun split-into-bytes (tile-collision-bitmap)
  (let ((width (array-dimension tile-collision-bitmap 0))
        (bytes (list)))
    (dotimes (y (array-dimension tile-collision-bitmap 1))
      (dotimes (byte (floor width 8))
        (let ((value 0))
          (dotimes (bit 8)
            (let ((x (+ bit (* 8 byte))))
              (when (< x width)
                (when (plusp (aref tile-collision-bitmap x y))
                  (setf value (logior value (ash 1 bit)))))))
          (push value bytes))))
    (reverse bytes)))

(defun 32-bit-word (bytes)
  (logior (elt bytes 0)
          (ash (elt bytes 1) 8)
          (ash (elt bytes 2) 16)
          (ash (elt bytes 3) 24)))

(defun bytes-to-32-bits (bytes)
  (loop for i from 0 by 4 below (length bytes)
        collecting (32-bit-word (subseq bytes i (+ i 4)))))

(defun split-grid-to-rows (width height words)
  (let ((output (make-array (list width height) :element-type 'integer))
        (i 0))
    (dotimes (y height)
      (dotimes (x width)
        (setf (aref output x y) (elt words i))
        (incf i)))
    output))

(defun parse-layer (layer)
  (let ((data (xml-match "data" layer)))
    (assert data)
    (assert (equal "base64" (assocdr "encoding" (second data))))
    (assert (stringp (third data)))
    (let* ((width (parse-integer (assocdr "width" (second layer))))
           (height (parse-integer (assocdr "height" (second layer)))))
      (split-grid-to-rows width height
                          (bytes-to-32-bits
                           (cl-base64:base64-string-to-usb8-array (third data)))))))

(defun find-tile-by-number (number tileset)
  (let ((id (- number (tileset-gid tileset))))
    (if (< id 128)
        (values id 
                (apply #'vector (loop for b below 6
                                      collect (aref (tile-attributes tileset) id b))))
        (values 0 #(0 0 0 0 0 0)))))

(defun assign-attributes (attr attr-table)
  (or (position-if (lambda (attribute) (equalp attr attribute)) attr-table)
      (progn (setf (cdr (last attr-table)) (cons attr nil))
             (1- (length attr-table)))))

(defun object-covers-tile-p (x y object)
  (or (and (find-if (lambda (el) (equal "point" (car el)))
                    (subseq object 2))
           (<= (* x 8) (parse-number (assocdr "x" (second object))) (1- (* (1+ x) 8)))
           (<= (* y 16) (parse-number (assocdr "y" (second object))) (1- (* (1+ y) 16))))))

(defun find-effective-attributes (tileset x y objects attributes exits)
  (let ((effective-objects (remove-if-not (lambda (el)
                                            (and (equal "object" (car el))
                                                 (object-covers-tile-p x y el)))
                                          (subseq objects 2))))
    (dolist (object effective-objects)
      (add-attribute-values nil object attributes exits))))

(defun add-alt-tile-attributes (tile-attributes alt-tile-attributes)
  (let ((wall-bits (logand #x0f (aref alt-tile-attributes 0))))
    (setf (aref tile-attributes 0) (logior (ash wall-bits 4) (aref tile-attributes 0))
          (aref tile-attributes 1) (logior #x01 (aref tile-attributes 1)))))

(defun mark-palette-transitions (grid attributes-table)
  (dotimes (y (array-dimension grid 1))
    (dotimes (x (array-dimension grid 0))
      (if (zerop x)
          (setf (aref grid x y 0) (logior #x80 (aref grid x y 0)))
          (let ((palette-left (tile-effective-palette grid (1- x) y attributes-table))
                (palette-self (tile-effective-palette grid x y attributes-table)))
            (unless (= palette-left palette-self)
              (setf (aref grid x y 0) (logior #x80 (aref grid x y 0)))))))))

(defun parse-tile-grid (layers objects tileset)
  (let* ((ground (parse-layer (first layers)))
         (detail (and (= 2 (length layers))
                      (parse-layer (second layers))))
         (output (make-array (list (array-dimension ground 0)
                                   (array-dimension ground 1)
                                   2)
                             :element-type 'integer))
         (attributes-table (list #(0 0 0 0 0 0)))
         (exits-table (list))
         (sprites-table (list)))
    (dotimes (y (array-dimension ground 1))
      (dotimes (x (array-dimension ground 0))
        (let* ((detailp (and detail (> (aref detail x y) 0)))
               (tile-number (if detailp
                                (aref detail x y)
                                (aref ground x y))))
          (multiple-value-bind (tile-id tile-attributes) (find-tile-by-number tile-number tileset)
            (when detailp
              (multiple-value-bind (alt-tile-id alt-tile-attributes)
                  (find-tile-by-number (aref ground x y) tileset)
                (setf (aref tile-attributes 5) alt-tile-id)
                (add-alt-tile-attributes tile-attributes alt-tile-attributes)))
            (find-effective-attributes tileset x y objects tile-attributes exits-table)
            (setf (aref output x y 0) tile-id
                  (aref output x y 1) (assign-attributes tile-attributes
                                                         attributes-table))))))
    #+ (or)  (dotimes (y 32)
               (fresh-line *trace-output*)
               (dotimes (x 32)
                 (format *trace-output* "~x " (tile-effective-palette output x y attributes-table))))
    (mark-palette-transitions output attributes-table)
    #+ (or) (format *trace-output* "~&~S" attributes-table)
    (values output attributes-table sprites-table exits-table)))

(defun map-layer-depth (layer.xml)
  (when (and (<= 3 (length layer.xml))
             (equal "properties" (car (third layer.xml))))
    (loop for prop in (subseq (third layer.xml) 2)
          when (and (equal "property" (car prop))
                    (equalp "ground" (assocdr "name" (second prop)))
                    (or (equalp "true" (assocdr "value" (second prop)))
                        (equalp "t" (assocdr "value" (second prop)))))
            return 0
          when (and (equal "property" (car prop))
                    (equalp "detail" (assocdr "name" (second prop)))
                    (or (equalp "true" (assocdr "value" (second prop)))
                        (equalp "t" (assocdr "value" (second prop)))))
            return 1)))

(defclass tileset ()
  ((gid :initarg :gid :reader tileset-gid)
   (pathname :initarg :pathname :reader tileset-pathname)
   (image :initarg :image :accessor tileset-image)
   (tile-attributes :accessor tile-attributes
                    :initform (make-array (list 128 6) :element-type '(unsigned-byte 8)))))

(defun load-tileset-image (pathname)
  (format *trace-output* "~&Loading tileset image from ~a" pathname)
  (let* ((png (png-read:read-png-file 
               (make-pathname 
                :name (subseq pathname 0
                              (position #\. pathname :from-end t))
                :type (subseq pathname (1+ (position #\. pathname :from-end t)))
                :defaults #p"./Source/Maps/")))
         (height (png-read:height png))
         (width (png-read:width png))
         (α (png-read:transparency png))
         (*machine* 7800))
    (png->palette height width
                  (png-read:image-data png)
                  α)))

(defun extract-8×16-tiles (image)
  (let ((output (list)))
    (dotimes (row (/ (1- (array-dimension image 1)) 16))
      (dotimes (column (/ (array-dimension image 0) 8))
        (let ((tile (extract-region image (* column 8) (* row 16) (+ (* column 8) 7) (+ (* row 16) 15))))
          (assert (= 8 (array-dimension tile 0)))
          (assert (= 16 (array-dimension tile 1)))
          (push tile output))))
    (format *trace-output* "… found ~d tile~:p in ~d×~d image"
            (length output) (array-dimension image 0) (array-dimension image 1))
    (reverse output)))

(defun extract-palettes (image)
  (let* ((last-row (1- (array-dimension image 1)))
         (palette-strip (extract-region image 0 last-row 25 last-row))
         (palettes (make-array (list 8 4) :element-type '(unsigned-byte 8))))
    (dotimes (p 8)
      (setf (aref palettes p 0) (aref palette-strip 0 0))
      (dotimes (c 3)
        (setf (aref palettes p (1+ c)) (aref palette-strip (+ 1 c (* p 3)) 0))))
    palettes))

(defun all-colors-in-tile (tile)
  (remove-duplicates (loop for y below 16 
                           append
                           (loop for x below 8
                                 collect (aref tile x y)))
                     :test #'=))

(defun tile-fits-palette-p (tile palette)
  (every (lambda (c) (member c palette))
         (all-colors-in-tile tile)))

(defun 2a-to-list (2a)
  (loop for row from 0 below (array-dimension 2a 0)
        collecting (loop 
                     with output = (make-array (list (array-dimension 2a 1)))
                     for column from 0 below (array-dimension 2a 1)
                     do (setf (aref output column) (aref 2a row column))
                     finally (return output))))

(defun best-palette (tile palettes)
  (position-if (lambda (palette)
                 (tile-fits-palette-p tile palette))
               (mapcar (lambda (p) (coerce p 'list)) (2a-to-list palettes))))

(defun split-images-to-palettes (image)
  (let ((tiles (extract-8×16-tiles image))
        (palettes (extract-palettes image))
        (output (make-array '(128) :element-type '(unsigned-byte 3))))
    (dotimes (i (length tiles))
      (setf (aref output i) (or (best-palette (elt tiles i) palettes)
                                (error "Tile ~d does not match any palette~%~s~2%~s"
                                       i (elt tiles i) palettes))))
    #+ (or) (format *trace-output* "~&Palettes for all tiles: ~s" output)
    output))

(defun tile-property-value (key tile.xml)
  (dolist (info (cddr tile.xml))
    (when (and (equal "properties" (car info)))
      (dolist (prop (cddr info))
        (when (and (equal "property" (car prop))
                   (equalp key (assocdr "name" (second prop))))
          (when-let (value (assocdr "value" (second prop)))
            (return-from tile-property-value
              (let ((value (string-trim #(#\Space) value)))
                (cond ((or (equalp "true" value)
                           (equalp "t" value)
                           (equalp "on" value))
                       t)
                      ((or (equalp "false" value)
                           (equalp "f" value)
                           (equalp "off" value))
                       :off)
                      (t value))))))))))

(defun tile-collision-p (tile.xml test-x test-y)
  (let* ((object-group (when (and tile.xml (< 1 (length tile.xml)))
                         (find-if (lambda (el) (equal "objectgroup" (car el))) 
                                  (subseq tile.xml 2))))
         (objects (when (and object-group (< 1 (length object-group)))
                    (remove-if (lambda (el)
                                 (or (not (equal "object" (car el)))
                                     (when-let (type-name (assocdr "type" (second el) nil))
                                       (not (equalp "Wall" type-name)))))
                               (subseq object-group 2)))))
    (dolist (object objects) 
      (let ((height (parse-number (assocdr "height" (second object))))
            (width (parse-number (assocdr "width" (second object))))
            (object-x (parse-number (assocdr "x" (second object))))
            (object-y (parse-number (assocdr "y" (second object)))))
        (when (and (<= object-x test-x (+ object-x width))
                   (<= object-y test-y (+ object-y height)))
          (return-from tile-collision-p t)))))
  nil)

(defun load-other-map (locale)
  (xmls:parse-to-list (alexandria:read-file-into-string 
                       (make-pathname :name locale
                                      :type "tmx"
                                      :defaults #p"./Source/Maps/"))))

(defun assign-exit (locale point exits)
  (let ((locale.xml (load-other-map locale)))
    (warn "Not trying to find point ~s in locale ~s" point locale)
    1))

(defun add-attribute-values (tile-palettes xml bytes &optional (exits nil exits-provided-p))
  (labels ((set-bit (byte bit)
             (setf (elt bytes byte) (logior (elt bytes byte) bit)))
           (clear-bit (byte bit)
             (setf (elt bytes byte) (logand (elt bytes byte) bit)))
           (map-boolean (property byte bit)
             (when-let (value (tile-property-value property xml))
               (cond ((eql t value) (set-bit byte bit))
                     ((eql :off value) (clear-bit byte bit))
                     (t (warn "Unrecognized value ~s for property ~s" value property))))))
    
    (when (tile-collision-p xml 4 0) (set-bit 0 #x01))
    (when (tile-collision-p xml 4 15) (set-bit 0 #x02))
    (when (tile-collision-p xml 0 7) (set-bit 0 #x04))
    (when (tile-collision-p xml 7 7) (set-bit 0 #x08))
    (map-boolean "Wall" 0 #x0f)
    (map-boolean "WallNorth" 0 #x01)
    (map-boolean "WallSouth" 0 #x02)
    (map-boolean "WallWest" 0 #x04)
    (map-boolean "WallEast" 0 #x08)
    ;; Ceiling → #x01 set by details layer
    (map-boolean "Wade" 1 #x02)
    (map-boolean "Swim" 1 #x04)
    (map-boolean "Ladder" 1 #x08)
    (map-boolean "Climb" 1 #x08)
    (map-boolean "Pit" 1 #x10)
    (map-boolean "Door" 1 #x20)
    (map-boolean "Flammable" 1 #x40)
    (map-boolean "StairsDown" 1 #x80)
    (map-boolean "Ice" 2 #x01)
    (map-boolean "Fire" 2 #x02)
    (when-let (switch (tile-property-value "Trigger" xml))
      (cond
        ((equalp switch "Step") (set-bit 2 #x04))
        ((equalp switch "Pull") (set-bit 2 #x08))
        ((equalp switch "Push") (set-bit 2 #x0c))
        (t (warn "Unknown value for switch Trigger property: ~s" switch))))
    (map-boolean "Iron" 2 #x10)
    (when-let (push (tile-property-value "Push" xml))
      (cond
        ((equalp push "Heavy") (set-bit 2 #x40))
        ((equalp push "VeryHeavy") (set-bit 2 #x60))
        (t (set-bit 2 #x20))))
    (when-let (destination (tile-property-value "Exit" xml))
      (set-bit 2 #x80)
      (destructuring-bind (locale point) (split-sequence #\/ destination)
        (if exits-provided-p
            (set-bit 4 (logand #x1f (assign-exit locale point exits)))
            (warn "Exit in tileset data is not supported (to ~s in ~s)" point locale))))
    (when-let (lock (tile-property-value "Lock" xml))
      (set-bit 3 (logand #x1f (parse-integer lock :radix 16))))
    (if-let (switch (tile-property-value "Switch" xml))
      (set-bit 4 (ash (logand #x0c (parse-integer switch :radix 16)) 3)))
    (when (tile-property-value "Locked" xml)
      (warn "Locked tile without Lock code"))
    (when-let (tile-id (assocdr "id" (second xml) nil))
      (when (and tile-palettes tile-id)
        (set-bit 4 (ash (aref tile-palettes (parse-integer tile-id)) 5))))
    (when-let (palette (tile-property-value "Palette" xml))
      (clear-bit 4 #x07)
      (set-bit 4 (ash (mod (parse-integer palette :radix 16) 8) 5)))))

(defun parse-tile-attributes (palettes xml i)
  (let ((bytes (make-array '(6) :element-type '(unsigned-byte 8)))
        (tile.xml (find-if (lambda (el)
                             (and (equal "tile" (car el))
                                  (= i (parse-integer (assocdr "id" (second el))))))
                           (subseq xml 2))))
    (add-attribute-values palettes tile.xml bytes)
    #+ (or) (format *trace-output* "~& Tile (~2,'0x) Palette ~x Attrs ~s"
                    i (logand #x07 (aref bytes 4)) bytes)
    bytes))

(defun tile-effective-palette (grid x y attributes-table)
  (let ((byte4 (ash (logand #xe0 (aref (elt attributes-table (aref grid x y 1)) 4)) -5)))
    (check-type byte4 (integer 0 7))
    byte4))

(defun load-tileset (xml-reference)
  (let* ((pathname (if (consp xml-reference)
                       (make-pathname :name (assocdr "source" (second xml-reference))
                                      :defaults #p"./Source/Maps/")
                       xml-reference))
         (gid (if (consp xml-reference)
                  (parse-integer (assocdr "firstgid" (second xml-reference)))
                  0))
         (xml (xmls:parse-to-list (alexandria:read-file-into-string pathname)))
         (tileset (make-instance 'tileset :gid gid :pathname pathname)))
    (format *trace-output* "~&Loading tileset data from ~a" pathname)
    (assert (equal "tileset" (first xml)))
    (assert (equal "128" (assocdr "tilecount" (second xml))))
    (assert (<= 1.7 (parse-number (assocdr "version" (second xml))) 1.8))
    (let* ((image (xml-match "image" xml))
           (image-data (load-tileset-image (assocdr "source" (second image))))
           (palette-data (split-images-to-palettes image-data)))
      (setf (tileset-image tileset) image-data)
      (dotimes (i 128)
        (let ((bytes (parse-tile-attributes palette-data xml i)))
          (dotimes (b 6)
            (setf (aref (tile-attributes tileset) i b) (elt bytes b))))))
    tileset))

(defun rle-encode (non-repeated repeated repeated-times)
  (when (> (length non-repeated) 127)
    (return-from rle-encode
      (reduce (lambda (a b) (concatenate 'vector a b))
              (append (mapcar (lambda (segment) (rle-encode segment #() 0))
                              (loop for start from 0 by 127
                                    while (< start (length non-repeated))
                                    collecting (subseq non-repeated
                                                       start
                                                       (min (+ 127 start)
                                                            (length non-repeated)))))
                      (list (rle-encode #() repeated repeated-times))))))
  (let ((output (make-array (list 0) :adjustable t :element-type '(unsigned-byte 8))))
    (when (plusp (length non-repeated))
      (vector-push-extend (1- (length non-repeated)) output)
      (dotimes (byte (length non-repeated))
        (vector-push-extend (aref non-repeated byte) output)))
    (when (plusp (length repeated))
      (vector-push-extend (logior #x80 (1- (length repeated))) output)
      (vector-push-extend (1- repeated-times) output)
      (dotimes (byte (length repeated))
        (vector-push-extend (aref repeated byte) output)))
    output))

(defun rle-expanded-string (rle)
  (let ((output (make-array (list 0) :adjustable t :element-type '(unsigned-byte 8)))
        (offset 0))
    (loop while (< offset (1- (length rle)))
          for string-length = (1+ (logand #x7f (aref rle offset)))
          do (if (zerop (logand #x80 (aref rle offset)))
                 (progn (loop for byte across (subseq rle (1+ offset) (+ 1 offset string-length))
                              do (vector-push-extend byte output))
                        (incf offset (1+ string-length)))
                 (progn (dotimes (i (1+ (aref rle (1+ offset))))
                          (loop for byte across (subseq rle (+ 2 offset) (+ 2 offset string-length))
                                do (vector-push-extend byte output)))
                        (incf offset (+ 2 string-length)))))
    output))

(defun rle-compress-segment (source)
  (when (< (length source) 4)
    (return-from rle-compress-segment (list (cons (rle-encode source #() 0) (length source)))))
  (let ((matches (list)))
    (lparallel:pdotimes (offset (min 127 (1- (length source))))
      (loop for length from (min 127 (- (length source) offset)) downto 1
            for first-part = (subseq source offset (+ offset length))
            do (loop for repeats
                     from (min 256 (floor (/ (- (length source) offset) length)))
                     downto (if (= 1 length) 3 2)
                     do (when (every (lambda (part) (equalp first-part part))
                                     (loop for i from 0 below repeats
                                           for n = (* i length)
                                           collect (subseq source (+ offset n)
                                                           (+ offset length n))))
                          (push (cons (rle-encode (subseq source 0 offset)
                                                  (subseq source offset (+ offset length))
                                                  repeats)
                                      (+ offset (* length repeats)))
                                matches)))))
    (incf *rle-options* (or (and matches (length matches))
                            1))
    (or matches
        (list (cons (rle-encode source #() 0) (length source))))))

(defun shorter (a b)
  (if (< (length a) (length b))
      a b))

(defun only-best-options (options)
  (let ((best-expanded-length (make-hash-table))
        (best-rle (make-hash-table)))
    (dolist (option options)
      (destructuring-bind (rle . expanded-length) option
        (let* ((length (length rle))
               (champion (gethash length best-expanded-length)))
          (if (or (null champion)
                  (> expanded-length length))
              (setf (gethash length best-expanded-length) expanded-length
                    (gethash length best-rle) rle)))))
    (let ((best-options
            (loop for length being each hash-key of best-expanded-length
                  collecting (cons (gethash length best-rle)
                                   (gethash length best-expanded-length)))))
      (if *rle-fast-mode*
          (if (> (length best-options) *rle-fast-mode*)
              (subseq (sort best-options
                            (lambda (a b)
                              (< (/ (length (car a)) (cdr a))
                                 (/ (length (car b)) (cdr b)))))
                      0 *rle-fast-mode*)
              best-options)
          best-options))))

(defun rle-compress-fully (source &optional recursive-p)
  (let ((total-length (length source))
        (options (only-best-options (rle-compress-segment source)))
        (fully (list)))
    (when (< 1 (length options))
      #+ (or)
      (format t "~& For source length ~:d, there are ~:d options with expanded-length from ~:d to ~:d bytes"
              (length source) 
              (length options)
              (reduce #'min (mapcar #'cdr options))
              (reduce #'max (mapcar #'cdr options))))
    (dolist (option options)
      (destructuring-bind (rle . expanded-length) option
        (when (zerop (random 10000))
          (format *trace-output* "~&(RLE compressor: ~:d segment options considered)" *rle-options*))
        (cond
          ((and (not recursive-p) (> (length rle) *rle-best-full*))
           ;; no op, drop that option
           )
          ((= expanded-length total-length)
           (push rle fully))
          (t
           (let ((rest (rle-compress-fully (subseq source expanded-length) t)))
             (when rest
               (push (concatenate 'vector rle rest) fully)))))))
    (when fully
      (reduce #'shorter fully))))

(defparameter *rle-fast-mode* 1)

(defvar *rle-options* 0)

(defvar *rle-best-full* most-positive-fixnum)

(defun rle-compress (source)
  (let ((lparallel:*kernel* (lparallel:make-kernel 8))
        (*rle-options* 0)
        (*rle-best-full* (1+ (length source))))
    (unwind-protect
         (let ((rle (rle-compress-fully source nil)))
           (format *trace-output* "~& Compressed ~:d byte~:p into ~:d byte~:p using RLE (~d%), ~
after considering ~:d option~:p."
                   (length source) (length rle)
                   (round (* 100 (/ (length rle) (length source))))
                   *rle-options*)
           (if (> (length rle) (1+ (length source)))
               (prog1 
                   (concatenate 'vector #(#xff) source)
                 (format *trace-output* "~&(Compression failed, saving uncompressed)"))
               rle))
      (lparallel:end-kernel))))

(defun hex-dump-comment (string)
  (format t "~{~&     ;; ~
~2,'0x~^ ~2,'0x~^ ~2,'0x~^ ~2,'0x~
~^  ~2,'0x~^ ~2,'0x~^ ~2,'0x~^ ~2,'0x~
~^  ~2,'0x~^ ~2,'0x~^ ~2,'0x~^ ~2,'0x~
~^  ~2,'0x~^ ~2,'0x~^ ~2,'0x~^ ~2,'0x~}" 
          (coerce string 'list)))

(defun hex-dump-bytes (string)
  (format t "~{~&     .byte $~2,'0x~^, $~2,'0x~^, $~2,'0x~^, $~2,'0x~
~^,   $~2,'0x~^, $~2,'0x~^, $~2,'0x~^, $~2,'0x~}" 
          (coerce string 'list)))

(defun xml-match (element xml)
  (find-if (lambda (el) (equal element (car el)))
           (subseq xml 2)))

(defun xml-matches (element xml)
  (remove-if-not (lambda (el) (equal element (car el)))
                 (subseq xml 2)))

(defun compile-map (pathname)
  (with-open-file (*standard-output* 
                   (make-pathname :defaults pathname
                                  :directory '(:relative "Source/Generated/Maps/")
                                  :type "s")
                   :direction :output
                   :if-exists :supersede)
    (format *trace-output* "~&Loading tile map from ~a" pathname)
    (let ((xml (xmls:parse-to-list (alexandria:read-file-into-string pathname))))
      (assert (equal "map" (car xml)))
      (assert (equal "orthogonal" (assocdr "orientation" (second xml))))
      (assert (equal "right-down" (assocdr "renderorder" (second xml))))
      (assert (equal "8" (assocdr "tilewidth" (second xml))))
      (assert (equal "16" (assocdr "tileheight" (second xml))))
      (let ((tilesets (mapcar #'load-tileset
                              (xml-matches "tileset" xml)))
            (layers (xml-matches "layer" xml))
            (object-groups (xml-matches "objectgroup" xml)))
        (assert (<= 1 (length layers) 2) ()
                "This tool requires 1-2 layers, found ~:d tile map layer~:p in ~a"
                (length layers) pathname)
        (when (= 2 (length layers))
          (when (or (and (null (map-layer-depth (first layers)))
                         (eql 0 (map-layer-depth (second layers))))
                    (and (null (map-layer-depth (second layers)))
                         (eql 1 (map-layer-depth (first layers))))
                    (and (map-layer-depth (first layers)) (map-layer-depth (second layers))
                         (> (map-layer-depth (first layers)) (map-layer-depth (second layers)))))
            (setf layers (reversef layers))))
        (assert (<= 0 (length object-groups) 1))
        (format t ";;; This is a generated file.~%;;; Source file: ~a~2%" pathname)
        (format t "Map_~a:     .block" (pathname-base-name pathname))
        (let ((base-tileset (first tilesets))
              (objects (first object-groups)))
          (format *trace-output* "~&Parsing map layers…")
          (multiple-value-bind (tile-grid attributes-table sprites-table exits-table)
              (parse-tile-grid layers objects base-tileset)
            (let ((width (array-dimension tile-grid 0))
                  (height (array-dimension tile-grid 1)))
              (assert (<= (* width height) 1024))
              (format *trace-output* "~&Found grid ~d×~d tiles, ~
~d unique attribute~:p, ~d sprite~:p, ~d unique exit~:p"
                      width height
                      (length attributes-table) (length sprites-table)
                      (length exits-table))
              (format t "~2%;;; Tile grid — ~d × ~d tiles
GridSize:     
Width:    .byte ~d
Height:    .byte ~d" 
                      width height width height)
              (format t "~2%;;; Pointers into grid data:
Pointers:
     .word Art
     .word TileAttributes
     .word Attributes
     .word Sprites
     .word Exits")
              (format t "~2%;;; Display name of locale
           .enc \"minifont\"
Name:     .ptext \"~a\"" 
                      (let ((name (concatenate 'string (string-downcase (cl-change-case:sentence-case (pathname-base-name pathname))))))
                        (subseq name 0 (min 20 (length name)))))
              (format t "~2%Art:     ;; Tile art")
              (let ((string (make-array (list (* width height)) :element-type '(unsigned-byte 8))))
                (dotimes (y height)
                  #+ (or) (fresh-line *trace-output*)
                  (dotimes (x width)
                    (let ((cell (aref tile-grid x y 0)))
                      #+ (or) (format *trace-output* "~2,'0x " cell)
                      (setf (aref string (+ (* width y) x)) cell))))
                (hex-dump-comment string)
                (let ((compressed (rle-compress string)))
                  (format t "~&     .word $~4,'0x" (length compressed))
                  (hex-dump-bytes compressed)))
              (format t "~2%TileAttributes:     ;; Tile attributes indices")
              (let ((string (make-array (list (* width height)) :element-type '(unsigned-byte 8))))
                (dotimes (y height)
                  (dotimes (x width)
                    (setf (aref string (+ (* width y) x)) (aref tile-grid x y 1))))
                (hex-dump-comment string)
                (let ((compressed (rle-compress string)))
                  (format t "~&     .word $~4,'0x" (length compressed))
                  (hex-dump-bytes compressed)))
              (format t "~2%Attributes:     ;; Tile attributes table~&     .byte ~d" (length attributes-table))
              (dolist (attr attributes-table)
                (hex-dump-bytes attr))
              (format t "~2%Sprites:     ;; Sprites table~&     .byte ~d" (length sprites-table))
              (dolist (sprite sprites-table)
                (hex-dump-bytes sprite))
              (format t "~2%Exits:     ;; Exit destination pointers~&     .byte ~d" (length exits-table))
              (dolist (exit exits-table)
                (hex-dump-bytes exit))))))
      (format t "~2&      .bend")
      (fresh-line))))

(defun rip-tiles-from-tileset (tileset images)
  (let ((i 0))
    (dotimes (y (floor (array-dimension (tileset-image tileset) 1) 16))
      (dotimes (x (floor (array-dimension (tileset-image tileset) 0) 8))
        (setf (aref images i) (extract-region (tileset-image tileset)
                                              (* x 8) (* y 16) 
                                              (1- (* (1+ x) 8)) (1- (* (1+ y) 16))))
        (incf i)))))

(defun palette-index (pixel palette)
  (position pixel (coerce palette 'list)))

(defun rip-bytes-from-image (image palettes bytes index)
  (let ((palette (elt (2a-to-list palettes) (best-palette image palettes))))
    (dotimes (y 16)
      (dotimes (half 2)
        (let ((byte-index (+ (+ half (* 2 index)) (* y #x100))))
          (check-type byte-index (integer 0 (4096)))
          (dotimes (x 4)
            (setf (ldb (byte 2 (* 2 x)) (aref bytes byte-index))
                  (palette-index (aref image (+ (- 3 x) (* 4 half)) (- 15 y)) palette))))))))

(defun compile-tileset (pathname)
  (with-open-file (*standard-output* 
                   (make-pathname :defaults pathname
                                  :directory '(:relative "Source/Generated/Maps/")
                                  :type "s")
                   :direction :output
                   :if-exists :supersede)
    (let* ((tileset (load-tileset pathname))
           (palettes (extract-palettes (tileset-image tileset)))
           (images (make-array (list 128)))
           (bytes (make-array (list (* 256 16)) :element-type '(unsigned-byte))))
      (format t ";;; This is a generated file~%;;; Source file ~a" pathname)
      (format t "~2&~a:      .block" (pathname-name pathname))
      (rip-tiles-from-tileset tileset images)
      (dotimes (i 128)
        (rip-bytes-from-image (aref images i) palettes bytes i))
      (format t "~2&Images:")
      (hex-dump-bytes bytes)
      (format t "~2&BackgroundColor:    .byte $~2,'0x" (aref palettes 0 0))
      (format t "~2&Palettes:")
      (dotimes (palette-index 7)
        (format t "~&     .byte $~2,'0x, $~2,'0x, $~2,'0x" 
                (aref palettes palette-index 1)
                (aref palettes palette-index 2)
                (aref palettes palette-index 3)))
      (format t "~2&      .bend")
      (fresh-line))))

