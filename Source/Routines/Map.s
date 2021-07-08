;;; Grizzards Source/Routines/Map.s
;;; Copyright © 2021 Bruce-Robert Pocock
DoMap:    .block

          jsr Random
          and #$4f
          ora #$20
          sta BumpCooldown

          lda # 0
          sta DeltaX
          sta DeltaY
          sta CurrentMusic + 1

          lda BlessedX
          sta PlayerX
          lda BlessedY
          sta PlayerY

NewRoom:
          ;; Got to figure out the sprites
          ;; Start at the head of the sprite list
          lda #<MapSprites
          sta Pointer
          lda #>MapSprites
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
          cpx MapCount
          bpl BadMap

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
          ldx #0
          stx SpriteCount

SetUpSprite:
          ;; .y wraps, from 0 to max 25 when all 4 sprites are used
          lda (Pointer), y         ; .y = .x × 6 + 0
          ;; End of sprite list?
          beq SpritesDone
          iny
          sta SpriteIndex, x
          cmp #$ff
          beq SpritePresent

          tay
          and #$38
          ror a
          ror a
          ror a
          tax
          tya
          and #$07
          tay

          lda ProvinceFlags, x
          and BitMask, y
          beq SpritePresent

SpriteAbsent:
          iny
          iny
          iny
          iny
          iny
          jmp SetUpSprite

SpritePresent:
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

          sta CXCLR
          jsr Overscan
          jmp Loop

BadMap:
          brk

Loop:
          ldx #MapServicesBank
          ldy #ServiceTopOfScreen
          jsr FarCall

          ldx CurrentMap
          lda MapRLEL, x
          sta pp5l
          lda MapRLEH, x
          sta pp5h

          ldx SpriteCount
          beq NoSprites

          ldx SpriteFlicker
          lda #>SpriteArt
          sta pp1h
          clc
          lda SpriteAction, x
          and #$03
          asl a
          asl a
          asl a
          asl a
          adc #<SpriteArt
          bcc +
          inc pp1h
+
          sta pp1l
          lda ClockFrame
          and #$10
          bne AnimationFrame0

          lda pp1l
          clc
          adc # 8
          bcc +
          inc pp1h
+
          sta pp1l

          jmp AnimationFrameReady

AnimationFrame0:

AnimationFrameReady:
          sta WSYNC             ; stablize line count

          ldx SpriteFlicker
          lda SpriteAction, x
          and #$03
          tax
          lda SpriteColor, x
          sta COLUP1

          sta WSYNC

          ldx SpriteFlicker
          lda SpriteY, x
          sta P1LineCounter

          jmp P1Ready

NoSprites:
          lda #$ff
          sta P1LineCounter

P1Ready:
          lda PlayerY
          sta P0LineCounter

          lda #0
          sta PF1
          sta PF2

          lda ClockFrame
          and #$10
          clc
          ror a
          adc #<PlayerWalk1
          sta pp0l
          lda #>PlayerWalk1
          sta pp0h

          ldx CurrentMap
          lda MapColors, x
          and #$f0
          .if TV == SECAM
          ror a
          ror a
          ror a
          ror a
          .else
          ora #$01
          .fi
          sta COLUPF

          ;; Force a load of the next (first) run of map data
          ldy #1
          sty RunLength

          ldy #72               ; 72 × 2 lines = 144 lines total
          sty LineCounter

          ldx CurrentMap
          lda #ENABLED
          sta ENABL
          lda MapSides, x
          bmi LeftBall
          and #$40
          bne RightBall
          beq NoBalls           ; always taken

LeftBall:
          sta WSYNC
          sta RESBL
          lda # $20
          sta HMBL
          jmp DoneBall

RightBall:
          sta WSYNC
          .SleepX 69
          sta RESBL
          lda # 0
          sta HMBL
          jmp DoneBall

NoBalls:
          lda # 0
          sta ENABL
          sta WSYNC

DoneBall:
          stx WSYNC
          sta HMOVE

          lda MapColors, x
          and #$0f
          .if TV != SECAM
          asl a
          asl a
          asl a
          asl a
          ora #$0f
          .fi
          sta COLUBK

DrawMap:
          dec RunLength
          bne NoMapChange

          ldy #0
          lda (pp5l), y
          sta RunLength
          iny
          lda (pp5l), y
          sta WSYNC
          sta PF0
          iny
          lda (pp5l), y
          sta PF1
          iny
          lda (pp5l), y
          sta PF2
          clc
          lda pp5l
          adc #4
          bcc +
          inc pp5h
+
          sta pp5l
          ldy LineCounter
NoMapChange:
          sta WSYNC

          lda #7
          dcp P0LineCounter
          bcc NoP0
          ldy P0LineCounter
          lda (pp0l), y
          sta GRP0
          jmp P0Done
NoP0:
          lda #0
          sta GRP0
P0Done:

          lda #7
          dcp P1LineCounter
          bcc NoP1
          ldy P1LineCounter
          lda (pp1l), y
          sta GRP1
          jmp P1Done
NoP1:
          lda #0
          sta GRP1
P1Done:
          sta WSYNC
          dec LineCounter
          bne DrawMap

          ldy #ServiceBottomOfScreen
          ldx #MapServicesBank
          jsr FarCall

          cpy #$ff
          beq NewRoom

          lda PlayerY
          cmp #ScreenTopEdge
          bmi GoScreenUp
          cmp #ScreenBottomEdge
          bpl GoScreenDown

          lda PlayerX
          cmp #ScreenLeftEdge
          beq GoScreenLeft
          cmp #ScreenRightEdge
          beq GoScreenRight

          jmp CheckSwitches

GoScreenUp:
          lda #ScreenBottomEdge - 1
          sta BlessedY
          sta PlayerY
          ldy #0
          jmp GoScreen

GoScreenDown:
          lda #ScreenTopEdge + 1
          sta BlessedY
          sta PlayerY
          ldy #1
          jmp GoScreen

GoScreenLeft:
          lda #ScreenRightEdge - 1
          sta BlessedX
          sta PlayerX
          ldy #2
          jmp GoScreen

GoScreenRight:
          lda #ScreenLeftEdge + 1
          sta BlessedX
          sta PlayerX
          ldy #3
GoScreen:
          lda #>MapLinks
          sta pp3h
          clc
          lda CurrentMap
          rol a
          rol a
          adc #<MapLinks
          bcc +
          inc pp3h
+
          sta pp3l
          lda (pp3l), y
          sta CurrentMap
          lda #0
          sta DeltaX
          sta DeltaY

          jmp NewRoom

CheckSwitches:

          lda SWCHB
          cmp DebounceSWCHB
          beq SkipSwitches
          sta DebounceSWCHB
          and #SWCHBReset
          bne NoReset
          jmp GoQuit

NoReset:

          .if TV == SECAM

          lda DebounceSWCHB
          and #SWCHBP0Advanced
          sta Pause

          .else

          ;; TODO — 7800 Pause button support
          lda DebounceSWCHB
          and #SWCHBColor
          eor #SWCHBColor
          sta Pause

          .fi

SkipSwitches:

          lda GameMode
          cmp #ModeMap
          bne Leave
          jsr Overscan
          jmp Loop

Leave:
          ldx # 0
          stx CurrentMusic + 1

          cmp #ModeCombat
          beq GoCombat
          cmp #ModeGrizzardDepot
          beq EnterGrizzardDepot
          cmp #ModeNewGrizzard
          beq GetNewGrizzard
          cmp #ModeMapNewRoom
          beq NewRoom
          brk

EnterGrizzardDepot:
          ldy #ServiceGrizzardDepot
          ldx #TextBank
          jsr FarCall
          jmp DoMap

GetNewGrizzard:
          ldx SpriteFlicker
          lda SpriteParam, x
          sta Temp
          ldy #ServiceNewGrizzard
          ldx #MapServicesBank
          jsr FarCall
          jmp DoMap
          
          .bend
