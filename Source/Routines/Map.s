;;; Grizzards Source/Routines/Map.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
Map:    .block

Loop:
          .FarJSR MapServicesBank, ServiceTopOfScreen

          .TimeLines KernelLines - 34

          ldx CurrentMap

;;; Special case: If this  is not the demo and we're in Bank  4, the RLE has
;;; to change  depending on whether  the tunnels have  been opened
;;; yet. If they have not been, we swap out the background for the
;;; BowClosed one.
          .if BANK == Province0MapBank && !DEMO

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

          .if BANK == Province2MapBank && !DEMO

          ;; Still in Province 2. Is this waterfront?
          lda ClockSeconds
          and # 1
          beq DoneShore

          cpx # 1
          beq SouthShoreAlt

          cpx # 14
          blt DoneShore

          cpx # 18
          bge MaybeNorthShore

SouthShoreAlt:
          ldx # 67              ; SouthShore2
          gne DoneShore

MaybeNorthShore:
          cpx # 51
          blt DoneShore

          cpx # 54
          bge DoneShore

          ldx # 68              ; NorthShore2
DoneShore:

          .fi

          lda MapRLEL, x
          sta pp5l
          lda MapRLEH, x
          sta pp5h
GotRLE:
          ldx CurrentMap
          lda MapColors, x
          and #$f0
          ;; Set up the effective color,
          ;; the brightness is based on province,
          ;; in province 1 the floor is darker than the walls
          .if SECAM == TV
            lsr a
            lsr a
            lsr a
            lsr a
          .else
            .switch BANK
            .case Province1MapBank ; Province 1 is Dark

              ora #$0e

            .case Province0MapBank ; only dark in caves

              .block
              ldy CurrentMap
              cpy #18
              blt NotDark
              cpy #19
              beq NotDark
              cpy #29
              bge NotDark

              ora #$08          ; dimmer than usual
              gne GotPF
NotDark:                        ; since room is not dark, walls are darker
              .switch TV
              .case NTSC
                ora #$02
              .case PAL
                ora #$04
              .endswitch
GotPF:
              .bend

            .case Province2MapBank ; never dark

              ora #$0e

            .endswitch
          .fi                   ; end of "not SECAM" section
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

          lda #ENABLED
          sta VBLANK
          ldx CurrentMap

          .if BANK == Province2MapBank

          lda # 0
          sta ENAM1
          cpx # 28              ; Labyrinth entrance
          bne DoneMagicRing
          lda ProvinceFlags + 6
          .BitBit $40              ; flag # 54
          beq DoneMagicRing
DoMagicRing:
          stx WSYNC
          .SleepX 41
          stx RESM1
          ldx #ENABLED
          stx ENAM1
          .if SECAM == TV
          ldx #COLWHITE
          .else
          ldx #COLGRAY | $e
          .fi
          stx COLUP1
          ldx #NUSIZMISSILE4
          stx NUSIZ1

          ldx # SoundSweepUp
          stx NextSound

          ldx AlarmCountdown
          bne NoBallsNoWSync

          ;; A has ProvinceFlags + 6
          and #~$40             ; clear bit $40
          sta ProvinceFlags + 6
          lda ProvinceFlags + 7
          and #$fe              ; clear bit 1 = flag 56
          sta ProvinceFlags + 7

          lda #ModeMapNewRoom
          sta GameMode
          gne NoBallsNoWSync

DoneMagicRing:

          .fi

          lda MapSides, x
          bmi LeftBall
          and #$40
          bne RightBall
          geq NoBalls

LeftBall:
          stx WSYNC
          sta RESBL
          lda #$20
          gne EnableBall

RightBall:
          stx WSYNC
          .SleepX 69
          sta RESBL
          lda # 0
EnableBall:
          sta HMBL
          lda #ENABLED
          sta ENABL
          gne DoneBall

NoBalls:
          stx WSYNC
NoBallsNoWSync:
          lda # 0
          sta ENABL

DoneBall:
          stx WSYNC
          sta HMOVE
;;; 
          ;; Prepare for the DrawMap loop
          ldx CurrentMap

          .if TV == SECAM
            lda # 0
          .else
            lda MapColors, x
            and #$0f
            asl a
            asl a
            asl a
            asl a
            .switch BANK
            .case Province1MapBank ; Province 1 is Dark

              .switch TV
              .case NTSC
                ora #$02
              .case PAL
                ora #$04
              .endswitch

            .case Province0MapBank ; only dark in caves

              .block
              ldy CurrentMap
              cpy #18
              blt NotDark
              cpy #19
              beq NotDark
              cpy #29
              bge NotDark

              ;;  floor darker than walls in caves
              .switch TV
              .case NTSC
                ora #$02
              .case PAL
                ora #$04
              .endswitch
              gne GotBK
NotDark:  
              ora #$0e
GotBK:
              .bend

            .case Province2MapBank ; never dark

              ora #$0e

            .endswitch
          .fi                   ; end of "not SECAM" section

          ldx # 0
          stx VBLANK
          stx WSYNC
          sta COLUBK
          lda pp4l
          sta PF0
          lda pp4h
          sta PF1
          lda pp3l
          sta PF2
          ldy # 1
          lax (pp5l), y
;;; 
DrawMap:
          ;; Actually draw each line of the map
          dec RunLength
          bne DrawPlayers

          ;; skip run length until the PF regs are written
          ;; or we'll be too late and update halfway into the line
          stx PF0
          iny
          lda (pp5l), y
          sta PF1
          iny
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

DrawPlayers:
          stx WSYNC
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
          stx WSYNC
+
          .fi

          ldy # 1
          lax (pp5l), y

          dec LineCounter
          stx WSYNC

          bne DrawMap
;;; 
FillBottomScreen:
          lda #ENABLED
          sta VBLANK
;;; 

          .if BANK == Province2MapBank

          ;; Still in Province 2!
          ;; This is another special-case
          ;; It's here because bank 1 is just full.
          lda CurrentMap
          cmp # 59              ; interior of Sue's house
          bne DoneMirror

          lda ProvinceFlags + 1
          and # 1
          bne DoneMirror

          lda PlayerX
          cmp #$a7
          blt DoneMirror
          lda PlayerY
          cmp #$3b
          blt DoneMirror

          lda # 51              ; Found the mirror
          sta SignpostIndex
          lda #ModeSignpost
          sta GameMode

DoneMirror:

          .fi

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

          gne ShouldIStayOrShouldIGo

GoScreenUp:
          lda #ScreenBottomEdge - 1
          sta BlessedY
          sta PlayerY
          ldy #0
          geq GoScreen

GoScreenDown:
          lda #ScreenTopEdge + 1
          sta BlessedY
          sta PlayerY
          ldy #1
          gne GoScreen

GoScreenLeft:
          lda #ScreenRightEdge - 1
          sta BlessedX
          sta PlayerX
          ldy #2
          gne GoScreen

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
          gne ShouldIStayOrShouldIGo

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
          cmp #ModePotion
          beq DoPotions
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
          lda CurrentMap
          sta NextMap
          lda #ModeMap
          sta GameMode
          .WaitScreenBottom
          jmp MapSetup

UnknownMode:
          brk

DoPotions:
          .FarJMP MonsterBank, ServicePotion

EnterGrizzardDepot:
          .FarJMP MapServicesBank, ServiceGrizzardDepot

GetNewGrizzard:
          lda NextMap
          sta Temp
          .FarJSR MapServicesBank, ServiceNewGrizzard ; does not return

ShowStats:
          .FarJSR MapServicesBank, ServiceGrizzardStatsScreen
          jmp MapSetup

          .bend
