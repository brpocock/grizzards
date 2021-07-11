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
          stx Temp
          ldx #TextBank
          ldy #ServiceFetchGrizzardMove
          jsr FarCall
          ldx Temp
          lda MoveDeltaHP, x
          bpl ChooseTarget

SelfTarget:
          ldx # 0
          stx MoveTarget
          jmp StickDone

ChooseTarget:
          ldx MoveTarget
          bne +
          ldx # 1
+
          cpx # 7
          blt +
          ldx # 1
+
          lda NewSWCHA
          and #P0StickLeft
          bne DoneStickLeft
          dex
          bne DoneStickLeft
          ldx # 6
DoneStickLeft:
          lda NewSWCHA
          and #P0StickRight
          bne DoneStickRight
          inx
          cpx # 7
          blt DoneStickRight
          ldx # 1
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
          beq NoSelect
          and #SWCHBSelect
          bne NoSelect
          lda #ModeGrizzardStats
          sta GameMode

NoSelect:

          .if TV == SECAM

          lda DebounceSWCHB
          and #SWCHBP0Advanced
          sta Pause

          .else

          lda DebounceSWCHB
          and #SWCHBColor
          eor #SWCHBColor
          beq NoPause
          lda DebounceSWCHB
          and #SWCHBGenuine2600
          bne +
          lda Pause
          eor #$ff
+
          sta Pause
          rts

NoPause:
          lda # 0
          sta Pause
          .fi

SkipSwitches:

          rts

          .bend
