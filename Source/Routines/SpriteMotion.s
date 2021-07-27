;;; Grizzards Source/Routines/SpriteMovement.s
;;; Copyright © 2021 Bruce-Robert Pocock

SpriteMovement:     .block
          lda Pause
          beq +
          rts
+
          ldx SpriteCount
          beq MovementLogicDone
          cpx # 5
          blt +
          brk
+
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
          beq SpriteMoveDone
          cmp #SpriteRandomEncounter
          bne SpriteXMove
          jsr Random            ; Is there a random encounter?
          bne NoRandom
          jsr Random
          and #1
          bne NoRandom
          pla                   ; discard the call to us
          pla
          jmp CheckPlayerCollision.FightWithSpriteX

NoRandom:
          dex
          bne MoveSprites
          rts

SpriteXMove:        
          cmp #SpriteMoveIdle
          beq SpriteMoveNext
          lda SpriteMotion, x
          .BitBit SpriteMoveLeft
          bne +
          dec SpriteX, x
+
          .BitBit SpriteMoveRight
          bne +
          inc SpriteX, x
+
          .BitBit SpriteMoveUp
          bne +
          dec SpriteY, x
+
          .BitBit SpriteMoveDown
          bne +
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
          bne SpriteMoveDone    ; always taken

ChasePlayer:
          lda SpriteX, x
          cmp PlayerX
          beq ChaseUpDown
          bge ChaseRight
          lda #SpriteMoveLeft
          sta SpriteMotion, x
          bne SpriteMoveDone    ; always taken

ChaseRight:
          lda #SpriteMoveRight
          sta SpriteMotion, x
          bne SpriteMoveDone    ; always taken

ChaseUpDown:
          lda SpriteY, x
          cmp PlayerY
          bge ChaseDown
          lda #SpriteMoveUp
          sta SpriteMotion, x
          bne SpriteMoveDone    ; always taken

ChaseDown:
          lda #SpriteMoveDown
          sta SpriteMotion, x
          bne SpriteMoveDone    ; always taken

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
          and #~SpriteMoveLeft
          ora #SpriteMoveIdle
          sta SpriteMotion, x
          lda #ScreenLeftEdge + 1
          sta SpriteX, x
LeftOK:
          cmp #ScreenRightEdge
          blt RightOK
          lda SpriteMotion, x
          and #~SpriteMoveRight
          ora #SpriteMoveIdle
          sta SpriteMotion, x
          lda #ScreenRightEdge - 1
          sta SpriteX, x
RightOK:
          lda SpriteY, x
          cmp #ScreenTopEdge
          bge TopOK
          lda SpriteMotion, x
          and #~SpriteMoveUp
          ora #SpriteMoveIdle
          sta SpriteMotion, x
          lda #ScreenTopEdge + 1
          sta SpriteY, x
TopOK:
          cmp #ScreenBottomEdge
          blt BottomOK
          lda SpriteMotion, x
          and #~SpriteMoveDown
          ora #SpriteMoveIdle
          sta SpriteMotion, x
          lda #ScreenBottomEdge - 1
          sta SpriteY, x
BottomOK:

          dex
          bpl MoveSprites
          ;; fall through
MovementLogicDone:
          rts

          .bend
