(require 'asdf)
(format t "~&Skyline-Tool: Setup script… ")
(finish-output)
(unless (find-package :quicklisp)
  (format t "~&Loading Quicklisp… ")
  (handler-bind
      ((error (lambda (c)
                (format *error-output*
                        "~2%Error of type ~:(~a~):~%~a

Perhaps Quicklisp  is not installed,  or in installed in  a non-standard
place? Visit https://beta.quicklisp.com/ for installation instructions.~%"
                        (type-of c) c)
                (finish-output))))
    (load (merge-pathnames (make-pathname
                            :directory '(:relative "quicklisp")
                            :name "setup" :type "lisp")
                           (user-homedir-pathname)))))

(defmacro with-casual-handlers (&body body)
  `(handler-bind
       ((serious-condition
         (lambda (c)
           (print c *error-output*)
           (cond ((find-restart 'continue)
                  (princ " … attempting Continue restart … " *error-output*)
                  (finish-output *error-output*)
                  (invoke-restart 'continue))
                 ((find-restart 'accept)
                  (princ " … attempting Accept restart … " *error-output*)
                  (finish-output *error-output*)
                  (invoke-restart 'accept))))))
     ,@body))

(asdf:load-asd (merge-pathnames (make-pathname :name "skyline-tool" 
                                               :type "asd")
                                (or *compile-file-pathname*
                                    *load-pathname*)))

;;(format t "Quickloading Skyline-Tool System … ")
;;(finish-output)
;; (funcall (intern "QUICKLOAD" (find-package :quicklisp)) :cl-plumbing)
;; (funcall (intern "QUICKLOAD" (find-package :quicklisp)) :clim)
;;(load (merge-pathnames (make-pathname :directory (list :relative)
;;				      :name "clim-simple-interactor" :type "lisp")
;;		       (or *compile-file-pathname*
;;			   *load-pathname*)))
;;(funcall (intern "QUICKLOAD" (find-package :quicklisp)) :skyline-tool)
;;(format t "… done with Quickload.~2%")
(finish-output)

