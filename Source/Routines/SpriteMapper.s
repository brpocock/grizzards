;;; Grizzards Source/Routines/SpriteMapper.s
;;; Copyright © 2022 Bruce-Robert Pocock

SpriteMapper:       .block
          ;; MAGIC — these addresses must be  known and must be the same
          ;; in every map bank.
          PlayerSprites = $f000
          MapSprites = (PlayerSprites + $0f)
          LeadingLines = 4

          EntryIntim = StringBuffer
          BusyLines = StringBuffer + 1

          DebugColors = true
;;; 
          lda P0LineCounter
          bmi PlayerOK

          cmp # 8 + LeadingLines              ; player is being drawn soon or now
          blt Leave

          ldx P1LineCounter
          bpl Leave

PlayerOK:
          ldx RunLength         ; going to have to change the playfield soon
          cpx # 1 + LeadingLines
          blt Leave

          stx WSYNC

          .if DebugColors
            lda # COLORANGE | $8
            sta COLUPF
          .fi

;;; 
          ldx SpriteFlicker
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

          .include "NextSprite.s"

          lda LineCounter
          sec
          adc # LeadingLines
          sta LineCounter

          lda RunLength
          sec
          sbc # LeadingLines
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
          .if DebugColors
            lda DebugColor, x
            sta COLUPF
            .SleepX 71 - 8 - 7
          .else
            .SleepX 71 - 8
          .fi
          stx HMOVE

Leave:
          stx WSYNC

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
