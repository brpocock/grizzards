;;; Grizzards Source/Routines/CheckSpriteCollision.s
;;; Copyright © 2021 Bruce-Robert Pocock

CheckSpriteCollision:         .block
          lda CXP1FB
          and $c0           ; collision with playfield or ball
          beq Done
          ldx SpriteFlicker
          lda SpriteMotion, x

          .BitBit SpriteMoveLeft
          beq CheckRight

          inc SpriteX, x
          inc SpriteX, x
          eor # SpriteMoveLeft | SpriteMoveRight
          sta SpriteMotion, x
          bne CheckUp           ; always taken

CheckRight:
          .BitBit SpriteMoveRight
          beq CheckUp

          dec SpriteX, x
          dec SpriteX, x
          eor # SpriteMoveLeft | SpriteMoveRight
          sta SpriteMotion, x
          ;; fall through
CheckUp:
          .BitBit SpriteMoveUp
          beq CheckDown

          inc SpriteY, x
          inc SpriteY, x
          eor # SpriteMoveUp | SpriteMoveDown
          sta SpriteMotion, x
          bne Done              ; always taken

CheckDown:
          .BitBit SpriteMoveDown
          beq Done

          dec SpriteY, x
          dec SpriteY, x
          eor # SpriteMoveUp | SpriteMoveDown
          sta SpriteMotion, x
          ;; fall through
Done:
          rts
          .bend
