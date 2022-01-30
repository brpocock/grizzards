;;; Grizzards Source/Common/StartBank.s
;;; Copyright © 2021-2022, Bruce-Robert Pocock <brpocock@star-hope.org>
;;; Start of each ROM bank

          ;; These can be overridden by the build command-line.
          .weak
          DEMO := false
          PUBLISHER := false
          TV := NTSC
          NOSAVE := false
          ATARIAGESAVE := false
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

