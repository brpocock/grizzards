;;; Grizzards Source/Routines/CombatOutcomeScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock

CombatOutcomeScreen:          .block
          lda # 0
          sta MoveSpeech

          lda MoveHitMiss
          beq SoundForMiss
          lda #SoundHit
          bne +                 ; alway taken
SoundForMiss:
          lda #SoundMiss
+
          sta NextSound
;;; 
Loop:
          .WaitScreenTop

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
          .SkipLines 34
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
          bne EchoStatus        ; always taken

FXAttackDown:
          .SetPointer AttackDownText
          bne EchoStatus        ; always taken

FXAttackUp:
          .SetPointer AttackUpText
          bne EchoStatus        ; always taken

FXDefendDown:
          .SetPointer DefendDownText
          bne EchoStatus        ; always taken

FXDefendUp:
          .SetPointer DefendUpText
          bne EchoStatus        ; always taken

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

          lda MoveSpeech
          bne Speech1

          lda MoveStatusFX
          bne SomethingHappened
          lda MoveHP
          beq NothingHappened
          cmp #$ff
          bne SomethingHappened

NothingHappened:
          lda #>Phrase_NoEffect
          sta CurrentUtterance + 1
          lda #<Phrase_NoEffect
          sta CurrentUtterance
          lda # $ff
          sta MoveSpeech
          bne SpeechDone        ; always taken

SomethingHappened:
          lda WhoseTurn
          beq SaySubjectPlayerTurn
SaySubjectMonsterTurn:
          lda MoveHP
          bmi SayMonster
SayPlayer:
          lda #>Phrase_Grizzard
          sta CurrentUtterance + 1
          lda #<Phrase_Grizzard
          sta CurrentUtterance

          inc MoveSpeech
          bne SpeechDone        ; always taken

SaySubjectPlayerTurn:
          lda MoveHP
          bmi SayPlayer
SayMonster:
          lda #>Phrase_Monster
          sta CurrentUtterance + 1
          lda #<Phrase_Monster
          sta CurrentUtterance

          inc MoveSpeech
          bne SpeechDone        ; always taken

Speech1:
          cmp # 2
          bge Speech2

          lda MoveHitMiss
          beq SayMissed

          lda MoveHP
          beq DontSayHP
          bmi SayHealed
SayInjured:
          lda #>Phrase_IsInjured
          sta CurrentUtterance + 1
          lda #<Phrase_IsInjured
          sta CurrentUtterance

          inc MoveSpeech
          bne SpeechDone        ; always taken

SayMissed:
          lda #>Phrase_Missed
          sta CurrentUtterance + 1
          lda #<Phrase_Missed
          sta CurrentUtterance

          inc MoveSpeech
          bne SpeechDone        ; always taken
          
SayHealed:
          eor #$ff
          beq DontSayHP
          lda #>Phrase_IsHealed
          sta CurrentUtterance + 1
          lda #<Phrase_IsHealed
          sta CurrentUtterance
          ;; fall through to common section
DontSayHP:
          inc MoveSpeech
          bne SpeechDone        ; always taken

Speech2:
          cmp # 3
          bge Speech3

          lda MoveHP
          beq DontSayHP
          eor #$ff
          beq DontSayHP
          lda MoveStatusFX
          beq DontSayHP

SayAnd:
          lda #>Phrase_And
          sta CurrentUtterance + 1
          lda #<Phrase_And
          sta CurrentUtterance

          inc MoveSpeech
          bne SpeechDone        ; always taken

Speech3:
          cmp # 4
          bge Speech4

          lda MoveStatusFX
          beq DontSayHP
          .BitBit StatusSleep
          bne SaySleep
          .BitBit StatusMuddle
          bne SayMuddle
          and # StatusAttackUp | StatusAttackDown
          bne SayAttack
          lda MoveStatusFX
          and # StatusDefendUp | StatusDefendDown
          bne SayDefend
          beq DontSayHP

SaySleep:
          lda #>Phrase_StatusFXSleep
          sta CurrentUtterance + 1
          lda #<Phrase_StatusFXSleep
          sta CurrentUtterance

          inc MoveSpeech
          bne SpeechDone        ; always taken

SayMuddle:          
          lda #>Phrase_StatusFXMuddle
          sta CurrentUtterance + 1
          lda #<Phrase_StatusFXMuddle
          sta CurrentUtterance

          inc MoveSpeech
          bne SpeechDone        ; always taken

SayAttack:
          lda #>Phrase_StatusFXAttack
          sta CurrentUtterance + 1
          lda #<Phrase_StatusFXAttack
          sta CurrentUtterance

          inc MoveSpeech
          bne SpeechDone        ; always taken

SayDefend:
          lda #>Phrase_StatusFXDefend
          sta CurrentUtterance + 1
          lda #<Phrase_StatusFXDefend
          sta CurrentUtterance

          inc MoveSpeech
          bne SpeechDone        ; always taken

Speech4:
          lda MoveSpeech
          cmp # 4
          bge SpeechDone

          lda MoveStatusFX
          and #StatusAttackDown | StatusDefendDown
          beq Speech4NotDown
Speech4Down:
          lda #>Phrase_StatusFXLower
          sta CurrentUtterance + 1
          lda #<Phrase_StatusFXLower
          sta CurrentUtterance
          inc MoveSpeech
          bne SpeechDone        ; always taken

Speech4NotDown:
          lda MoveStatusFX
          and #StatusAttackUp | StatusDefendUp
          beq Spoke4

          lda #>Phrase_StatusFXRaise
          sta CurrentUtterance + 1
          lda #<Phrase_StatusFXRaise
          sta CurrentUtterance
          ;; fall through to common
Spoke4:
          inc MoveSpeech
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

          lda #>Phrase_Victory
          sta CurrentUtterance + 1
          lda #<Phrase_Victory
          sta CurrentUtterance
          
          lda #ModeMap
          sta GameMode
          .WaitScreenBottom
          jmp GoMap

CheckForLoss:
          lda CurrentHP
          bne Bye

          lda #>Phrase_GameOver
          sta CurrentUtterance + 1
          lda #<Phrase_GameOver
          sta CurrentUtterance
          
          .FarJMP MapServicesBank, ServiceDeath ; never returns
Bye:
          .WaitScreenBottomTail

          .bend
