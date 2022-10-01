;;; Grizzards Source/Routines/AttractStory.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

AttractStory:       .block
          lda AttractHasSpoken
          cmp #<Phrase_Story
          beq Loop

          ldy # 0
          sty AttractStoryPanel
          sty AttractStoryProgress

          jsr Random

          and #$0f
          tax
          lda MonsterShapes, x
          sta CurrentMonsterArt
          lda Monsters, x
          sta CurrentMonsterNumber
          lda # 0
          sta CombatMajorP
RandomColor:
          ;; ldy # 0 ; already zero from above
          sty DeltaY            ; XXX used for a timer

          ldx # 6
RandomHP:
          jsr Random

          and #$03
          sta EnemyHP - 1, x
          dex
          bne RandomHP

          beq LoopFirst
;;; 
Loop:
          .WaitScreenTop
LoopFirst:
          .SetSkyColor
          stx WSYNC
          sta COLUBK

          lda AttractStoryPanel
          cmp # 1
          bge StoryPhase0

          lda AttractStoryProgress
          adc # 1
          cmp # FramesPerSecond * 2
          beq ProgressedToPhase0

          sta AttractStoryProgress
GoToStoryDone:
          jmp StoryDone

ProgressedToPhase0:
          ldy # 0               ; necessary? XXX
          sty AttractStoryProgress
          .mva AttractStoryPanel, # 1
          gne GoToStoryDone

StoryPhase0:
          ;; Introducing the monsters
          cmp # 2
          bge StoryPhase1

          ldx AttractStoryProgress
          beq DoneSkipping

SkipLinesForPhase0:
          stx WSYNC
          dex
          bne SkipLinesForPhase0
DoneSkipping:
          stx MoveTarget        ; X = 0

          .if DEMO
            jsr DrawMonsterGroup
          .else
            .FarJSR MonsterBank, ServiceDrawMonsterGroup
          .fi

          lda # KernelLines / 4
          sec
          sbc AttractStoryProgress
          tax
          beq DoneSkippingLower

SkipLower:
          stx WSYNC
          dex
          bne SkipLower

DoneSkippingLower:
          .if SECAM == TV
            lda #COLBLACK
          .else
            .ldacolu COLGREEN, $4
          .fi
          stx WSYNC
          sta COLUBK

          lda DeltaY            ; XXX using this for a timer
          clc
          adc # ceil( $40 * ( FramesPerSecond / 24.0 ) )
          sta DeltaY            ; timer
          cmp #$40
          blt StoryDone

          sec
          sbc #$40
          sta DeltaY            ; timer
          inc AttractStoryProgress
          lda AttractStoryProgress
          cmp # KernelLines / 4
          blt StoryDone

          inc AttractStoryPanel
;;;
StoryPhase1:
          ;; Grizzard attacking the monsters
          cmp # 8
          bge StoryDone

Six:
          cmp # 6
          bne NotSix

          lda DeltaY            ; timer
          cmp # ceil(FramesPerSecond / 3.0)
          bne NotSix

          lda # 0
          sta DeltaY            ; timer
          lda AttractStoryPanel

          jsr Random
          and #$07
          tax
          lda EnemyHP, x
          beq DoneHitSound

          lda # SoundHit
          sta NextSound
          stx WSYNC
          stx WSYNC
DoneHitSound:
          lda EnemyHP, x
          beq NotSix
          lda # 0
          dec EnemyHP, x
          lda EnemyHP
          ora EnemyHP + 1
          ora EnemyHP + 2
          ora EnemyHP + 3
          ora EnemyHP + 4
          ora EnemyHP + 5
          bne NotSix

          lda # SoundVictory
          sta NextSound

          lda # 0
          sta CurrentMusic
          sta CurrentMusic + 1
          inc AttractStoryPanel

NotSix:
          .SkipLines KernelLines / 4

          .if DEMO
            jsr DrawMonsterGroup
          .else
            .FarJSR MonsterBank, ServiceDrawMonsterGroup
          .fi

          ldy # 0               ; XXX should not need this but … do.
          sty GRP0
          sty GRP1

          .if SECAM == TV
            lda #COLBLACK
          .else
            .ldacolu COLGREEN, $4
          .fi
          stx WSYNC
          sta COLUBK
          
          ldx AttractStoryProgress
          beq DoneSkipPhase1
SkipPhase1:
          stx WSYNC
          dex
          bne SkipPhase1

DoneSkipPhase1:
          jsr DrawGrizzard

          lda AttractStoryPanel
          cmp # 3
          bge StoryPhase1b

StoryPhase1a:
          lda DeltaY            ; timer
          clc
          adc # ceil( $40 * ( FramesPerSecond / 30.0 ) )
          sta DeltaY            ; timer
          cmp #$40
          blt StoryDone

          sec
          sbc #$40
          sta DeltaY            ; timer
          dec AttractStoryProgress
          lda AttractStoryProgress
          bne StoryDone

          inc AttractStoryPanel
          lda # 0
          sta DeltaY            ; timer
          .SetUtterance Phrase_Story
          sta AttractHasSpoken
          gne StoryDone

StoryPhase1b:
          inc DeltaY            ; timer
          lda DeltaY            ; timer
          cmp # 2 * FramesPerSecond
          blt StoryDone

          inc AttractStoryPanel
          ldy # 0               ; XXX necessary?
          sty DeltaY
          ;; gne StoryDone ; fall through
;;; 
StoryDone:
          jsr Prepare48pxMobBlob

          lda AttractStoryPanel
          cmp # 8
          blt StillStory

          ;; Return to title screen, with a new Grizzard
          ldy # 0               ; necessary? XXX
          sty DeltaY

NextGrizzard:
          ldx CurrentGrizzard
          lda IncMod3, x
          sta CurrentGrizzard

          .if DEMO
            .mva GameMode, #ModePublisherPresents
            rts
          .else
            .mva GameMode, #ModeAttractBestiary
            jmp AttractBestiary
          .fi
;;; 
StillStory:
          lda NewSWCHB
          beq CheckFire

          and #SWCHBSelect
          bne LoopMe

CheckFire:
          lda NewButtons
          beq LoopMe

          and #ButtonI
          bne LoopMe

SelectSlot:
          .mva GameMode, #ModeSelectSlot
          rts
;;; 
LoopMe:
          .WaitScreenBottom
          jmp Loop
;;; 
Monsters:
          .byte 0, 1, 2, 8,   11, 13, 18, 23
          .byte 3, 5, 9, 14,  19, 6, 42, 10
MonsterShapes:
          .byte Monster_SlimeSmall
          .byte Monster_SlimeSmall
          .byte Monster_Bunny
          .byte Monster_Dog
          .byte Monster_Firefox
          .byte Monster_Mutant
          .byte Monster_Bat
          .byte Monster_Bird

          .byte Monster_Rodent
          .byte Monster_Turtle
          .byte Monster_Spider
          .byte Monster_WillOWisp
          .byte Monster_Sheep
          .byte Monster_Fox
          .byte Monster_Radish
          .byte Monster_Rodent

IncMod3:
          .byte 1, 2, 0
          .bend
