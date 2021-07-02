;;; Grizzards Source/Common/CombatAnnouncementScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock
CombatAnnouncementScreen:     .block

          lda # 0
          sta MoveAnnouncement

          lda SWCHA
          and #$02              ; Serial Ready bit
          beq JumpToLoop00      ; not ready for speech

          jsr VSync
          jsr VBlank

          lda WhoseTurn
          beq SayPlayerSubject

          jsr SayMonster

          lda #>Phrase_Zero
          sta CurrentUtterance + 1
          lda #<Phrase_Zero
          clc
          adc WhoseTurn
          bcc +
          inc CurrentUtterance + 1
+
	sta CurrentUtterance
          jsr WaitForSpeech

          jmp SayUsesMove

SayPlayerSubject:
          jsr SayPlayerGrizzard
          ;; fall through

SayUsesMove:
          lda #>Phrase_UsesMove
          sta CurrentUtterance + 1
          lda #<Phrase_UsesMove
          sta CurrentUtterance
          jsr WaitForSpeech

          lda #>Phrase_Move01
          sta CurrentUtterance + 1
          lda #<Phrase_Move01
          clc
          adc MoveSelection
          bcc +
          inc CurrentUtterance + 1
+
          sta CurrentUtterance
          jsr WaitForSpeech

          lda #>Phrase_On
          sta CurrentUtterance + 1
          lda #<Phrase_On
          sta CurrentUtterance
          jsr WaitForSpeech
          
          lda WhoseTurn
          beq MonsterObject

          jsr SayPlayerGrizzard
          jmp Loop00
          
MonsterObject:
          jsr SayMonster

          lda MoveTarget
          beq JumpToLoop00
          
          lda #>Phrase_Zero
          sta CurrentUtterance + 1
          lda #<Phrase_Zero
          clc
          adc MoveTarget
          bcc +
          inc CurrentUtterance + 1
+
	sta CurrentUtterance
          jsr WaitForSpeech
          
JumpToLoop00:
          lda #2
          jsr SetNextAlarm

          jmp Loop00

Loop:     
          jsr VSync
          jsr VBlank
Loop00:
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
          cmp #4
          beq CombatMoveDone
AlarmDone:
          jmp Loop

CombatMoveDone:
          jmp CombatOutcomeScreen

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

          .switch BANK
          .case 5
          MonsterPhrase := Phrase_Monster5_0
          .case 6
          MonsterPhrase := Phrase_Monster6_0
          .default
          .error "What bank am I in?"
          .endswitch

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
          ;; fall through

WaitForSpeech:

          ldx #KernelLines - 3
-
          stx WSYNC
          dex
          bne -

          jsr Overscan
          jsr VSync
          jsr VBlank

          lda CurrentUtterance
          bne WaitForSpeech
          lda CurrentUtterance + 1
          bne WaitForSpeech

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

          jmp WaitForSpeech
