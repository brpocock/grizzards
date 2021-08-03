;;; Grizzards Source/Routines/AttractStory.s
;;; Copyright © 2021 Bruce-Robert Pocock

AttractStory:       .block
          lda AttractHasSpoken
          cmp #<Phrase_Story
          beq Loop

          lda # STARTER
          sta CurrentGrizzard

          lda # 0
          sta AttractStoryPanel
          sta AttractStoryProgress

          jsr Random
          and #$07
          adc # 2
          sta CurrentMonsterArt
RandomColor:
          jsr Random
          .if TV == SECAM
          beq RandomColor
          .else
          ora #$03
          .fi
          sta DeltaX

          lda # 0
          sta DeltaY

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
          bge StoryPhase0

          lda AttractStoryProgress
          adc # 1
          cmp # FramesPerSecond * 2
          beq +
          sta AttractStoryProgress
-
          jmp StoryDone
+
          lda # 0
          sta AttractStoryProgress
          lda # 1
          sta AttractStoryPanel
          bne -                 ; always taken

StoryPhase0:
          cmp # 2
          bge StoryPhase1

          ldx AttractStoryProgress
          beq +
-
          stx WSYNC
          dex
          bne -
+

          stx MoveTarget        ; always zero

          lda DeltaX
          sta COLUP0

          jsr DrawMonsterGroup

          lda DeltaY
          clc
          adc # ( $40 * ( FramesPerSecond / 24.0 ) )
          sta DeltaY
          cmp #$40
          blt StoryDone
          sec
          sbc #$40
          sta DeltaY
          inc AttractStoryProgress
          lda AttractStoryProgress
          cmp # KernelLines / 4
          blt StoryDone
          inc AttractStoryPanel
;;; 
StoryPhase1:
          cmp # 8
          bge StoryDone

Six:
          cmp # 6
          bne NotSix

          lda DeltaY
          cmp # ceil(.33333 * FramesPerSecond)
          bne NotSix

          lda # 0
          sta DeltaY
          lda AttractStoryPanel

          jsr Random
          and #$07
          tax
          lda MonsterHP, x
          beq +
          lda # SoundHit
          sta NextSound
          stx WSYNC
          stx WSYNC
+
          lda MonsterHP, x
          beq NotSix
          lda # 0
          dec MonsterHP, x
          lda MonsterHP
          ora MonsterHP + 1
          ora MonsterHP + 2
          ora MonsterHP + 3
          ora MonsterHP + 4
          ora MonsterHP + 5
          bne NotSix

          lda # SoundVictory
          sta NextSound

          lda # 0
          sta CurrentMusic
          sta CurrentMusic + 1
          inc AttractStoryPanel

NotSix:
          .SkipLines KernelLines / 4

          lda DeltaX
          sta COLUP0

          jsr DrawMonsterGroup

          ldx AttractStoryProgress
          beq +
-
          stx WSYNC
          dex
          bne -
+

          jsr DrawGrizzard

          lda AttractStoryPanel
          cmp # 3
          bge StoryPhase1b
StoryPhase1a:       
          lda DeltaY
          clc
          adc # ( $40 * ( FramesPerSecond / 30.0 ) )
          sta DeltaY
          cmp #$40
          blt StoryDone
          sec
          sbc #$40
          sta DeltaY
          dec AttractStoryProgress
          lda AttractStoryProgress
          bne StoryDone

          inc AttractStoryPanel
          lda # 0
          sta DeltaY
          lda #>Phrase_Story
          sta CurrentUtterance + 1
          lda #<Phrase_Story
          sta CurrentUtterance
          sta AttractHasSpoken
          bne StoryDone         ; always taken

StoryPhase1b:
          inc DeltaY
          lda DeltaY
          cmp # 2 * FramesPerSecond
          blt StoryDone
          inc AttractStoryPanel
          lda # 0
          sta DeltaY
          bne StoryDone         ; always taken

StoryDone:
          ;; fall through
;;; 

          jsr Prepare48pxMobBlob

          .WaitScreenBottom

          lda AttractStoryPanel
          cmp # 8
          blt StillStory

          lda # 30
          jsr SetNextAlarm
          lda #ModeAttractTitle
          sta GameMode
          rts

StillStory:
          lda NewSWCHB
          beq CheckFire

          and #SWCHBSelect
          bne LoopMe

CheckFire:
          lda NewButtons
          beq LoopMe
          and #PRESSED
          bne LoopMe

SelectSlot:
          lda #ModeSelectSlot
          sta GameMode
          rts

LoopMe:
          jmp Loop

          .bend
