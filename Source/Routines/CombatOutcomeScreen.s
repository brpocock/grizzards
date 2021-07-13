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

          lda MoveHP
          bmi DrawHealPoints

          .LoadString "HP  00"

          ldx # 39              ; '-'
          stx StringBuffer + 3
          and #$7f
          sta Temp
          jmp DrawHitPoints

DrawHealPoints:
          eor #$ff
          sta Temp
          .LoadString "HEAL00"

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
          lda MoveStatusFX
          jsr ExecuteCombatMove.FindHighBit
          txa
          asl a
          sta Temp
          asl a
          adc Temp

          tax
          ldy # 0
-
          lda StatusFXStrings, x
          sta StringBuffer, y
          inx
          iny
          cpy # 6
          bne -

          ldy #ServiceDecodeAndShowText
          ldx #TextBank
          jsr FarCall

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

;;; 

StatusFXStrings:
          .MiniText "SLEEP "
          .MiniText "      "
          .MiniText "ATK DN"
          .MiniText "DEF DN"
          .MiniText "MUDDLE"
          .MiniText "      "
          .MiniText "ATK UP"
          .MiniText "DEF UP"

