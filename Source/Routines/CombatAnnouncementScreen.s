;;; Grizzards Source/Common/CombatAnnouncementScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock

CombatAnnouncementScreen:     .block
          ;; We are jumped in here lacking an overscan
          jsr Overscan

;;; Set up for the combat move announcement & execution
;;; (this whole first page is really a separate step from the announcement screen)
          .WaitScreenTop

          lda # 0
          sta MoveAnnouncement
          sta MoveSpeech

          ldy MoveSelection

          lda WhoseTurn
          bne FindMonsterMove
FindPlayerMove:
          .FarJSR TextBank, ServiceFetchGrizzardMove
          ldy Temp
          sty CombatMoveSelected
          ldx CombatMoveSelected
          jmp MoveFound

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

          lda (Pointer), y
          sta CombatMoveSelected
          tax

MoveFound:
          lda MoveDeltaHP, x
          sta CombatMoveDeltaHP

          lda # 1
          jsr SetNextAlarm

          .WaitScreenBottom
;;; 
Loop:
          .WaitScreenTop
          jsr Prepare48pxMobBlob

          .ldacolu COLINDIGO, 0
          sta COLUBK

          lda WhoseTurn
          bne MonsterTurnColor
          .ldacolu COLTURQUOISE, $f
          jmp +

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
          blt SkipObject

          lda MoveTarget
          cmp #$ff
          beq SkipObject
DrawObject:
          ldx CombatMoveSelected
          lda MoveDeltaHP, x
          bpl ObjectOther
ObjectSelf:
          lda WhoseTurn
          beq PlayerObject
          bne MonsterTargetObject ; always taken

ObjectOther:
          lda WhoseTurn
          bne PlayerObject
          ;; fall through
MonsterTargetObject:
          jsr ShowMonsterNameAndNumber
          jmp WaitOutSpeechInterval

PlayerObject:
          .FarJSR TextBank, ServiceShowGrizzardName
          beq WaitOutSpeechInterval   ; always taken

SkipObject:
;;; 
WaitOutSpeechInterval:
ScheduleSpeech:
          lda CurrentUtterance
          bne SpeechDone
          lda CurrentUtterance + 1
          bne SpeechDone

          lda MoveSpeech
          cmp # 1
          bge Speech1

          lda WhoseTurn
          beq SayPlayerSubject
SayMonsterSubject:
          jsr SayMonster
          inc MoveSpeech
          bne SpeechDone        ; always taken

SayPlayerSubject:
          jsr SayPlayerGrizzard
          inc MoveSpeech
          bne SpeechDone        ; always taken

Speech1:
          cmp # 2
          bge Speech2
          lda WhoseTurn
          beq Speech1Done

          lda #>(Phrase_One - 1)
          sta CurrentUtterance + 1
          lda #<(Phrase_One - 1)
          clc
          adc WhoseTurn
          sta CurrentUtterance
Speech1Done:
          inc MoveSpeech
          bne SpeechDone        ; always taken

Speech2:
          cmp # 3
          bge Speech3

          lda #>Phrase_UsesMove
          sta CurrentUtterance + 1
          lda #<Phrase_UsesMove
          sta CurrentUtterance

          inc MoveSpeech
          bne SpeechDone        ; always taken

Speech3:
          cmp # 4
          bge Speech4

          lda #>Phrase_Move01 - 1
          sta CurrentUtterance + 1
          lda #<Phrase_Move01 - 1
          clc
          adc CombatMoveSelected
          sta CurrentUtterance

          inc MoveSpeech
          bne SpeechDone        ; always taken

Speech4:
          cmp # 5
          bge Speech5

          lda #>Phrase_On
          sta CurrentUtterance + 1
          lda #<Phrase_On
          sta CurrentUtterance

          inc MoveSpeech
          bne SpeechDone        ; always taken

Speech5:
          cmp # 6
          bge Speech6

          ldx CombatMoveSelected
          lda WhoseTurn
          beq SayMonsterObject
SayPlayerObject:
          lda MoveDeltaHP, x
          bpl +
          jsr SayMonster
          jmp SayObjectDone
+
          jsr SayPlayerGrizzard
          jmp SayObjectDone

SayMonsterObject:
          lda MoveDeltaHP, x
          bpl +
          jsr SayPlayerGrizzard
          jmp SayObjectDone
+
          jsr SayMonster

SayObjectDone:
          inc MoveSpeech
          bne SpeechDone        ; always taken

Speech6:
          cmp # 7
          bge SpeechDone

          ldx CombatMoveSelected
          lda WhoseTurn
          beq SayObjectNumberOnPlayersTurn
SayObjectNumberOnMonstersTurn:
          lda MoveDeltaHP, x
          bpl Speech6Done
          bmi SayThatObjectNumber ; always taken

SayObjectNumberOnPlayersTurn:
          lda MoveDeltaHP, x
          bmi Speech6Done
SayThatObjectNumber:
          lda #>(Phrase_One - 1)
          sta CurrentUtterance + 1
          lda #<(Phrase_One - 1)
          clc
          adc MoveTarget
	sta CurrentUtterance

Speech6Done:
          inc MoveSpeech
          ;; fall through
SpeechDone:
;;; 
CheckForAlarm:
          lda ClockSeconds
          cmp AlarmSeconds
          bne AlarmDone

          inc MoveAnnouncement
          lda # 2
          jsr SetNextAlarm

AlarmDone:
          .WaitScreenBottom

          lda MoveAnnouncement
          cmp # 4
          beq CombatMoveDone
          jmp Loop

CombatMoveDone:
          jmp ExecuteCombatMove
;;; 
ShowMonsterNameAndNumber:
          jsr ShowMonsterName

          lda #40               ; blank space
          sta StringBuffer + 0
          sta StringBuffer + 1
          sta StringBuffer + 2
          sta StringBuffer + 4
          sta StringBuffer + 5
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
