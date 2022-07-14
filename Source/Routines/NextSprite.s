;;; Grizzards Source/Routines/NextSprite.s
;;; Copyright © 2022 Bruce-Robert Pocock

          lda SpriteX, x
          clc
          adc # 8
          sec
          .page
          stx WSYNC
P1HPos:
          sbc # 15
          bcs P1HPos
          sta RESP1
          .endp

          eor #$07
          .rept 4
            asl a
          .next
          sta HMP1

SetUpSprites:
          ldx SpriteCount
          beq NoSprites

          ldx SpriteFlicker
          lda SpriteAction, x
          and #$07
          cmp # SpriteProvinceDoor
          bne +
          lda # SpriteDoor
+
          tax
          lda SpriteColor, x
          sta COLUP1

          ldx SpriteFlicker
          .mva pp1h, #>MapSprites
          clc
          lda MapFlags
          and # MapFlagRandomSpawn
          tay
          lda SpriteAction, x
          and #$07
          cmp # SpriteProvinceDoor
          bne +
          lda # SpriteDoor
+
          cpy # MapFlagRandomSpawn
          beq +                 ; keep poofs until stabilized
          ldy AlarmCountdown
          beq NoPuff            ; otherwise just for countdown time
+
          cmp #SpriteMajorCombat
          beq Puff

          cmp #SpriteCombat
          bne NoPuff

Puff:
          .mva COLUP1, SpriteColor + SpriteCombatPuff ; get color for poofs
          lda #SpriteCombatPuff
NoPuff:
          .rept 4
            asl a
          .next
          adc #<MapSprites
          bcc +
          inc pp1h
+
          sta pp1l
MaybeAnimate:
          bit SystemFlags
          bmi AnimationFrameReady

          lda SpriteAction, x
          cmp #SpriteCombat
          beq Flippy

          cmp #SpritePerson
          beq Flippy

          cmp #SpriteMajorCombat
          bne NoFlip

Flippy:
          lda ClockFrame
          and #$20
          beq SetFlip

          lda # REFLECTED
          gne SetFlip

NoFlip:
          lda # 0
SetFlip:
          sta REFP1

FindAnimationFrame:
          lda ClockFrame
          .BitBit $10
          bne AnimationFrameReady

          lda pp1l
          clc
          adc # 8
          bcc +
          inc pp1h
+
          sta pp1l

AnimationFrameReady:
