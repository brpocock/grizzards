;;; Grizzards Source/Routines/CombatOutcomeScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock

CombatOutcomeScreen:          .block

          lda MoveHitMiss
          beq SoundForMiss
          lda #SoundHit
          bne +                 ; alway taken
SoundForMiss:
          lda #SoundMiss
+
          sta NextSound

Loop:
          jsr VSync
          jsr VBlank

          .ldacolu COLBLUE, 0
          sta COLUBK
          .ldacolu COLGRAY, $f
          sta COLUP0
          sta COLUP1

;;; 
          lda MoveAnnouncement
          cmp # 5
          bmi SkipHitPoints

          lda MoveHitMiss
          beq DrawMissed

          lda MoveHP
          bmi DrawHealPoints
          beq SkipHitPoints
          sta Temp              ; for later decoding

          .SetPointer HPLostText
          jmp DrawHitPoints

DrawMissed:
          .SetPointer MissedText
          jsr CopyPointerText
          jsr DecodeAndShowText
          jmp AfterHitPoints

DrawHealPoints:
          eor #$ff
          beq SkipHitPoints
          sta Temp
          .SetPointer HealedText

DrawHitPoints:
          jsr AppendDecimalAndPrint.FromTemp
          jmp AfterHitPoints

SkipHitPoints:
          .SkipLines 41
;;; 
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
          .SkipLines 35
;;; 
AfterStatusFX:
          .SkipLines KernelLines - 79
;;; 
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
;;; 
CombatOutcomeDone:
          lda WhoseTurn
          bne CheckForLoss

CheckForWin:
          ldx #6
-
          lda MonsterHP - 1, x
          beq +
          rts
+
          dex
          bne -

WonBattle:
          lda CurrentCombatIndex
          ror a
          ror a
          ror a
          and #$07
          tay
          ldx CurrentCombatIndex
          lda BitMask, x
          ora ProvinceFlags, y
          sta ProvinceFlags, y

          jsr Random
          sta Temp
          lda GrizzardAttack
          jsr CalculateAttackMask
          and Temp
          bne +
          inc GrizzardAttack
+
          jsr Random
          sta Temp
          lda GrizzardDefense
          jsr CalculateAttackMask
          and Temp
          bne +
          inc GrizzardDefense
+
          
;;; TODO Check if they have won the game
          .fill $20, $ea        ; pad with some NOPs

WonReturnToMap:
          lda #SoundVictory
          sta NextSound

          lda #ModeMap
          sta GameMode
          jmp GoMap

CheckForLoss:
          lda CurrentHP
          bne +
          .FarJMP MapServicesBank, ServiceDeath ; never returns
+
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

HPLostText:
          .MiniText "HP -00"
HealedText:
          .MiniText "HEAL00"
MissedText:
          .MiniText "MISSED"
