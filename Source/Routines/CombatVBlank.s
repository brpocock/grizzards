;;; Grizzards Source/Routines/CombatVBlank.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CombatVBlank:       .block

          lda GameMode
          cmp #ModeCombat
          beq CombatLogic

          rts

CombatLogic:
          lda AlarmCountdown
          beq DoAutoMove

          lda WhoseTurn
          beq CheckStick

          .SkipLines KernelLines - 180
          jmp CheckSwitches
;;; 
DoAutoMove:
          lda WhoseTurn
          bne DoMonsterMove

MaybeDoPlayerMove:
          lda StatusFX
          .BitBit StatusSleep
          beq NotPlayerSleep

DoPlayerSleep:
          jsr Random
          bpl PlayerNotAwaken

          lda StatusFX
          and #~StatusSleep
          sta StatusFX
PlayerNotAwaken:
          lda #ModeCombatNextTurn
          sta GameMode
          gne CheckStick

NotPlayerSleep:
          and #StatusMuddle
          beq CheckStick

DoPlayerMuddled:
          jsr Random

          bpl PlayerNotClearUp

          lda StatusFX
          and #~StatusMuddle
          sta StatusFX
          jmp CheckStick

PlayerNotClearUp:
SetMuddledMove:
          jsr Random
          and #$07
          tax
          lda BitMask, x
          bit MovesKnown
          beq SetMuddledMove

          inx
          stx MoveSelection

PickMonster:
          jsr Random

          and #$07
          tax
CheckMonsterPulse:
          cpx # 6
          bge PickMonster

          lda EnemyHP, x
          bne GotMonster

          inx
          gne CheckMonsterPulse

GotMonster:
          inx
          stx MoveTarget
          lda #ModeCombatDoMove
          sta GameMode
          jmp StickDone

DoMonsterMove:
          ldx WhoseTurn
          dex
          lda EnemyStatusFX, x
          and #StatusSleep
          beq MonsterMoves

          lda #ModeCombatNextTurn
          sta GameMode
          gne CheckStick

MonsterMoves:
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

          lda #SoundChirp
          sta NextSound
          lda CombatMajorP
          beq CanSelectMoveUp

          dex
          beq WrapMoveForUp

          gne DoneStickUp

CanSelectMoveUp:
          dex
          cpx #$ff
          bne DoneStickUp

WrapMoveForUp:
          ldx # 8

DoneStickUp:
          lda NewSWCHA
          and #P0StickDown
          bne DoneStickDown

          inx 
          lda #SoundChirp
          sta NextSound
          cpx #9              ; max moves = 8
          blt DoneStickDown

          ldy CombatMajorP
          beq CanRunAwayDown

          ldx # 1
          gne DoneStickDown

CanRunAwayDown:
          ldx # 0

DoneStickDown:
          stx MoveSelection
StickLeftRight:
          lda CombatMoveDeltaHP
          bmi SelfTarget

ChooseTarget:
          lda CombatMajorP
          beq ChooseMinorTarget

          ldx # 1
          gne ForcedTarget

SelfTarget:
          ldx # 0
ForcedTarget:
          stx MoveTarget
          jmp StickDone

ChooseMinorTarget:
          ldx MoveTarget
          bne NormalizeMinorTarget

          ;; copied from CombatMainScreen
TargetFirstMonster:
          ldx #0
TargetNextMonster:
          lda EnemyHP, x
          bne TargetFirst

          inx
          cpx # 5
          bne TargetNextMonster

TargetFirst:
          inx
          stx MoveTarget
NormalizeMinorTarget:
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
          beq DoneSwitches

          .BitBit SWCHBReset
          bne NoReset

          .WaitForTimer
          ldx # 0
          stx VBLANK
          .if TV == NTSC
            .TimeLines KernelLines - 1
          .else
            lda #$ff
            sta TIM64T
          .fi

          .FarJMP SaveKeyBank, ServiceAttract

NoReset:
          .BitBit SWCHBSelect
          bne NoSelect

          lda #ModeGrizzardStats
          sta GameMode

NoSelect:

;;; XXX the pause code should be in some other place rather than being duplicated here
;;; Moreover, Pause does not even affect combat mode, so this is maybe wasted code?
          .if TV == SECAM

            lda DebounceSWCHB
            and #SWCHBP1Advanced ; SECAM pause
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

DoneSwitches:
          rts

          .bend
