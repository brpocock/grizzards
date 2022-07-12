;;; Grizzards Source/Routines/CheckSpriteCollision.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CheckSpriteCollision:         .block
          lda DrawnSprites
          and #$f0
          bne PriorCollision

          bit CXP1FB
          bmi CurrentCollision
          bvc NoCollision

CurrentCollision:
          ldx SpriteFlicker
          jmp CollisionHasOccurred

PriorCollision:
          ;; Tricky, BIT already tests bits 7 & 6 for us, so
          ;; we ask it to test bit 5 as well, and since we
          ;; know precisely one of those four bits must have
          ;; been set, if none of those flags are set, it was
          ;; bit 4.
          lda #$20
          bit DrawnSprites
          bmi Cx4
          bvs Cx3
          beq Cx2
Cx1:
          ldx # 0
          gne CollisionHasOccurred

Cx4:
          ldx # 3
          gne CollisionHasOccurred

Cx3:
          ldx # 2
          gne CollisionHasOccurred

Cx2:
          ldx # 1
          gne CollisionHasOccurred

NoCollision:
          lda MapFlags
          and InvertedBitMask + 4, x ; MapFlagSprite𝑥Moved
          sta MapFlags
          and #~MapFlagFacing
          cmp #MapFlagRandomSpawn
          beq EndRandomSpawn

          ;; This sprite has moved, so clear its bit (above)
          ;; and get out (because no collision)
          rts

EndRandomSpawn:
          ;; Make sure the timer has run out.
          ;; Else we may not have drawn the screen at all yet.
          ;; This delay is overkill, but it works.
          ;; (we only really need 1-4 frames)
          lda AlarmCountdown
          bne Return

          ;; Don't exit spawn mode if paused
          bit SystemFlags
          bmi Return

          ;; Every sprite has been checked at least once,
          ;; and has not had to be repositioned, so we must
          ;; be OK to exit "poof" mode.
          lda MapFlags
          and #~MapFlagRandomSpawn
          sta MapFlags
Return:
          rts
;;; 
CollisionHasOccurred:
          ;; If we are still in random spawn "poof" mode, we can
          ;; (should) just randomly reposition the sprite, it
          ;; probably materialized inside a wall or something.
          lda MapFlags
          .BitBit MapFlagRandomSpawn
          beq NoRePosition    ; Not in RandomSpawn mode

NotCertainOfPositions:
          ;; We are still in Random Spawn interval, and this
          ;; sprite had a collision; write a zero location to it
          ;; and jump back to ValidateMap to pick a new
          ;; random position that hopefull won't collide.
          lda # 0
          sta SpriteX, x
          geq ValidateMap.CheckSpriteSpawn ; tail call

NoRePosition:
          ;; We are not in random spawn "poof" mode
          ;; We can't just reposition sprites any more
          ;; They must have moved to where they got stuck
          ;; If they didn't move, we're S-O-L.
          lda SpriteMotion, x
          beq Bye

CheckLeft:
          .BitBit SpriteMoveLeft
          beq CheckRight

          inc SpriteX, x
          inc SpriteX, x
          gne InvertHorizontal

CheckRight:
          .BitBit SpriteMoveRight
          beq CheckUp

          dec SpriteX, x
          dec SpriteX, x
InvertHorizontal:
          eor # SpriteMoveLeft | SpriteMoveRight

CheckUp:
          .BitBit SpriteMoveUp
          beq CheckDown

          inc SpriteY, x
          inc SpriteY, x
          gne InvertVertical

CheckDown:
          .BitBit SpriteMoveDown
          beq Done

          dec SpriteY, x
          dec SpriteY, x
InvertVertical:
          eor # SpriteMoveUp | SpriteMoveDown

Done:
          sta SpriteMotion, x
Bye:
          rts

InvertedBitMask:
          .byte ~$01, ~$02, ~$04, ~$08, ~$10, ~$20, ~$40, ~$80

          .bend

