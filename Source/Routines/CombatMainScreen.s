;;; Grizzards Source/Common/CombatMainScreen.s
;;; Copyright © 2021 Bruce-Robert Pocock
CombatMainScreen:   .block

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

MonstersDisplay:
          jsr ShowMonsterName

          ldy # 14              ; offset of monster color
          lda (CurrentMonsterPointer), y
          sta COLUP0

          ldy #ServiceDrawMonsterGroup
          ldx #MapServicesBank
          jsr FarCall

DelayAfterMonsters:
          
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

          jsr Prepare48pxMobBlob

          ldx MoveSelection
          cpx # 0
          beq SelectedRunAway
          ldy # COLGRAY | 0
          dex
          lda BitMask, x
          bit MovesKnown
          beq +
          ldy # COLRED | $4
+
          sty COLUP0
          sty COLUP1

          ldx #TextBank
          ldy #ServiceShowMove
          jsr FarCall

          lda NewINPT4
          beq ScreenDone
          and #$80
          bne ScreenDone

          ;; Is the move known?
          ldx MoveSelection
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

SelectedRunAway:

          lda # COLTURQUOISE | $f
          sta COLUP0
          sta COLUP1
          
          ldx #TextBank
          ldy #ServiceShowMove
          jsr FarCall

          lda NewINPT4
          beq ScreenDone
          and #$80
          bne ScreenDone

          lda #SoundHappy
          sta NextSound

          lda #ModeMap
          sta GameMode
          jmp GoMap

ScreenDone:

          jsr Overscan

          lda GameMode
          cmp #ModeCombat
          bne Leave
          jmp Loop

Leave:
          cmp #ModeGrizzardStats
          bne +
          lda #ModeCombat
          sta DeltaY
          jmp GrizzardStatsScreen
+
          cmp #ModeCombatAnnouncement
          jmp CombatAnnouncementScreen
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

