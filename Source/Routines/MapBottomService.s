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

          .if KernelLines > 209
          ldx #KernelLines - 209 ; PAL/SECAM with score at top
          .else
          ldx #KernelLines - 187 ; NTSC with no score
          .fi
FillScreen:
          stx WSYNC
          dex
          bne FillScreen

          rts

          .bend
