;;; Grizzards Source/Common/Overscan.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Overscan: .block
          .TimeLines OverscanLines

          ldy # 0
          sty ENAM0
          sty ENAM1
          sty GRP0
          sty GRP1
          sty ENABL
          sty PF0
          sty PF1
          sty PF2
          sty COLUPF
          sty COLUBK

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
