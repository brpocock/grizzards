;;; Grizzards Source/Routines/MapSetup.s
;;; Copyright © 2021 Bruce-Robert Pocock

MapSetup: .block
          .WaitScreenTop

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
          jsr VSync
          .TimeLines KernelLines - 3
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
          ;; .y wraps, from 0 to max 25 when all 4 sprites are used
          lda (Pointer), y         ; .y = .x × 6 + 0
          ;; End of sprite list?
          beq SpritesDone
          iny
          sty Temp
          sta SpriteIndex, x
          cmp #$ff
          beq SpritePresent

          sty Temp
          tay
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

SpriteAbsent:
          lda Temp
          clc
          adc # 6
          tay
          jmp SetUpSprite

SpritePresent:
          ldx SpriteCount
          ldy Temp
          lda (Pointer), y
          cmp #SpriteFixed
          beq AddFixedSprite

          cmp #SpriteWander
          beq AddWanderingSprite

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
          lda # SpriteRandomEncounter
          sta SpriteMotion, x
          inc SpriteCount
          iny
          inx
          jmp SetUpSprite

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
          sta SpriteMotion, x
          inc SpriteCount
          iny                   ; .y = .x⁺¹ × 6   (start of next entry)
          ;; Go back looking for more sprites
          inx
          jmp SetUpSprite

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
          sta SpriteMotion, x
          inc SpriteCount
          iny                   ; .y = .x⁺¹ × 6   (start of next entry)
          ;; Go back looking for more sprites
          inx
          jmp SetUpSprite

SpritesDone:
;;; 
          sta CXCLR

          .WaitScreenBottom
          stx WSYNC

          ;; MUST be followed by Map directly

          .bend
