;;; Grizzards Source/Routines/CombatOutcomeScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock

CombatOutcomeScreen:          .block
          .WaitScreenTopMinus 1, 0

          lda # 0
          sta SpeechSegment

          lda MoveHitMiss
          beq SoundForMiss
          lda #SoundHit
          bne +                 ; alway taken
SoundForMiss:
          lda #SoundMiss
+
          sta NextSound

          bne LoopFirst         ; always taken
;;; 
Loop:
          .WaitScreenTop
LoopFirst:
          .ldacolu COLBLUE, 0
          sta COLUBK
          .ldacolu COLGRAY, $f
          sta COLUP0
          sta COLUP1
;;; 
          lda MoveAnnouncement
          cmp # 5
          blt SkipHitPoints

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
          .if TV == NTSC
          ;; XXX PAL ran out of space
          .SkipLines 34
          .fi
;;; 
AfterHitPoints:
          lda MoveAnnouncement
          cmp # 5
          bmi SkipStatusFX

DrawStatusFX:
          lda MoveStatusFX

          .BitBit StatusSleep
          bne FXSleep

          .BitBit StatusAttackDown
          bne FXAttackDown

          .BitBit StatusAttackUp
          bne FXAttackUp

          .BitBit StatusDefendDown
          bne FXDefendDown

          .BitBit StatusDefendUp
          bne FXDefendUp

          .BitBit StatusMuddle
          bne FXMuddle

          jmp AfterStatusFX

FXSleep:
          .SetPointer SleepText
          jmp EchoStatus

FXAttackDown:
          .SetPointer AttackDownText
          jmp EchoStatus

FXAttackUp:
          .SetPointer AttackUpText
          jmp EchoStatus

FXDefendDown:
          .SetPointer DefendDownText
          jmp EchoStatus

FXDefendUp:
          .SetPointer DefendUpText
          jmp EchoStatus

FXMuddle:
          .SetPointer MuddleText
          ;; fall through
EchoStatus:
          jsr CopyPointerText
          jsr DecodeAndShowText

SkipStatusFX:
AfterStatusFX:
;;; 
          lda ClockSeconds
          cmp AlarmSeconds
          bne AlarmDone

          inc MoveAnnouncement
          lda #2
          jsr SetNextAlarm

          lda MoveAnnouncement
          cmp # 6
          beq CombatOutcomeDone
AlarmDone:
;;; 
ScheduleSpeech:
          lda CurrentUtterance
          bne SpeechDone
          lda CurrentUtterance + 1
          bne SpeechDone

          lda SpeechSegment
          bne Speech1

          lda MoveStatusFX
          bne SomethingHappened
          lda MoveHP
          beq NothingHappened
          cmp #$ff
          bne SomethingHappened

NothingHappened:
          .SetUtterance Phrase_NoEffect
          lda # $ff
          sta SpeechSegment
          bne SpeechDone        ; always taken

SomethingHappened:
          lda WhoseTurn
          beq SaySubjectPlayerTurn
SaySubjectMonsterTurn:
          lda MoveHP
          bmi SayMonster
SayPlayer:
          .SetUtterance Phrase_Grizzard

          bne SpeechQueued        ; always taken

SaySubjectPlayerTurn:
          lda MoveHP
          bmi SayPlayer
SayMonster:
          .SetUtterance Phrase_Monster

          bne SpeechQueued        ; always taken

Speech1:
          cmp # 2
          bge Speech2

          lda MoveHitMiss
          beq SayMissed

          lda MoveHP
          beq SpeechQueued
          bmi SayHealed
SayInjured:
          .SetUtterance Phrase_IsInjured

          bne SpeechQueued        ; always taken

SayMissed:
          .SetUtterance Phrase_Missed

          inc SpeechSegment
          bne SpeechDone        ; always taken
          
SayHealed:
          eor #$ff
          beq SpeechQueued
          .SetUtterance Phrase_IsHealed
          bne SpeechQueued      ; always taken

Speech2:
          cmp # 3
          bge Speech3

          lda MoveHP
          beq SpeechQueued
          eor #$ff
          beq SpeechQueued
          lda MoveStatusFX
          beq SpeechQueued      ; always taken

SayAnd:
          .SetUtterance Phrase_And

          bne SpeechQueued        ; always taken

Speech3:
          cmp # 4
          bge Speech4

          lda MoveStatusFX
          beq SpeechQueued
          .BitBit StatusSleep
          bne SaySleep
          .BitBit StatusMuddle
          bne SayMuddle
          and # StatusAttackUp | StatusAttackDown
          bne SayAttack
          lda MoveStatusFX
          and # StatusDefendUp | StatusDefendDown
          bne SayDefend
          beq SpeechQueued      ; always taken

SaySleep:
          .SetUtterance Phrase_StatusFXSleep

          bne SpeechQueued        ; always taken

SayMuddle:          
          .SetUtterance Phrase_StatusFXMuddle
          bne SpeechQueued      ; always taken

SayAttack:
          .SetUtterance Phrase_StatusFXAttack
          bne SpeechQueued        ; always taken

SayDefend:
          .SetUtterance Phrase_StatusFXDefend
          bne SpeechQueued        ; always taken

Speech4:
          lda SpeechSegment
          cmp # 5
          bge SpeechDone

          lda MoveStatusFX
          and #StatusAttackDown | StatusDefendDown
          beq Speech4NotDown
Speech4Down:
          .SetUtterance Phrase_StatusFXLower
          bne SpeechQueued        ; always taken

Speech4NotDown:
          lda MoveStatusFX
          and #StatusAttackUp | StatusDefendUp
          beq SpeechQueued

          .SetUtterance Phrase_StatusFXRaise
          ;; fall through to common
SpeechQueued:
          inc SpeechSegment
          ;; fall through
SpeechDone:
;;;  
          .WaitScreenBottom
          jmp Loop
;;; 
CombatOutcomeDone:
          lda WhoseTurn
          bne CheckForLoss

CheckForWin:
          ldx #6
-
          lda MonsterHP - 1, x
          bne Bye
          dex
          bne -

WonBattle:
          .SetBitFlag CurrentCombatIndex
          ;; Did the player level up their stats by this victory?
          ;; The likelihood decreases the higher that stat is.
          ;; Use DeltaX to store which level(s) was (were) raised
          lda # 0
          sta DeltaX

          jsr Random
          sta Temp
          lda GrizzardAttack
          cmp # 99
          bge AttackLevelUpDone
          jsr CalculateAttackMask
          and Temp
          bne AttackLevelUpDone
          inc GrizzardAttack
          lda # LevelUpAttack
          sta DeltaX
AttackLevelUpDone:
          jsr Random
          sta Temp
          lda GrizzardDefense
          cmp # 99
          bge DefendLevelUpDone
          jsr CalculateAttackMask
          and Temp
          bne DefendLevelUpDone
          inc GrizzardDefense
          lda # LevelUpDefend
          ora DeltaX
          sta DeltaX
DefendLevelUpDone:
          jsr Random
          sta Temp
          lda MaxHP
          cmp # 99
          bge HPLevelUpDone
          jsr CalculateAttackMask
          and Temp
          bne HPLevelUpDone
          inc MaxHP
          lda # LevelUpMaxHP
          ora DeltaX
          sta DeltaX
HPLevelUpDone:

          lda DeltaX
          beq NoLevelUp

          jsr LevelUp

NoLevelUp:

;;; TODO Check if they have won the game
          .fill $30, $ea        ; pad with some NOPs to reserve space

WonReturnToMap:
          lda #SoundVictory
          sta NextSound

          .SetUtterance Phrase_Victory
          
          lda #ModeMap
          sta GameMode
          .WaitScreenBottom
          jmp GoMap

CheckForLoss:
          lda CurrentHP
          bne Bye

          .WaitScreenBottom
          .FarJMP AnimationsBank, ServiceDeath
Bye:
          .WaitScreenBottomTail

          .bend
