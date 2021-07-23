;;; Grizzards Source/Routines/AttractStory.s
;;; Copyright © 2021 Bruce-Robert Pocock

AttractStory:       .block
          .WaitScreenTop

          lda AttractHasSpoken
          cmp #<Phrase_Story
          beq Loop

          lda #>Phrase_Story
          sta CurrentUtterance + 1
          lda #<Phrase_Story
          sta CurrentUtterance
          sta AttractHasSpoken

          lda # 0
          sta AttractStoryPanel
          sta AttractStoryProgress

          jsr Random
          and #$07
          adc # 2
          sta CurrentMonsterArt
          jsr Random
          sta pp5h

          ldx # 6
-
          jsr Random
          and #$03
          sta MonsterHP - 1, x
          dex
          bne -

          beq LoopFirst
;;; 
Loop:
          .WaitScreenTop
LoopFirst:
          lda AttractStoryPanel
          cmp # 1
          bge StoryPhase1

          ldx # AttractStoryProgress
-
          stx WSYNC
          dex
          bne -

          stx MoveTarget

          lda pp5l
          sta COLUP0

          jsr DrawMonsterGroup

          inc AttractStoryProgress
          lda AttractStoryProgress
          cmp # KernelLines / 3
          blt StoryDone
          inc AttractStoryProgress

StoryPhase1:
          cmp # 2
          bge StoryPhase2

StoryPhase2:
          cmp # 3
          bge StoryPhase3

StoryPhase3:
StoryDone:
          ;; fall through
;;; 

          jsr Prepare48pxMobBlob

          lda ClockSeconds
          cmp AlarmSeconds
          bne StillStory

          lda # 30
          jsr SetNextAlarm
          lda #ModeAttractTitle
          sta GameMode
          rts

StillStory:
          .WaitScreenBottom

          lda NewSWCHB
          beq LoopMe
          and #SWCHBSelect
          bne LoopMe
          lda #ModeSelectSlot
          sta GameMode
          rts

LoopMe:
          jmp Loop

          .bend
