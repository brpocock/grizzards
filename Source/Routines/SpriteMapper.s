;;; Grizzards Source/Routines/SpriteMapper.s
;;; Copyright © 2022 Bruce-Robert Pocock

SpriteMapper:       .block
          ;; MAGIC — these addresses must be  known and must be the same
	;; in every map bank.
          PlayerSprites = $f000
          MapSprites = PlayerSprites + 16
          LeadingLines = 4
;;; 
          lda P0LineCounter
          bmi PlayerOK

          cmp # 8 + LeadingLines              ; player is being drawn soon or now
          blt Leave

          ldx P1LineCounter
          bpl Leave

PlayerOK:
          ldx RunLength         ; is RunLength at least 2?
          cpx # LeadingLines
          blt Leave

          lda # COLORANGE | $8
          sta COLUBK
;;; 
          .include "NextSprite.s"
;;; 
AnimationFrameReady:

          lda LineCounter
          sec
          sbc # LeadingLines
          bpl +
          lda # 1
+
          sta LineCounter

          lda RunLength
          sec
          sbc # LeadingLines
          sta RunLength

          lda P0LineCounter
          sec
          sbc # LeadingLines
          sta P0LineCounter

          ldx SpriteFlicker
          lda # 72
          sec
          sbc LineCounter
          sta Temp
          lda SpriteY, x
          sec
          sbc Temp
          bmi TryAgain

          cmp # 3
          blt TryAgain

          sta P1LineCounter
P1Ready:
          lda DebugColor, x
          sta COLUBK

Leave:
          stx WSYNC

          ldx CurrentProvince
          lda ProvinceMapBank, x
          tax
Return:
          jmp ReturnFromSpriteMapperToMap

;;; 
TryAgain:
          ldx SpriteFlicker
          lda DebugColor, x     ; COLRED
          sta COLUBK
          .mva P1LineCounter, # 0
          jmp GetOuttaHere

NoSprites:
          .mva COLUBK, # COLPURPLE | $8
          .mva P1LineCounter, #$ff
	
          lda LineCounter
          sec
          sbc # LeadingLines
          sta LineCounter

          lda P0LineCounter
          sec
          sbc # LeadingLines
          bmi TryAgain
          sta P0LineCounter

GetOuttaHere:
          ldx CurrentProvince
          lda ProvinceMapBank, x
          tax

          jmp ReturnFromSpriteMapperToMap

ProvinceMapBank:
          .byte Province0MapBank, Province1MapBank, Province2MapBank

DebugColor:
          .colu COLGREEN, $8
          .colu COLCYAN, $8
          .colu COLSPRINGGREEN, $8
          .colu COLBROWN, $8
          .bend
