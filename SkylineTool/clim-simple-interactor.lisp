(defpackage clim-simple-interactor
  (:use :clim :clim-lisp :clim-extensions)
  (:export #:run-in-simple-interactor))

(in-package :clim-simple-interactor)

(defclass interactor-view (textual-view) ())
(defclass input-view (textual-view) ())

(define-presentation-method present :around
  ((object sequence) (type sequence) stream (view interactor-view)
   &key acceptably for-context-type)
  (present object 'expression :stream stream :view view
           :acceptably acceptably :for-context-type for-context-type))

(defmethod simple-interaction-prompt (pane app)
  (terpri pane)
  (with-text-size (pane :large)
    (princ "⇒" pane))
  (force-output pane))

(define-application-frame simple-interactor (standard-application-frame)
  ((pipe :initarg :pipe :reader frame-pipe)) 
  (:panes (interactor-container
           (make-clim-stream-pane
            :type 'interactor-pane
            :name 'interactor :scroll-bars t
            :default-view (make-instance 'interactor-view)))
          (input-container
           (make-clim-stream-pane
            :type 'interactor-pane
            :name 'input :scroll-bars t
            :default-view (make-instance 'input-view))))
  (:top-level (default-frame-top-level :prompt 'simple-interaction-prompt))
  (:command-table (simple-interactor)) 
  (:layouts (default
	      (vertically ()
                  interactor-container
                  input-container))))

(defmethod frame-standard-output ((frame simple-interactor))
  (get-frame-pane frame 'interactor))

(defmethod frame-error-output ((frame simple-interactor))
  (get-frame-pane frame 'interactor))

(defmethod frame-standard-input ((frame simple-interactor))
  (get-frame-pane frame 'input))

(define-presentation-type empty-input ())

(define-presentation-method present 
    (object (type empty-input) stream view &key &allow-other-keys)
  (with-text-size (stream :small)
    (with-text-style (stream (make-text-style :sans-serif :italic :small))
      (terpri stream)
      (princ "(No reponse …)" stream)
      (force-output stream))))

(defmethod read-frame-command ((frame simple-interactor) 
                               &key (stream *query-io*)) 
  (multiple-value-bind (object type)
      (with-text-style (stream (make-text-style :fix :roman :normal))
        (accept 'form :stream stream :prompt nil 
                :default "" :default-type 'empty-input))
    (cond
      ((presentation-subtypep type 'empty-input)
       ;; Do nothing.
       nil) 
      (t (print object (frame-pipe frame))
         (force-output (frame-pipe frame))))))

(defun run-in-simple-interactor (function &key (width 600)
                                               (height 400)
                                               port
                                               frame-manager
                                               (process-name "Query I/O")
                                               (window-title process-name))
  (let* ((fm (or frame-manager (find-frame-manager :port (or port (find-port)))))
         (pipe (cl-plumbing:make-pipe))
         (frame (make-application-frame 'simple-interactor
                                        :pretty-name window-title
                                        :function function
                                        :frame-manager fm
                                        :pipe pipe 
                                        :width width
                                        :height height))
         (process (clim-sys:make-process (lambda ()
                                           (run-frame-top-level frame)
                                           (disown-frame fm frame))
                                         :name process-name))
         (*query-io* (make-two-way-stream pipe (frame-standard-output frame)))
         (*trace-output* (if (null *trace-output*)
                             nil
                             (frame-standard-output frame)))
         (*standard-input* (frame-standard-input frame))
         (*standard-output* (frame-standard-output frame))
         (*error-output* (frame-error-output frame)))
    (prog1 (funcall function)
      (clim-sys:destroy-process process)
      (destroy-frame frame))))

(defmethod clim:note-frame-disabled ((frame-manager null) frame)
  (format *trace-output* "~&Frame disabled: ~a" frame))
