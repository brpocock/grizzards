(in-package :skyline-tool)

(defun write-texi-headers ()
  (format t "
\input texinfo   @c -*-texinfo-*-
@c %**start of header
@documentencoding UTF-8
@documentlanguage en_US
@dircategory Games
@setfilename skyline-assembly-docs.info
@settitle Skyline Assembly-Language Documentation
@c %**end of header
@copying
For the Atari Video Computer System CX-2600.

Copyright @copyright{} 2007,2017,2020 Bruce-Robert Pocock

The document was typeset with
@uref{http://www.texinfo.org/, GNU Texinfo}.

@heading Acknowledgements

``Andrew Christian'' and the distinctive Andrew Christian ``Swiss flag''
logo are trademarks of Andrew Christian, Inc, used with permission.

``Atari'' is a registered trademark of Atari Inc or its successors.

``SEGA,''  ``SEGA   Master  System,''   ``SEGA  Genesis,''   and  ``SEGA
MegaDrive'' are trademarks of SEGA in the US and overseas.

This game  program is not  authorized, licensed, or certified  by Atari,
SEGA, or any other agency or publisher.


@end copying

@documentdescription
A handbook  for the  Skyline game  for the  Atari Video  Computer System
CX-2600 (``Atari 2600'') and compatible systems.
@end documentdescription

@titlepage
@title Skyline Game Program Instructions
@subtitle For the Atari Video Computer System CX-2600
@author Bruce-Robert Pocock <brpocock@@Star-Hope.org>
@center{@image{missing-screenshot,3in}}
@page
@vskip 0pt plus 1filll
@insertcopying
@end titlepage


@c Output the table of the contents at the beginning.
@contents

@ifnottex
@node Top, Parental Advisory, (dir), (dir)
@top Skyline Game Program Instructions

@insertcopying
@end ifnottex

@c Generate the nodes for this menu with `C-c C-u C-m'.
@menu
* Parental Advisory::
* Introduction::
* Setting Up::
* Controls::
* Pausing/Saving::
* Trouble in River City::
@end menu


"))

(defun find-all-sources (type)
  (loop with directories = (copy-list '(:relative "src" "core")
                                      '(:relative "src" "include")
                                      '(:relative "src" "2600"))
     for dir = (pop directories)
     for match = (make-pathname :directory dir :name :wild
                                :version :wild :type "s")
     for all-files = (make-pathname :directory dir :name :wild
                                    :version :wild :type nil)
     while dir
     append (directory match)
     do (dolist (subdir? (directory all-files))
          (when (uiop:directory-exists-p subdir?)
            (push subdir? directories)))))

(defun document-assembly (machine)
  (let* ((*files* (find-all-sources "s"))
         (*symbols* (find-all-symbols *files*))
         (*authors* (find-all-authors *files*))
         (temp-name (make-pathname
                     :directory (list :relative "doc" "dev")
                     :name ".#skyline-assembly-docs"
                     :type "texi")))
    (with-output-to-file (*standard-output*
                          temp-name
                          :if-exists :supersede)
      (write-texi-headers)
      (write-texi-introduction)
      (dolist (source *files*)
        (write-assembly-docs source))
      (write-texi-footer))
    ;; remove the ".#" from the temporary file, now that it's complete
    (rename-file temp-name
                 (merge-pathnames
                  temp-name
                  :name "skyline-assembly-docs"))))
