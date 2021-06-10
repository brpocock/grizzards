(in-package :skyline-tool)

(defpackage skylisp
  (:use :common-lisp :alexandria :split-sequence :cl-6502))

(require :cl-6502)

(defgeneric compile-skylisp (source output)
  (:method (source (output string))
    (with-output-to-file (out-file output
                                   :if-exists :supersede)
      (compile-skylisp source out-file)))
  (:method ((source string) (output stream))
    (if (probe-file source)
        (with-input-from-file (in-file source)
          (compile-skylisp in-file output))
        (let ((in (make-string-input-stream source)))
          (compile-skylisp in output))))
  (:method ((source stream) (output stream))
    (let ((eof (gensym "EOF"))
          (*package* (find-package :skylisp)))
      (loop for form = (read source nil eof)
         while (not (eql eof form))
         do (write (compile-skylisp form nil) :stream output))))
  (:method (source (output null))
    (eval source)))
