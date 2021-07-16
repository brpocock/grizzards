;;; Grizzards Source/Common/CombatMainScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock
CombatMainScreen:   .block

          lda #0
          sta MoveSelection
Loop:
          jsr VSync
          jsr VBlank

          jsr Prepare48pxMobBlob

          lda Pause
          beq NotPaused

          .ldacolu COLGRAY, $f
          sta COLUBK
          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1
          jmp PausedOrNot

NotPaused:
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

          ldx # 10
-
          stx WSYNC
          dex
          bne -

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

DoneHealth:
          ldx #4
-
          sta WSYNC
          dex
          bne -

;;; 

          lda # 0
          sta PF0
          sta PF1
          sta PF2

          .if KernelLines > 192
          ldx # KernelLines - 192
FillScreen:
          stx WSYNC
          dex
          bne FillScreen
          .else
          stx WSYNC
          stx WSYNC
          .fi

;;; 

ChooseMove:
          lda WhoseTurn
          beq PlayerChooseMove

MonsterChooseMove:
          jsr Random
          and #$03
          sta MoveSelection

MoveAutoChosen:
          ldx #40
-
	stx WSYNC
          dex
          bne -
          jmp ScreenDone

PlayerMuddled:
          jsr Random
          and #$07
          tax
          lda BitMask, x
          beq PlayerMuddled
          stx MoveSelection
          jsr Random
          bpl +
          lda StatusFX
          ora #~StatusMuddle
          sta StatusFX
+
          jmp MoveAutoChosen

PlayerSleeps:
          jsr Random
          bpl +
          bpl +
          lda StatusFX
          ora #~StatusSleep
          sta StatusFX
+
          jmp ExecuteCombatMove.NextTurn ; FIXME scanline count

PlayerChooseMove:
          lda StatusFX
          and #StatusSleep
          bne PlayerSleeps
          lda StatusFX
          and #StatusMuddle
          bne PlayerMuddled

          jsr Prepare48pxMobBlob

          ldx MoveSelection
          bne NotRunAway
          .ldacolu COLTURQUOISE, $f
          .rept 4
          sta WSYNC
          .next
          bne ShowSelectedMove  ; always taken

NotRunAway:
          lda BitMask - 1, x
          bit MovesKnown
          beq NotMoveKnown
          .ldacolu COLRED, 4
          bne ShowSelectedMove

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

          lda #SoundBump
          sta NextSound

          jmp ScreenDone

DoUseMove:
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
