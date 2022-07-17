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
          ldx SpriteFlicker
          clv                   ; so the next branch is never taken
          
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
          .include "NextSprite.s"

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

          ldx CurrentProvince
          lda ProvinceMapBank, x ; 43 cycles

          ;; this duplicates  the Leave  routine below,  but part  of it
	;; happens before the HMOVE
          .if DebugColors != 0
            ldx SpriteFlicker
            lda DebugColor, x
            sta DebugColors     ; +11 cycles = 54 cycles
          .fi

          .if DebugColors != 0
            .SleepX 71 - 56
          .else
            .SleepX 71 - 45
          .fi

          tax                   ; after the SleepX

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
          .byte Province0MapBank, Province1MapBank, Province2MapBank

SpriteCxMask:
          .byte 1 << ((0,1,2,3 ) + 4)

          .if DebugColors != 0
DebugColor:
            .colu COLCYAN, $4
            .colu COLMAGENTA, $4
            .colu COLYELLOW, $4
            .colu COLGRAY, $4
            .colu COLRED, $4
          .fi

          .bend
