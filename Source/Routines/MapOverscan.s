;;; Grizzards Source/Routines/MapOverscan.s
;;; Copyright © 2021 Bruce-Robert Pocock

MapOverscan:        .block

          lda GameMode
          cmp #ModeMap
          beq MovementLogic
          rts
          
MovementLogic:
          lda ClockFrame
          and # $04
          beq DoSpriteMotion

CheckSpriteCollision:
          lda CXP1FB
          and #$c0              ; hit playfield or ball
          beq MovementLogicDone

          ;; Who did we just draw?
          ldx SpriteFlicker
          lda SpriteMotion, x
          and #SpriteMoveLeft
          bne SpriteCxRight
          lda SpriteMotion, x
          and # SpriteMoveUp | SpriteMoveDown
          ora #SpriteMoveRight
          sta SpriteMotion, x
          jmp SpriteCxUpDown

SpriteCxRight:
          lda SpriteMotion, x
          and # SpriteMoveUp | SpriteMoveDown
          ora #SpriteMoveLeft
          sta SpriteMotion, x
SpriteCxUpDown:
          lda SpriteMotion, x
          and #SpriteMoveUp
          bne SpriteCxDown
          lda SpriteMotion, x
          and # SpriteMoveLeft | SpriteMoveRight
          ora #SpriteMoveDown
          sta SpriteMotion, x
          
          rts

SpriteCxDown:
          lda SpriteMotion, x
          and # SpriteMoveLeft | SpriteMoveRight
          ora #SpriteMoveDown
          sta SpriteMotion, x

          rts

DoSpriteMotion:
          ldx SpriteCount
MoveSprites:
          lda SpriteMotion, x
          beq SpriteMoveDone

SpriteXMove:        
          cmp #SpriteMoveIdle
          beq SpriteMoveNext
          lda SpriteMotion, x
          and #SpriteMoveLeft
          bne +
          dec SpriteX, x
+
          lda SpriteMotion, x
          and #SpriteMoveRight
          bne +
          inc SpriteX, x
+
          lda SpriteMotion, x
          and #SpriteMoveUp
          bne +
          dec SpriteY, x
+
          lda SpriteMotion, x
          and #SpriteMoveDown
          bne +
          inc SpriteY, x
+
          
SpriteMoveNext:
          ;; Possibly change movement randomly
          jsr Random
          and #$07
          bne SpriteMoveDone

          jsr Random
          and #$01
          beq RandomlyMove

          lda SpriteMoveIdle
          sta SpriteMotion, x
          jmp SpriteMoveDone

RandomlyMove:       
          
          jsr Random
          and #$f0              ; random movement may be up+down or something stupid like that
          beq RandomlyMove
          sta SpriteMotion, x
          ;; fall through
          
SpriteMoveDone:
          dex
          cpx #$ff              ; wait for it to wrap around below 0
          bne MoveSprites

MovementLogicDone:
          rts
          
          .bend
