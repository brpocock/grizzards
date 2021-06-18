(in-package :skyline-tool)



;; entry point from shell

(defvar *invocation*
  (list :--help 'about-skyline-tool
        :-h 'about-skyline-tool
        :help 'about-skyline-tool
        :build-banking 'build-banking
        :burn-rom 'click.adventuring.skyline.eprom::burn-rom
        :compile-index 'compile-index
        :compile-art 'compile-art
        :compile-font 'compile-font-command
        :compile-map 'compile-map
        :compile-code 'compile-skylisp
        :collect-strings 'collect-strings
        :compile-music 'compile-music
        :collect-assets 'collect-assets
        :compile-critters 'compile-critters))

(defun debug-myself-in-emacs ()
  (let ((swank (find-package :swank)))
    (funcall (intern "SETUP-SERVER" swank) 0
             (lambda (port)
               (uiop:run-program (list "/usr/bin/emacsclient" "-e"
                                       (format nil "(progn
   \(load (expand-file-name \"~~/quicklisp/slime-helper.el\"))~
   \(eval-after-load \"slime\" (quote (slime-connect \"::1\" ~d))))" port))))
             (intern "*COMMUNICATION-STYLE*" swank)
             (intern "*DONT-CLOSE*" swank) nil)))

#+mcclim
(defun edit-myself-in-climacs (file)
  (climacs:edit-file file
                     :process-name "Editing Skyline-Tool"))

(defun start-prepl ()
  (about-skyline-tool)
  (format t "~5% Skyline-Tool internal REPL starting…
To invoke command-line entry points, use (c VERB PARAMS)")
  (let ((*package* (find-package :skyline-tool)))
    (prepl:repl)))

#+mcclim
(defun start-listener ()
  (clim-listener:run-listener :new-process t
                              :process-name "Skyline Tool"
                              :package :Skyline-Tool))

(defun x11-p ()
  (when-let (display (sb-posix:getenv "DISPLAY"))
    (find #\: display)))

(defun prompt (query)
  (format *query-io* "~&~a" query)
  (force-output *query-io*)
  (string-trim #(#\Space #\Page #\Return #\Linefeed #\Tab)
               (read-line *query-io*))
  (terpri *query-io*)
  (finish-output *query-io*))

(defun prompt-function (prompt)
  (lambda ()
    (if #+mcclim (x11-p) #-mcclim nil
        #+mcclim
        (clim-simple-interactor:run-in-simple-interactor
         (lambda () (prompt prompt)))
        #-mcclim nil
        (prompt prompt))))

(defun dialog (title message &rest args)
  (if #+mcclim (x11-p) #-mcclim nil
      #+mcclim (clim-simple-interactor:run-in-simple-interactor
                (lambda ()
                  (apply #'format *query-io* message args)
                  (clim:with-text-size (*query-io* :small)
                    (format *query-io* "~2%~20t(Press Return)"))
                  (force-output *query-io*)
                  (read-char))
                :process-name title)
      #-mcclim nil
      (progn
        (format t "~&~% ★ ~a ★~%" title)
        (apply #'format t message args)
        (fresh-line)
        (force-output))))

(defmacro with-happy-restarts (&body body)
  `(tagbody do-over
      (let ((*debugger-hook* (if #+mcclim (x11-p) #-mcclim nil
                                 #+mcclim #'clim-debugger:debugger
                                 #-mcclim nil
                                 *debugger-hook*)))
        (restart-case
            (unwind-protect
                 (progn ,@body)
              (force-output *trace-output*)) 
          (do-over ()
            :report "Try again, from the top"
            (go do-over))
          (abort ()
            :report "Cancel this command")
          (change-directory (new-directory)
            :report (lambda (s) (format s "Change the working directory from ~a"
                                        *default-pathname-defaults*))
            :interactive-function (prompt-function "Change to directory?")
            (setf *default-pathname-defaults* new-directory)
            (sb-posix:chdir new-directory))
          (invoke-make (target)
            :report "Ask GNU Make to generate a file"
            :interactive-function (prompt-function "What file should be regenerated?")
            (uiop:run-program (list "make" "-r" target)))
          (gimp (file)
            :report "Edit a file in Gimp"
            :interactive-function (prompt-function "Edit which file in Gimp?")
            (uiop:run-program (list "gimp" file)))          
          (tiled (file)
            :report "Edit a file in Tiled"
            :interactive-function (prompt-function "Edit which file in Tiled?")
            (uiop:run-program (list "tiled" file)))
          #+mcclim (start-repl ()
                     :report "Open a read-eval-print-loop listener"
                     (if (x11-p)
                         (clim-listener:run-listener :process-name "Skyline Tool REPL"
                                                     :package :skyline-tool)
                         (start-prepl))
                     (go do-over))
          #-mcclim (start-repl ()
                     :report "Open a read-eval-print-loop listener"
                     (start-prepl)
                     (go do-over))
          (debug-in-emacs ()
            :report "Debug this in a running GNU Emacs"
            (debug-myself-in-emacs)
            (go do-over))
          #+mcclim (edit-in-climacs (file)
                     :report "Edit in Climacs"
                     :interactive-function (prompt-function "Edit which file in Climacs?")
                     (edit-myself-in-climacs file)
                     (format t "Climacs now open … ~
recompile when you've corrected the error. (C-c C-k) and restart.")
                     (go do-over))
          (recompile-skyline-tool ()
            :report "Recompile system Skyline-Tool (and retry)"
            (format t "
I will  reload the ASDF  System Skyline-Tool  and integrate it  into the
running   image.  This   will   NOT  affect   the  application   program
file  (bin/skyline-tool),  though;  in   order  to  make  these  changes
effective for next time, you should run Make (which will run Buildapp).
")
            (compile-file (make-pathname
                           :directory '(:relative "src" "tool" "skyline-tool")
                           :name "setup" :type "lisp")
                          :print nil)
            (load (make-pathname
                   :directory '(:relative "src" "tool" "skyline-tool") 
                   :name "setup" :type "fasl"))
            (go do-over))
          (quit-completely ()
            :report "Quit completely from Skyline-Tool"
            (bye))))))

(defun about-skyline-tool (&rest commands)
  "Display help and version information.

Supply a list of verb(s) to see detailed documentation"
  (format *trace-output* "~&

 Skyline-Tool
 ————————————

Copyright © 2014-2017
 Bruce-Robert Pocock (brpocock@star-hope.org)
 Most Rights Reserved.  See COPYING for details.

Compiler: ~a,~%	version ~a
System software: ~a,~%	version ~a
Machine: ~a, type: ~a,~%	version ~a
~@[Site: ~a~]~@[~%	(~a)~]

Usage: the first  parameter must be a verb;  following parameters depend
on the verb being invoked. You almost certainly want to just look at the
Makefile for an example, but you can try “help” + command-name for the
documentation also.

"
          (lisp-implementation-type) (lisp-implementation-version)
          (software-type) (software-version)
          (machine-instance) (machine-type) (machine-version)
          (short-site-name) (long-site-name))
  (if commands
      (dolist (command commands)
        (if-let (fun (getf *invocation* (make-keyword (string-upcase command))))
          (format *trace-output* "~2% • ~(~a~)~2%~a"
                  command (or (documentation fun 'function)
                              "(no documentation yet)"))
          (format *trace-output* "~% • ~a: unknown ☹" command)))
      (dolist (verb (sort (remove-if-not #'keywordp *invocation*)
                          #'string-lessp))
        (format *trace-output* "~% • ~(~a~): ~a"
                verb (or (first-line (documentation (getf *invocation* verb)
                                                    'function))
                         "(no documentation yet)")))))

(defun bye ()
  (format t "~&~|~%Good-bye.~2%")
  (sb-ext:exit :timeout 10))

(defun command (argv)
  (format *trace-output* "~&Skyline tool invoked: (Skyline-Tool:Command '~s)" 
          argv)
  (let ((sb-impl::*default-external-format* :utf-8))
    (with-happy-restarts
        (unless (< 1 (length argv))
          (start-prepl))
      (destructuring-bind (self verb &rest invocation) argv
        (if-let (fun (getf *invocation* (make-keyword (string-upcase verb))))
          (flet ((runner ()
                   (apply fun (remove-if (curry #'string= self)
                                         invocation))
                   (fresh-line)))
            (if #+mcclim (x11-p) #-mcclim nil
                #+mcclim
                (clim-simple-interactor:run-in-simple-interactor
                 #'runner
                 :process-name
                 (format nil "Skyline-Tool: running ~:(~a~)~{ ~a~}"
                         (substitute #\Space #\- verb)
                         invocation)) 
                #-mcclim nil
                (funcall #'runner)))
          (error "Command not recognized: “~a” (try “help”)" verb))
        (fresh-line)))))

(defun c (&rest args)
  (funcall #'command (cons "c" args)))

#+mcclim (assert (fboundp 'clim-debugger:debugger))
