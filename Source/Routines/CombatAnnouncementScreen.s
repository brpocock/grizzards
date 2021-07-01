;;; Grizzards Source/Common/CombatAnnouncementScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock
CombatAnnouncementScreen:     .block

          lda # 0
          sta MoveAnnouncement
          lda #2
          jsr SetNextAlarm

Loop:     
          jsr VSync
          jsr VBlank

          jsr Prepare48pxMobBlob
          
          .ldacolu COLGREEN, 0
          sta COLUBK

          lda WhoseTurn
          beq MonsterTurnColor
          .ldacolu COLTURQUOISE, $f
          jmp +

MonsterTurnColor:   
          .ldacolu COLRED, $f
+
          sta COLUP0
          sta COLUP1

;;; Subject
          
          lda MoveAnnouncement
          cmp # 1
          bmi SkipSubject

DrawSubject:
          lda WhoseTurn
          beq PlayerSubject

          jsr ShowMonsterNameAndNumber
          
          jmp SubjectDone

PlayerSubject:
          ldy #ServiceShowGrizzardName
          ldx #TextBank
          jsr FarCall
          ldx # 32
SkipSubjectX:       
          stx WSYNC
          dex
          bne SkipSubjectX
          beq SubjectDone

SkipSubject:
          ldx # 55
          jmp SkipSubjectX
          
SubjectDone:

;;; Verb
          
          lda MoveAnnouncement
          cmp # 2
          bmi SkipVerb

DrawVerb:
          ldy #ServiceShowMove
          ldx #TextBank
          jsr FarCall
          jmp VerbDone

SkipVerb:
          ldx # 42
-
          stx WSYNC
          dex
          bne -
          
VerbDone:

;;; Object

          lda MoveAnnouncement
          cmp # 3
          bmi SkipObject

          lda MoveTarget
          cmp #$ff
          beq SkipObject

DrawObject:
          lda WhoseTurn
          bne PlayerObject

MonsterTargetObject:
          jsr ShowMonsterNameAndNumber
          jmp ObjectDone

PlayerObject:
          ldy #ServiceShowGrizzardName
          ldx #TextBank
          jsr FarCall
          ldx # 32
SkipObjectX:
          stx WSYNC
          dex
          bne SkipObjectX
          beq ObjectDone

SkipObject:
          ldx # 60
          jmp SkipObjectX
          
ObjectDone:

;;; Done printing the main text
          
          ldx # KernelLines - 132
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
          cmp #6
          beq CombatMoveDone
AlarmDone:
          jmp Loop

CombatMoveDone:

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
          ldx MoveSelection
          lda MoveTargets, x
          cmp #1
          bne ObjectAOE
          lda MoveTarget

+
          sta StringBuffer + 3
          ldx #TextBank
          ldy #ServiceDecodeAndShowText
          jmp FarCall

ObjectAOE:

          ldx #20
-          
          stx WSYNC
          dex
          bne -
          rts
