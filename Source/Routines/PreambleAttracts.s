;;; Grizzards Source/Routines/PreambleAttracts.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Preamble: .block
          
          .if PUBLISHER

PublisherPresentsMode:
          .SetUpFortyEight AtariAgeLogo
          .ldacolu COLGRAY, $f
          sta COLUBK
          .if SECAM == TV
            lda #COLBLUE
          .else
            .ldacolu COLTURQUOISE, $8
          .fi

          .else

BRPPreambleMode:
          .SetUpFortyEight BRPCredit
          .ldacolu COLINDIGO, $8

          .fi

          sta COLUP0
          sta COLUP1

          stx WSYNC

          lda AlarmCountdown
          bne StillPresenting

RandomGrizzard:
          jsr Random
          and #$03
          cmp # 3
          beq RandomGrizzard
          sta CurrentGrizzard

          lda # 60
          sta AlarmCountdown
          lda #ModeAttractTitle
          sta GameMode
          
StillPresenting:
SingleGraphicAttract:

          .SkipLines 71

          jsr ShowPicture

          .if PUBLISHER
            .SetUpFortyEight AtariAgeText
            stx WSYNC
            jsr ShowPicture
          .fi

          jmp Attract.DoneKernel

          .bend
