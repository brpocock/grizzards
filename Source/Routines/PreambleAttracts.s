;;; Grizzards Source/Routines/PreambleAttracts.s
;;; Copyright © 2021 Bruce-Robert Pocock

          .if PUBLISHER
PublisherPresentsMode:
          .SetUpFortyEight PublisherCredit
          lda #CTRLPFREF
          sta CTRLPF
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
          jmp SingleGraphicAttract

SingleGraphicAttract:

          ldx # 71
SkipAboveGraphic:
          stx WSYNC
          dex
          bne SkipAboveGraphic

          sty LineCounter
          jsr ShowPicture

          .if PUBLISHER

          .SetUpFortyEight PublisherName
          ldy #PublisherName.Height
          sty LineCounter
          jsr ShowPicture

          ldx # KernelLines - (125 + PublisherName.Height)

          .else

          ldx # KernelLines - 125

          .fi

SkipBelowGraphic:
          stx WSYNC
          dex
          bne SkipBelowGraphic

          jmp DoneAttractKernel
