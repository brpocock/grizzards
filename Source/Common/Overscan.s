;;; Grizzards Source/Common/Overscan.s
;;; Copyright © 2021 Bruce-Robert Pocock

Overscan: .block
          lda # ( 76 * OverscanLines ) / 64 - 1
          sta TIM64T

          ldx #SFXBank
          jsr FarCall

          .switch BANK
          .case 3

          jsr DoMusic

          .case 4

          jsr DoMusic

          .default

          ;; no op

          .endswitch
          
FillOverscan:
          lda INTIM
          bpl FillOverscan

          sta WSYNC
          rts
          .bend
