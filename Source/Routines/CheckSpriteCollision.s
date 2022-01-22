;;; Grizzards Source/Routines/CheckSpriteCollision.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CheckSpriteCollision:         .block
          lda CXP1FB
          and #$c0           ; collision with playfield or ball
          bne CollisionHasOccurred
          rts

CollisionHasOccurred:
          ldx SpriteFlicker

          ;; If we  are in random  spawn mode,  and nobody had  to move,
          ;; we must have gotten  through a round of validations without
	;; any collisions, so we can turn off RandomSpawn mode
          lda MapFlags
          .BitBit MapFlagRandomSpawn
          beq NoRePosition    ; Not in RandomSpawn mode
          and #MapFlagRandomSpawn | MapFlagAnySpriteMoved
          cmp #MapFlagRandomSpawn
          bne NotCertainOfPositions
EndRandomSpawn:
          lda MapFlags
          and #~MapFlagRandomSpawn
          sta MapFlags
          jmp NoRePosition

NotCertainOfPositions:
          lda BitMask + 4, x    ; MapFlagSprite𝑥Moved
          ora MapFlags
          sta MapFlags          ; mark sprite as being moved (by warping, in this case)
          lda # 0
          sta SpriteX, x
          jmp ValidateMap.CheckSpriteSpawn ; tail call

NoRePosition:
          lda BitMask + 4, x   ; $10 … $80 = MapFlagSprite𝑥Moved

          bit MapFlags
          beq Bye               ; sprite did not move since last check?
          eor #$ff              ; invert to clear MapFlagSprite𝑥Moved
          and MapFlags
          sta MapFlags

          ldx SpriteFlicker
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
