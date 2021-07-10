;;; Grizzards Source/Routines/CombatVBlank.s
;;; Copyright © 2021 Bruce-Robert Pocock

CombatVBlank:       .block

          lda GameMode
          cmp #ModeCombat
          beq CombatLogic

          rts

CombatLogic:

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

          lda #SoundDrone
          sta NextSound

          lda #ModeCombatAnnouncement
          sta GameMode

CheckStick:
          ldx MoveSelection

          lda NewSWCHA
          beq StickDone
          and #P0StickUp
          bne DoneStickUp
          lda #SoundChirp
          sta NextSound
          dex
          bpl DoneStickUp
          ldx #8

DoneStickUp:
          lda NewSWCHA
          and #P0StickDown
          bne DoneStickDown
          lda #SoundChirp
          sta NextSound
          inx
          cpx #9              ; max moves = 8
          blt DoneStickDown
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
          lda NewSWCHA
          and #P0StickLeft
          bne DoneStickLeft
          dex
          bpl DoneStickLeft
          ldx #6
DoneStickLeft:
          lda NewSWCHA
          and #P0StickRight
          bne DoneStickRight
          inx
          cpx #6
          bne DoneStickRight
          ldx #1
DoneStickRight:
          stx MoveTarget

StickDone:
CheckSwitches:

          lda NewSWCHB
          beq SkipSwitches
          and #SWCHBReset
          bne NoReset
          jmp GoQuit

NoReset:
          lda NewSWCHB
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


          rts

          .bend
