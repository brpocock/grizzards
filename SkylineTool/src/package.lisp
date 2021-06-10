(cl:defpackage :skyline-tool
  (:use :cl :alexandria :split-sequence :parse-number :bordeaux-threads)
  (:import-from :uiop
                uiop:run-program
                uiop:split-string)
  (:export #:compile-index
           #:collect-assets
           #:compile-art
           #:compile-critters
           #:compile-map
           #:compile-sound
           #:compile-music
           #:command 
           #:build-banking
           #:c
           #:bye))

(in-package :skyline-tool)

(defvar *machine* :unknown)
(defvar *region* :ntsc)


