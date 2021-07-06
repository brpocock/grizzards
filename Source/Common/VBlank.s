VBlank: .block
          ldx # ( 76 * VBlankLines ) / 64 - 1
          sta TIM64T

FillVBlank:
          sta WSYNC
          lda TIMINT
          bpl FillVBlank

          ldx # 0
          stx VBLANK
          rts
          .bend
