;;; Grizzards Source/Routines/PreambleAttracts.s
;;; Copyright © 2021 Bruce-Robert Pocock

          .if PUBLISHER
PublisherPresentsMode:
          .SetUpFortyEight PublisherCredit
          lda #CTRLPFREF
          sta CTRLPF
          .ldacolu COLGRAY, $f
          sta COLUPF
          lda #$c0
          sta PF2
          ldy # PublisherCredit.Height
          .ldacolu COLBLUE, $f
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

          ldx # 70
SkipAboveGraphic:
          stx WSYNC
          dex
          bne SkipAboveGraphic

          sty LineCounter
          jsr ShowPicture

          ldx # KernelLines - 95
SkipBelowGraphic:
          stx WSYNC
          dex
          bne SkipBelowGraphic

          jmp DoneAttractKernel
