(in-package :cl-user)
(require 'asdf)
(asdf:defsystem :skyline-tool
  :description "A tool for building tile-based adventure games for 8-bit systems"
  :author "Bruce-Robert Pocock"
  :version "0.8.1"
  :maintainer "Bruce-Robert Pocock"
  :mailto "brpocock+skyline@star-hope.org"
  :licence "MIT" ; if this poses a problem, ask me for a waiver.
  :long-name "The Skyline tools for building ARPG's for Atari 2600 and more"
  
  :depends-on ( ;; broken into lines for easier sorting
               :alexandria
               :bordeaux-threads
               :cl-6502
               :cl-ppcre 
               ;; :clim-listener
               ;; :clim-debugger
               ;; :climacs
               ;; :clouseau
               :cserial-port
               ;; :mcclim
               :midi
               :parse-number
               :png-read
               :prepl
               :quicklisp-slime-helper
               :split-sequence
               :swank
               :trivial-gray-streams
               :xmls
               )

  :encoding :utf-8

  :serial t
  
  :components
  ((:file "gray-streams-pipe")
   ;;(:file "clim-simple-interactor")
   (:module "src"
    :components ((:file "package")
                 (:file "utils")
                 (:file "misc")
                 (:file "assembly")
                 (:file "music")
                 (:file "eprom")
                 (:file "graphics")
                 (:file "maps")
                 (:file "i18n-l10n")
                 (:file "skylisp")
                 (:file "tmx")
                 (:file "interface")))))
