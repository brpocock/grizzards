;;; Grizzards Source/Common/Skip11Lines.s
;;; Copyright © 2021 Bruce-Robert Pocock

;;; Saves a few bytes of ROM in PAL/SECAM .WaitScreenBottom macroexpansion.
;;; Not needed for NTSC's shorter screen height.
          .if TV != NTSC
Skip11Lines:
          .SkipLines 11
          rts
          .fi
