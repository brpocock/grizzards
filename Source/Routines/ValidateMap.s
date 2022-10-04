;;; Grizzards Source/Routines/ValidateMap.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

ValidateMap:        .block
          ;; Remove any Grizzard who is already a companion.
          ldx SpriteCount
CheckForGrizzard:
          dex
          bmi DoneCheckingGrizzards ; wrapped below 0

          lda SpriteAction, x
          cmp #SpriteGrizzard
          bne CheckForGrizzard

          lda SpriteParam, x
          sta Temp              ; SpriteParam, x
          txa                   ; sprite being validated
          pha                   ; sprite begin validated
          .FarJSR SaveKeyBank, ServicePeekGrizzard

          bcc DidNotCatchGrizzardYet

AlreadyCaughtGrizzard:
          pla                   ; sprite being validated
          pha                   ; sprite being validated
          tax                   ; sprite being validated

ShiftSpritesDownOne:
          lda SpriteIndex + 1, x
          sta SpriteIndex, x

          lda SpriteX + 1, x
          sta SpriteX, x

          lda SpriteY + 1, x
          sta SpriteY, x

          lda SpriteMotion + 1, x
          sta SpriteMotion, x

          lda SpriteAction + 1, x
          sta SpriteAction, x

          lda SpriteParam + 1, x
          sta SpriteParam, x

          inx
          cpx # 3
          blt ShiftSpritesDownOne

          dec SpriteCount

DidNotCatchGrizzardYet:
          pla                   ; sprite being validated
          tax                   ; sprite being validated

          jmp CheckForGrizzard
;;; 
DoneCheckingGrizzards:
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
          beq SpriteIsDoor

          and #$07
          cmp #SpriteProvinceDoor
          bne NotADoor

SpriteIsDoor:
          lda SpriteX, x
          sta PlayerX
          sta BlessedX

          lda SpriteY, x
          clc
          adc # 12
          sta PlayerY
          sta BlessedY

          gne DonePlacing

NotADoor:
          inx
          cpx SpriteCount
          bne CheckNextSpriteForDoor

DonePlacing:
          .mva GameMode, #ModeMap
;;; 
CheckForRandomSpawns:
          ldx SpriteCount
          beq Bye
          dex

CheckSpriteSpawn:
          lda SpriteMotion, x
          and #SpriteRandomEncounter
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

          lda BitMask + 4, x    ; MapFlagSprite𝑥Moved
          ora #MapFlagRandomSpawn
          ora MapFlags
          sta MapFlags

NextMayBeRandom:
          dex
          bpl CheckSpriteSpawn
;;; 
Bye:
          rts

          .bend

;;; Audited 2022-02-16 BRPocock
