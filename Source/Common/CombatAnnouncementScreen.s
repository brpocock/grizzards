CombatAnnouncementScreen:     .block

          lda # ModeCombat
          sta AlarmCode
          lda # 0
          sta MoveAnnouncement
          jsr SetNextAlarm

Loop:     
          jsr VSync
          jsr VBlank

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

          ;; FIXME monster name
          .LoadString "THE   "
          ldy #ServiceDecodeAndShowText
          ldx #TextBank
          jsr FarCall
          .LoadString "MONSTR"
          ldy #ServiceDecodeAndShowText
          ldx #TextBank
          jsr FarCall
          jmp SubjectDone

PlayerSubject:
          ldy #ServiceShowGrizzardName
          ldx #TextBank
          jsr FarCall
          ldx # 18
SkipSubjectX:       
          stx WSYNC
          dex
          bne SkipSubjectX
          beq SubjectDone

SkipSubject:
          ldx # 34
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

SkipVerb:
          ldx # 34
-
          stx WSYNC
          dex
          bne -
          
VerbDone:

;;; Object

          lda MoveAnnouncement
          cmp # 3
          bmi SkipObject

DrawObject:
          lda WhoseTurn
          beq MonsterTargetObject


MonsterTargetObject:
          ;; FIXME monster name
          .LoadString "  THE "
          ldy #ServiceDecodeAndShowText
          ldx #TextBank
          jsr FarCall
          .LoadString "MONSTR"
          ldy #ServiceDecodeAndShowText
          ldx #TextBank
          jsr FarCall
          jmp ObjectDone

PlayerObject:
          ldy #ServiceShowGrizzardName
          ldx #TextBank
          jsr FarCall
          ldx # 18
SkipObjectX:       
          stx WSYNC
          dex
          bne SkipObjectX
          beq ObjectDone

SkipObject:
          ldx # 34
          jmp SkipObjectX
          
ObjectDone:

;;; Done printing the main text
          
          ldx # KernelLines - 128
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
          jsr SetNextAlarm

          lda MoveAnnouncement
          cmp #4
          bne AlarmDone

          ;; TODO set up effects of Move
          
          jmp CombatMainScreen

AlarmDone:  
          
          jmp Loop

          .bend

SetNextAlarm:
          lda ClockMinutes
          sta AlarmMinutes
          lda ClockSeconds
          adc # 5
          cmp # 60
          bmi +
          sec
          sbc # 60
          inc AlarmMinutes
+
          sta AlarmSeconds

          rts
