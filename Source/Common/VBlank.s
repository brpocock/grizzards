;;; Grizzards Source/Common/VBlank.s
;;; Copyright © 2021 Bruce-Robert Pocock

          .weak
          DoVBlankWork = 0
          .endweak

VBlank: .block
          lda # ( 76 * VBlankLines ) / 64 - 1
          sta TIM64T
          sta WSYNC

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
