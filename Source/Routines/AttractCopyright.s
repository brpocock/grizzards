;;; Grizzards Source/Routines/AttractCopyright.s
;;; Copyright © 2021 Bruce-Robert Pocock

CopyrightMode:

          ldx # 29
SkipAboveCopyright:
          stx WSYNC
          dex
          bne SkipAboveCopyright

          .ldacolu COLTURQUOISE | $e
          sta COLUP0
          sta COLUP1

          .LoadString " COPY "
          jsr ShowText
          .LoadString "RIGHT "
          jsr ShowText
          .LoadString " 2021 "
          jsr ShowText
          .LoadString "BRUCE-"
          jsr ShowText
          .LoadString "ROBERT"
          jsr ShowText
          .LoadString "POCOCK"
          jsr ShowText

          ldx # KernelLines - 100 - 22
SkipBelowCopyright:
          stx WSYNC
          dex
          bne SkipBelowCopyright

          lda ClockSeconds
          cmp AlarmSeconds
          bmi StillCopyright

          lda ClockMinutes
          cmp AlarmMinutes
          bmi StillCopyright

          lda # 30
          jsr SetNextAlarm
          lda #ModeAttractTitle
          sta GameMode

StillCopyright:               
          jmp DoneAttractKernel         
