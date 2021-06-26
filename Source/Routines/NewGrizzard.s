;;; Grizzards Source/Routines/NewGrizzard.s
;;; Copyright © 2021 Bruce-Robert Pocock

NewGrizzard:        .block
          ;; Call with new Grizzard ID in .A

          pha                   ; save for later also

          ldy #ServicePeekGrizzard
          ldx #SaveKeyBank
          jsr FarCall

          bcs CatchEm
          ;; If so, nothing doing, return
          pla                   ; discard stashed ID

          rts

CatchEm:  
          ;; New Grizzard found, save current Grizzard …
          ldy #ServiceSaveGrizzard
          ldx #SaveKeyBank
          jsr FarCall
          
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
          sta GrizzardAcuity
          iny
          lda GrizzardStartingStats, y
          sta MovesKnown

          ;; Now, save this guy for good measure
          ldy #ServiceSaveGrizzard
          ldx #SaveKeyBank
          jmp FarCall

          .bend
