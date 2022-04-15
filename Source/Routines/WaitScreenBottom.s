;;; Grizzards Source/Routines/WaitScreenBottom.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

WaitScreenBottomSub:          .block
          .WaitForTimer
          .if TV != NTSC
            .SkipLines 11
          .fi
          ;; fall through to Overscan
          .if Overscan < EndBank
            jmp Overscan
          .fi

          .bend

;;; Audited 2022-02-16 BRPocock
