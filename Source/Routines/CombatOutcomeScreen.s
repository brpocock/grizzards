;;; Grizzards Source/Routines/CombatOutcomeScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock

CombatOutcomeScreen:          .block

          jsr Overscan

          jsr VSync
          jsr VBlank

          lda # 215             ; 181 scan lines
          sta TIM64T

DetermineOutcome:


WaitOutScreen:
-
          lda INTIM
          bpl -

          ldx # KernelLines - 181
-
          stx WSYNC
          dex
          bne -

          jsr Overscan

;;; 

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
          ldx #5
-
          lda MonsterHP, x
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

          ldy # 14              ; ATK/DEF
          lda (CurrentMonsterPointer), y
          and #$0f
          sta Temp
          lda (CurrentMonsterPointer), y
          and #$f0
          ror a
          ror a
          ror a
          ror a
          sed
          adc Temp
          sta Temp
          cld
          iny                   ; ACU/Count
          lda (CurrentMonsterPointer), y
          and #$f0
          ror a
          ror a
          ror a
          ror a
          sed
          adc Temp
          sta Temp
          cld
          lda (CurrentMonsterPointer), y
          and #$0f
          tax
TallyScore:
          lda Temp
          sed
          clc
          adc Score
          bcc ScoreDone
          inc Score + 1
          bcc ScoreDone
          inc Score + 2
          bcc ScoreDone
          lda # $99
          sta Score
          sta Score + 1
          sta Score + 2
ScoreDone:
          dex
          bne TallyScore
          
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
