;;; Grizzards Source/Routines/MapTopService.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
TopOfScreenService: .block

          ;; MAGIC — these addresses must be  known and must be the same
	;; in every map bank.

          PlayerSprites = $f000
          MapSprites = PlayerSprites + 16

          jsr VSync
          .TimeLines 32
          .if NTSC != TV
          stx WSYNC
          .fi
          jsr Prepare48pxMobBlob

          .ldacolu COLGRAY, $f
          sta COLUP0
          sta COLUP1
          .ldacolu COLGRAY, 0
          sta COLUBK
;;; 
          lda Pause
          beq DrawScore
          .LoadString "PAUSED"
          gne ScoreDone

DrawScore:
          jsr DecodeScore

ScoreDone:
          .FarJSR TextBank, ServiceDecodeAndShowText
;;; 
AfterScore:
          lda #CTRLPFREF | CTRLPFBALLSZ8 | CTRLPFPFP
          sta CTRLPF

          lda #0
          sta VDELP0
          sta VDELP1
          sta NUSIZ0
          sta NUSIZ1

          ldx CurrentMap

          .ldacolu COLGOLD, $8
          ora BumpCooldown

          sta COLUP0

          sta HMCLR

          lda PlayerX
          sec
          stx WSYNC
P0HPos:
          sbc #15
          bcs P0HPos
          sta RESP0

          eor #$07
          asl a
          asl a
          asl a
          asl a
          sta HMP0

          lda MapFlags
          and #MapFlagFacing
          sta REFP0

          ldx SpriteCount
          beq NoSprites

          stx CXCLR
          ldx SpriteFlicker
          ldy # 5
NextFlickerCandidate:
          inx
          cpx SpriteCount
          blt FlickerOK
          ldx #0
FlickerOK:
          dey
          beq SetUpSprites
          lda SpriteMotion, x
          cmp # SpriteRandomEncounter
          beq NextFlickerCandidate
          stx SpriteFlicker

          lda SpriteX, x
          sec
          stx WSYNC
P1HPos:
          sbc #15
          bcs P1HPos
          sta RESP1

          eor #$07
          asl a
          asl a
          asl a
          asl a
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
          lda #>MapSprites
          sta pp1h
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
          beq +                 ; keep puffs until stabilized
          ldy AlarmCountdown
          beq NoPuff            ; otherwise just for countdown time
+
          cmp #SpriteMajorCombat
          beq Puff
          cmp #SpriteCombat
          bne NoPuff
Puff:
          lda SpriteColor + SpriteCombatPuff ; get color for puffs
          sta COLUP1
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
          lda Pause
          bne AnimationFrameReady
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
          lda # 0
          sta REFP1
          geq FindAnimationFrame

NoFlip:
          lda # REFLECTED
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
          ldx SpriteFlicker
          lda SpriteY, x
          sta P1LineCounter

          jmp P1Ready

NoSprites:
          lda #$ff
          sta P1LineCounter

P1Ready:
          lda PlayerY
          ldy NextMap
          cpy CurrentMap
          beq +
          ;; new screen being loaded: player is off the screen
          lda #$ff
+
          sta P0LineCounter
          lda #0
          sta PF1
          sta PF2

          lda #>PlayerSprites
          sta pp0h

          lda DeltaX
          ora DeltaY
          beq +        ; always show frame 0 unless moving
          lda ClockFrame
          and #$08
          bne +
          ldx #SoundFootstep
          stx NextSound
+
          clc
          adc #<PlayerSprites
          bcc +
          inc pp0h
+
          sta pp0l

TheEnd:
          .WaitForTimer
          rts

          .bend
