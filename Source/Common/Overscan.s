;;; Grizzards Source/Common/Overscan.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          
Overscan: .block
          .TimeLines OverscanLines

          ldx #SFXBank
          jsr FarCall

          .if DEMO && BANK == 4
          jsr DoMusic
          .fi

          .if !DEMO
          .switch BANK
          .case 3
          jsr DoMusic

          .case 4
          jsr DoMusic

          .case 5
          jsr DoMusic

          .default
          ;; no op

          .endswitch
          .fi

          .WaitForTimer

          stx WSYNC
          rts
          .bend
