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

          ldx #KernelLines - 185
FillScreen:
          stx WSYNC
          dex
          bne FillScreen

          rts

          .bend

BitMask:
          .byte $01, $02, $04, $08, $10, $20, $40, $80
