;;; Grizzards Source/Routines/PreambleAttracts.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Preamble: .block
          
          .if PUBLISHER

PublisherPresentsMode:
            .SetUpFortyEight AtariAgeLogo
            .ldacolu COLGRAY, 0
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

          inc Rand
          dec Rand + 1

          lda CurrentGrizzard
RandomGrizzard:
          and #$03
          cmp # 3
          bne IsValidGrizzard

          jsr Random
          bne RandomGrizzard

IsValidGrizzard:
          sta CurrentGrizzard

          .mva AlarmCountdown, # 60
          .mva GameMode, #ModeAttractTitle

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

;;; Audited 2022-02-16 BRPocock
