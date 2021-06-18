DoMap:    .block

          ScreenLeftEdge = 48
          ScreenRightEdge = 200

          lda # 30
          sta BumpCooldown

          lda # 0
          sta DeltaX
          sta DeltaY

NewRoom:
          ;; Got to figure out the sprites
          ;; Start at the head of the sprite list
          lda #<MapSprites
          sta pp2l
          lda #>MapSprites
          sta pp2h

          ldy #0
FindSprites:
          ;; Get the map index
          ldx CurrentMap
          ;; If it was zero, our work here is done.
          beq DoneFinding

          ;; Skipping over a room means searching for the end of the list
SkipRoom:
          lda (pp2l), y         ; .y = 0
          ;; End of list? Then one room down, .x more to go
          beq SkipRoomDone
          ;; Not end of list, so we have to skip 6 bytes
          lda pp2l
          clc
          adc #6
          bcc +
          inc pp2h
+
          sta pp2l
          ;; Then keep going, look for end of the room's list
          jmp SkipRoom

SkipRoomDone:
          ;; We've reached the end of one room
          dex
          ;; Are we done? Then the next entry is this room
          beq FoundSprites
          ;; Not done yet — skip a/more room[s]
          lda pp2l
          clc
          adc # 1
          bcc +
          inc pp2h
+
          sta pp2l
          jmp SkipRoom

          ;; OK, we found "our" sprite list head at pp2l + 1
FoundSprites:
          lda pp2l
          clc
          adc #1
          bcc +
          inc pp2h
+
          sta pp2l

DoneFinding:
          ;; Start with 0 sprites
          ;; There can be up to 4
          ldx #0
          stx SpriteCount

SetUpSprite:
          ;; .y wraps, from 0 to max 25 when all 4 sprites are used
          lda (pp2l), y         ; .y = .x × 6 + 0
          ;; End of sprite list?
          beq SpritesDone

          cmp #SpriteFixed
          beq AddFixedSprite

          cmp #SpriteWander
          beq AddWanderingSprite
          
          ;; TODO other kinds of sprites
          brk

AddFixedSprite:
          iny
          lda (pp2l), y         ; .y = .x × 6 + 1
          sta SpriteIndex, x
          iny
          lda (pp2l), y         ; .y = .x × 6 + 2
          sta SpriteX, x
          iny
          lda (pp2l), y         ; .y = .x × 6 + 3
          sta SpriteY, x
          iny
          lda (pp2l), y         ; .y = .x × 6 + 4
          sta SpriteAction, x
          iny
          lda (pp2l), y         ; .y = .x × 6 + 5
          sta SpriteParam, x
          inc SpriteCount
          iny                   ; .y = .x⁺¹ × 6   (start of next entry)
          ;; Go back looking for more sprites
          inx
          jmp SetUpSprite

AddWanderingSprite:
          ;; TODO Add wandering sprite

          tya
          clc
          adc #6
          tay
          jmp SetUpSprite

SpritesDone:

          sta CXCLR
          jmp Loop

BadMap:
          brk

Loop:
          ldx #MapServicesBank
          ldy #0
          jsr FarCall

          ldx CurrentMap
          lda MapRLEL, x
          sta pp5l
          lda MapRLEH, x
          sta pp5h

          ldx SpriteCount
          beq NoSprites

          lda #>SpriteArt
          sta pp1h
          clc
          lda SpriteIndex, x
          rol a
          rol a
          rol a
          rol a
          adc #<SpriteArt
          bcc +
          inc pp1h
+
          sta pp1l
          lda ClockFrame
          and #$10
          bne AnimationFrameReady

          lda pp1l
          clc
          adc # 8
          bcc +
          inc pp1h
+
          sta pp1l

AnimationFrameReady:

          lda SpriteIndex, x
          tax
          lda SpriteColor, x
          sta COLUP1

          sta WSYNC

          lda SpriteY, x
          sta P1LineCounter

          jmp P1Ready

NoSprites:
          ;; TODO NoSprites

P1Ready:

          stx WSYNC

          lda PlayerY
          sta P0LineCounter

          stx WSYNC

          lda #0
          sta PF1
          sta PF2

          sta WSYNC

          lda ClockFrame
          and #$10
          clc
          ror a
          adc #<PlayerWalk1
          sta pp0l
          lda #>PlayerWalk1
          sta pp0h

          sta WSYNC
          ldx CurrentMap

          cpx MapCount
          bpl BadMap

          lda MapFG, x
          sta COLUPF

          ;; Force a load of the next (first) run of map data
          ldy #1
          sty RunLength

          ldy #75               ; 75 × 2 lines = 150 lines total
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
          .SleepX 71
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

          lda MapBG, x
          sta COLUBK
DrawMap:
          dec RunLength
          bne NoMapChange

          ldy #0
          lda (pp5l), y
          sta RunLength
          iny
          lda (pp5l), y
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

          ldy #$ff
          ldx #MapServicesBank
          jsr FarCall

          cpy #$ff
          beq NewRoom

          lda PlayerY
          cmp #8
          bmi GoScreenUp
          cmp #75
          bpl GoScreenDown

          lda PlayerX
          cmp #ScreenLeftEdge
          beq GoScreenLeft
          cmp #ScreenRightEdge
          beq GoScreenRight

          jmp CheckSwitches

GoScreenUp:
          lda #74
          sta PlayerY
          ldy #0
          jmp GoScreen

GoScreenDown:
          lda #9
          sta PlayerY
          ldy #1
          jmp GoScreen

GoScreenLeft:
          lda #ScreenRightEdge - 1
          sta PlayerX
          ldy #2
          jmp GoScreen

GoScreenRight:
          lda #ScreenLeftEdge + 1
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

          jsr Overscan
          jmp NewRoom

CheckSwitches:

          lda SWCHB
          cmp DebounceSWCHB
          beq SkipSwitches
          sta DebounceSWCHB
          and #SWCHBReset
          bne NoReset
          jmp GoSaveAndQuit

NoReset:

          lda DebounceSWCHB
          and #SWCHBColor
          eor #SWCHBColor
          sta Pause

SkipSwitches:

          lda #ModeMap
          cmp GameMode
          bne Leave
          jsr Overscan
          jmp Loop

Leave:
          jsr Overscan
          jmp DoMap

          .bend
