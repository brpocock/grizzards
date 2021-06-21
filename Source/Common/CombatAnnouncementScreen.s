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

          jsr ShowMonsterName
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
          jsr ShowMonsterName
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

ExecuteMove:
          lda WhoseTurn
          beq ExecutePlayerMove

ExecuteMonsterMove:
          ;; TODO execute monster move
          inc WhoseTurn

          jmp CombatMainScreen

ExecutePlayerMove:
          lda # 1
          sta WhoseTurn

          ;; TODO really execute player move
          ldx MoveTarget
          lda EnemyHP, x
          sec
          sbc # 2               ; FIXME HP subtract
          bcs +
          lda # 0
+
          sta EnemyHP, x

          jmp CombatMainScreen

AlarmDone:  
          
          jmp Loop

          .bend

SetNextAlarm:
          lda ClockMinutes
          sta AlarmMinutes
          lda ClockSeconds
          adc # 3
          cmp # 60
          bmi +
          sec
          sbc # 60
          inc AlarmMinutes
+
          sta AlarmSeconds

          rts
ShowMonsterName:
                    lda CurrentMonsterPointer
          sta Pointer
          lda CurrentMonsterPointer + 1
          sta Pointer + 1

          jsr ShowPointerText

          lda Pointer
          clc
          adc # 6
          bcc +
          inc Pointer + 1
+
          sta Pointer

          jmp ShowPointerText

