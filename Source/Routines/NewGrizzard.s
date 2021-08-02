;;; Grizzards Source/Routines/NewGrizzard.s
;;; Copyright © 2021 Bruce-Robert Pocock

NewGrizzard:        .block
          ;; Call with new Grizzard in Temp
          lda Temp
          pha

          .FarJSR SaveKeyBank, ServicePeekGrizzard
          ;; carry is set if the Grizzard is found
          bcc CatchEm
          ;; If so, nothing doing, return
          pla                   ; discard stashed ID

          rts

CatchEm:  
          ;; New Grizzard found, save current Grizzard …
          .FarJSR SaveKeyBank, ServiceSaveGrizzard

          ;; … and set up this one with default levels
          pla

          sta CurrentGrizzard

          sta Temp
          asl a
          asl a
          clc
          adc Temp              ; × 5
          tay
          ;; max 150, .y can hold it OK

          lda GrizzardStartingStats, y
          sta MaxHP
          sta CurrentHP
          iny
          lda GrizzardStartingStats, y
          sta GrizzardAttack
          iny
          lda GrizzardStartingStats, y
          sta GrizzardDefense
          iny
          lda GrizzardStartingStats, y
          sta GrizzardDefense + 1
          iny
          lda GrizzardStartingStats, y
          sta MovesKnown

          ;; Now, save this guy for good measure
          .FarJMP SaveKeyBank, ServiceSaveGrizzard ; tail call

          .bend
