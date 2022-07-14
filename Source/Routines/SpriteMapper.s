;;; Grizzards Source/Routines/SpriteMapper.s
;;; Copyright © 2022 Bruce-Robert Pocock

SpriteMapper:       .block
          ;; MAGIC — these addresses must be  known and must be the same
          ;; in every map bank.
          PlayerSprites = $f000
          MapSprites = (PlayerSprites + $0f)

          ;; Tunables for this file
          LeadingLines = 7
          DebugColors = false 
          DebugVerbose = false
;;; 
          .if DebugColors && DebugVerbose
            lda # COLBLUE | $f
            sta DebugColors
          .fi

          lda MapFlags
          and #MapFlagRandomSpawn
          bne Leave

          lda P0LineCounter
          bmi PlayerOK

          cmp # 8 + LeadingLines              ; player is being drawn soon or now
          blt Leave

PlayerOK:
          .if DebugColors
            lda # COLORANGE | $8
            sta DebugColors
          .fi

          ldx RunLength         ; going to have to change the playfield soon
          cpx # 2 + LeadingLines
          blt Leave

;;; 
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

FindFlickerCandidate:
          stx WSYNC
          inc LineCounter
          dec RunLength
          dec P0LineCounter

          ldy SpriteCount
          iny
NextFlickerCandidate:
          inx
NextFlickerCandidateTry:
          cpx SpriteCount
          blt FlickerOK

          ldx # 0
FlickerOK:
          dey
          beq NoSprites

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
          sec
          adc # LeadingLines - 1
          sta LineCounter       ; 21 cycles

          lda RunLength
          sec
          sbc # LeadingLines - 1
          sta RunLength         ; 34 cycles

          lda P0LineCounter
          sec
          sbc # LeadingLines - 1
          sta P0LineCounter     ; 47 cycles

          .SleepX 71 - 47

          stx HMOVE             ; Cycle 74 HMOVE

Leave:
          .if DebugColors
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
NoSprites:
          .if DebugColors
            lda DebugColor + 4
            ora #$0f
            sta DebugColors
          .fi
          .mva P1LineCounter, #$7f

LeaveLate:
          inc LineCounter
          dec RunLength
          dec P0LineCounter
          jmp Leave

;;; 
          ;; Data tables

ProvinceMapBank:
          .byte Province0MapBank, Province1MapBank, Province2MapBank

          .if DebugColors
DebugColor:
            .colu COLCYAN, $4
            .colu COLMAGENTA, $4
            .colu COLYELLOW, $4
            .colu COLGRAY, $4
            .colu COLRED, $4
          .fi

SpriteCxMask:
          .byte $10, $20, $40, $80

          .bend
