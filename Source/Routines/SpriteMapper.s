;;; Grizzards Source/Routines/SpriteMapper.s
;;; Copyright © 2022 Bruce-Robert Pocock

SpriteMapper:       .block

          lda P0LineCounter
          bmi PlayerOK

          cmp # 10              ; player is being drawn soon or now
          blt Leave

          ldx P1LineCounter
          bpl Leave

PlayerOK:
          ldx RunLength         ; is RunLength at least 2?
          dex
          dex
          bmi Leave

          ldx SpriteFlicker
          ldy # 5
NextFlickerCandidate:
          inx
          cpx SpriteCount
          blt FlickerOK

          ldx # 0
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
          sbc # 15
          bcs P1HPos
          sta RESP1

          eor #$07
          .rept 4
            asl a
          .next
          sta HMP1

SetUpSprites:
          ;; DEBUG
          lda DebugColor, x
          sta COLUPF
          ;; DEBUG

          stx SpriteFlicker

          lda SpriteY, x
          sec
          sbc LineCounter
          sta P1LineCounter

          .Sleep 50

          .Sleep 65

          dec LineCounter
          dec P0LineCounter
          beq Leave
          dec LineCounter
          dec P0LineCounter

Leave:
          stx WSYNC

          ldx CurrentProvince
          lda ProvinceMapBank, x
          tax
Return:
          jmp ReturnFromSpriteMapperToMap

          .fill $100

DebugColor:
          .byte COLGREEN | $8
          .byte COLGRAY | $8
          .byte COLRED | $8
          .byte COLYELLOW | $8
ProvinceMapBank:
          .byte Province0MapBank, Province1MapBank, Province2MapBank

          .bend
