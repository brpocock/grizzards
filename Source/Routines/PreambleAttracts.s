;;; Grizzards Source/Routines/PreambleAttracts.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Preamble: .block
          
          .if PUBLISHER

PublisherPresentsMode:
          .SetUpFortyEight AtariAgeLogo
          .ldacolu COLGRAY, $f
          sta COLUBK
          ldy # AtariAgeLogo.Height
          .ldacolu COLTURQUOISE, $8

          .else

BRPPreambleMode:
          .SetUpFortyEight BRPCredit
          ldy # BRPCredit.Height
          .ldacolu COLINDIGO, $8

          .fi

          sta COLUP0
          sta COLUP1

          sta WSYNC

          lda AlarmCountdown
          bne StillPresenting

          lda # 60
          sta AlarmCountdown
          lda #ModeAttractTitle
          sta GameMode
          
StillPresenting:
SingleGraphicAttract:

          .SkipLines 71

          sty LineCounter
          jsr ShowPicture

          .if PUBLISHER
            .SetUpFortyEight AtariAgeText
            ldy #AtariAgeText.Height
          sty LineCounter
          sty WSYNC
            jsr ShowPicture
          .fi

          jmp Attract.DoneKernel

          .bend
