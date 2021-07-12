;;; Grizzards Source/Routines/CombatOutcomeScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock

CombatOutcomeScreen:          .block

Loop:
          jsr VSync
          jsr VBlank

          .ldacolu COLBLUE, 0
          sta COLUBK
          .ldacolu COLGRAY, $f
          sta COLUP0
          sta COLUP1

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
          sta StringBuffer + 3

          lda MoveHP
          bmi DrawHitPoints

          ldx # 39              ; '-'
          stx StringBuffer + 3
          and #$7f
          sta Temp

DrawHitPoints:
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

DrawStatusFX:
          
SkipStatusFX:

          ldx # 35
-
          stx WSYNC
          dex
          bne -

AfterStatusFX:

          ldx # KernelLines - 62
FillScreen:
          stx WSYNC
          dex
          bne FillScreen

          lda ClockSeconds
          cmp AlarmSeconds
          bne AlarmDone

          lda ClockMinutes
          cmp AlarmMinutes
          bne AlarmDone
          inc MoveAnnouncement
          lda #2
          jsr SetNextAlarm

          lda MoveAnnouncement
          cmp # 6
          beq CombatOutcomeDone
AlarmDone:

          jsr Overscan
          jmp Loop

CombatOutcomeDone:
          lda WhoseTurn
          bne CheckForLoss

CheckForWin:
          ldx #6
-
          lda MonsterHP - 1, x
          bne NextTurn
          dex
          bne -

WonBattle:
          lda CurrentCombatEncounter
          ror a
          ror a
          ror a
          and #$07
          tay
          ldx CurrentCombatEncounter
          lda BitMask, x
          ora ProvinceFlags, y
          sta ProvinceFlags, y


          
          lda #ModeMap
          sta GameMode
          jmp GoMap

CheckForLoss:
          lda CurrentHP
          bne NextTurn

          ldy #ServiceDeath
          ldx #MapServicesBank
          jsr FarCall           ; never returns

NextTurn: 
          inc WhoseTurn
          ldx WhoseTurn
          dex
          cpx #6
          bne +
          ldx #0
          stx WhoseTurn
          jmp BackToMain
+
          lda MonsterHP, x
          beq NextTurn

          lda #3
          jsr SetNextAlarm
BackToMain:         
          jmp CombatMainScreen          

          .bend
