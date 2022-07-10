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
;;; 
          lda P0LineCounter
          bmi PlayerOK

          cmp # 8 + LeadingLines              ; player is being drawn soon or now
          blt Leave

PlayerOK:
          ldx RunLength         ; going to have to change the playfield soon
          cpx # LeadingLines
          blt Leave

          ;; lda # COLORANGE | $8
          ;; sta COLUBK

          lda INTIM
          sta EntryIntim
;;; 
          ldx SpriteFlicker
          .include "NextSprite.s"
;;; 
AnimationFrameReady:
          lda EntryIntim
          sec
          sbc INTIM
          ;; 64/76 = 16/19
          .Div 19, BusyLines
          sta BusyLines

          lda LineCounter
          sec
          sbc BusyLines
          bpl +
          lda # 1
+
          sta LineCounter

          lda RunLength
          sec
          sbc BusyLines
          sta RunLength

          lda P0LineCounter
          sec
          sbc BusyLines
          sta P0LineCounter

          ldx SpriteFlicker
          lda # 72
          sec
          sbc LineCounter
          sta Temp
          lda SpriteY, x
          sec
          sbc Temp
          sta P1LineCounter
P1Ready:
          ;; lda DebugColor, x
          ;; sta COLUBK

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
          ;; lda # COLRED | $8
          ;; sta COLUBK
          .mva P1LineCounter, # 0
          jmp GetOuttaHere

NoSprites:
          ;; inx
          ;; lda DebugColor, x
          ;; ora #$0f
          ;; sta COLUBK
          .mva P1LineCounter, # 72

          dec LineCounter
          dec RunLength
          dec P0LineCounter

GetOuttaHere:
          ldx CurrentProvince
          lda ProvinceMapBank, x
          tax

          jmp ReturnFromSpriteMapperToMap

ProvinceMapBank:
          .byte Province0MapBank, Province1MapBank, Province2MapBank

DebugColor:
          .colu COLCYAN, $8
          .colu COLMAGENTA, $8
          .colu COLYELLOW, $8
          .colu COLGRAY, $8
          .bend
