;;; Grizzards Source/Routines/CheckSpriteCollision.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CheckSpriteCollision:         .block
          ldx SpriteFlicker
          lda CXP1FB
          and #$c0           ; collision with playfield or ball
          bne CollisionHasOccurred
NoCollision:
          lda InvertedBitMask + 4, x    ; MapFlagSprite𝑥Moved
          and MapFlags
          cmp #MapFlagRandomSpawn | MapFlagAnySpriteMoved
          bne EndRandomSpawn
          sta MapFlags
          rts

EndRandomSpawn:
          lda MapFlags
          and #~MapFlagRandomSpawn
          sta MapFlags
          rts

CollisionHasOccurred:
          ;; If we  are in random  spawn mode,  and nobody had  to move,
          ;; we must have gotten  through a round of validations without
	;; any collisions, so we can turn off RandomSpawn mode
          lda MapFlags
          .BitBit MapFlagRandomSpawn
          beq NoRePosition    ; Not in RandomSpawn mode
NotCertainOfPositions:
          lda BitMask + 4, x    ; MapFlagSprite𝑥Moved
          ora MapFlags
          sta MapFlags          ; mark sprite as being moved (by warping, in this case)
          lda # 0
          sta SpriteX, x
          jmp ValidateMap.CheckSpriteSpawn ; tail call

NoRePosition:
          lda SpriteMotion, x
          beq Bye
CheckLeft:
          .BitBit SpriteMoveLeft
          beq CheckRight

          inc SpriteX, x
          inc SpriteX, x
          eor # SpriteMoveLeft | SpriteMoveRight
          gne CheckUp

CheckRight:
          .BitBit SpriteMoveRight
          beq CheckUp

          dec SpriteX, x
          dec SpriteX, x
          eor # SpriteMoveLeft | SpriteMoveRight
          ;; fall through
CheckUp:
          .BitBit SpriteMoveUp
          beq CheckDown

          inc SpriteY, x
          inc SpriteY, x
          eor # SpriteMoveUp | SpriteMoveDown
          gne Done

CheckDown:
          .BitBit SpriteMoveDown
          beq Done

          dec SpriteY, x
          dec SpriteY, x
          eor # SpriteMoveUp | SpriteMoveDown
          ;; fall through
Done:
          sta SpriteMotion, x
Bye:
          rts
          .bend
