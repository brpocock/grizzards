;;; Grizzards Source/Routines/NextSprite.s
;;; Copyright © 2022 Bruce-Robert Pocock

          ldy # 5
NextFlickerCandidate:
          inx

          cpx SpriteFlicker
          beq NoSprites

          cpx SpriteCount
          blt FlickerOK

          ldx # 0
FlickerOK:
          dey
          beq NoSprites

          lda SpriteMotion, x
          cmp # SpriteRandomEncounter
          beq NextFlickerCandidate

          .if SpriteMapperBank == BANK

            ;; if we're already too late to draw it, don't select it
            lda SpriteY, x
            sbc # 8             ; it's OK if the carry bit fucks this up a line
            cmp LineCounter
            bge NextFlickerCandidate
          .fi

          stx SpriteFlicker

          lda SpriteX, x
          sec
          stx WSYNC
P1HPos:
          sbc # 15
          bcs P1HPos
          sta RESP1

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
          and #MapFlagRandomSpawn
          tay
          lda SpriteAction, x
          and #$07
          cmp # SpriteProvinceDoor
          bne +
          lda # SpriteDoor
+
          cpy #MapFlagRandomSpawn
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
          bne FindAnimationFrame

Flippy:
          lda ClockFrame
          .BitBit $20
          bne NoFlip

          .mva REFP1, # 0
          geq FindAnimationFrame

NoFlip:
          .mva REFP1, # REFLECTED

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
