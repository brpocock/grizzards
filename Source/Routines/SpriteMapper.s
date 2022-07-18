;;; Grizzards Source/Routines/SpriteMapper.s
;;; Copyright © 2022 Bruce-Robert Pocock

SpriteMapper:       .block
          ;; MAGIC — these addresses must be  known and must be the same
          ;; in every map bank.
          PlayerSprites = $f000
          MapSprites = (PlayerSprites + $0f)

          ;; Tunables for this file
          LeadingLines = 3
          DebugColors = 0
          DebugVerbose = true
;;; 
Leaving:
          jmp Leave
;;; 
Entry:

          .if DebugColors != 0 && DebugVerbose
            lda # COLBLUE | $f
            sta DebugColors
          .fi

          lda MapFlags
          and #MapFlagRandomSpawn
          bne Leaving

          lda P0LineCounter
          sbc # 8 + LeadingLines              ; player is being drawn soon or now
          blt Leaving

PlayerOK:
          .if DebugColors != 0
            lda # COLORANGE | $8
            sta DebugColors
          .fi

          ldx RunLength         ; going to have to change the playfield soon
          cpx # 1 + LeadingLines
          blt Leaving

;;; 
CheckPriorP1:
          ldx SpriteFlicker

          lda BitMask, x
          ora DrawnSprites
          sta DrawnSprites

          and #$f0              ; already seen a collision?
          bne FindFlickerCandidate

          bit CXP1FB
          bpl NoPFCollision
Collision:
          lda SpriteCxMask, x
          ora DrawnSprites
          sta DrawnSprites
          .byte $0c             ; NOP (4 cycles, 3 bytes)
          
NoPFCollision:
          bvs Collision
;;; 
FindFlickerCandidate:
          nop
 
          ldy SpriteCount
NextFlickerCandidate:
          inx
NextFlickerCandidateTry:
          cpx SpriteCount
          blt FlickerOK

          dex                   ; = SpriteFlicker value now
FlickerOK:
          dey
          beq NoSpritesButWait

          lda SpriteMotion, x
          cmp # SpriteRandomEncounter
          beq NextFlickerCandidate

          ;; if we're already too late to draw it, don't count it
          lda LineCounter
          adc # 8 + LeadingLines
          cmp SpriteY, x
          bge NextFlickerCandidate

          stx SpriteFlicker
          lda BitMask, x
          ora DrawnSprites
          sta DrawnSprites

MarkedDrawn:
          lda SpriteX, x
          clc
          adc # 8
          sec

          .page
          stx WSYNC
P1HPos:
          sbc # 15
          bcs P1HPos

          stx RESP1
          .endp

          eor #$07
          tay
          lda Ash4, y
          sta HMP1

SetUpSprites:
          lda SpriteAction, x
          and #$07
          tay
          cpy # SpriteProvinceDoor
          bne +
          ldy # SpriteDoor
+
          lda SpriteColor, y
          sta COLUP1

          .mva pp1h, #>MapSprites

NoPuff:
          lda Ash4, y   ; Y = sprite action
          clc
          adc #<MapSprites
          sta pp1l              ; will not cross page boundary
MaybeAnimate:
          bit SystemFlags
          bmi WaitAndAnimationFrameReady

          cpy #SpriteCombat     ; Y = sprite action
          beq Flippy

          cpy #SpritePerson
          beq Flippy

          cpy #SpriteMajorCombat
          bne NoFlip

Flippy:
          lda ClockFrame
          and #$20
          beq SetFlip

          lda #REFLECTED
          gne SetFlip

NoFlip:
          lda # 0
SetFlip:
          sta REFP1

FindAnimationFrame:
          lda ClockFrame
          and #$10
          bne AnimationFrameReady

          lda pp1l
          clc
          adc # 8
          sta pp1l              ; will not cross page boundary

WaitAndAnimationFrameReady:

AnimationFrameReady:

          ;; X = SpriteFlicker at this point
          lda SpriteY, x
          sec
          sbc LineCounter
          sta P1LineCounter

P1Ready:
          stx WSYNC
          lda #$80
          sta HMP0              ; Don't reposition P0 & BL
          sta HMBL              ; 8 cycles

          lda LineCounter
          clc
          adc # LeadingLines
          sta LineCounter       ; 18 cycles

          lda RunLength
          sec
          sbc # LeadingLines
          sta RunLength         ; 28 cycles

          lda P0LineCounter
          sbc # LeadingLines
          sta P0LineCounter     ; 36 cycles

          ;; this duplicates  the Leave  routine below,  but part  of it
	;; happens before the HMOVE
          .if DebugColors != 0
            ldx SpriteFlicker
            lda DebugColor, x
            sta DebugColors     ; +11 cycles
          .fi

          .if DebugColors != 0
            .SleepX 71 - 45 - 11
          .else
            .SleepX 71 - 45
          .fi

          ;; keep this after DebugColors and SleepX
          ldx CurrentProvince
          lda ProvinceMapBank, x
          tax                   ; 45 cycles, ignoring the SleepX

          stx HMOVE             ; Cycle 74 HMOVE

          jmp ReturnFromSpriteMapperToMap

;;; 
NoSpritesButWait:
          stx WSYNC

NoSprites:
          .mva P1LineCounter, #$7f

LeaveLate:
          inc LineCounter
          dec RunLength
          dec P0LineCounter

Leave:
          .if DebugColors != 0
            ldx SpriteFlicker
            lda DebugColor, x
            sta DebugColors
          .fi

          ldx CurrentProvince
          lda ProvinceMapBank, x
          tax
Return:
          jmp ReturnFromSpriteMapperToMap

;;; 
          ;; Data tables

ProvinceMapBank:
          .page
          .byte Province0MapBank, Province1MapBank, Province2MapBank
          .endp

SpriteCxMask:
          .page
          .byte 1 << ((0,1,2,3) + 4)
          .endp

Ash4:
          .page
          .byte range(0, $f) << 4
          .endp
          
          .if DebugColors != 0
DebugColor:
            .colu COLCYAN, $4
            .colu COLMAGENTA, $4
            .colu COLYELLOW, $4
            .colu COLGRAY, $4
            .colu COLRED, $4
          .fi

          .bend
