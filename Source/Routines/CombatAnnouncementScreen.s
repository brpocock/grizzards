;;; Grizzards Source/Common/CombatAnnouncementScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock

CombatAnnouncementScreen:     .block

          ;; We are jumped in here lacking an overscan
          jsr Overscan

;;; Set up for the combat move announcement & execution
;;; (this whole first page is really a separate step from the announcement screen)
          lda # 0
          sta MoveAnnouncement
          sta MoveSpeech

          .WaitScreenTop

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

          lda #2
          jsr SetNextAlarm

          .WaitScreenBottom

;;; 

Loop:
          jsr VSync
          jsr VBlank

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
          bmi SkipSubject

DrawSubject:
          lda WhoseTurn
          beq PlayerSubject

          jsr ShowMonsterNameAndNumber

          jmp AnnounceVerb

PlayerSubject:
          .FarJSR TextBank, ServiceShowGrizzardName
          .SkipLines 32
          beq AnnounceVerb       ; always taken

SkipSubject:
          .SkipLines 55
;;; 
AnnounceVerb:

          lda MoveAnnouncement
          cmp # 2
          bmi SkipVerb

DrawVerb:
          lda CombatMoveSelected
          sta Temp
          .FarJSR TextBank, ServiceShowMoveDecoded
          stx WSYNC

          jmp AnnounceObject

SkipVerb:
          .SkipLines 42
;;; 
AnnounceObject:

          lda MoveAnnouncement
          cmp # 3
          bmi SkipObject

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
          bne MonsterTargetObject

ObjectOther:
          lda WhoseTurn
          bne PlayerObject
          ;; fall through
MonsterTargetObject:
          jsr ShowMonsterNameAndNumber
          jmp WaitOutSpeechInterval

PlayerObject:
          .FarJSR TextBank, ServiceShowGrizzardName
          .SkipLines 32
          beq WaitOutSpeechInterval   ; always taken

SkipObject:
          .SkipLines 60
;;; 
WaitOutSpeechInterval:
          lda # ( (KernelLines - 161) * 76 ) / 64
          sta TIM64T
;;; 
ScheduleSpeech:
          lda CurrentUtterance
          bne SpeechDone
          lda CurrentUtterance + 1
          bne SpeechDone

          lda MoveSpeech
          bne Speech1

          lda WhoseTurn
          beq SayPlayerSubject
SayMonsterSubject:
          jsr SayMonster
          inc MoveSpeech
          bne SpeechDone        ; always taken

SayPlayerSubject:
          jsr SayPlayerGrizzard
          inc MoveSpeech
          jmp SpeechDone

Speech1:
          cmp # 2
          bge Speech2
          lda WhoseTurn
          beq Speech1Done

          lda #>Phrase_Zero
          sta CurrentUtterance + 1
          lda #<Phrase_Zero
          clc
          adc WhoseTurn
          bcc +
          inc CurrentUtterance + 1
+
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

          lda #>Phrase_Move01
          sta CurrentUtterance + 1
          lda #<Phrase_Move01
          clc
          adc MoveSelection
          bcc +
          inc CurrentUtterance + 1
+
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

          lda WhoseTurn
          beq SayMonsterObject
          jsr SayPlayerGrizzard
          jmp SayObjectDone

SayMonsterObject:
          jsr SayMonster
SayObjectDone:
          inc MoveSpeech
          bne SpeechDone        ; always taken

Speech6:
          cmp # 7
          bge SpeechDone

          lda WhoseTurn
          beq Speech6Done

          lda #>Phrase_Zero
          sta CurrentUtterance + 1
          lda #<Phrase_Zero
          clc
          adc MoveTarget
          bcc +
          inc CurrentUtterance + 1
+
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

          lda ClockMinutes
          cmp AlarmMinutes
          bne AlarmDone
          inc MoveAnnouncement
          lda # 2
          jsr SetNextAlarm

AlarmDone:

-
          lda INSTAT
          bpl -

          lda MoveAnnouncement
          cmp # 4
          beq CombatMoveDone

          jsr Overscan
          jmp Loop

CombatMoveDone:
          jmp ExecuteCombatMove

          .bend

;;; 

SetNextAlarm:
          tax
          lda ClockMinutes
          sta AlarmMinutes
          txa
          adc ClockSeconds
          cmp # 60
          bmi +
          sec
          sbc # 60
          inc AlarmMinutes
+
          sta AlarmSeconds

          rts

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
          bcc +
          inc CurrentUtterance + 1
+
          sta CurrentUtterance
          rts

SayPlayerGrizzard:
          lda #>Phrase_Grizzard0
          sta CurrentUtterance + 1
          lda #<Phrase_Grizzard0
          clc
          adc CurrentGrizzard
          bcc +
          inc CurrentUtterance + 1
+
          sta CurrentUtterance

          rts
