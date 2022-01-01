;;; Grizzards Source/Routines/CombatVBlank.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CombatVBlank:       .block

          lda GameMode
          cmp #ModeCombat
          beq CombatLogic

          rts

CombatLogic:

          lda WhoseTurn
          beq CheckStick

          lda AlarmCountdown
          beq DoAutoMove

          .SkipLines KernelLines - 180
          jmp CheckSwitches
;;; 
DoAutoMove:
          lda WhoseTurn
          bne DoMonsterMove
MaybeDoPlayerMove:
          lda StatusFX
          .BitBit StatusSleep
          bne DoPlayerSleep
          and #StatusMuddle
          bne DoPlayerMuddled
          geq CheckStick

DoPlayerSleep:
          jsr Random
          bpl +
          lda StatusFX
          ora #~StatusSleep
          sta StatusFX
+
          lda #ModeCombatNextTurn
          sta GameMode
          gne CheckStick

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

          lda #ModeCombatAnnouncement
          sta GameMode

CheckStick:
          ldx MoveSelection
          stx WSYNC

          lda NewSWCHA
          beq StickDone

          and #P0StickUp
          bne DoneStickUp
          dex
          bpl DoneStickUp
          ldx #8

DoneStickUp:
          lda NewSWCHA
          and #P0StickDown
          bne DoneStickDown
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
          jsr CombatMainScreen.TargetFirstMonster
+
          cpx # 7
          blt +
          ldx # 1
+
          lda NewSWCHA
          .BitBit P0StickLeft
          bne DoneStickLeft
          dex
          bne DoneStickLeft
          ldx # 6
DoneStickLeft:
          lda NewSWCHA
          .BitBit P0StickRight
          bne DoneStickRight
          inx
          cpx # 7
          blt DoneStickRight
          ldx # 1
DoneStickRight:
          stx MoveTarget

StickDone:
CheckSwitches:
          stx WSYNC

          lda NewSWCHB
          beq SkipSwitches
          .BitBit SWCHBReset
          bne NoReset
          jmp GoQuit

NoReset:
          .BitBit SWCHBSelect
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
          .BitBit SWCHBColor
          bne NoPause
          and #SWCHB7800
          beq +
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
