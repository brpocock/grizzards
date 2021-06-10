(in-package :skyline-tool)



(defmacro define-simple-class (name (&rest superclasses) (&rest fields-and-accessors))
  `(defclass ,name (,@superclasses)
     ,(map 'list
           (lambda (field-info)
             (destructuring-bind (field accessor &rest more) field-info
               `(,field
                 :initarg ,(make-keyword field)
                 ,@(when accessor
                         (list accessor (format-symbol *package* "~a-~a" name field)))
                 ,@more)))
           fields-and-accessors)))

(defvar *potential-parts*)

(defun identify-potential-part (sequence parent start)
  (let ((prior (gethash sequence *potential-parts* nil)))
    (setf (gethash sequence *potential-parts*)
          (cons (list parent start)
                prior))))

(let ((*potential-parts* (make-hash-table :test 'equalp)))
  (identify-potential-part "abc" "abc" 0)
  (assert (equalp (gethash "abc" *potential-parts*)
                  '(("abc" 0)))) 
  (identify-potential-part "abc" "abcd" 0)
  (assert (equalp (gethash "abc" *potential-parts*)
                  '(("abcd" 0) ("abc" 0))))
  (assert (= 1 (hash-table-count *potential-parts*))))

(defun identify-all-potential-parts (sequences min-length max-length)
  (dolist (sequence sequences)
    (let ((last-start (- (length sequence) min-length))) 
      (if (not (plusp last-start))
          (identify-potential-part sequence sequence 0)
          (dotimes (start (1+ last-start)) 
            (loop for length from min-length
               upto (min max-length (- (length sequence) start)) 
               do (identify-potential-part
                   (subseq sequence start (+ start length))
                   sequence start)))))))

(let ((*potential-parts* (make-hash-table :test 'equalp)))
  (identify-all-potential-parts '("abc") 1 3)
  (assert (equalp (sort (hash-table-alist *potential-parts*)
                        #'string< :key #'car)
                  '(("a" ("abc" 0)) ("ab" ("abc" 0)) ("abc" ("abc" 0))
                    ("b" ("abc" 1)) ("bc" ("abc" 1)) ("c" ("abc" 2))))))

(let ((*potential-parts* (make-hash-table :test 'equalp)))
  (identify-all-potential-parts '("abc" "bcd") 1 3)
  (assert (equalp (sort (hash-table-alist *potential-parts*)
                        #'string< :key #'car)
                  '(("a" ("abc" 0)) ("ab" ("abc" 0)) ("abc" ("abc" 0))
                    ("b" ("bcd" 0) ("abc" 1)) ("bc" ("bcd" 0) ("abc" 1))
                    ("bcd" ("bcd" 0)) ("c" ("bcd" 1) ("abc" 2)) ("cd" ("bcd" 1))
                    ("d" ("bcd" 2))))))

(defun rank-popular-sequences ()
  (sort (hash-table-alist *potential-parts*)
        #'< :key #'length))

(let ((*potential-parts* (make-hash-table :test 'equalp)))
  (identify-all-potential-parts '("the" "theory" "them") 3 3)
  (assert (equalp (sort (hash-table-alist *potential-parts*)
                        #'string< :key #'car)
                  '(("eor" ("theory" 2)) ("hem" ("them" 1)) ("heo" ("theory" 1))
                    ("ory" ("theory" 3)) ("the" ("them" 0) ("theory" 0) ("the" 0))))))

(defun part-starting-at-p (matches? original start)
  (mapcar #'car
          (remove-if-not (lambda (match) 
                           (and (member original (cdr match) :key #'first) 
                                (member start (cdr match) :key #'second :test #'=)))
                         matches?)))

(assert (part-starting-at-p '(("abc" (#1="abc" 0))) #1# 0))
(assert (equalp (part-starting-at-p '(("abc" (#1="abc" 0))) #1# 0)
                '("abc")))
(assert (not (part-starting-at-p '(("abc" (#1="abc" 0))) "def" 0)))
(assert (not (part-starting-at-p '(("bc" ("bc" 0))) "abc" 1)))

(defun find-subsequent-parts (popularity original &optional (start 0))
  (error "doesn't work")
  (if-let (found (part-starting-at-p popularity original start))
    (loop for prefix in found 
       for next = (+ start (length prefix)) 
         
       if (<= next (length popularity)) 
       append (cons prefix
                    (find-subsequent-parts popularity original next))
       else append nil)
    (list found)))
#+broken
(let ((popular '(("eor" (#1="theory" 2))
                 ("hem" ("them" 1)) ("heo" (#1# 1))
                 ("ory" (#1# 3)) ("the" ("them" 0) (#1# 0) ("the" 0)))))
  (find-subsequent-parts popular #1# 0))

(defun split-into-recurring (sequences &key
                                         (min-length 16) 
                                         (max-length 256) 
                                         (max-parts 256))
  "Given a set of SEQUENCES, split them, removing repeated sections.

Returns  a sequence  of strings  of indices  and a  table of  sequences,
which,  when integrated  in  the  order of  the  indices, reproduce  the
original  sequences.  Each  split-up  sequence   will  be  of  at  least
MIN-LENGTH and at  most MAX-LENGTH elements, and no  more than MAX-PARTS
will be produced. 

The sequences are compared using EQUALP.

This  implementation is  probably terribly  inefficient, and  constructs
tons  of objects,  and I  don't really  care, because  I'm using  it for
packing small things into even smaller spaces.

SEQUENCE can consist of any elements;  but each element is considered to
be  of  equal weight  for  purposes  of  the MIN-LENGTH  and  MAX-LENGTH
parameters."
  (let ((*potential-parts* (make-hash-table :test 'equalp)))
    (identify-all-potential-parts sequences min-length max-length) 
    (let* ((popularity (rank-popular-sequences))
           (coded 
            (remove-if
             (lambda (coded)
               (< max-parts (length coded)))
             (mapcar (curry #'find-subsequent-parts popularity) sequences))))
      ;; this sort is wrong
      coded
      ;; (first (sort coded #'< :key (compose #'length #'flatten)))
      )))
#+broken
(assert (equalp (split-into-recurring
                 '( "abcdefg" "abcdef" "abcdef") 
                 :min-length 1 :max-length 10 :max-parts 3)
                '( ( (0 1) (0) (0) )
                  ( "abcdef" "g"))))



(defun group-into-3 (list)
  (loop for (a b c) on list by #'cdddr
     collect (list a b c)))

(defun group-into-6 (list)
  (loop for (a b c d e f) on list by (curry #'nthcdr 6)
     collect (list a b c d e f)))

(defmacro concatenatef (place new-string)
  `(setf ,place (concatenate 'string ,place ,new-string)))



(defun alist-flip (alist)
  (loop for (key . value) in alist
     collect (cons value key)))

(defun check-sequential (alist)
  (loop for i from 0
     for (num . _) in alist
     do (assert (= i num) (alist)
                "The indexed alist was expected to be sequential, but missed #~d and found ~d next~%indices: ~s"
                i num (mapcar #'car alist))))

(defun reverse-byte (byte)
  (check-type byte (unsigned-byte 8))
  (dpb (ldb (byte 1 7) byte) (byte 1 0)
       (dpb (ldb (byte 1 6) byte) (byte 1 1)
            (dpb (ldb (byte 1 5) byte) (byte 1 2)
                 (dpb (ldb (byte 1 4) byte) (byte 1 3)
                      (dpb (ldb (byte 1 3) byte) (byte 1 4)
                           (dpb (ldb (byte 1 2) byte) (byte 1 5)
                                (dpb (ldb (byte 1 1) byte) (byte 1 6)
                                     (dpb (ldb (byte 1 0) byte) (byte 1 7)
                                          0)))))))))

(assert (= #x80 (reverse-byte 1)))
(assert (= #x55 (reverse-byte #xaa)))

(defun sort-hash-table-by-values (hash-table)
  (let ((alist (sort (alist-flip (hash-table-alist hash-table))
                     #'< :key #'car)))
    (check-sequential alist)
    (mapcar #'cdr alist)))

(defun !! (generalized-boolean)
  (and generalized-boolean t))


(defun array-2d-p (place)
  (let ((type (type-of place)))
    (and (consp type)
         (member (car type) '(array simple-array))
         (= 2 (length (third type))))))

(deftype array-2d () '(satisfies array-2d-p))



(defun copy-rect (array2d left top width height)
  (check-type array2d array-2d)
  (check-type left (integer 0 *))
  (check-type width (integer 0 *))
  (check-type top (integer 0 *))
  (check-type height (integer 0 *))
  (assert (>= (array-dimension array2d 0) (+ left width)))
  (assert (>= (array-dimension array2d 1) (+ top height)))
  (let ((copy (make-array (list width height))))
    (dotimes (x width)
      (dotimes (y height)
        (setf (aref copy x y) (aref array2d (+ left x) (+ top y)))))
    copy))

(defun nullif (nullish value)
  (if (equal value nullish)
      nil
      value))

(defun range (from to)
  (check-type from real)
  (check-type to real)
  (assert (<= from to))
  (loop for i from from to to collect i))

(defmacro maptimes ((var count) &body body)
  `(mapcar (lambda (,var)
             ,@body)
           (range 0 (1- ,count))))



(defun power-of-two-size (size)
  (check-type size (integer 0 *))
  (if (zerop size) "empty"
      (multiple-value-bind (G M_) (floor size (expt 2 30))
        (multiple-value-bind (M k_) (floor M_ (expt 2 20))
          (multiple-value-bind (k b) (floor k_ (expt 2 10))
            (format nil "~[~:;~:*~:dGiB ~]~[~:;~:*~:dMiB ~]~[~:;~:*~:dkiB ~]~[~:;~:*~:d byte~:p~]" G M k b))))))



(defun first-line (text)
  (if-let (line-end (position #\Newline text))
    (let ((to-newline (subseq text 0 line-end)))
      (if (< 80 (length to-newline))
          (first-line to-newline)
          to-newline))
    (if (> 72 (length text))
        text
        (concatenate 'string
                     (if-let (space (position #\Space text :from-end t :start 40 :end 72))
                       (subseq text 0 space)
                       (subseq text 0 72))
                     "…"))))

(assert (equal (first-line "Now is the time for all good men to come to the aid of their country")
               "Now is the time for all good men to come to the aid of their country"))

(assert (equal (first-line (make-array 100 :element-type 'character :initial-element #\x))
               "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx…"))

(assert (equal (first-line "This is one line.
This is another.")
               "This is one line."))

(assert (equal (first-line
                "The quick brown fox jumped over the lazy dog. The quick brown dog jumped over the lazy fox.")
               "The quick brown fox jumped over the lazy dog. The quick brown dog…"))



(defun numbered (list)
  (check-type list list)
  (loop for i from 1
     for element in list
     collect (cons i element)))



