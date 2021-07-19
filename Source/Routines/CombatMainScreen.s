;;; Grizzards Source/Common/CombatMainScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock
CombatMainScreen:   .block

          lda #0
          sta MoveSelection
          lda #ModeCombat
          sta GameMode
Loop:
          jsr VSync
          jsr VBlank

          ;; drawing the monsters seems to sometimes be a little variable in its timing, so we'll use a timer.
          lda # (( 76 * 95 ) / 64)
          sta TIM64T

          jsr Prepare48pxMobBlob

          .switch TV
          .case NTSC
          .ldacolu COLRED, 0
          .case PAL
          .ldacolu COLRED, $2
          .case SECAM
          lda #COLBLACK
          .endswitch
          sta COLUBK
          .ldacolu COLYELLOW, $f
          sta COLUP0
          sta COLUP1

PausedOrNot:
;;; 
MonstersDisplay:
          jsr ShowMonsterName

          ldy # 13              ; offset of monster color
          lda (CurrentMonsterPointer), y

          .if TV == SECAM
          bne +                 ; COLBLACK = 0
          lda #COLWHITE
+
          .fi

          sta COLUP0

          lda WhoseTurn         ; show highlight on monster moving
          beq +
          sta MoveTarget
+

          .FarJSR MapServicesBank, ServiceDrawMonsterGroup
DelayAfterMonsters:
          .WaitForTimer
          .TimeLines KernelLines - 122
;;; 
BeginPlayerSection:
          .ldacolu COLBLUE, $f
          sta COLUP0
          sta COLUP1
          .if TV == SECAM
          lda #COLMAGENTA
          .else
          .ldacolu COLINDIGO, $8
          .fi
          sta COLUBK

DrawGrizzardName:
          .FarJSR TextBank, ServiceShowGrizzardName

DrawGrizzard:
          .FarJSR TextBank, ServiceDrawGrizzard
;;; 
DrawHealthBar:
          ldx CurrentHP
          cpx MaxHP
          beq AtMaxHP
          cpx # 4
          bmi AtMinHP
          .ldacolu COLYELLOW, $f
          sta COLUPF
          bne DrawHealthPF      ; always taken

AtMaxHP:
          .ldacolu COLSPRINGGREEN, $f
          sta COLUPF
          bne DrawHealthPF      ; always taken

AtMinHP:
          .ldacolu COLRED, $f
          sta COLUPF

DrawHealthPF:
          cpx # 8
          bpl FullCenter
          lda HealthyPF2, x
          sta PF2
          jmp DoneHealth

FullCenter:
          lda #$ff
          sta PF2
          cpx # 16
          bpl FullMid
          lda HealthyPF1, x
          sta PF1
          jmp DoneHealth

FullMid:
          lda #$ff
          sta PF1
          ;; TODO … draw health bar properly
          nop
          nop
          nop
          nop
          sta PF0
;;; 
DoneHealth:
          .SkipLines 4
          lda # 0
          sta PF0
          sta PF1
          sta PF2

          .SkipLines KernelLines - 192
;;; 
          lda WhoseTurn
          beq PlayerChooseMove

          .SkipLines 46
          beq ScreenDone        ; always taken

PlayerChooseMove:
          jsr Prepare48pxMobBlob

          ldx MoveSelection
          bne NotRunAway
          .ldacolu COLTURQUOISE, $f
          sta WSYNC
          bne ShowSelectedMove  ; always taken

NotRunAway:
          lda BitMask - 1, x
          bit MovesKnown
          beq NotMoveKnown
          .ldacolu COLRED, 4
          bne ShowSelectedMove  ; always taken

NotMoveKnown:
          .ldacolu COLGRAY, 0
          ;; fall through
ShowSelectedMove:
          sta COLUP0
          sta COLUP1

          .FarJSR TextBank, ServiceShowMove

          lda NewINPT4
          beq ScreenDone
          and #PRESSED
          bne ScreenDone

          ldx MoveSelection
          beq RunAway
          dex
          lda BitMask, x
          and MovesKnown
          bne DoUseMove
MoveNotOK:
          lda #SoundBump
          sta NextSound

          bne ScreenDone        ; always taken

DoUseMove:
          ldx MoveTarget
          beq MoveOK
          lda MonsterHP - 1, x
          beq MoveNotOK
MoveOK:
          lda #SoundChirp
          sta NextSound

          jmp CombatAnnouncementScreen

RunAway:
          lda #SoundHappy
          sta NextSound

          lda #ModeMap
          sta GameMode
          ;; fall through
;;; 
ScreenDone:
          .WaitForTimer
          .SkipLines 6
          jsr Overscan

          lda GameMode
          cmp #ModeCombat
          bne Leave
          jmp Loop

Leave:
          cmp #ModeMap
          bne +
          jmp GoMap
+
          cmp #ModeGrizzardStats
          bne +
          lda #ModeCombat
          sta DeltaY
          jmp GrizzardStatsScreen
+
          cmp #ModeCombatAnnouncement
          jmp CombatAnnouncementScreen
          brk
;;; 
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
