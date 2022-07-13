;;; Grizzards Source/Routines/SpriteMapper.s
;;; Copyright © 2022 Bruce-Robert Pocock

SpriteMapper:       .block
          ;; MAGIC — these addresses must be  known and must be the same
          ;; in every map bank.
          PlayerSprites = $f000
          MapSprites = (PlayerSprites + $0f)

          ;; Tunables for this file
          LeadingLines = 4
          DebugColors = true
;;; 
          lda MapFlags
          and #MapFlagRandomSpawn
          bne LeaveFast

          ldx RunLength         ; going to have to change the playfield soon
          cpx # 2 + LeadingLines
          blt LeaveFast

          lda P0LineCounter
          bmi PlayerOK

          cmp # 8 + LeadingLines              ; player is being drawn soon or now
          blt LeaveFast

PlayerOK:
          ldx P1LineCounter
          bpl LeaveFast

          .if DebugColors
            lda # COLORANGE | $8
            sta COLUPF
          .fi

          stx WSYNC

;;; 
          ldx SpriteFlicker

          lda BitMask, x
          ora DrawnSprites
          sta DrawnSprites

          and #$f0
          bne FindFlickerCandidate

          bit CXP1FB
          bpl NoPFCollision
Collision:
          inx
          inx
          inx
          inx
          lda BitMask, x
          ora DrawnSprites
          sta DrawnSprites
          gne FindFlickerCandidate 
          
NoPFCollision:
          bvs Collision

FindFlickerCandidate:
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

          ;; if we're already too late to draw it, don't select it
          lda LineCounter
          adc # 8 + LeadingLines     ; who cares if Carry fucks it up here
          cmp SpriteY, x
          bge NextFlickerCandidate

          stx SpriteFlicker
          lda BitMask, x
          ora DrawnSprites
          sta DrawnSprites

          .include "NextSprite.s"

          lda LineCounter
          sec
          adc # LeadingLines
          sta LineCounter

          lda RunLength
          sec
          sbc # LeadingLines + 1
          sta RunLength

          lda P0LineCounter
          sec
          sbc # LeadingLines
          sta P0LineCounter

          ;; X = SpriteFlicker at this point
          sec
          lda SpriteY, x
          sbc LineCounter
          sta P1LineCounter
P1Ready:
          stx WSYNC
          lda #$80
          sta HMP0              ; Don't reposition P0
          sta HMBL
          .SleepX 71 - 8
          stx HMOVE
          .if DebugColors
            lda DebugColor, x
            sta COLUPF
          .fi

Leave:
          stx WSYNC
LeaveFast:
          ldx CurrentProvince
          lda ProvinceMapBank, x
          tax
Return:
          jmp ReturnFromSpriteMapperToMap

;;; 
NoSprites:
          .if DebugColors
            inx
            lda DebugColor, x
            ora #$0f
            sta COLUPF
          .fi
          .mva P1LineCounter, #$7f

          inc LineCounter
          inc LineCounter
          dec RunLength
          dec RunLength
          dec P0LineCounter
          dec P0LineCounter
          stx WSYNC

GetOuttaHere:
          ldx CurrentProvince
          lda ProvinceMapBank, x
          tax

          jmp ReturnFromSpriteMapperToMap

ProvinceMapBank:
          .byte Province0MapBank, Province1MapBank, Province2MapBank

          .if DebugColors
DebugColor:
            .colu COLCYAN, $4
            .colu COLMAGENTA, $4
            .colu COLYELLOW, $4
            .colu COLGRAY, $4
          .fi

          .bend
