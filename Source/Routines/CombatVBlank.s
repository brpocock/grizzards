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
          beq DoAutoMove

+
          ldx # KernelLines - 180
-
          stx WSYNC
          dex
          bne -
          jmp CheckSwitches
;;; 
DoAutoMove:
          lda WhoseTurn
          bne DoMonsterMove
MaybeDoPlayerMove:
          lda StatusFX
          and #StatusSleep
          bne DoPlayerSleep
          lda StatusFX
          and #StatusMuddle
          bne DoPlayerMuddled
          beq CheckStick        ; always taken

DoPlayerSleep:
          jsr Random
          bpl +
          bpl +
          lda StatusFX
          ora #~StatusSleep
          sta StatusFX
+
          lda #ModeCombatNextTurn
          sta GameMode
          bne CheckStick        ; always taken

DoPlayerMuddled:
          jsr Random
          and #$07
          tax
          lda BitMask, x
          bit MovesKnown
          beq DoPlayerMuddled
          stx MoveSelection
          jsr Random
          bpl CheckStick
          lda StatusFX
          ora #~StatusMuddle
          sta StatusFX
          jmp CheckStick

DoMonsterMove:
          jsr Random
          and #$03
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
          .FarJSR TextBank, ServiceFetchGrizzardMove
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
