;;; -*- asm -*-
;;;
;;; Grizzards
;;;
;;; Copyright © 2021, Bruce-Robert Pocock <brpocock@star-hope.org>
;;;
;;; Most rights reserved. (See COPYING for details.)
;;;

;;; Start of each ROM bank

          .weak
          DEMO := false
          PUBLISHER := false
          STARTER := 0
          TV := NTSC
          .endweak

          .enc "Unicode"
          .cdef $00, $1ffff, 0

	.include "Math.s"
	.include "VCS.s"
	.include "Enums.s"
	.include "ZeroPage.s"
	.include "VCS-Consts.s"
	.include "Macros.s"

	* = $f000
	.offs -$f000

