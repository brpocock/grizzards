;;; Grizzards Source/Routines/Map.s
;;; Copyright © 2021 Bruce-Robert Pocock
Map:    .block

Loop:
          .FarJSR MapServicesBank, ServiceTopOfScreen

          .TimeLines KernelLines - 34

          ldx CurrentMap

;;; Special case: If this  is not the demo and we're in Bank  4, the RLE has
;;; to change  depending on whether  the tunnels have  been opened
;;; yet. If they have not been, we swap out the background for the
;;; BowClosed one.
          .if BANK == 4 && !DEMO
          cpx # 17
          bne NoChangeRLE

          lda CurrentProvince
          bne NoChangeRLE

          lda ProvinceFlags
          and #$02
          bne NoChangeRLE

          lda #<Map_BowClosed
          sta pp5l
          lda #>Map_BowClosed
          sta pp5h
          jmp GotRLE
NoChangeRLE:
          .fi

          lda MapRLEL, x
          sta pp5l
          lda MapRLEH, x
          sta pp5h
GotRLE:

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
          
;;; 
BeforeKernel:
          ldy # 72              ; 72 × 2 lines = 144 lines total
          sty LineCounter       ; (72 × 2½ lines = 180 lines on PAL/SECAM)

          ldx CurrentMap
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
          lda #ENABLED
          sta ENABL
          bne DoneBall          ; always taken

RightBall:
          sta WSYNC
          .SleepX 69
          sta RESBL
          lda # 0
          sta HMBL
          lda #ENABLED
          sta ENABL
          bne DoneBall          ; always taken

NoBalls:
          lda # 0
          sta ENABL
          sta WSYNC

DoneBall:
          stx WSYNC
          sta HMOVE
;;; 
          ;; Prepare for the DrawMap loop
          ldx CurrentMap

          lda MapColors, x
          and #$0f
          .if TV != SECAM
          asl a
          asl a
          asl a
          asl a
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
          ;; Actually draw each line of the map
          dec RunLength
          bne DrawLine

          ldy # 1
          ;; skip run length until the PF regs are written
          ;; or we'll be too late and update halfway into the line
          lax (pp5l), y
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
          ;; extend every even line on PAL/SECAM
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
;;; 
ScreenJumpLogic:
          lda PlayerY
          cmp #ScreenTopEdge
          blt GoScreenUp
          cmp #ScreenBottomEdge
          bge GoScreenDown

          lda PlayerX
          cmp #ScreenLeftEdge
          blt GoScreenLeft
          cmp #ScreenRightEdge
          bge GoScreenRight

          bne ShouldIStayOrShouldIGo     ; always taken

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

          sta Temp

          lda #>MapLinks
          sta Pointer + 1

          clc
          lda CurrentMap
          rol a
          rol Temp
          ;; carry will be clear
          rol a
          rol Temp
          ;; carry will be clear
          adc #<MapLinks
          bcc +
          inc Pointer + 1
+
          sta Pointer

          lda Pointer + 1
          clc
          adc Temp
          sta Pointer + 1

          lda (Pointer), y
          cmp #$ff
          beq ScreenBounce
          sta NextMap

          lda #ModeMapNewRoom
          sta GameMode
          bne ShouldIStayOrShouldIGo     ; always taken

ScreenBounce:
          ;; stuff the player into the middle of the screen
          lda #$7a
          sta PlayerX
          lda #$21
          sta PlayerY

ShouldIStayOrShouldIGo:
          lda GameMode
          cmp #ModeMap
          bne Leave
          .WaitForTimer
          jsr Overscan
          jmp Loop
;;; 
Leave:
          cmp #ModeMapNewRoom
          beq MapSetup.NewRoom

          cmp #ModeMapNewRoomDoor
          beq MapSetup.NewRoom

          ldx # 0
          stx CurrentMusic + 1

          cmp #ModeGrizzardDepot
          beq EnterGrizzardDepot

          .WaitForTimer
          jsr Overscan

          lda GameMode
          cmp #ModeCombat
          beq GoCombat
          cmp #ModeNewGrizzard
          beq GetNewGrizzard
          cmp #ModeGrizzardStats
          beq ShowStats
          cmp #ModeSignpost
          bne UnknownMode
          ldx #SignpostBank
          jsr FarCall
          lda #ModeMap
          sta GameMode
          .WaitScreenBottom
          jmp MapSetup

UnknownMode:
          brk

EnterGrizzardDepot:
          .FarJMP MapServicesBank, ServiceGrizzardDepot

GetNewGrizzard:
          lda NextMap
          sta Temp
          .FarJSR MapServicesBank, ServiceNewGrizzard
          lda CurrentMap
          sta NextMap
          jmp MapSetup

ShowStats:
          .FarJSR MapServicesBank, ServiceGrizzardStatsScreen
          jmp MapSetup

          .bend
