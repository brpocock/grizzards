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

          jsr ShowMonsterName
          lda #40               ; blank space
          sta StringBuffer + 0
          sta StringBuffer + 1
          sta StringBuffer + 2
          sta StringBuffer + 4
          sta StringBuffer + 5
          lda WhoseTurn
          sta StringBuffer + 3
          ldx #TextBank
          ldy #ServiceDecodeAndShowText
          jsr FarCall
          
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
          bne PlayerObject

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
          lda #2
          jsr SetNextAlarm

          lda MoveAnnouncement
          cmp #4
          bne AlarmDone

ExecuteMove:
          lda WhoseTurn
          beq ExecutePlayerMove

ExecuteMonsterMove:
          ;; TODO execute monster move

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
          lda EnemyHP, x
          beq NextTurn

          lda #3
          jsr SetNextAlarm
BackToMain:         
          jmp CombatMainScreen

ExecutePlayerMove:

          ;; TODO really execute player move
          ldx MoveTarget
          lda EnemyHP, x
          sec
          sbc # 2               ; FIXME HP subtract
          bcs +
          lda # 0
+
          sta EnemyHP, x

CheckForWin:
          ldx #5
-
          lda EnemyHP, x
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
          ora GameEventFlags, y
          sta GameEventFlags, y
          
          lda #ModeMap
          sta GameMode

AlarmDone:  
          
          jmp Loop

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

