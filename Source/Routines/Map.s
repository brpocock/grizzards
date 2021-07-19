;;; Grizzards Source/Routines/Map.s
;;; Copyright © 2021 Bruce-Robert Pocock
Map:    .block

Loop:
          .FarJSR MapServicesBank, ServiceTopOfScreen

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
          .rept 4
          asl a
          .next
          adc #<SpriteArt
          bcc +
          inc pp1h
+
          sta pp1l
          lda ClockFrame
          .BitBit $10
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

          .rept 4
          sta WSYNC
          .next

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
          .switch TV
          .case SECAM
          ror a
          ror a
          ror a
          ror a
          .case NTSC
          ora #$02              ; dim
          .case PAL
          ora #$04              ; not quite as dim on PAL
          .default
          .error "What kind of TV standard are we working with here?"
          .endswitch
          sta COLUPF

          ;; Force a load of the next (first) run of map data
          ldy # 0
          lda (pp5l), y
          sta RunLength
          iny
          lda (pp5l), y
          sta pp4l
          iny
          lda (pp5l), y
          sta pp4h
          iny
          lda (pp5l), y
          sta pp3l

          clc
          lda pp5l
          adc # 4
          bcc +
          inc pp5h
+
          sta pp5l

          ldy # 72              ; 72 × 2 lines = 144 lines total
          sty LineCounter

          ldx CurrentMap
          lda #ENABLED
          sta ENABL
          lda MapSides, x
          bmi LeftBall
          .BitBit $40
          bne RightBall
          beq NoBalls           ; always taken

LeftBall:
          sta WSYNC
          sta RESBL
          lda # $20
          sta HMBL
          bne DoneBall          ; always taken

RightBall:
          sta WSYNC
          .SleepX 69
          sta RESBL
          lda # 0
          sta HMBL
          beq DoneBall          ; always taken

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
          .rept 4
          asl a
          .next
          ora #$0e
          .fi

          sta WSYNC
          sta COLUBK
          lda pp4l
          sta PF0
          lda pp4h
          sta PF1
          lda pp3l
          sta PF2
;;; 
DrawMap:
          dec RunLength
          bne DrawLine

          ldy # 1
          ;; skip run length until the PF regs are written
          ;; or we'll be too late and update halfway into the line
          lda (pp5l), y
          tax
          iny
          lda (pp5l), y
          iny
          stx PF0
          sta PF1
          lda (pp5l), y
          sta PF2
          ldy # 0
          lda (pp5l), y
          sta RunLength
          clc
          lda pp5l
          adc #4
          bcc +
          inc pp5h
+
          sta pp5l
          ldy LineCounter

DrawLine:
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
          .if TV != NTSC
          lda #$01
          bit LineCounter
          beq +
          sta WSYNC
+
          .fi

          dec LineCounter
          sta WSYNC

          bne DrawMap
;;; 
FillBottomScreen:
          lda # 0
          sta COLUBK
          sta PF0
          sta PF1
          sta PF2
          sta GRP0
          sta GRP1
          sta ENABL

          .if TV == NTSC
          .SkipLines KernelLines - 180
          .else
          .SkipLines KernelLines - 215
          .fi

ScreenJumpLogic:
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

          bne CheckSwitches     ; always taken

GoScreenUp:
          lda #ScreenBottomEdge - 1
          sta BlessedY
          sta PlayerY
          ldy #0
          beq GoScreen          ; always taken

GoScreenDown:
          lda #ScreenTopEdge + 1
          sta BlessedY
          sta PlayerY
          ldy #1
          bne GoScreen          ; always taken

GoScreenLeft:
          lda #ScreenRightEdge - 1
          sta BlessedX
          sta PlayerX
          ldy #2
          bne GoScreen          ; always taken

GoScreenRight:
          lda #ScreenLeftEdge + 1
          sta BlessedX
          sta PlayerX
          ldy #3
          ;; fall through
GoScreen:
          lda #0
          sta DeltaX
          sta DeltaY

          lda #>MapLinks
          sta Pointer + 1
          clc
          lda CurrentMap
          rol a
          rol a
          adc #<MapLinks
          bcc +
          inc Pointer + 1
+
          sta Pointer
          lda (Pointer), y
          cmp #$ff
          beq ScreenBounce
          sta CurrentMap

          lda #ModeMapNewRoom
          sta GameMode
          bne CheckSwitches     ; always taken

ScreenBounce:
          ;; stuff the player into the middle of the screen
          lda #$7a
          sta PlayerX
          lda #$21
          sta PlayerY

CheckSwitches:

          lda NewSWCHB
          beq NoReset
          .BitBit SWCHBReset
          bne NoReset
          jmp GoQuit

NoReset:
;;; 
          .if TV == SECAM

          lda DebounceSWCHB
          and # SWCHBP0Advanced
          sta Pause

          .else

          lda DebounceSWCHB
          .BitBit SWCHBColor
          bne NoPause
          .BitBit SWCHBGenuine2600
          bne +
          lda Pause
          eor #$ff
+
          sta Pause
          jmp SkipSwitches

NoPause:
          lda # 0
          sta Pause

          .fi
;;; 
SkipSwitches:

          jsr Overscan

          lda GameMode
          cmp #ModeMap
          bne Leave
          jmp Loop

Leave:
          cmp #ModeMapNewRoom
          beq MapSetup.NewRoom

          ldx # 0
          stx CurrentMusic + 1

          cmp #ModeCombat
          beq GoCombat
          cmp #ModeGrizzardDepot
          beq EnterGrizzardDepot
          cmp #ModeNewGrizzard
          beq GetNewGrizzard
          brk

EnterGrizzardDepot:
          .FarJSR TextBank, ServiceGrizzardDepot
          jmp MapSetup

GetNewGrizzard:
          ldx SpriteFlicker
          lda SpriteParam, x
          sta Temp
          .FarJSR MapServicesBank, ServiceNewGrizzard
          jmp MapSetup

          .bend
