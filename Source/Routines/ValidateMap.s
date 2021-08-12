;;; Grizzards Source/Routines/ValidateMap.s
;;; Copyright © 2021 Bruce-Robert Pocock

ValidateMap:        .block
          ;; Remove any Grizzard who is already a companion.
          ;; New Grizzards must be the last sprite on the list for a room.
          ldx SpriteCount
          dex

          lda SpriteAction, x
          cmp #SpriteGrizzard
          bne +

          lda SpriteParam, x
          sta Temp
          .FarJSR SaveKeyBank, ServicePeekGrizzard
          bcc +                 ; Grizzard not found
          dec SpriteCount
+
;;; 
          lda GameMode
          cmp #ModeMapNewRoomDoor
          bne DonePlacing
PlacePlayerUnderDoor:
          ldx SpriteCount
          beq DonePlacing

          ldx #0
CheckNextSpriteForDoor:
          lda SpriteAction, x
          cmp #SpriteDoor
          bne NotADoor

          lda SpriteX, x
          sta PlayerX
          sta BlessedX

          lda SpriteY, x
          clc
          adc #12
          sta PlayerY
          sta BlessedY

          bne DonePlacing       ; always taken

NotADoor:
          inx
          cmp SpriteCount
          bne CheckNextSpriteForDoor
DonePlacing:
;;; 
CheckForRandomSpawns:
          ldx SpriteCount
          beq Bye
          dex
CheckSpriteSpawn:
          lda SpriteMotion, x
          .BitBit SpriteRandomEncounter
          bne NextMayBeRandom

          lda SpriteX, x
          bne NextMayBeRandom

RandomX:
          jsr Random
          cmp #ScreenLeftEdge
          blt RandomX
          cmp #ScreenRightEdge
          bge RandomX
          sta SpriteX, x

RandomY:
          jsr Random
          and #$3f
          adc #ScreenTopEdge    ; who cares what Carry says, it'll fit either way
          sta SpriteY, x

          lda MapFlags
          ora #MapFlagRandomSpawn
          sta MapFlags

NextMayBeRandom:
          dex
          bpl CheckSpriteSpawn
;;; 
Bye:
          rts
          .bend
