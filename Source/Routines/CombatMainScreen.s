;;; Grizzards Source/Common/CombatMainScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock
CombatMainScreen:   .block

          lda #0
          sta MoveSelection
          lda #ModeCombat
          sta GameMode
Loop:
          jsr VSync

          ;; drawing the monsters seems to sometimes be a little variable in its timing, so we'll use a timer.
          .TimeLines 95

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
          .if TV == NTSC
          .TimeLines KernelLines - 97
          .else
          .TimeLines KernelLines - 99
          .fi
;;; 
BeginPlayerSection:
          sta WSYNC
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
          blt AtMinHP
          .ldacolu COLYELLOW, $f
          sta COLUPF
          bne DrawHealthPF      ; always taken

AtMaxHP:
          .ldacolu COLGREEN, $f
          sta COLUPF
          bne DrawHealthPF      ; always taken

AtMinHP:
          .ldacolu COLRED, $f
          sta COLUPF

DrawHealthPF:
          cpx # 8
          bge FullPF2
          lda HealthyPF2, x
          sta PF2
          bne DoneHealth        ; always taken

FullPF2:
          lda #$ff
          sta PF2
          txa                   ; ∈ 8…99
          clc
          ror                   ; ∈ 4…50
          clc
          ror                   ; ∈ 2…25
          clc
          ror                   ; ∈ 1…12
          tax
          cpx # 8
          bge FullPF1
          lda HealthyPF1, x
          sta PF1
          bne DoneHealth        ; always taken

FullPF1:                        ; ∈ 8…12
          sec
          sbc # 8               ; ∈ 0…4
          tax
          lda #$ff
          sta PF1
          lda HealthyPF2, x
          sta PF0
          ;; fall through
;;; 
DoneHealth:
          .SkipLines 4
          lda # 0
          sta PF0
          sta PF1
          sta PF2
;;; 
          lda WhoseTurn
          beq PlayerChooseMove
          .WaitForTimer
          jmp ScreenDone

PlayerChooseMove:
          jsr Prepare48pxMobBlob

          ldx MoveSelection
          bne NotRunAway
          .ldacolu COLTURQUOISE, $f
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
          sta WSYNC

          .FarJSR TextBank, ServiceShowMove

          .WaitForTimer

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
          .SkipLines 3
          jmp CombatAnnouncementScreen

RunAway:
          lda #SoundHappy
          sta NextSound

          lda #ModeMap
          sta GameMode
          ;; fall through
;;; 
ScreenDone:
          .SkipLines 3
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
