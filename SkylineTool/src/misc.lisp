(in-package :skyline-tool)

(defun region-valid-p ()
  (assert (member *region* '(:ntsc :pal :secam)) (*region*)
          "For some systems, the TV standard (region) must be set to one
          of (the keywords) NTSC, PAL, SECAM"))

(defvar *warned* (make-hash-table :test 'equal))
(defun warn-once (format &rest args)
  (let ((s (apply #'format nil format args)))
    (let ((n (gethash s *warned* 0)))
      (when (or (zerop n) (zerop (random n)))
        (warn s))
      (incf (gethash s *warned* 0) 0))))



(defun interactive-wait (format &rest args)
  (loop
     (apply #'format t format args)
     (fresh-line)
     (princ " ⏱ (I'll wait…) ⇒")
     (let ((char (read-char)))
       (when (member char '(#\return #\linefeed #\newline) :test #'char=)
         (return-from interactive-wait t)))))

*

(defun compile-index (index-file &rest asset-files)
  (warn "unimplemented, make index ~A from ~{~A~^, ~}" index-file asset-files))

(defun collect-assets (assets-file &rest asset-files)
  (warn "unimplemented, collect assets ~{~A~^, ~} into ~A" asset-files assets-file))


;;; generic bitmap manipulation stuff

(defvar *palette-warnings* nil)

;; common utility functions

(defun exact-length (len seq)
  (if (< (length seq) len)
      (append seq (make-list (- len (length seq)) :initial-element nil))
      (subseq seq 0 len)))

;; art compilers

(defun make-source-file-name (source-file-base-name)
  (make-pathname :directory (list :relative "Source" "Generated" (princ-to-string *machine*))
                 :name source-file-base-name))

(defun machine-from-filename (file-name)
  "Given a filename of an object file, identify which machine's object directory it is in."
  (destructuring-bind (obj machine &rest _) (split-sequence #\/ file-name)
    (declare (ignore _))
    (assert (equal "Source" obj))
    (ignore-errors (parse-integer machine))))



(defun compile-critters (index-out &rest critter-files)
  (warn "unimplemented, compile critters from ~{~A~^, ~} into ~A" critter-files index-out))


(defun world-from-filename (filename)
  (first (split-sequence #\. (lastcar (split-sequence #\/ (format nil "~A" filename))))))

(defun critters-referenced (dictionary)
  (remove-duplicates
   (append (all-references dictionary :critter)
           (mapcan #'cdr (all-references dictionary :spawn)))
   :test 'equal))

(defun all-references (dictionary type)
  (remove-duplicates
   (remove-if #'null
              (mapcar (rcurry #'getf type)
                      (hash-table-values dictionary)))
   :test 'equal))

(defun token-safe (token)
  "Render a token safe for use as a symbol using a very minimal alphabet."
  (typecase token
    (string (reduce (curry #'concatenate 'string)
                    (mapcar #'token-safe (coerce token 'list))))
    (character
     (if (or (alpha-char-p token)
             (digit-char-p token))
         (string token)
         (case token
           (#\: "_colon_") (#\. "_stop_") (#\, "_comma_") (#\% "_percent_")
           (#\; "_sem_") (#\< "_less_") (#\@ "_at_")
           (#\/ "_stroke_") (#\> "_more_") (#\- "_tack_") (#\+ "_plus_")
           (#\= "_eq_") (#\& "_and_") (#\~ "_tilde_") (#\$ "_dollar_")
           (#\! "_bang_") (#\( "_lparen_") (#\) "_rparen_") (#\? "_query_")
           (#\[ "_lbrac_") (#\] "_rbrac_") (#\' "_apos_") (#\" "_quote_")
           (#\\ "_revsol_") (#\# "_num_") (#\Space "__") (#\Newline "___")
           (#\Return "_ret_")
           (otherwise (format nil "_u~4,'0x_" (char-code token))))))
    
    (number (format nil "tok~36r" token))
    
    (null "nil")
    
    (t (token-safe (princ-to-string token)))))

(assert (equal (token-safe "My best friend") "My__best__friend"))

(assert (equal (token-safe "Look: up there, in the sky")
               "Look_colon___up__there_comma___in__the__sky"))

(defun test->asm (sexp)
  (ecase (car sexp)
    (not (not (test->asm (second sexp))))
    (has (format t "~% lda inventory_~A" (second sexp))
         nil)
    (did (format t "~% lda flags_~A~% and #flags_bit_~:*~A"
                 (second sexp)))))

(defvar *stringtab*)

(defun make-message-label (string)
  (string
   (gensym
    (concatenate 'string "MSG_"
                 (string-upcase
                  (remove-if-not #'alpha-char-p
                                 (subseq string 0
                                         (min (length string)
                                              10
                                              (position #\Space string :start 5)))))))))

(defun script->asm (sexp)
  (ecase (car sexp)
    (prog (let ((tag (string (gensym "PROG"))))
            (format t "~%;;; begin ~A" tag)
            (dolist (form (cdr sexp))
              (script->asm form))
            (format t "~%;;; end ~A" tag)))
    (did (format t "~% lda flags_~A	; set flag ~:*~A~:*
 ora #flags_bit_~A~:*
 sta flags_~A" (second sexp)))
    (undo (format t "~% lda flags_~A	; clear flag ~:*~A~:*
 and #($ff ^ flags_bit_~A)~:*
 sta flags_~A" (second sexp)))
    (give (format t "~% lda inventory_~A	; grant item ~:*~A
 bmi ~A
 clc
 inc inventory_~0@*~A
~A:" (second sexp) (string (gensym "GOT_ENOUGH_"))))
    (take (format t "~% lda inventory_~A	; drop item ~:*~A
 beq ~A
 clv
 dec inventory_~0@*~A
~A:" (second sexp) (string (gensym "DO_NOT_HAVE_"))))
    (print (destructuring-bind (string &key highlight) (cdr sexp)
             (let ((label (make-message-label string)))
               (format t "~2% ldy #>~A ; \"~A…\"
 ldx #<~0@*~A
 jsr printlines
;;; won't actually continue here until player hits •
"
                       label (subseq string 0 (min 16 (length string))))
               (push highlight *stringtab*)
               (push string *stringtab*)
               (push label *stringtab*))))
    (if (let ((end-label (gensym "END_IF_")))
          (let ((test (second sexp)))
            (format t "~% ;; test: ~S?" test)
            (if (eql 'and (car test))
                (mapcar (lambda (test)
                          (let ((sense (test->asm test)))
                            (format t "~% ~:[beq~;bne~] ~A" sense end-label)))
                        (cdr test))
                (let ((sense (test->asm test)))
                  (format t "~% ~:[beq~;bne~] ~A" sense end-label)))
            (script->asm (third sexp))
            (format t "~%~A: ;; skip to here if ¬~S" end-label test))))))

(defun string-index-to-screen (index)
  "convert string indices to screen-relative-positions"
  (+ (logand index #x3f)
     (* 40 (/ (logand index #xc0) 32))))

(defun char->petscii-font (char)
  "Convert a character to a PETSCII-like code … deprecated in favour of directly using screen codes in future, though."
  (cond
    ((null char) #xff)
    ;; alpha: case-invert
    ((char<= #\a char #\z) (values (char-upcase char) t))
    ((char<= #\A char #\Z) (values (char-downcase char) t))
    ;; don't quote, quotes.
    ((char= #\" char) (values #\" nil))
    ;; matching punctuation and digits
    ((or (char<= #\Space char #\.)
         (char<= #\0 char #\9)
         (char<= #\: char #\@)
         (char= #\[ char)
         (char= #\] char)) (values char t))
    ;; non-matching punctuation
    (t (let ((alter (getf +unicode->petscii-ish+ char)))
         (if alter
             (values alter nil)
             (progn (warn "No PETSCII'ish mapping for char ~A (~X)"
                          char (char-code char))
                    (values #xff nil)))))))

(defun char->ascii-font (char)
  (cond
    ((null char) #xff)
    ((or (char<= #\a char #\z)
         (char<= #\A char #\Z)
         (char<= #\Space char #\.)
         (char<= #\0 char #\9)
         (char<= #\: char #\@)
         (char= #\[ char)
         (char= #\] char)) (values char t))
    ;; don't quote, quotes.
    ((char= #\" char) (values #\" nil))
    ;; non-matching punctuation
    (t (let ((alter (getf +unicode->ascii-ish+ char)))
         (if alter
             (values alter nil)
             (progn (warn "No ASCII'ish mapping for char ~A (~X)"
                          char (char-code char))
                    (values #xff nil)))))))

(defun char->min-font (char)
  (cond
    ((null char) 47)
    ((char<= #\0 char #\9) (- (char-code char) (char-code #\0)))
    (t (case char
         (#\a 10)
         (#\b 11)
         (#\c 12)
         (#\d 13)
         (#\e 14)
         (#\f 15)
         (#\space 16)
         (#\. 17)
         (#\g 6)
         (#\h 18)
         (#\i 1)
         (#\j 19)
         (#\k 20)
         (#\l 21)
         (#\m (list 22 23))
         (#\n 24)
         (#\o 0)
         (#\p 25)
         (#\q 26)
         (#\r 27)
         (#\s 5)
         (#\t 28)
         (#\u 29)
         (#\v 30)
         (#\w (list 31 30))
         (#\x 32)
         (#\z 2)
         (#\- 33)
         (#\+ 34)
         ((#\[ #\( #\{) 35)
         ((#\] #\) #\}) 36)
         (#\! 37)
         (#\? 38)
         (#\“ 39)
         ((#\' #\") 40)
         (#\/ 41)
         (#\× 42)
         (#\• 43)
         (#\, 44)
         ((#\← #\<) 45)
         (#\> 46)
         (otherwise (error "Can't encode ~s in Atari minimalist coding" char))))))

(defun char->font (char)
  (ecase *machine*
    ((20 64 128) (char->petscii-font char))
    (2 (char->ascii-font char))
    (2600 (values (char->min-font char) nil))))

(defun unicode->font (string)
  (string-trim
   " ,"
   (apply
    #'concatenate
    'string
    (let ((quotedp nil))
      (append
       (loop for char across string
          collecting
            (multiple-value-bind (byte printablep)
                (char->font char)
              (cond
                ((and printablep quotedp) (string (coerce byte 'character)))
                (printablep (setf quotedp t)
                            (coerce (list #\, #\Space #\" (coerce byte 'character)) 'string))
                (quotedp (setf quotedp nil)
                         (etypecase byte
                           (character (format nil "\", $~2,'0X" (char-code byte)))
                           (number (format nil "\", $~2,'0X" byte))
                           (list (format nil "\"~{, $~2,'0X~}" byte))))
                (t (etypecase byte
                     (character (format nil ", $~2,'0X" (char-code byte)))
                     (number (format nil ", $~2,'0X" byte))
                     (list (format nil "~{, $~2,'0X~}" byte)))))))
       (when quotedp (list "\"")))))))

(defun write-stringtab ()
  (format t "~2%;;; strings table for script~%	.enc none~%")
  (loop for (label expr highlights) on *stringtab* by #'cdddr
     do (let ((expr96 (format nil "~96A" expr)))
          (format t "
~A	.byte ~{$~2,'0X~^, ~} ; highlights~
~{~% .text ~A~}~%"
                  label
                  (subseq (append (mapcar
                                   #'string-index-to-screen
                                   highlights)
                                  (list #xff #xff #xff #xff #xff #xff)) 0 6)
                  (list
                   (unicode->font (subseq expr96 0 32))
                   (unicode->font (subseq expr96 32 64))
                   (unicode->font (subseq expr96 64 96)))))))

(defun script->file (token script area map-file)
  (let ((script-file (merge-pathnames
                      (make-pathname
                       :directory '(:relative ".." "Object")
                       :name (concatenate 'string "map."
                                          area
                                          ".script."
                                          (token-safe token))
                       :type "s")
                      map-file)))
    (with-output-to-file (*standard-output* script-file
                                            :if-exists :supersede)
      (format t ";;; -*- asm -*-
;;; This file generated from map —
;;; World ~A
;;; Area: ~A
;;; Token: ~A

~:*~:*script_~A_~A:
" (world-from-filename map-file) area token)
      (let ((*stringtab*))
        (script->asm script)
        (format t "~% rts~3%;;; --------------------------------~2%")
        (write-stringtab)
        (format t "~3%;;; End.~%")))
    script-file)
  (format nil "script_~A_~A" area token))

(defun interpret-map-tile (tile dictionary map-area)
  (or (gethash tile dictionary)
      (error "Tile ~S used in map area ~A is not defined" tile map-area)))

(defmacro map-loop (array (row col tile) &body body)
  `(loop for ,col from 0 upto 63
      append
        (loop for ,row from 0 upto 9
           for ,tile = (aref ,array ,col ,row)
             ,@body)))

(defun gather-scripts (dictionary area map-file)
  (loop for token in (sort (hash-table-keys dictionary) #'string<)
     for script = (getf (gethash token dictionary) :script)
     when script
     collecting (list (if (and (stringp token)
                               (= 1 (length token)))
                          (elt token 0)
                          token)
                      (script->file token script area map-file))))

(defun map->script (array script-indices dictionary)
  (append (map-loop array (row col tile)
            for script-index = (position tile script-indices :key #'car)
            when script-index
            collect (list col row script-index))
          (when (getf (gethash "enter" dictionary) :script)
            (list #x80 #x80 (position "enter" script-indices :key #'car :test #'equal)))))

(defun write-asm-map-wrapper (asm map->script script-indices area)
  (format asm "~2%
	;;; ★ Area “~A” ★~:*

	.align $400
area_~A:~:*
	;; precompiled map grid data — 640B (128×64)
	.binary \"map.~A.o\",2 ~:*
	;; ends with script linkage count and X, Y, and script index pointers lists
	;; position now will be (area_~A + $~X)
	;; script jump table (~:D script~:P~:*)
	.byte ~:D
	.word ~{~A~^, ~}~
~%"
          area

          (length map->script)

          (length script-indices)
          (substitute 0 nil (exact-length 8 (mapcar #'second script-indices)))))

(defun write-scripts (map-file area dictionary asm)
  (format t "~2& Writing scripts in area ~A" area)

  (let ((script-indices (gather-scripts dictionary area map-file)))
    (assert (= (length script-indices) (length (all-references dictionary :script)))
            nil
            "Lost a script somewhere; I only found ~:D script~:P but thought I had ~:D"
            (length script-indices) (length (all-references dictionary :script)))
    (format t "~% Script labels: ~{~% • ~A~}~%"
            (mapcar #'second script-indices))
    (format asm "~2%
	;;; ★ Area “~A” ★
~:[	;;; No scripts~;~:*~{~%	.include \"~A\"~}~]
~%"
            area
            (mapcar (curry #'format nil "map.~A.script.~A.s" area )
                    (mapcar #'car script-indices)))))

(defun write-map+index (map-file area array dictionary asm)
  (format *trace-output* "~2& Writing area ~A" area)

  (let ((local-art (all-references dictionary :art)))
    (format *trace-output* "~% All tile art used: ~{~A~^, ~}" local-art))
  (format *trace-output* "~%~:[ No special sprites used.~;~:* All special sprites used: ~{~A~^, ~}~]"
          (all-references dictionary :sprite))
  (format *trace-output* "~%~:[ No critters.~;~:* All critters: ~{~A~^, ~}~]"
          (critters-referenced dictionary))
  (format *trace-output* "~%~:D Script~:P"
          (length (all-references dictionary :script)))
  (let ((map-bin-file (merge-pathnames
                       (make-pathname
                        :directory '(:relative ".." "Object")
                        :name (concatenate 'string "map." area)
                        :type "o")
                       map-file)))
    (with-output-to-file (area-binary map-bin-file
                                      :if-exists :supersede)

      ;; PRG header
      (princ (code-char 0) area-binary)
      (princ (code-char 8) area-binary)

      ;; array of tile images + control codes
      (map-loop array (row col tile)
        for interpretation = (interpret-map-tile tile dictionary area)
        do (princ
            (code-char (logand (tile-control-value interpretation)
                               (tile-art-value interpretation))) area-binary))

      ;; Two unused bytes. For alignment, I guess.
      (princ (code-char 1) area-binary)
      (princ (code-char 1) area-binary)

      ;; script associations
      (let ((script-indices (gather-scripts dictionary area map-file)))
        (assert (= (length script-indices) (length (all-references dictionary :script)))
                nil
                "Lost a script somewhere; I only found ~:D script~:P but thought I had ~:D"
                (length script-indices) (length (all-references dictionary :script)))
        (let ((map->script (map->script array script-indices dictionary)))
          (format *trace-output* "~%Script linkage: ~{~{(~2D,~2D) → #~2D~}~^; ~}
Script labels:"
                  map->script)
          (loop for label in script-indices
             for i from 0 upto (1- (length script-indices))
             do (format *trace-output* "~% #~2D. ~A" i (second label)))

          (princ (code-char (length map->script)) area-binary)
          (dotimes (table 3)
            (dolist (byte (mapcar #'code-char (mapcar (curry #'nth table) map->script)))
              (princ byte area-binary)))

          (write-asm-map-wrapper asm map->script script-indices area))))))

(defun add-map-row (line row array)
  (if (= (length line) 64)
      (dotimes (col 64)
        (setf (aref array col row) (elt line col)))
      (error "Area map row must be 64 chars; this one is:~%“~A”~%(~D chars)"
             line (length line))))

(defun define-tile (symbol dictionary &rest values)
  (setf (gethash symbol dictionary)
        (append values (gethash symbol dictionary))))

(defvar *all-areas* nil)
(defvar *all-critters* nil)
(defvar *all-flags* nil)
(defvar *all-items* nil)
(defvar *all-tiles* nil)

(defun dash-delim-p (delim)
  (and (< 10 (length delim))
       (every (curry #'char= #\-) (string-trim " " delim))))

(defun transform-string (line)
  (let ((aline
         (cl-ppcre:regex-replace-all
          "\~c="
          (cl-ppcre:regex-replace-all
           "\~stop"
           (cl-ppcre:regex-replace-all
            "\~f7"
            (cl-ppcre:regex-replace-all
             "\~button"
             (cl-ppcre:regex-replace-all
              "_(.*?)_"
              (cl-ppcre:regex-replace-all
               "\\.\\.\\."
               (cl-ppcre:regex-replace-all
                "``"
                (cl-ppcre:regex-replace-all
                 "''"
                 (string-trim " " line)
                 "”")
                "“")
               "…")
              "«\\1»")
             "•")
            "Ⓕ⑦")
           "ⓇⓊⓃ")
          "䓈")))
    (let ((tline (remove #\« (remove #\» aline))))
      (when (< 32 (length tline))
        (error "Dialog string too long: \"~A\" is ~:D characters (limit: 32)"
               tline (length tline)))
      (values (format nil "~32A" tline)
              (position #\« aline)
              (position #\» (remove #\« aline))))))

(defun parse-boolean-expr (words)
  (if-let ((orry (position "or" words :test 'string=)))
    (list 'or
          (parse-boolean-expr (subseq words 0 orry))
          (parse-boolean-expr (subseq words (1+ orry))))
    (if-let ((andy (position "and" words :test 'string=)))
      (list 'and
            (parse-boolean-expr (subseq words 0 andy))
            (parse-boolean-expr (subseq words (1+ andy))))
      (ecase (intern (string-upcase (car words)) :keyword)
        (:has (pushnew (second words) *all-items* :test 'equal)
              `(has ,(second words)))
        (:no (pushnew (second words) *all-items* :test 'equal)
             `(not (has ,(second words))))
        (:did (pushnew (second words) *all-flags* :test 'equal)
              `(did ,(second words)))
        (:not (pushnew (second words) *all-flags* :test 'equal)
              `(not (did ,(second words))))))))

(defun compile-script (area stream delim &optional recursion)
  (format *trace-output* "~& (compiling script in ~A~@[, until ~A~])" area recursion)
  (let* ((sexp '(prog))
         (string "")
         (highlights nil))
    (flet ((finish-string ()
             (when (plusp (length string))
               (appendf sexp `((print ,string :highlight ,highlights)))
               (setf string "")
               (setf highlights nil))))

      (flet ((add-string (line start-highlight end-highlight)
               (format *trace-output* "~& |~32A|" line)
               (cond
                 ((or (null line) (zerop (length line))
                      (every (curry #'char= #\Space) line))
                  (format *trace-output* " ✗ blank"))
                 ((zerop (length string))
                  (setf highlights (when start-highlight (list start-highlight end-highlight)))
                  (setf string line)
                  (format *trace-output* " ⁂ starts new screen"))
                 ((> 96 (length string))
                  (when start-highlight (appendf highlights (mapcar (curry #'+ (length string))
                                                                    (list start-highlight end-highlight))))
                  (setf string  (concatenate 'string
                                             string (transform-string line)))
                  (format *trace-output* " … "))
                 (t (finish-string)
                    (setf highlights (when start-highlight (list start-highlight end-highlight)))
                    (setf string line)
                    (format *trace-output* " ✓ starts another screen")))))
        (unless (or recursion (dash-delim-p delim))
          (error "Expected script delimiter --------------------------------; got ~A" delim))
        ;; (if recursion
        ;;     (format *error-output* "~%     Looking for end marker ~A" recursion)
        ;;     (format *error-output* "~% Compiling a script for area ~A" area))
        (loop
           for line = (read-line stream)
           until (if recursion
                     (string= recursion line)
                     (dash-delim-p line))
           do (if (and (plusp (length line))
                       (char= #\\ (elt (string-trim " " line) 0)))
                  (let ((command (intern (string-upcase (subseq line
                                                                (1+ (position #\\ line))
                                                                (or (position #\Space line)
                                                                    (length line))))))
                        (words (rest (split-sequence #\Space line))))
                    (finish-string)
                    (format *trace-output* "~&ƒ \\~A ~{~A~^ ~}" command words)
                    (ecase command
                      (if (appendf sexp
                                   `((if ,(parse-boolean-expr words)
                                         ,(compile-script area stream delim "\\fi")))))
                      ((give take)
                       (appendf sexp `((,command ,@words)))
                       (pushnew (second words) *all-items* :test 'string=))
                      ((did undo)
                       (appendf sexp `((,command ,@words)))
                       (pushnew (second words) *all-flags* :test 'string=))))

                  ;; String line handler
                  (multiple-value-bind (line start-highlight end-highlight) (transform-string line)
                    (add-string line start-highlight end-highlight)))
           finally (progn (when (plusp (length string))
                            (finish-string))
                          (format *trace-output* "~&… done~:[ with this script.~; with this § — got to ~:*~A.~]" recursion)
                          (return-from compile-script sexp)))))))

(defun read-declaration (area stream line dictionary)
  (unless (or (zerop (length line))
              (and (dash-delim-p line)
                   (error "Unexpected dashed delimiter (script leaked?)~%~A" line)))
    (let* ((parts (mapcar (curry #'string-trim " ")
                          (split-sequence #\= line)))
           (defined (if (= 1 (length (car parts)))
                        (elt (car parts) 0)
                        (car parts)))
           (declared (remove-if #'null
                                (split-sequence #\Space
                                                (or (second parts)
                                                    (error "Don't know what to define ~A as in ~A"
                                                           defined line))))))

      ;; (format *error-output* " ~S …" defined)

      (when (and (member defined '(#\; #\, #\^ #\_))
                 (= 1 (length declared)))
        (setf declared (list "floor"
                             "door" (car declared)
                             (ecase defined
                               (#\, #\;) (#\; #\,) (#\^ #\_) (#\_ #\^)))))

      (flet ((learn (key value)
               (define-tile defined dictionary key value))
             (accepted (count) (setf declared (nthcdr count declared))))

        (when (string= defined "spawn")
          (let ((critters (remove-if (lambda (s)
                                       (zerop (length s)))
                                     (mapcar (curry #'string-trim " ,")
                                             (mapcan (curry #'split-sequence #\,)
                                                     (rest declared))))))
            (learn :spawn `(,(parse-integer (car declared))
                             ,@critters))
            (dolist (critter critters) (pushnew critter *all-critters* :test 'equal)))
          (setf declared nil))

        (when (and (characterp defined)
                   (or (char<= #\a defined #\z)
                       (char<= #\A defined #\Z)))
          (learn :art "floor")
          (learn :wall nil))

        (loop while declared
           ;; do (format *error-output* "~A" (first declared))
           do (case (intern (string-upcase (first declared)) :keyword)
                (:door (learn :door (cons (second declared) (third declared)))
                       (learn :entry defined)
                       (accepted 3)
                       (pushnew (second declared) *all-areas* :test 'equal))
                (:entry (learn :entry defined)
                        (accepted 1))
                (:floor (learn :wall nil)
                        (learn :art "floor")
                        (accepted 1))
                (:art (learn :art (second declared))
                      (accepted 2))
                (:wall (learn :wall t)
                       (learn :art "wall")
                       (accepted 1))
                (:sprite (learn :sprite (second declared))
                         (accepted 2))
                (:cost (learn :cost
                              (parse-integer (remove-if (rcurry #'member '(#\Space #\$ #\,))
                                                        (string-trim " ." (second declared)))))
                       (accepted 2))
                (:spawn (let ((critter (second declared)))
                          (learn :sprite critter)
                          (learn :critter critter)
                          (pushnew critter *all-critters* :test 'equal)
                          (accepted 2)))
                ((:chat :script) (accepted 1) (learn :script (compile-script area stream (read-line stream))))
                (:& (accepted 1))
                (:item (let ((item-name (second declared)))
                         (learn :sprite item-name)
                         (let ((flag (concatenate 'string "itemp_" area "_" (string defined))))
                           (learn :sprite-flag flag)
                           (pushnew flag *all-flags* :test 'equal)
                           (pushnew item-name *all-items* :test 'equal)
                           (learn :script `(if (not (did ,flag)) (give ,item-name))))
                         (accepted 2)))
                (otherwise
                 (if (= 1 (length declared))
                     (progn (learn :art (car declared))
                            (warn "Assuming ~A means ~A has art ~A" line defined (car declared))
                            (accepted 1))
                     (error "~%Unrecognized declaration ~A in ~A~% ~S" (first declared) line declared)))))))))

(defun seek-heading (stream)
  (loop for heading = (read-line stream nil :eof)
     do (cond
          ((or (eql :eof heading)
               (and (plusp (length heading))
                    (char= #\* (elt heading 0)))) (return-from seek-heading heading))
          ((and (plusp (length heading))
                (string= "!end" heading :end2 4)) (return-from seek-heading :eof))
          ((plusp (length (string-trim " " heading)))
           (warn "Discarded junk line ~A before maps" heading)))))

(defun fresh-dictionary ()
  (let ((dict (make-hash-table)))
    (setf (gethash #\# dict) '(:wall t :art "wall"))
    (setf (gethash #\$ dict) '(:wall t :art "wall-decor"))
    (setf (gethash #\- dict) '(:wall t :art "floor"))
    (setf (gethash #\. dict) '(:wall nil :art "floor"))
    (setf (gethash #\: dict) '(:wall nil :art "floor-decor"))
    (setf (gethash #\< dict) '(:wall nil :art "door-left"))
    (setf (gethash #\> dict) '(:wall nil :art "door-right"))
    (setf (gethash #\@ dict) '(:wall nil :art "door-up"))
    (setf (gethash #\~ dict) '(:wall nil :art "door-down"))
    dict))

(defun read-area (map)
  (let ((heading (seek-heading map)))
    (when (eql :eof heading) (return-from read-area nil))
    (let ((this-area (string-trim " " (subseq heading 1)))
          (array (make-array '(64 10) :element-type 'character :initial-element #\Return))
          (dictionary (fresh-dictionary)))
      (format *trace-output* "~2& ★ Reading map for area ~A" this-area)
      (pushnew this-area *all-areas* :test 'equal)
      (dotimes (row 10)
        (let ((line (string-trim " " (read-line map))))
          (add-map-row line row array)))
      (loop until (char= #\* (peek-char nil map nil #\*))
         for line = (string-trim " " (read-line map))
         do (read-declaration this-area map line dictionary))
      (values this-area array dictionary))))

(defun read-tile-layout (map-file)
  (with-open-file (tileset (merge-pathnames
                            (make-pathname
                             :name (world-from-filename map-file)
                             :type "layout"
                             :directory '(:relative ".." "art"))
                            map-file))
    (setf *tileset* (read tileset nil nil))))

(defun group-flags (flags)
  (loop for cluster on flags by (curry #'nthcdr 8)
     collect (loop for flag in (subseq cluster 0 (min 8 (length cluster)))
                for bit from 0
                collecting (list flag (expt 2 (- 7 bit))))))

(defun write-index (index)
  (format *trace-output* "~2&
------------------------------------------------------------------------
Done with all files; saw:
 All areas: ~{~A~^, ~}~% All items: ~{~A~^, ~}~% All flags: ~{~A~^, ~}~% All critters: ~{~A~^, ~}"
          (sort *all-areas* #'string<)
          (sort *all-items* #'string<)
          (sort *all-flags* #'string<)
          (sort *all-critters* #'string<))
  (format index ";;; -*- asm -*-
;;; Player data block: inventory and flags
	.include \"../src/wiring.asm\"

	* = inventorystart
inventory:~
~{~%inventory_~A	.byte ?~}

gameflags:~
~{~2%	.byte ?	; ~{~{~A~*~}~^, ~}~:*
~{~{~%	flags_~A = *~:*
		flags_bit_~A = $~2,'0X ~}~}~}

inventory_end = *
	.warn \"Inventory and game flags = \", *-inventory, \" bytes; \", inventorymax-*,\" bytes free\"
	.if (* > inventorymax)
		.error \"FAILURE: Relocate inventory; \", *, \" > \", inventorymax
	.fi
"
          (sort (remove-duplicates (append *all-items* (cons "AI" nil)) :test 'equal) #'string<)
          (group-flags (sort *all-flags* #'string<))))

(defun compile-map (index-out &rest map-files)
  (let (*all-areas* *all-items* *all-flags* *all-critters*)
    (unless (plusp (length map-files))
      (warn "No maps?")
      (with-output-to-file (index index-out :if-exists :supersede)
        (format index ";;; -*- asm -*- TODO: map some maps for this area~%~% * = 0 ~% brk~%"))
      (return-from compile-map nil))
    (format *trace-output* "~%Creating map binaries~%~{~% • world file: ~A~}" map-files)
    (with-output-to-file (index index-out
                                :if-exists :supersede)
      (dolist (map-file map-files)
        (format *trace-output* "~2%--------------------------------~% ★ World: ~:(~A~) ★ ~2%"
                (world-from-filename map-file))
        (let ((*tileset* nil))
          (read-tile-layout map-file)
          (with-open-file (map map-file :direction :input)
            (let ((asm-file (make-pathname
                             :name (format nil "world.~A" (world-from-filename map-file))
                             :type "asm"
                             :defaults index-out)))
              (with-output-to-file (asm asm-file
                                        :if-exists :supersede)
                (let ((queue))
                  (tagbody back
                     (multiple-value-bind (area map dict)
                         (read-area map)
                       (when area
                         (appendf queue (list (list area map dict)))
                         (go back))))
                  (format asm ";;; ★ World: ~:(~A~) ★

	.include \"../include/world-header.s\"

	* = mapstart
"
                          (world-from-filename map-file))
                  (loop for (area array dict) in queue
                     do (write-map+index map-file area array dict asm))
                  (format asm "~5%	;;; ************************************ ~2%")
                  (loop for (area array dict) in queue
                     do (write-scripts map-file area dict asm))
                  (format asm "~3%
	;;; Trailer record
	;;; ~R area~:P, then scripts start
	.byte ~:*~D"
                          (length queue))))
              (format *trace-output* "~2% WROTE WORLD — wrapper in ~A" asm-file)))))
      (write-index index))))



(defun compile-sound (index-out midi-in)
  (warn "unimplemented, compile sound ~A into ~A" midi-in index-out))




(defun machine-short-name ()
  (ecase *machine*
    (1 "Oric-1")
    (2 "Apple //")
    (8 "NES")
    (16 "TG-16")
    (20 "VIC-20")
    (64 "C=64")
    (88 "SNES")
    (128 "C=128")
    (223 "BBC")
    (264 "Plus/4")
    (2600 "VCS")
    (5200 "SuperSystem")
    (7800 "ProSystem")))

(defun machine-long-name ()
  (ecase *machine* 
    (1 "Oric-1")
    (2 "Apple ][ (][plus, //c, //e, //gs)")
    (8 "Nintendo Entertainment System")
    (16 "TurboGrafx-16 (PC Engine)")
    (20 "Commodore VIC-20 (VC-20)")
    (64 "Commodore 64")
    (88 "Super Nintendo Entertainment System")
    (128 "Commodore 128")
    (223 "BBC Micro")
    (264 "Commodore Plus/4 (16)")
    (2600 "Atari Video Computer System CX-2600")
    (5200 "Atari Video SuperSystem CX-5200")
    (7800 "Atari Video ProSystem CX-7800")))

(defun machine-valid-p ()
  (assert (and (machine-short-name) (machine-long-name))
          (*machine*)))




(defun truthy (s)
  "Converts a string, symbol, or number into a generalized Boolean
 
Strings or symbols can be TRUE, T, YES, ON, &c. (case-insensitive)

Numbers must be merely non-zero

Strings-of-numbers must be non-zero integers (eg: 1, -1)"
  (and s
       (or (eql t s)
           (when (numberp s) (not (zerop s))) 
           (member s '(true t yes on si oui ja jes да) 
                   :test #'string-equal)
           (not (zerop (parse-integer s :junk-allowed t))))))



(defun atari-f9-p ()
  (truthy (uiop:getenv "ATARI_F9")))

(defun atari-2600-number-of-banks ()
  "Use 8 banks of 4kiB (32kiB) or 128×4kiB (512kiB)?

Assume $f4  (32kiB) banking, unless environment  variable ATARI_F9=T,
then use $f9 (512kiB) banking."
  (if (atari-f9-p)
      128
      8))



(defmacro do-collect ((&rest for-clause) &body body)
  `(loop for ,@for-clause
      collect (progn    ,@body)))

(defun group-by (predicate set)
  (check-type set list)
  (let (truthy falsy)
    (dolist (element set)
      (if (funcall predicate element)
          (push element truthy)
          (push element falsy)))
    (list (nreverse truthy) (nreverse falsy))))


(defun pretty-duration (seconds)
  (cond
    ((> seconds (* 24 60 60))
     (format nil "~:d day~:p~[~:;, ~:*~:d hour~:p~]"
             (floor seconds (* 24 60 60))
             (round (rem seconds (* 24 60 60)) (* 60 60))))
    ((> seconds (* 60 60))
     (format nil "~:d hour~:p~[~:;, ~:*~:d minute~:p~]"
             (floor seconds (* 60 60))
             (round (rem seconds (* 60 60)) 60)))
    ((> seconds 60)
     (format nil "~:d minute~:p~[~:;, ~:*~,1f second~:p~]"
             (floor seconds 60)
             (rem seconds 60)))
    (t
     (format nil "~,1f second~:p" seconds))))

(defvar *make-vars%*)

(defun get-make-vars ()
  (memoize *make-vars%*
           (let ((make-qp (uiop:run-program '("make" "-qp") :output :string
                                            :ignore-error-status 1))
                 (vars (make-hash-table :test 'equal)))
             (loop for line in (split-string make-qp :separator #(#\newline))
                when (and
                      (plusp (length line))
                      (char/= #\# (char line 0))
                      (or (search " = " line)
                          (search " := " line)))
                do (setf (gethash (string-trim #(#\space #\tab) 
                                               (subseq line 0 (position #\= line))) 
                                  vars)
                         (string-trim #(#\space #\tab)
                                      (subseq line (1+ (position #\= line)))))
                when (equal line "# Directories")
                do (return-from get-make-vars vars)))))

(defun make-var-actual-value (identifier vars)
  (let ((value (gethash (string identifier) vars)))
    (assert (stringp value) (value)
            "Make variable “~a” is identified but not defined" identifier)
    (loop
       while (and (search "${" value)
                  (position #\} value)
                  (< (search "${" value)
                     (position #\} value)))
       do (setf value 
                (concatenate 'string 
                             (subseq value 0 (search "${" value))
                             (make-var-actual-value 
                              (subseq value 
                                      (+ 2 (search "${" value))
                                      (position #\} value))
                              vars)
                             (subseq value (1+ (position #\} value))))))
    (loop
       while (and (search "$(shell" value)
                  (position #\) value)
                  (< (search "$(shell" value)
                     (position #\) value)))
       do (setf value 
                (concatenate
                 'string 
                 (subseq value 0 (search "$(shell" value))
                 (run-program 
                  (string-trim
                   #(#\space #\tab)
                   (subseq value 
                           (+ 7 (search "$(shell" value))
                           (position #\) value)))
                  :output :string
                  )
                 (subseq value (1+ (position #\) value))))))
    (substitute #\Space #\Newline value)))


(defun atari-bank-switching-method-switch ()
  (if (atari-f9-p)
      " -D BankSwitchingMethod='$f9' "
      " -D BankSwitchingMethod='$f4' "))

(defun ensure-bin/64tass-exists ()
  (unless (probe-file "bin/64tass")
    (run-program '("make" "bin/64tass"))))


(defun error-output-from-compiling (temp-name)
  (second 
   (multiple-value-list 
    (run-program 
     (concatenate 'string
                  "bin/64tass "
                  (make-var-actual-value "AS2600" (get-make-vars))
                  " " 
                  (atari-bank-switching-method-switch)
                  (namestring temp-name))
     :output nil :error-output :string
     :ignore-error-status t))))





(defun find-size-of-bank (&rest includes)
  (uiop:with-temporary-file
      (:stream temp
               :pathname temp-name
               :suffix "s"
               :element-type 'character
               :external-format :utf-8)
    (format temp "BANK=9
.include \"preamble.s\"
~{~%.include \"~a\"~}
.include \"finis.s\"~%"
            includes)
    (finish-output temp)
    (ensure-bin/64tass-exists) 
    (let* ((compiler-warnings (or (error-output-from-compiling temp-name)
                                  (error "No compiler warnings?")))
           (bytes-left (search "bytes left" compiler-warnings)))
      (unless bytes-left
        (error "Couldn't find “bytes left” in ~s" compiler-warnings))
      (parse-integer (remove-if-not #'digit-char-p
                                    (subseq compiler-warnings
                                            (- bytes-left 6)
                                            bytes-left))))))

(defun max-banks (machine)
  (getf (list
         2600 (atari-2600-number-of-banks)
         64 32) machine))
