;;; Grizzards Source/Routines/Map.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Map:    .block

Loop:
          .FarJSR MapServicesBank, ServiceTopOfScreen

          .TimeLines KernelLines - 34

          ldx CurrentMap
;;; 
AlternateBackgroundArt:
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

            .mva pp5l, #<Map_BowClosed
            .mva pp5h, #>Map_BowClosed
            gne GotRLE
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
            ldx # 68              ; SouthShore2
            gne DoneShore

MaybeNorthShore:
            cpx # 51
            blt DoneShore

            cpx # 54
            bge DoneShore

            ldx # 69              ; NorthShore2
DoneShore:

          .fi

          lda MapRLEL, x
          sta pp5l
          lda MapRLEH, x
          sta pp5h
GotRLE:
;;; 
GetMapColors:
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

              cpx # 18
              blt NotDark
              cpx # 19
              beq NotDark
              cpx # 29
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
              ;;  walls are always darker than floors here
              .switch TV
              .case NTSC
                ora #$02
              .case PAL
                ora #$04
              .endswitch

            .endswitch
          .fi                   ; end of "not SECAM" section
          sta COLUPF
;;; 
BeforeKernel:
          .mva VBLANK, #ENABLED
          ldx CurrentMap

          .if BANK == Province2MapBank

            .mva ENAM1, # 0
            cpx # 28              ; Labyrinth entrance
            bne DoneMagicRing
            lda ProvinceFlags + 6
            .BitBit $40              ; flag # 54
            beq DoneMagicRing

DoMagicRing:
            stx WSYNC
            .SleepX 41
            stx RESM1
            .mvx ENAM1, #ENABLED
            .if SECAM == TV
              ldx #COLWHITE
            .else
              ldx #COLGRAY | $e
            .fi
            stx COLUP1
            .mvx NUSIZ1, #NUSIZMISSILE4

            .mvx NextSound, # SoundSweepUp

            ldx AlarmCountdown
            bne NoBallsNoWSync

            ;; A has ProvinceFlags + 6
            and #~$40             ; clear bit $40
            sta ProvinceFlags + 6
            lda ProvinceFlags + 7
            and #~$01             ; clear bit 1 = flag 56
            sta ProvinceFlags + 7

            .mva GameMode, #ModeMapNewRoom
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
          lda #$a0
          gne EnableBall

RightBall:
          stx WSYNC
          .SleepX 69
          sta RESBL
          lda #$80
EnableBall:
          sta HMBL
          .mva ENABL, #ENABLED
          gne DoneBall

NoBalls:
          stx WSYNC
NoBallsNoWSync:
          .mva ENABL, # 0

DoneBall:
          stx WSYNC
          .SleepX 71
          sta HMOVE
;;; 
          ;; Prepare for the DrawMap loop
          ldx CurrentMap

          .if TV == SECAM
            lda # 0
          .else
            lda MapColors, x
            .rept 4
              asl a
            .next
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
              cpx # 18
              blt NotDark
              cpx # 19
              beq NotDark
              cpx # 29
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

          sta COLUBK


          ldy # 0
          lda (pp5l), y
          sta RunLength

          stx WSYNC
          sty VBLANK
          iny                   ; Y = 1
          jmp DrawPF0

;;; 
          ;; Actually draw each line of the map
DrawMap:
          dec RunLength
          bne DrawPlayers

          lda pp5l
          ;; Carry is clear here (after DEC)
          adc # 4
          bcc +
          inc pp5h
+
          sta pp5l

;;          stx WSYNC
DrawPF:
          ldy # 1
DrawPF0:
          lda (pp5l), y
          sta PF0
          iny                   ; Y = 2
          lda (pp5l), y
          sta PF1
          iny                   ; Y = 3
          lda (pp5l), y
          sta PF2

DrawPlayer0NoWait:
          lda # 7
          dcp P0LineCounter
          bge P0NoWait

NoP0NoWait:
          lda # 0
          .Sleep 4
          jmp P0DoneNoWait

P0NoWait:
          ldy P0LineCounter
          lda (pp0l), y

P0DoneNoWait:
          sta GRP0
          jmp DrawPlayer1

DrawPlayers:

DrawPlayer0:
          lda # 7
          dcp P0LineCounter
          blt NoP0

          ldy P0LineCounter
          lda (pp0l), y
          jmp P0Done

NoP0:
          lda # 0
P0Done:
          stx WSYNC
          sta GRP0

DrawPlayer1:
          lda # 7
          ldy P1LineCounter
          bmi RemapSprites

          dcp P1LineCounter
          blt NoP1

          lda (pp1l), y
          jmp P1Done

RemapSprites:
          jmp GoSpriteMapper

NoP1:
          lda # 0
P1Done:
          sta GRP1

SpriteMapperReturn:
          ldy RunLength
          bne SyncWithoutRLE

          lda (pp5l), y
          sta RunLength
          gne Sync

SyncWithoutRLE:
          stx WSYNC

Sync:
          inc LineCounter       ; 72 × 2 lines = 144 lines total
          ldy LineCounter       ; (72 × 2½ lines = 180 lines on PAL/SECAM)

          .if TV != NTSC
          ;; extend every odd line on PAL/SECAM
            tya
            and # 1
            beq +
            stx WSYNC
+
          .fi

          cpy # 72
          blt DrawMap           ; crosses a page boundary
;;; 
FillBottomScreen:
          stx WSYNC
          .mva VBLANK, #ENABLED
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

            .mva NextMap, # 51              ; Found the mirror
            .mva GameMode, #ModeSignpost
DoneMirror:
          .fi
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

          gne ShouldIStayOrShouldIGo

GoScreenUp:
          .if BANK == Province2MapBank

            ;; It was possible to get stuck, #413
            lda CurrentMap
            cmp # 1
            bne DoneCoastBump
            lda PlayerX
            cmp #$c0
            blt DoneCoastBump

            .mva BlessedX, #$c0

DoneCoastBump:

          .fi
          .mva BlessedY, #ScreenBottomEdge - 1
          sta PlayerY
          ldy # 0
          geq GoScreen

GoScreenDown:
          .mva BlessedY, #ScreenTopEdge + 1
          sta PlayerY
          ldy # 1
          gne GoScreen

GoScreenLeft:
          .mva BlessedX, #ScreenRightEdge - 1
          sta PlayerX
          ldy # 2
          gne GoScreen

GoScreenRight:
          .if BANK == Province2MapBank

            ;; It was possible to get stuck, #413
            lda CurrentMap
            cmp # 1
            bne DoneDockBump

            lda PlayerY
            bmi GotStuck

            cmp #$10
            bge DoneDockBump
GotStuck:
            .mva BlessedY, #$10

DoneDockBump:

          .fi
          .mva BlessedX, #ScreenLeftEdge + 1
          sta PlayerX
          ldy # 3
          ;; fall through
GoScreen:
          lda # 0               ; Y is a link index right now
          sta DeltaX
          sta DeltaY
	sta Temp

          .mva Pointer + 1, #>MapLinks

          lda CurrentMap
          asl a
          rol Temp
          asl a
          rol Temp
          clc                   ; XXX necessary?
          adc #<MapLinks
          sta Pointer

          lda Pointer + 1
          adc Temp
          sta Pointer + 1

          lda (Pointer), y
          bmi ScreenBounce

          sta NextMap

          .mva GameMode, #ModeMapNewRoom
          gne ShouldIStayOrShouldIGo

ScreenBounce:
          ;; stuff the player into the middle of the screen
          .mva PlayerX, #$7a
          .mva PlayerY, #$21
ShouldIStayOrShouldIGo:
          lda GameMode
          cmp #ModeMap
          bne Leave

          jsr LeaveTiming

          jmp Loop

LeaveTiming:
          .WaitForTimer
          .if TV == NTSC
            jmp Overscan        ; tail call
          .else
            .TimeLines OverscanLines
            jmp Overscan.Short  ; tail call
          .fi
;;; 
Leave:
          cmp #ModeGrizzardDepot
          beq EnterGrizzardDepot

          jsr LeaveTiming

          lda GameMode

          cmp #ModeMapNewRoom
          bne +
          stx WSYNC
          jmp MapSetup.NewRoom
+

          cmp #ModeMapNewRoomDoor
          bne +
          stx WSYNC
          jmp MapSetup.NewRoom
+

          cmp #ModePotion
          beq DoPotions

          cmp #ModeNewGrizzard
          beq GetNewGrizzard

          cmp #ModeGrizzardStats
          beq ShowStats

          cmp #ModeSignpost
          bne UnknownMode

          .mva SignpostIndex, NextMap
          ldx #SignpostBank
          jsr FarCall

          .mva NextMap, CurrentMap
          .mva GameMode, #ModeMap
          .WaitScreenBottom
          jmp MapSetup

UnknownMode:
          brk

DoPotions:
          .FarJMP MonsterBank, ServicePotion

EnterGrizzardDepot:
          .FarJMP MapServicesBank, ServiceGrizzardDepot

GetNewGrizzard:
          .mva Temp, NextMap
          .FarJMP MapServicesBank, ServiceNewGrizzard

ShowStats:
          .FarJSR MapServicesBank, ServiceGrizzardStatsScreen
          jmp MapSetup

          .bend
