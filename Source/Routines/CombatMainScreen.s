;;; Grizzards Source/Common/CombatMainScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock
CombatMainScreen:   .block

Loop:
          jsr VSync
          jsr VBlank

          jsr Prepare48pxMobBlob
          
          lda Pause
          beq NotPaused

          .ldacolu COLGRAY, 0
          sta COLUBK
          .ldacolu COLGRAY, $f
          sta COLUP0
          sta COLUP1
          jmp PausedOrNot

NotPaused:
          .ldacolu COLRED, 0
          sta COLUBK
          .ldacolu COLYELLOW, $f
          sta COLUP0
          sta COLUP1

PausedOrNot:

          jsr ShowMonsterName

          ldy #ServiceDrawMonsterGroup
          ldx #MapServicesBank
          jsr FarCall

DelayAfterMonsters:
          lda # 0
          sta GRP1
          
          ldx # 10
-          
          stx WSYNC
          dex
          bne -

DrawGrizzardName:

          .ldacolu COLBLUE, $f
          sta COLUP0
          sta COLUP1
          .ldacolu COLINDIGO, $8
          sta COLUBK

          ldx #TextBank
          ldy #ServiceShowGrizzardName
          jsr FarCall

DrawGrizzard:
          ldx #TextBank
          ldy #ServiceDrawGrizzard
          jsr FarCall

DrawHealthBar:      
          ldx CurrentHP
          cpx MaxHP
          beq AtMaxHP
          cpx #4
          bmi AtMinHP
          .ldacolu COLYELLOW, $f
          sta COLUPF
          jmp DrawHealthPF

AtMaxHP:
          .ldacolu COLSPRINGGREEN, $f
          sta COLUPF
          jmp DrawHealthPF

AtMinHP:
          .ldacolu COLRED, $f
          sta COLUPF

DrawHealthPF:
          cpx #8
          bpl FullCenter
          lda HealthyPF2, x
          sta PF2
          jmp DoneHealth

FullCenter:
          lda #$ff
          sta PF2
          cpx #16
          bpl FullMid
          lda HealthyPF1, x
          sta PF1
          jmp DoneHealth

FullMid:
          lda #$ff
          sta PF1
          ;; TODO …
          nop
          nop
          nop
          nop
          sta PF0

DoneHealth:
          ldx #4
-
          sta WSYNC
          dex
          bne -

          lda # 0
          sta PF0
          sta PF1
          sta PF2
          
          ldx # KernelLines - 190
FillScreen:
          stx WSYNC
          dex
          bne FillScreen

          lda WhoseTurn
          beq CheckStick

          lda ClockSeconds
          cmp AlarmSeconds
          bne +

          lda ClockMinutes
          cmp AlarmMinutes
          beq DoMonsterMove

+
          ldx # KernelLines - 180
-
          stx WSYNC
          dex
          bne -
          jmp CheckSwitches
          
DoMonsterMove:      

          jsr Random
          and #$03
          sta Temp

          lda EncounterMonster
          asl a
          asl a                 ; at most 200
          adc Temp

          tay
          lda MonsterMoves, y
          
          sta MoveSelection
          jmp CombatAnnouncementScreen

CheckStick:
          ldx MoveSelection

          lda SWCHA
          cmp DebounceSWCHA
          beq StickDone
          sta DebounceSWCHA
          and #P0StickUp
          bne DoneStickUp
          dex
          bpl DoneStickUp
          ldx #8

DoneStickUp:
          lda SWCHA
          and #P0StickDown
          bne DoneStickDown
          inx
          cpx #9              ; max moves = 8
          bmi DoneStickDown
          ldx #0

DoneStickDown:
          stx MoveSelection

StickLeftRight:
          ldx MoveSelection
          lda MoveTargets, x
          cmp #1
          beq ChooseTarget
          cmp #0
          beq SelfTarget
          ldx #$ff
          stx MoveTarget
          jmp StickDone

SelfTarget:
          ldx # 0
          stx MoveTarget
          jmp StickDone

ChooseTarget:       
          ldx MoveTarget
          lda SWCHA
          and #P0StickLeft
          bne DoneStickLeft
          dex
          bpl DoneStickLeft
          ldx #6
DoneStickLeft:
          lda SWCHA
          and #P0StickRight
          bne DoneStickRight
          inx
          cpx #6
          bne DoneStickRight
          ldx #1
DoneStickRight:
          stx MoveTarget

StickDone:

          jsr Prepare48pxMobBlob

          ldx MoveSelection
          cpx # 0
          beq SelectedRunAway
          ldy # COLGRAY | 0
          dex
          lda BitMask, x
          and MovesKnown
          beq +
          ldy # COLRED | $4
+
          sty COLUP0
          sty COLUP1

          ldx #TextBank
          ldy #ServiceShowMove
          jsr FarCall

          lda INPT4
          and #$80
          bne CheckSwitches

          ;; Is the move known?
          ldx MoveSelection
          dex
          lda BitMask, x
          and MovesKnown
          bne DoUseMove

          lda #SoundBump
          sta NextSound

          jmp CheckSwitches

DoUseMove:
          jmp CombatAnnouncementScreen

SelectedRunAway:

          lda # COLTURQUOISE | $f
          sta COLUP0
          sta COLUP1
          
          ldx #TextBank
          ldy #ServiceShowMove
          jsr FarCall

          lda INPT4
          and #$80
          bne CheckSwitches

          lda #SoundHappy
          sta NextSound

          lda #ModeMap
          sta GameMode
          jmp GoMap

CheckSwitches:

          lda SWCHB
          cmp DebounceSWCHB
          beq SkipSwitches
          sta DebounceSWCHB
          and #SWCHBReset
          bne NoReset
          jmp GoQuit

NoReset:
          lda DebounceSWCHB
          and #SWCHBSelect
          bne NoSelect
          lda #ModeGrizzardStats
          sta GameMode
          
NoSelect:
          .if TV != SECAM
          ;; TODO — 7800 Pause button support
          lda DebounceSWCHB
          and #SWCHBColor
          eor #SWCHBColor
          lda DebounceSWCHB
          and #SWCHBGenuine2600
          bne +
          lda Pause
          eor #$ff
+
          sta Pause
          .fi

SkipSwitches:
          jsr Overscan

          lda GameMode
          cmp #ModeCombat
          bne Leave
          jmp Loop

Leave:
          cmp #ModeGrizzardStats
          jmp GrizzardStatsScreen
          brk

HealthyPF2:
          .byte %00000000
          .byte %10000000
          .byte %11000000
          .byte %11100000
          .byte %11110000
          .byte %11111000
          .byte %11111100
          .byte %11111110

HealthyPF1:
          .byte %00000000
          .byte %00000001
          .byte %00000011
          .byte %00000111
          .byte %00001111
          .byte %00011111
          .byte %00111111
          .byte %01111111
          
          .bend

BitMask:
          ;; also used by ExecuteCombatMove, so it's outside the block.
          .byte 1, 2, 4, 8, $10, $20, $40, $80
