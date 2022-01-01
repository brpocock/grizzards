;;; Grizzards Source/Routines/WaitScreenBottom.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

WaitScreenBottomSub:
          .WaitForTimer
          .if TV != NTSC
          .SkipLines 11
          .fi
          jmp Overscan          ; tail call
