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
          cmp # 5
          bmi SkipHitPoints

          lda MoveHitMiss
          beq DrawMissed

          lda MoveHP
          bmi DrawHealPoints
          sta Temp              ; for later decoding

          .LoadString "HP -00"

          jmp DrawHitPoints

DrawMissed:
          .LoadString "MISSED"
          jsr DecodeAndShowText
          jmp AfterHitPoints

DrawHealPoints:
          eor #$ff
          clc
          adc #1
          sta Temp
          .LoadString "HEAL00"

DrawHitPoints:
          jsr AppendDecimalAndPrint
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
          jsr FindHighBit
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

          jsr DecodeAndShowText

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

          ;; TODO won battle music?

          lda #ModeMap
          sta GameMode
          jmp GoMap

CheckForLoss:
          lda CurrentHP
          bne NextTurn

          .FarJMP MapServicesBank, ServiceDeath ; never returns

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
          rts

          .bend

;;; 

StatusFXStrings:
          .MiniText "      "    ; no status fx
          .MiniText "SLEEP "    ; sleep
          .MiniText "      "    ; undefined
          .MiniText "ATK DN"    ; attack down
          .MiniText "DEF DN"    ; defend down
          .MiniText "MUDDLE"    ; muddle mind
          .MiniText "      "    ; undefined
          .MiniText "ATK UP"    ; attack up
          .MiniText "DEF UP"    ; defend up

