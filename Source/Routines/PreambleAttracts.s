;;; Grizzards Source/Routines/PreambleAttracts.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Preamble: .block
          
          .if PUBLISHER

PublisherPresentsMode:
          .SetUpFortyEight AtariAgeLogo
          .ldacolu COLGRAY, $f
          sta COLUBK
          ldy # AtariAgeLogo.Height
          .if SECAM == TV
            lda #COLBLUE
          .else
            .ldacolu COLTURQUOISE, $8
          .fi

          .else

BRPPreambleMode:
          .SetUpFortyEight BRPCredit
          ldy # BRPCredit.Height
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
