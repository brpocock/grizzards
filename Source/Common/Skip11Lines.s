;;; Grizzards Source/Common/Skip11Lines.s
;;; Copyright © 2021 Bruce-Robert Pocock

;;; Saves a few bytes of ROM in PAL/SECAM .WaitScreenBottom macroexpansion.
;;; Not needed for NTSC's shorter screen height.

;;; Don't  use the  .SkipLines macro  here, as  it is  “smart” and  will
;;; expand to a call to this subroutine automatically.
          .if TV != NTSC
Skip11Lines:
          ldx # 11
-
          stx WSYNC
          dex
          bne -
          rts
          .fi
