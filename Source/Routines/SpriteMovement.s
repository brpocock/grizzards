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
DivByFPS:
          sbc # FramesPerSecond / 10
          bcs DivByFPS

          bmi Do10Hz

          rts

Do10Hz:
          lda BitMask, x
          and DrawnSprites
          beq NextSprite

          lda SpriteMotion, x
          beq NextSprite

          cmp #SpriteRandomEncounter
          bne SpriteXMove

          jsr Random            ; Is there a random encounter?
          bne NoRandom

          stx SpriteFlicker
          .FarJMP MonsterBank, ServiceSpriteCollision

NoRandom:
          dex
          bne Do10Hz
          rts

SpriteXMove:
          cmp #SpriteMoveIdle
          beq SpriteMoveNext

          .BitBit SpriteMoveLeft
          beq DoneLeftMove

          dec SpriteX, x
DoneLeftMove:
          .BitBit SpriteMoveRight
          beq DoneRightMove

          inc SpriteX, x
DoneRightMove:
          .BitBit SpriteMoveUp
          beq DoneUpMove

          dec SpriteY, x
DoneUpMove:
          .BitBit SpriteMoveDown
          beq DoneDownMove
          
          inc SpriteY, x
DoneDownMove:
SpriteMoveNext:
          ;; Possibly change movement randomly
          jsr Random

          tay
          and #$07
          bne SpriteMoveReady

          tya
          .BitBit $10
          beq ChasePlayer

          .BitBit $20
          beq RandomlyMove

          lda #SpriteMoveIdle
          sta SpriteMotion, x
          gne SpriteMoveReady

ChasePlayer:
          lda SpriteX, x
          cmp PlayerX
          beq ChaseUpDown

          bge ChaseRight

          lda #SpriteMoveLeft
          sta SpriteMotion, x
          gne SpriteMoveReady

ChaseRight:
          lda #SpriteMoveRight
          sta SpriteMotion, x
          gne SpriteMoveReady

ChaseUpDown:
          lda SpriteY, x
          cmp PlayerY
          bge ChaseDown

          lda #SpriteMoveUp
          sta SpriteMotion, x
          gne SpriteMoveReady

ChaseDown:
          lda #SpriteMoveDown
          sta SpriteMotion, x
          gne SpriteMoveReady

RandomlyMove:
          jsr Random
          and # SpriteMoveUp | SpriteMoveDown | SpriteMoveLeft | SpriteMoveRight
          bne RandomDoMove

          lda #SpriteMoveIdle
RandomDoMove:
          .BitBit SpriteMoveUp
          beq NoRandUp

          and # ~SpriteMoveDown
NoRandUp:
          .BitBit SpriteMoveDown
          beq NoRandDown

          and # ~SpriteMoveUp
NoRandDown:
          .BitBit SpriteMoveLeft
          beq NoRandLeft

          and # ~SpriteMoveRight
NoRandLeft:
          .BitBit SpriteMoveRight
          beq NoRandRight

          and # ~SpriteMoveLeft
NoRandRight:
          sta SpriteMotion, x
SpriteMoveReady:
          lda SpriteX, x
          cmp #ScreenLeftEdge
          bge LeftOK

          inc SpriteX, x
          gne InvertHorizontal

LeftOK:
          cmp #ScreenRightEdge
          blt RightOK

          dec SpriteX, x
InvertHorizontal:
          lda SpriteMotion, x
          eor # SpriteMoveLeft | SpriteMoveRight
          sta SpriteMotion, x
RightOK:
          lda SpriteY, x
          cmp #ScreenTopEdge
          bge TopOK

          inc SpriteY, x
          gne InvertVertical

TopOK:
          cmp #ScreenBottomEdge
          blt BottomOK

          dec SpriteY, x
InvertVertical:
          lda SpriteMotion, x
          eor # SpriteMoveUp | SpriteMoveDown
          sta SpriteMotion, x
BottomOK:

NextSprite:
          dex
          bpl Do10Hz

MovementLogicDone:
          rts

          .bend

;;; audited 2022-03-22 BRPocock
