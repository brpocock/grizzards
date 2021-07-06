VBlank: .block
          lda # ( 76 * VBlankLines ) / 64 - 1
          sta TIM64T
          sta WSYNC

FillVBlank:
          lda TIMINT
          bpl FillVBlank

          stx WSYNC
          ldx # 0
          stx VBLANK
          rts
          .bend
