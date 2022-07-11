;;; Grizzards Source/Routines/CheckPlayerCollision.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CheckPlayerCollision:         .block
          lda CXP0FB
          and #$c0              ; hit playfield or ball
          beq NoBumpWall

          jmp BumpWall          ; tail call
;;; 
NoBumpWall:
          bit CXPPMM
          bpl PlayerMoveOK         ; did not hit

BumpSprite:
;;; 
FindBumpedSprite:
          ldy # 0
FindBumpedSpriteLoop:
          lda BitMask, y
          and DrawnSprites
          beq ScanNextSprite

          lda SpriteY, y
          clc
          adc # 8
          cmp PlayerY
          blt ScanNextSprite

          lda PlayerY
          clc
          adc # 8
          cmp SpriteY, y
          blt ScanNextSprite

          sty SpriteFlicker

          jsr BumpWall

          .FarJMP MonsterBank, ServiceSpriteCollision

ScanNextSprite:
          iny
          cpy # 4
          blt FindBumpedSpriteLoop
;;; 
BumpWall:
          sta CXCLR

          lda BlessedX
          cmp PlayerX
          beq NeedsXShove

          sta PlayerX
          gne BumpY

NeedsXShove:
          lda DeltaX
          bne ShoveX

          jsr Random

          and # 1
          beq ShoveX

          lda #-1
ShoveX:
          sta DeltaX
          clc
          adc PlayerX
          sta PlayerX
BumpY:
          lda BlessedY
          cmp PlayerY
          beq NeedsYShove

          sta PlayerY
          jmp DoneBump

NeedsYShove:
          lda DeltaY
          bne ShoveY

          jsr Random

          and # 1
          beq ShoveY

          lda #-1
ShoveY:
          sta DeltaY
          clc
          adc PlayerY
          sta PlayerY

          ldy # 0               ; XXX necessary?
          sty PlayerXFraction
          sty PlayerYFraction
          
DoneBump:
          .mva NextSound, #SoundBump

          rts

PlayerMoveOK:
          lda BumpCooldown
          beq Cool

          dec BumpCooldown
Cool:
          lda ClockFrame
          and #$03
          bne DonePlayerMove

          .mva BlessedX, PlayerX
          .mva BlessedY, PlayerY
DonePlayerMove:
          rts
          .bend
