;;; Grizzards Source/Routines/SpriteMovement.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

SpriteMovement:     .block
          lda SystemFlags
          bpl NotPaused

          rts

NotPaused:
          ldx SpriteCount
          beq MovementLogicDone

          ;; XXX this check should never have been needed
          ;; XXX it might be removed in the final roundup
          cpx # 5
          blt ValidSpriteCount

          brk

ValidSpriteCount:
          dex

MoveSprites:
          lda ClockFrame
          ;; Allow moving approximately 10 Hz regardless of TV region
          sec
-
          sbc # FramesPerSecond / 10
          bcs -
          cmp #$ff
          beq +
          rts
+
          lda SpriteMotion, x
          beq NextSprite
          cmp #SpriteRandomEncounter
          bne SpriteXMove
          jsr Random            ; Is there a random encounter?
          bne NoRandom
          lda SpriteAction, x
          jmp CheckPlayerCollision.ActionWithSpriteX

NoRandom:
          dex
          bne MoveSprites
          rts

SpriteXMove:
          cmp #SpriteMoveIdle
          beq SpriteMoveNext
          .BitBit SpriteMoveLeft
          beq +
          dec SpriteX, x
+
          .BitBit SpriteMoveRight
          beq +
          inc SpriteX, x
+
          .BitBit SpriteMoveUp
          beq +
          dec SpriteY, x
+
          .BitBit SpriteMoveDown
          beq +
          inc SpriteY, x
+

SpriteMoveNext:
          ;; Possibly change movement randomly
          jsr Random
          tay
          and #$07
          bne SpriteMoveDone

          tya
          .BitBit $10
          beq ChasePlayer

          .BitBit $20
          beq RandomlyMove

          lda #SpriteMoveIdle
          sta SpriteMotion, x
          gne SpriteMoveDone

ChasePlayer:
          lda SpriteX, x
          cmp PlayerX
          beq ChaseUpDown
          bge ChaseRight
          lda #SpriteMoveLeft
          sta SpriteMotion, x
          gne SpriteMoveDone

ChaseRight:
          lda #SpriteMoveRight
          sta SpriteMotion, x
          gne SpriteMoveDone

ChaseUpDown:
          lda SpriteY, x
          cmp PlayerY
          bge ChaseDown
          lda #SpriteMoveUp
          sta SpriteMotion, x
          gne SpriteMoveDone

ChaseDown:
          lda #SpriteMoveDown
          sta SpriteMotion, x
          gne SpriteMoveDone

RandomlyMove:
          jsr Random
          and # SpriteMoveUp | SpriteMoveDown | SpriteMoveLeft | SpriteMoveRight
          bne +
          lda #SpriteMoveIdle
+
          .BitBit SpriteMoveUp
          beq +
          and # ~SpriteMoveDown
+
          .BitBit SpriteMoveDown
          beq +
          and # ~SpriteMoveUp
+
          .BitBit SpriteMoveLeft
          beq +
          and # ~SpriteMoveRight
+
          .BitBit SpriteMoveRight
          beq +
          and # ~SpriteMoveLeft
+
          sta SpriteMotion, x
          ;; fall through
SpriteMoveDone:
          lda SpriteX, x
          cmp #ScreenLeftEdge
          bge LeftOK
          lda SpriteMotion, x
          eor # SpriteMoveLeft | SpriteMoveRight
          sta SpriteMotion, x
          inc SpriteX, x
LeftOK:
          cmp #ScreenRightEdge
          blt RightOK
          lda SpriteMotion, x
          eor # SpriteMoveLeft | SpriteMoveRight
          sta SpriteMotion, x
          dec SpriteX, x
RightOK:
          lda SpriteY, x
          cmp #ScreenTopEdge
          bge TopOK
          lda SpriteMotion, x
          eor # SpriteMoveUp | SpriteMoveDown
          sta SpriteMotion, x
          inc SpriteY, x
TopOK:
          cmp #ScreenBottomEdge
          blt BottomOK
          lda SpriteMotion, x
          eor # SpriteMoveUp | SpriteMoveDown
          sta SpriteMotion, x
          dec SpriteY, x
BottomOK:

NextSprite:
          dex
          bpl MoveSprites
          ;; fall through
MovementLogicDone:
          rts

          .bend
