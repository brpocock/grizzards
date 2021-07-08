;;; Grizzards Source/Routines/AttractStory.s
;;; Copyright © 2021 Bruce-Robert Pocock

AttractStory:       .block

          .ldacolu COLBLUE, $8
          sta COLUBK
          ldx # KernelLines - 10
-
          stx WSYNC
          dex
          bne -

          .ldacolu COLGRAY, 0
          sta COLUBK
          
          lda SWCHB

          lda ClockSeconds
          cmp AlarmSeconds
          bmi StillStory

          lda ClockMinutes
          cmp AlarmMinutes
          bmi StillStory

          lda # 30
          jsr SetNextAlarm
          lda #ModeAttract
          sta GameMode

StillStory:
          jmp DoneAttractKernel

          .bend
