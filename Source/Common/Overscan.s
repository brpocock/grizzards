;;; Grizzards Source/Common/Overscan.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Overscan: .block
          .if NTSC == TV
            .TimeLines OverscanLines
          .else
            .TimeLines OverscanLines + 10
          .fi
Short:
          ldy # 0
          stx WSYNC
          sty COLUPF
          sty COLUBK
          sty GRP0
          sty GRP1
          sty ENAM0
          sty ENAM1
          sty ENABL
          sty PF0
          sty PF1
          sty PF2

          ldx #SFXBank
          jsr FarCall

          .if DEMO
            .if BANK == 4
              jsr DoMusic
            .fi
          .else
            .switch BANK
            .case 3, 4, 5
              jsr DoMusic
            .endswitch
          .fi

          .WaitForTimer

          stx WSYNC
          rts
          .bend
