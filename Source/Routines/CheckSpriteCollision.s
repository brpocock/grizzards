;;; Grizzards Source/Routines/CheckSpriteCollision.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CheckSpriteCollision:         .block
          lda CXP1FB
          and #$c0           ; collision with playfield or ball
          beq Bye

          ldx SpriteFlicker

          lda MapFlags
          .BitBit MapFlagRandomSpawn
          bne NoRePosition
          lda AlarmCountdown
          bne NoRePosition
          lda # 0
          sta SpriteX, x
          jsr ValidateMap.CheckSpriteSpawn
          jmp Bye

NoRePosition
          lda BitMask + 4, x   ; $10 … $80 = MapFlagSprite𝑥Moved

          bit MapFlags
          beq Bye               ; sprite did not move since last check?
          eor #$ff
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
