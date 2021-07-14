;;; Grizzards Source/Routines/AttractStory.s
;;; Copyright © 2021 Bruce-Robert Pocock

AttractStory:       .block

Loop:
          jsr VSync
          jsr VBlank

          .ldacolu COLBLUE, $8
          sta COLUBK

          .ldacolu COLBROWN, 0
          sta COLUP0
          sta COLUP1

          .LoadString "STORY "
          .FarJSR TextBank, ServiceDecodeAndShowText

          .LoadString "-TODO-"
          .FarJSR TextBank, ServiceDecodeAndShowText

          .LoadString "COMING"
          .FarJSR TextBank, ServiceDecodeAndShowText

          .LoadString "AUGUST"
          .FarJSR TextBank, ServiceDecodeAndShowText

          ldx # KernelLines - 84
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
          lda #ModeAttractTitle
          sta GameMode
          rts

StillStory:
          jsr Overscan
          jmp Loop

          ;; TODO flesh out this mode

          .fill $200, $ea
          
          .bend
