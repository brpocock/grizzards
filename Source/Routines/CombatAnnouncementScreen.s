;;; Grizzards Source/Routines/CombatAnnouncementScreen.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CombatAnnouncementScreen:     .block
;;; Set up for the combat move announcement & execution
;;; (this whole first page is really a separate step from the announcement screen)
          .switch TV

          .case NTSC
            ;; no lines skipped
            .WaitScreenBottom

          .case PAL
            .WaitScreenBottom
            .SkipLines 1
            lda WhoseTurn
            beq +
            .SkipLines 4
+

          .case SECAM
          ;; This is all crazy shit discovered by experiment
          ;; There is no rational explanation
            .WaitForTimer
            lda WhoseTurn
            beq SkipFew
SkipMore:
            .SkipLines 5
SkipFew:
            .SkipLines 11
            jsr Overscan

          .endswitch

          .WaitScreenTop

          lda # 0
          sta MoveAnnouncement
          sta SpeechSegment

          ldy MoveSelection

          lda WhoseTurn
          bne FindMonsterMove
FindPlayerMove:
          .FarJSR TextBank, ServiceFetchGrizzardMove
          ldx Temp
          stx CombatMoveSelected
          gne MoveFound

FindMonsterMove:
          lda #>MonsterMoves
          sta Pointer + 1

          clc
          ldx CurrentCombatEncounter
          lda EncounterMonster, x
          asl a
          asl a
          adc #<MonsterMoves
          bcc +
          inc Pointer + 1
+
          sta Pointer

          lax (Pointer), y
          stx CombatMoveSelected
          ;; fall through:
MoveFound:
          lda MoveDeltaHP, x
          sta CombatMoveDeltaHP

          lda # 2
          sta AlarmCountdown

          gne FirstTime
;;; 
Loop:
          .WaitScreenTop
FirstTime:
          jsr Prepare48pxMobBlob

          ;; stx WSYNC ; commented out for space
          .ldacolu COLINDIGO, 0
          sta COLUBK

          lda WhoseTurn
          bne MonsterTurnColor
          .ldacolu COLTURQUOISE, $f
          gne +

MonsterTurnColor:
          .ldacolu COLRED, $f
+
          sta COLUP0
          sta COLUP1
;;; 
AnnounceSubject:
          lda MoveAnnouncement
          cmp # 1
          blt AnnounceVerb

DrawSubject:
          lda WhoseTurn
          beq PlayerSubject
MonsterSubject:
          jsr ShowMonsterNameAndNumber
          jmp AnnounceVerb

PlayerSubject:
          .FarJSR TextBank, ServiceShowGrizzardName
          ;; fall through
;;; 
AnnounceVerb:
          lda MoveAnnouncement
          cmp # 2
          blt SkipVerb

DrawVerb:
          lda CombatMoveSelected
          sta Temp
          .FarJSR TextBank, ServiceShowMoveDecoded
          stx WSYNC

          jmp AnnounceObject

SkipVerb:
;;; 
AnnounceObject:
          lda MoveAnnouncement
          cmp # 3
          blt Speak

          lda MoveTarget
          cmp #$ff
          beq Speak
DrawObject:
          ldx CombatMoveSelected
          bit CombatMoveDeltaHP
          bpl ObjectOther
ObjectSelf:
          lda WhoseTurn
          beq PlayerObject
          gne MonsterTargetObject

ObjectOther:
          lda WhoseTurn
          bne PlayerObject
          ;; fall through
MonsterTargetObject:
          jsr ShowMonsterNameAndNumber
          jmp Speak

PlayerObject:
          .FarJSR TextBank, ServiceShowGrizzardName

;;; 
Speak:
          lda CurrentUtterance
          bne SpeechDone
          lda CurrentUtterance + 1
          bne SpeechDone

Speech0:
          lda SpeechSegment
          cmp # 1
          bge Speech1

          lda WhoseTurn
          beq SayPlayerSubject
SayMonsterSubject:
          jsr SayMonster
          gne SpeechQueued

SayPlayerSubject:
          jsr SayPlayerGrizzard
          gne SpeechQueued

Speech1:
          cmp # 2
          bge Speech2
          lda WhoseTurn
          beq SpeechQueued
          lda CombatMajorP
          bne SpeechQueued

          lda #>(Phrase_One - 1)
          sta CurrentUtterance + 1
          lda #<(Phrase_One - 1)
          clc
          adc WhoseTurn
          sta CurrentUtterance
          gne SpeechQueued

Speech2:
          cmp # 3
          bge Speech3
          .SetUtterance Phrase_UsesMove
          gne SpeechQueued

Speech3:
          cmp # 4
          bge Speech4

          lda #>Phrase_Move01 - 1
          sta CurrentUtterance + 1
          lda #<Phrase_Move01 - 1
          clc
          adc CombatMoveSelected
          sta CurrentUtterance
          gne SpeechQueued

Speech4:
          cmp # 5
          bge Speech5
          .SetUtterance Phrase_On
          gne SpeechQueued

Speech5:
          cmp # 6
          bge Speech6

          ldx CombatMoveSelected
          lda WhoseTurn
          beq SayMonsterObject
SayPlayerObject:
          bit CombatMoveDeltaHP
          bpl +
          jsr SayMonster
          jmp SpeechQueued
+
          jsr SayPlayerGrizzard
          jmp SpeechQueued

SayMonsterObject:
          bit CombatMoveDeltaHP
          bpl +
          jsr SayPlayerGrizzard
          jmp SpeechQueued
+
          jsr SayMonster
          jmp SpeechQueued

Speech6:
          cmp # 7
          bge SpeechDone

          lda CombatMajorP
          bne SpeechQueued

          ldx CombatMoveSelected
          lda WhoseTurn
          beq SayObjectNumberOnPlayersTurn
SayObjectNumberOnMonstersTurn:
          bit CombatMoveDeltaHP
          bpl SpeechQueued
          gmi SayThatObjectNumber

SayObjectNumberOnPlayersTurn:
          bit CombatMoveDeltaHP
          bmi SpeechQueued
SayThatObjectNumber:
          lda CombatMajorP
          bne SpeechQueued
          lda #>(Phrase_One - 1)
          sta CurrentUtterance + 1
          lda #<(Phrase_One - 1)
          clc
          adc MoveTarget
	sta CurrentUtterance

SpeechQueued:
          inc SpeechSegment
          ;; fall through
SpeechDone:
;;; 
CheckForAlarm:
          lda AlarmCountdown
          bne KeepWaiting

          inc MoveAnnouncement
          lda # 2
          sta AlarmCountdown

KeepWaiting:
          .WaitScreenBottom

          lda MoveAnnouncement
          cmp # 4
          beq CombatMoveDone
GoBack:
          jmp Loop

CombatMoveDone:
          jmp ExecuteCombatMove
;;; 
ShowMonsterNameAndNumber:
          jsr ShowMonsterName

          lda CombatMajorP
          beq +
          ;; major combat, no number
          rts

+
          ldx # 6
          lda #$28              ; blank
-
          sta StringBuffer - 1, x
          dex
          bne -
          lda WhoseTurn
          bne +
          lda MoveTarget
+
          sta StringBuffer + 3
          .FarJMP TextBank, ServiceDecodeAndShowText ; tail call
;;; 
SayMonster:
          lda #>MonsterPhrase
          sta CurrentUtterance + 1
          lda #<MonsterPhrase
          ldx CurrentCombatEncounter
          clc
          adc EncounterMonster, x
          sta CurrentUtterance
          rts

SayPlayerGrizzard:
          lda #>Phrase_Grizzard0
          sta CurrentUtterance + 1
          lda #<Phrase_Grizzard0
          clc
          adc CurrentGrizzard
          sta CurrentUtterance
          rts
;;; 
          .bend
