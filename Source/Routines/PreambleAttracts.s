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
          .ldacolu COLINDIGO, $f

          .fi

          sta COLUP0
          sta COLUP1

          sta WSYNC

          lda ClockSeconds
          cmp AlarmSeconds
          bmi StillPresenting

          lda ClockMinutes
          cmp AlarmMinutes
          bmi StillPresenting

          lda # 30
          jsr SetNextAlarm
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

          .SkipLines KernelLines - (127 + PublisherName.Height)

          .else

          .SkipLines KernelLines - 127

          .fi

          jmp Attract.DoneAttractKernel

          .bend
