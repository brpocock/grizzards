;;; Grizzards Source/Routines/CombatOutcomeScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock

CombatOutcomeScreen:          .block

                   lda MoveAnnouncement
          cmp # 4
          bmi SkipHitPoints

          lda MoveHitMiss
          beq DrawHitPoints

          lda # 17              ; 'H'
          sta StringBuffer + 0
          lda # 25              ; 'P'
          sta StringBuffer + 1
          lda # 40              ; blank
          sta StringBuffer + 2
          ldx # 39              ; '-'
          lda MoveHP
          bpl DrawMinusHP

DrawIncreasedHP:
          ldx # 40              ; blank
DrawMinusHP:
          stx StringBuffer + 3

DrawHitPoints:      
          and #$7f
          sta Temp
          ldy #ServiceAppendDecimalAndPrint
          ldx #TextBank
          jsr FarCall
          jmp AfterHitPoints

SkipHitPoints:

          ldx # 35
-
          stx WSYNC
          dex
          bne -

AfterHitPoints:
          lda MoveAnnouncement
          cmp # 5
          bmi SkipStatusFX

SkipStatusFX:

          ldx # 35
-
          stx WSYNC
          dex
          bne -

AfterStatusFX:


          .bend
