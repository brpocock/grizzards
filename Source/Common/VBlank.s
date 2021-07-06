;;; Grizzards Source/Common/VBlank.s
;;; Copyright © 2021 Bruce-Robert Pocock

VBlank: .block
          lda # ( 76 * VBlankLines ) / 64 - 1
          sta TIM64T
          sta WSYNC

          .weak
          DoVBlankWork := 0
          .endweak

          .if DoVBlankWork != 0
          jsr DoVBlankWork
          .fi

FillVBlank:
          lda TIMINT
          bpl FillVBlank

          stx WSYNC
          ldx # 0
          stx VBLANK
          rts
          .bend
