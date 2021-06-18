;;;  -*- lisp -*-

;; This program  is a  script that  runs through SBCL.  You may  need to
;; first install SBCL with your OS's package tools; one of the following
;; may work:

;;;     pkcon install sbcl
;;;     sudo dnf install sbcl
;;;     sudo apt-get install sbcl
;;;     sudo yum install sbcl

(defpackage prepare-system-for-skyline-tool
  (:use :cl))
(in-package :prepare-system-for-skyline-tool)

(require 'sb-posix)

(defparameter *install-os-libs* (not (plusp (length (sb-posix:getenv "SKIP_DNF")))))

(defvar *quicklisp-pgp-signature*
  "4a7a5c2aebe0716417047854267397e24a44d0cce096127411e9ce9ccfeb2c17"
  "This signature, found at https://www.quicklisp.org/beta/, can be used
  to   verify  the   installation  script   when  GnuPG   is  installed.
  Note  that (7/2016)  the  TLS certificate  for  QuickLisp.org has  thi
  following SHA-256 fingerprint (valid through 4/2017):

61:3F:E4:CB:2F:E1:77:74:55:01:27:0D:17:CC:B2:DA:
90:36:1E:C1:BB:83:79:10:70:8D:1A:F2:43:46:E8:D7") ; WARNING: This is NOT being done right now.

(defun run (command &rest args)
  (ignore-errors 
    (zerop (sb-ext:process-status (sb-ext:run-program command args
                                                      :output *standard-output*
                                                      :error *error-output*
                                                      :wait t)))))

(defun install-os-package (package-name &key libp develp)
  (return-from install-os-package nil)
  (destructuring-bind ((installer &rest args) nomenclature successes)
      (cond
        ((probe-file "/usr/bin/pkcon") '(("/usr/bin/pkcon" "install") :either (0 7)))
        ((probe-file "/usr/bin/dnf") '(("/usr/bin/dnf" "install") :rpm (0)))
        ((probe-file "/usr/bin/yum") '(("/usr/bin/yum" "install") :rpm (0)))
        ((probe-file "/usr/bin/apt-get") '(("/usr/bin/apt-get" "install") :deb (0)))
        (t (error "Sorry, I don't recognize any package manager tool on this host.

\(Looked for pkcon, dnf, yum, apt-get)

To  skip  this  step,  you  can instead  set  the  environment  variable
SKIP_DNF=t and you'll need to hunt  down any “C” library dependencies on
your own.

")))
    (format t "~&Attempting to install OS package “~a”~@[ (as a library)~]~@[ (as a “devel” package)~] …"
            package-name libp develp)
    (let ((effective-names (list package-name)))
      (when (and develp (member nomenclature '(:rpm :either)))
        (push (concatenate 'string package-name "devel") effective-names))
      (when (and develp (member nomenclature '(:deb :either)))
        (push (concatenate 'string package-name "dev") effective-names))
      (when libp
        (push (concatenate 'string "lib" package-name) effective-names))
      (when (> (length effective-names) 1)
        (format t "(possible aliases:  ~{~a~^, ~})… " effective-names))
      (if (and (member nomenclature '(:rpm :either))
               (some (lambda (name) (run "rpm" "-q" name)) effective-names))
          (format t "Found already installed. Victory.")
          (format t "Installation ~:[has failed; I cannot help you further.
 ⁂ You'll need to fix this yourself.~%~
~;successful.~]"
                  (block try-install
                    (dolist (name effective-names)
                      (when (or (run installer args name)
                                (run "sudo" installer args name))
                        (return-from try-install t)))))))))

(defun desperately-install-quicklisp ()
  (when (or (find-package :%quicklisp)
            (and (probe-file "~/quicklisp/setup.lisp")
                 (load "~/quicklisp/setup.lisp")))
    (return-from desperately-install-quicklisp t))
  (let ((buffer (or (when (probe-file "/usr/bin/curl")
                      (format t "~&Downloading using curl…")
                      (run "/usr/bin/curl" '"https://beta.quicklisp.org/quicklisp.lisp")) 
                    (when (probe-file "/usr/bin/wget") 
                      (format t "~&Downloading using wget…")
                      (run "wget" "-O" "-" "https://beta.quicklisp.org/quicklisp.lisp"))
                    (when (probe-file "/usr/bin/lynx") 
                      (format t "~&Downloading using Lynx…")
                      (run "lynx" "-source" "https://beta.quicklisp.org/quicklisp.lisp"))
                    (progn
                      (format t "~&Installing curl to bootstrap Quicklisp…")
                      (install-os-package "curl")
                      (format t "~&Downloading using curl…")
                      (run "/usr/bin/curl" "https://beta.quicklisp.org/quicklisp.lisp"))))
        (eof (gensym "EOF")))
    (unless (plusp (length buffer))
      (error "Downloading Quicklisp bootstrap program seems to have failed.

Run https://beta.quicklisp.org/quicklisp.lisp yourself (on SBCL).

"))
    (block reading
      (loop
         (multiple-value-bind (form next-form) (read-from-string buffer nil eof)
           (if (eql form eof)
               (return-from reading t)
               (eval form))
           (setf buffer (subseq buffer next-form)))))))

(format t "

Prepare-System

This script will  try to make sure  your machine is set  up for building
with the Skyline  tools. This may include installing  local software, so
you may need to have local administrative privileges.

\(This program is invoked by Make if you do not have a bin/buildapp
 program present. If you wish to use an already-installed BuildApp
 executable, link it there.)

I will now:
 
~@[ • Ensure that libraries needed to compile “C” programs are present
    — (to skip this step, run with SKIP_DNF=t in your environment)
 
~] • Ensure that Quicklisp is ready and working
 
 • Perform the first compilation of the Lisp development tools

 • Compile the BuildApp  program, which will be used by  Make to compile
   Skyline-Tool whenever it is changed.



"
        *install-os-libs*)

#-linux (format t "

You don't seem to  be on a Linux system; this makes  it very likely that
the prerequisites needed  for Skyline's toolchain may  not be available,
and this script won't be able to help.

The  easiest solution  is  to  install a  virtual  machine like  VMWare,
VirtualBox,  or similar  and install  to it  a free  copy of  the latest
Workstation edition of Fedora  from http://fedoraproject.org/, then work
from  within there.  That's out  of the  scope of  this script,  though,
for now.")

(format t "

Checking for Quicklisp first…")

(desperately-install-quicklisp)

(when *install-os-libs*
  (format t "~&Checking for various prerequisite packages…")

  (loop for (package &optional libp develp) in
       '(("libpng" t t) ("zlib" t t)
         ("SDL2" t t) ("w3m") ("curl")
         ("glibc" t t) ("gcc") ("gcc-c++")
         ("bzip2" t t) ("expat" t t) ("fontconfig" t t)
         ("freetype" t t) ("glib2" t t) ("ffi" t t)
         ("libgcc" t t) ("ICE" t t) ("SM" t t)
         ("libstdc++" t t) ("libuuid" t t) ("libX11" t t)
         ("qt" t t) ("gimp") ("nautilus")
         ("perl") ("sed") ("coreutils")
         ("binutils") ("cyrus-sasl-lib" t t)
         ("keyutils-libs" t t) ("krb5-libs" t t) ("libcom_err" t t)
         ("libcurl" t t) ("libidn" t t) ("libnghttp2" t t)
         ("libssh2" t t) ("libzip" t t) ("nss-util")
         ("openssl-libs" t t) ("pcre" t t) ("SDL" t t)
         ("openldap" t t) ("make")
         ("texinfo-tex"))
     do (install-os-package package :libp libp :develp develp)))

(format t "~&Precompiling fastloads of Lisp libraries…")

(load (merge-pathnames (make-pathname :name "setup" :type "lisp"
                                      :directory '(:relative))
                       *load-truename*))
(format t "~& … and some optional debugging libs …")
(ignore-errors
  (map nil (intern "QUICKLOAD" (find-package :quicklisp))
       '(:prepl ;:clim-clx :mcclim :clouseau :climacs 
         :quicklisp-slime-helper :prepl)))

(format t "~& Compiling Buildapp…")

(funcall (intern "QUICKLOAD" (find-package :quicklisp)) :buildapp)
(funcall (intern "BUILD-BUILDAPP" (find-package :buildapp)) "bin/buildapp")


