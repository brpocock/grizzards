;;; Grizzards Source/Routines/PreambleAttracts.s
;;; Copyright © 2021 Bruce-Robert Pocock

Preamble: .block
          
          .if PUBLISHER

PublisherPresentsMode:
          .SetUpFortyEight PublisherCredit
          .ldacolu COLGRAY, $f
          sta COLUBK
          ldy # PublisherCredit.Height
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
            .SetUpFortyEight PublisherName
            ldy #PublisherName.Height
            sty LineCounter
            jsr ShowPicture
          .fi

          jmp Attract.DoneKernel

          .bend
