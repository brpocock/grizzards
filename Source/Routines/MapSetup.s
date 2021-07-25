;;; Grizzards Source/Routines/MapSetup.s
;;; Copyright © 2021 Bruce-Robert Pocock

MapSetup: .block
          .WaitScreenTopMinus 3, 0

          jsr Random
          and #$4f
          ora #$20
          sta BumpCooldown

          lda # 0
          sta SpriteFlicker
          sta SpriteCount
          sta DeltaX
          sta DeltaY
          sta CurrentMusic + 1

          lda BlessedX
          sta PlayerX
          lda BlessedY
          sta PlayerY
          jmp NewRoomTimerRunning
;;; 
NewRoom:
          .WaitForTimer
          stx WSYNC
          stx WSYNC
          jsr Overscan
          .WaitScreenTopMinus 3, 0
          
NewRoomTimerRunning:
          ;; Got to figure out the sprites
          ;; Start at the head of the sprite list
          lda #<SpriteList
          sta Pointer
          lda #>SpriteList
          sta Pointer + 1
          lda #ModeMap
          sta GameMode

          ldy #0
FindSprites:
          ;; Get the map index
          ldx CurrentMap

          ;; If it was zero, our work here is done.
          beq DoneFinding

          ;; Crash early if the map ID is out of range for this province (bank)
          cpx #MapCount
          blt SkipRoom
BadMap:
          brk

          ;; Skipping over a room means searching for the end of the list
SkipRoom:
          lda (Pointer), y         ; .y = 0
          ;; End of list? Then one room down, .x more to go
          beq SkipRoomDone
          ;; Not end of list, so we have to skip 6 bytes
          lda Pointer
          clc
          adc #6
          bcc +
          inc Pointer + 1
+
          sta Pointer
          ;; Then keep going, look for end of the room's list
          jmp SkipRoom

SkipRoomDone:
          ;; We've reached the end of one room
          dex
          ;; Are we done? Then the next entry is this room
          beq FoundSprites
          ;; Not done yet — skip a/more room[s]
          lda Pointer
          clc
          adc # 1
          bcc +
          inc Pointer + 1
+
          sta Pointer
          jmp SkipRoom

          ;; OK, we found "our" sprite list head at (Pointer) + 1
FoundSprites:
          lda Pointer
          clc
          adc #1
          bcc +
          inc Pointer + 1
+
          sta Pointer

DoneFinding:
          ;; Start with 0 sprites
          ;; There can be up to 4
          ldx #0                ; XXX this is probably already the case
          stx SpriteCount

SetUpSprite:
          ;; .y varies from 0 to max 25 when all 4 sprites are used
          lda (Pointer), y         ; .y = .x × 6 + 0
          ;; End of sprite list?
          beq SpritesDone
          iny
          sty Temp
          sta SpriteIndex, x
          cmp #$ff
          beq SpritePresentAndYSet

          tay                   ; has the combat been conquered?
          and #$38
          ror a
          ror a
          ror a
          stx SpriteCount
          tax
          tya
          and #$07
          tay

          lda ProvinceFlags, x
          ldx SpriteCount
          and BitMask, y
          beq SpritePresent
          ;; fall through
SpriteAbsent:
          lda Temp
          clc
          adc # 5               ; already been incremented once
          tay
          bne SetUpSprite       ; always taken

MoreSprites:
          sta SpriteMotion, x
          iny
          inc SpriteCount
          inx
          bne SetUpSprite       ; always taken

SpritePresent:
          ldy Temp
SpritePresentAndYSet:
          lda (Pointer), y
          cmp #SpriteFixed
          beq AddFixedSprite
          cmp #SpriteWander
          beq AddWanderingSprite
          ;; fall through
AddRandomEncounter:
          iny
          lda (Pointer), y
          sta SpriteX, x
          iny
          lda (Pointer), y
          ora #$80              ; ensure position off screen
          sta SpriteY, x
          iny
          lda (Pointer), y
          sta SpriteAction, x
          iny
          lda (Pointer), y         ; .y = .x × 6 + 5
          sta SpriteParam, x
          lda # SpriteRandomEncounter
          bne MoreSprites       ; always taken

AddFixedSprite:
          iny
          lda (Pointer), y         ; .y = .x × 6 + 2
          sta SpriteX, x
          iny
          lda (Pointer), y         ; .y = .x × 6 + 3
          sta SpriteY, x
          iny
          lda (Pointer), y         ; .y = .x × 6 + 4
          sta SpriteAction, x
          iny
          lda (Pointer), y         ; .y = .x × 6 + 5
          sta SpriteParam, x
          lda # 0
          ;; .y = .x⁺¹ × 6   (start of next entry)
          ;; Go back looking for more sprites
          beq MoreSprites       ; always taken

AddWanderingSprite:
          ;; TODO: merge this with the fixed sprite code
          iny
          lda (Pointer), y         ; .y = .x × 6 + 2
          sta SpriteX, x
          iny
          lda (Pointer), y         ; .y = .x × 6 + 3
          sta SpriteY, x
          iny
          lda (Pointer), y         ; .y = .x × 6 + 4
          sta SpriteAction, x
          iny
          lda (Pointer), y         ; .y = .x × 6 + 5
          sta SpriteParam, x
          lda # SpriteMoveIdle
          ;; .y = .x⁺¹ × 6   (start of next entry)
          ;; Go back looking for more sprites
          bne MoreSprites                 ; always taken

SpritesDone:
;;; 
          sta CXCLR

          .WaitScreenBottom
          stx WSYNC
          stx WSYNC

          ;; fall through to Map
          .bend
