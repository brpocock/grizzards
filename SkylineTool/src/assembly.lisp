(in-package :Skyline-Tool)

(defun machine-source-file (name)
  (make-pathname :directory (list :relative "Source" (princ-to-string *machine*))
                 :name name :type "s"))

(defun machine-generated-file (name)
  (make-pathname :directory (list :relative "Source" "Generated" (princ-to-string *machine*))
                 :name name :type "s"))

(defun write-asm-header ()
  (format t ";;; -*- asm -*-
;;;
;;; This is a generated file, created by Skyline-Tool.
;;;
;;; Changes made to this file may be erased when it is regenerated;
;;; instead, you should edit the file(s) which contribute to this, or
;;; Skyline-Tool itself.
;;;~2%"))

(defun memory-bank-file (bank-number)
  (machine-generated-file (format nil "bank-~(~2,'0x~)" bank-number)))

(defun write-memory-bank-header (bank-number)
  (write-asm-header)
  (format t ";;; Memory bank structure file (for $F9 banking)
	BANK = ~d	; ~:*$~2,'0x
	.include \"preamble.s\"~2%"
          bank-number))

(defun write-memory-bank-footer (bank-number)
  (declare (ignore bank-number))
  (format t "~2%	.include \"finis.s\"~%"))

(defmacro with-output-to-memory-bank-file ((bank-number) &body body)
  `(with-output-to-file (*standard-output* (memory-bank-file ,bank-number)
                                           :if-exists :supersede)
     (write-memory-bank-header ,bank-number)
     ,@body
     (write-memory-bank-footer ,bank-number)))

(defgeneric write-text-bank (machine bank-number info))

(defmethod write-text-bank ((machine (eql 2600)) bank-number description)
  (declare (ignore description))
  (with-output-to-memory-bank-file (bank-number)
    (format t "~%;;; TODO: this content is not yet created")
    (format t "~%bankinit:	brk")))

(defun write-map-data/2600 (table-name format-string grid-key
                            world grids)
  (check-type table-name string)
  (check-type format-string string) 
  (check-type world string) 
  (check-type grid-key (or symbol function))
  (check-type grids cons) 
  (every (lambda (grid) (check-type grid grid/tia)) grids)
  
  (progn (format t "~%~|~%map~a:" table-name)
         (dolist (grid grids)
           (let ((data (funcall grid-key grid)))
             (format t "~%map_~a_~a_~x:~%"
                     table-name world (grid-id grid))
             (format t format-string data)))))

(defun write-map-grids/2600 (grids) 
  (loop for (table-name format-string grid-key)
     in '(("Tiles" "~{~%	.byte $~2,'0x, $~2,'0x, $~2,'0x, $~2,'0x~}" list-grid-tiles)
          ("Colors" "	.byte ~{$~2,'0x~^, ~}" list-grid-row-palette-colors)
          ("Backgrounds" "	.byte $~2,'0x" grid-background-color))
     do (write-map-data/2600 table-name format-string grid-key
                             world grids)))





(defvar *current-file*)
(defvar *line-number*)
(defvar *symbol-table*)

(defvar *memory-map* nil)

(require 'cl-6502)

(define-simple-class memory-region () ())

(define-simple-class memory-bank (memory-region)
  ((image :reader :type (or (vector (unsigned-byte 8))))))
(define-simple-class ram-bank (memory-region) ())
(define-simple-class rom-bank (memory-region) ())

(define-simple-class mapped-io (memory-region) ())
(define-simple-class r6510-ports (mapped-io)
  ((io :accessor)
   (ddr :accessor)))
(define-simple-class io-ports (mapped-io) ())
(define-simple-class f4-controls (mapped-io)
  ((rom :reader :type rom-bank :reader rom-bank)))
(define-simple-class f9-controls (mapped-io)
  ((rom :reader :type rom-bank :reader rom-bank)))

(define-simple-class memory-mapping ()
  ((region :accessor)
   (start :accessor :type (integer 0 *))
   (end :accessor :type (integer 0 *))
   (mapped-start :accessor :type (unsigned-byte 16) :initform 0)
   (mapped-end :accessor :type (unsigned-byte 16))
   (writep :accessor :accessor mapping-write-p)))

(defvar *mapping* nil)

(defun mapped-bank (address &optional writep)
  (dolist (mapped *mapping*)
    (when (and (<= (memory-mapping-start mapped)
                   address
                   (memory-mapping-end mapped))

               (or (not writep)
                   (mapping-write-p mapped)))
      (return-from mapped-bank mapped))))

(defgeneric memory-byte (region address)
  (:method ((region memory-bank) address)
    (aref (memory-bank-image region)
          (+ address
             (- (memory-mapping-start region))
             (memory-mapping-mapped-start region)))))

(defmethod memory-byte ((region io-ports) address)
  (declare (ignore address))
  (cons 0 #xff))

(defgeneric (setf memory-byte) (new-value region address)
  (:method (new-value (region ram-bank) address)
    (setf (aref (memory-bank-image region)
                (+ address
                   (- (memory-mapping-start region))
                   (memory-mapping-mapped-start region))) new-value))
  (:method (new-value (region rom-bank) address)
    nil))

(defun cl-6502::get-byte (address)
  (the (unsigned-byte 8)
       (memory-byte (mapped-bank address) address)))

(defun (setf cl-6502::get-byte) (new-val address)
  (setf (memory-byte (mapped-bank address :write) address) new-val))

(defun cl-6502::get-range (start &optional end)
  (coerce
   (loop for address from start to end collect (cl-6502::get-byte address))
   'vector))

(defun (setf cl-6502::get-range) (bytevector start)
  (dotimes (i (length bytevector))
    (setf (cl-6502::get-byte (+ i start)) (aref bytevector i))))

(defgeneric build-image (machine-type rom-image)
  (:method (machine rom)
    (declare (ignore rom))
    (error "No build-image function for machine-type, so I can't optimize the binary.")))

(defun make-uninitialized-ram (bank-size &optional (start-address 0))
  (check-type bank-size (integer 1 #x10000))
  (check-type start-address (unsigned-byte 16))
  (make-instance 'memory-mapping
                 :writep t
                 :mapped-start start-address
                 :mapped-end (1- (+ start-address bank-size))
                 :region (make-instance
                          'ram-bank
                          :image (make-array bank-size
                                             :element-type '(unsigned-byte 8)
                                             :initial-contents (maptimes (_ bank-size)
                                                                 (declare (ignore _))
                                                                 (random #x100))))))
(defun make-riot-ram ()
  (make-uninitialized-ram #x80 #x80))

(defun make-unemulated-io (start-address length)
  (check-type start-address (unsigned-byte 16))
  (check-type length (unsigned-byte 16))
  (make-instance 'memory-mapping
                 :writep t
                 :mapped-start start-address
                 :mapped-end (1- (+ start-address length))
                 :region (make-instance 'io-ports)))

(defun make-tia-io ()
  (make-unemulated-io 0 #x80))

(defun make-riot-io ()
  (make-unemulated-io #x200 #x100))

(defmethod build-image ((machine-type (eql 2600)) rom)
  (list (make-riot-ram)
        (make-tia-io)
        (make-riot-io)
        (ecase (round (log (length rom) 2))
          (15 (make-instance 'f4-controls :rom rom))
          (19 (make-instance 'f9-controls :rom rom)))))

(defmethod build-image ((machine-type (eql 64)) rom)
  (list (make-instance 'r6510)
        (make-uninitialized-ram #x10000)))

(defun optimize-6502 (binary &optional *machine*)
  (let* ((rom-image (read-file-into-byte-vector binary))
         (*mapping* (build-image *machine* rom-image))
         (cl-6502:*cpu* (make-instance 'cl-6502:cpu)))
    (cl-6502:reset cl-6502:*cpu*)))

(defun assemble (source-file)
  (cl-6502:asm (read-file-into-string source-file)))


