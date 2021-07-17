;;; Grizzards Source/Routines/MapBottomService.s
;;; Copyright © 2021 Bruce-Robert Pocock
BottomOfScreenService: .block
          lda #0
          sta COLUBK
          sta PF0
          sta PF1
          sta PF2
          sta GRP0
          sta GRP1
          sta ENABL
          sta WSYNC

          .if TV == NTSC
          .SkipLInes KernelLines - 184
          .else
          .SkipLines KernelLines - 219
          .fi

          rts

          .bend
