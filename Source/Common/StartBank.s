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
            PORTABLE := false
          .endweak

          .switch TV
	.case NTSC
            TVTypeName = "NTSC"
          .case PAL
            TVTypeName = "PAL"
          .case SECAM
            TVTypeName = "SECAM"
          .endswitch

          .if DEMO
            .if NOSAVE
              ConfigCode = "NoSave"
            .else
              ConfigCode = "Demo"
            .fi
          .else
            .if ATARIAGESAVE
              ConfigCode = "1"
            .else
              ConfigCode = "0"
            .fi
          .fi

          ConfigPartNumber = format ("Griz0.%s.%s", ConfigCode, TVTypeName)

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

;;; Audited 2022-04-18 BRPocock
