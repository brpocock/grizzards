;;; Grizzards Source/Routines/CombatOutcomeScreen.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CombatOutcomeScreen:          .block
          .WaitScreenTopMinus 1, -2

          ldy # 0
          sty SpeechSegment

          lda MoveHitMiss
          beq SoundForMiss

          lda MoveHP
          bmi SoundForHeal

          lda #SoundHit
          gne SoundReady

SoundForHeal:
          cmp #$ff
          beq SoundForMiss

          lda #SoundHappy
          gne SoundReady

SoundForMiss:
          lda #SoundMiss
SoundReady:
          sta NextSound

          gne LoopFirst
;;; 
Loop:
          .WaitScreenTop
LoopFirst:
          stx WSYNC
          .if SECAM == TV

            .mva COLUBK, #COLBLACK

            lda #COLWHITE
            ldx CriticalHitP
            beq +
            lda #COLRED
+
            sta COLUP0
            sta COLUP1

          .else
          
            .ldacolu COLBLUE, 0
            ldx CriticalHitP
            beq +
            .ldacolu COLRED, 0
+
            sta COLUBK
            .ldacolu COLGRAY, $f
            sta COLUP0
            sta COLUP1

          .fi
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
CheckForPulse:
          ldx WhoseTurn
          beq CheckMonsterPulse2

          lda CurrentHP
          bne PrintInjured

PrintKilled:
          .SetPointer KilledText
          jsr ShowPointerText

          jmp DoneStatusFX

CheckMonsterPulse2:
          ldx MoveTarget
          lda EnemyHP - 1, x
          beq PrintKilled

PrintInjured:
          .SetPointer HPLostText
          jmp DrawHitPoints

DrawMissed:
          .SetPointer MissedText
          jsr CopyPointerText

          jsr DecodeAndShowText

          jmp DoneHitPoints

DrawHealPoints:
          eor #$ff
          beq SkipHitPoints

          sta Temp
          .SetPointer HealedText
DrawHitPoints:
          jsr AppendDecimalAndPrint.FromTemp

          jmp DoneHitPoints

SkipHitPoints:
          .SkipLines 34
;;; 
DoneHitPoints:
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

          jmp DoneStatusFX

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
          jsr ShowPointerText

SkipStatusFX:
DoneStatusFX:
          lda CriticalHitP
          beq DoneCritNotice
          .SetPointer CritText
          jsr ShowPointerText
DoneCritNotice:
;;; 
          lda AlarmCountdown
          bne AlarmDone

          .mva AlarmCountdown, # 4
          inc MoveAnnouncement
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
          .mva SpeechSegment, # $ff
          gne SpeechDone

SomethingHappened:
          lda WhoseTurn
          beq SaySubjectPlayerTurn

SaySubjectMonsterTurn:
          lda MoveHP
          bmi SayMonster

SayPlayer:
          .SetUtterance Phrase_Grizzard
          gne SpeechQueued

SaySubjectPlayerTurn:
          lda MoveHP
          bmi SayPlayer

SayMonster:
          .SetUtterance Phrase_Monster
          gne SpeechQueued

Speech1:
          cmp # 2
          bge Speech2

          lda MoveHitMiss
          beq SayMissed

          lda MoveHP
          beq SpeechQueued

          bmi SayHealed

SayInjuredOrKilled:
          ldx WhoseTurn
          beq CheckMonsterPulse

          lda CurrentHP
          bne SayInjured

SayKilled:
          .SetUtterance Phrase_IsKilled
          .mva SpeechSegment, # 5
          gne SpeechQueued

CheckMonsterPulse:
          ldx MoveTarget
          lda EnemyHP - 1, x
          beq SayKilled

SayInjured:
          .SetUtterance Phrase_IsInjured
          gne SpeechQueued

SayMissed:
          .SetUtterance Phrase_Missed
          gne SpeechQueued

SayHealed:
          eor #$ff
          beq SpeechQueued

          .SetUtterance Phrase_IsHealed
          gne SpeechQueued

Speech2:
          cmp # 3
          bge Speech3

          lda MoveHP
          beq SpeechQueued

          eor #$ff
          beq SpeechQueued

          lda MoveStatusFX
          geq SpeechQueued

SayAnd:
          .SetUtterance Phrase_And
          gne SpeechQueued

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

          geq SpeechQueued

SaySleep:
          .SetUtterance Phrase_StatusFXSleep
          gne SpeechQueued

SayMuddle:
          .SetUtterance Phrase_StatusFXMuddle
          gne SpeechQueued

SayAttack:
          .SetUtterance Phrase_StatusFXAttack
          gne SpeechQueued

SayDefend:
          .SetUtterance Phrase_StatusFXDefend
          gne SpeechQueued

Speech4:
          lda SpeechSegment
          cmp # 5
          bge Speech5

          lda MoveStatusFX
          and #StatusAttackDown | StatusDefendDown
          beq Speech4NotDown

Speech4Down:
          .SetUtterance Phrase_StatusFXLower
          gne SpeechQueued

Speech4NotDown:
          lda MoveStatusFX
          and #StatusAttackUp | StatusDefendUp
          beq SpeechQueued

          .SetUtterance Phrase_StatusFXRaise
          gne SpeechQueued

Speech5:
          lda SpeechSegment
          cmp # 6
          bge SpeechDone

          lda CriticalHitP
          beq SpeechQueued

          .SetUtterance Phrase_CriticalHit
SpeechQueued:
          inc SpeechSegment
          ;; fall through
SpeechDone:
          .WaitScreenBottom
          jmp Loop
;;; 
CombatOutcomeDone:
          lda WhoseTurn
          bne CheckForLoss

CheckForWin:
          ldx # 6
-
          lda EnemyHP - 1, x
          bne Bye

          dex
          bne -

WonBattle:
          lda CurrentCombatIndex
          cmp #$ff
          beq +
          .SetBitFlag CurrentCombatIndex
          ;; Did the player level up their stats by this victory?
          ;; The likelihood decreases the higher that stat is.
          ;; Use DeltaX to store which level(s) was (were) raised
+
          .mva DeltaX, # 0      ; Y ≠ 0 after SetBitFlag

          jsr Random
          sta Temp
          lda GrizzardAttack
          cmp #$ff
          bge AttackLevelUpDone

          jsr CalculateAttackMask

          and Temp
          bne AttackLevelUpDone

          inc GrizzardAttack
          .mva DeltaX, # LevelUpAttack
AttackLevelUpDone:
          jsr Random

          sta Temp
          lda GrizzardDefense
          cmp #$ff
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
          cmp #$ff
          bge HPLevelUpDone

          ;; HP needs to level up faster than other stats
          lsr a
          lsr a
          lsr a
          jsr CalculateAttackMask

          and Temp
          bne HPLevelUpDone

          inc MaxHP
          inc CurrentHP
          lda # LevelUpMaxHP
          ora DeltaX
          sta DeltaX
HPLevelUpDone:
          lda DeltaX
          beq NoLevelUp

          sta Temp
          jsr LevelUp

NoLevelUp:
WonReturnToMap:
          jmp CombatVictoryScreen

CheckForLoss:
          lda CurrentHP
          bne Bye

          .if TV == NTSC
            ldx INTIM
            dex
            stx TIM64T
          .fi
          .WaitScreenBottom
          .FarJMP AnimationsBank, ServiceDeath

Bye:
          .WaitScreenBottomTail

          .bend

;;; Audited 2022-02-16 BRPocock
