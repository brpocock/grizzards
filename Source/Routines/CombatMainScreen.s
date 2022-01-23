;;; Grizzards Source/Common/CombatMainScreen.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
CombatMainScreen:   .block

BackToPlayer:
          lda #1
          sta MoveSelection
          lda #ModeCombat
          sta GameMode
          lda # 4
          sta AlarmCountdown
          lda StatusFX
          .BitBit StatusSleep
          beq NotAsleep1
          .SetUtterance Phrase_Sleeping

NotAsleep1:
          and #StatusMuddle
          beq NotMuddled1
          .SetUtterance Phrase_Muddled

NotMuddled1:
          ;; copied into CombatVBlank also
TargetFirstMonster:
          ldx #0
-
          lda MonsterHP, x
          bne TargetFirst
          inx
          cpx # 5
          bne -
TargetFirst:
          inx
          stx MoveTarget

          .WaitScreenBottom
          jmp LoopFirst
;;; 
Loop:
          .WaitScreenBottom
          .if TV != NTSC
          lda WhoseTurn
          bne +
          .SkipLines 3
+
          .SkipLines 2
          .fi
LoopFirst:
          .WaitScreenTopMinus 1, 3
          jsr Prepare48pxMobBlob

          .switch TV
          .case NTSC
            .ldacolu COLRED, 0
          .case PAL
            .ldacolu COLRED, $2
          .case SECAM
          ;; black background normally, but red for Boss Bear
            lda #COLBLACK
            ldx CurrentCombatEncounter
            cpx # 92
            bne +
            lda #COLRED
+
          .endswitch
          sta COLUBK
          .ldacolu COLYELLOW, $f
          sta COLUP0
          sta COLUP1

;;; 
MonstersDisplay:
          lda CurrentCombatEncounter
          cmp # 92              ; Boss Bear encounter
          bne MonsterWithName
          .SkipLines 20
          .FarJSR EndAnimationsBank, ServiceShowBossBear
          .SkipLines 20
          jmp DelayAfterMonsters

MonsterWithName:
          jsr ShowMonsterName

          ldy # MonsterColorIndex
          lda (CurrentMonsterPointer), y

          .if TV == SECAM
          ;; With only 8 colors we might run into
          ;; something that's “rounded off” to black
          ;; (background) or white (highlight)
          bne +                 ; COLBLACK = 0
          lda #COLGREEN
+
          cmp #COLWHITE
          bne +
          lda #COLGREEN
+
          .fi

          sta COLUP0

          lda WhoseTurn         ; show highlight on monster moving
          beq +
          sta MoveTarget
+

          .FarJSR AnimationsBank, ServiceDrawMonsterGroup
DelayAfterMonsters:
          ;; no actual delay now
;;; 
BeginPlayerSection:
          .ldacolu COLBLUE, $f
          sta COLUP0
          sta COLUP1
          .if TV == SECAM
          lda #COLMAGENTA
          .else
          .ldacolu COLINDIGO, $4
          .fi
          stx WSYNC
          sta COLUBK

DrawGrizzardName:
          .FarJSR TextBank, ServiceShowGrizzardName

DrawGrizzard:
          .FarJSR AnimationsBank, ServiceDrawGrizzard
;;; 
DrawHealthBar:
          ldx CurrentHP
          cpx MaxHP
          beq AtMaxHP
          cpx # 4
          blt AtMinHP
          .ldacolu COLYELLOW, $f
          sta COLUPF
          gne DrawHealthPF

AtMaxHP:
          .ldacolu COLGREEN, $8
          sta COLUPF
          gne DrawHealthPF

AtMinHP:
          .ldacolu COLRED, $8
          sta COLUPF

DrawHealthPF:
          cpx # 8
          bge FullPF2
          lda HealthyPF2, x
          sta PF2
          gne DoneHealth

FullPF2:
          lda #$ff
          sta PF2
          txa                   ; ∈ 8…99
          clc
          and #$f8
          ror a                  ; ∈ 4…50
          ror a                  ; ∈ 2…25
          ror a                  ; ∈ 1…12
          tax
          cpx # 8
          bge FullPF1
          lda HealthyPF1, x
          sta PF1
          gne DoneHealth

FullPF1:                        ; ∈ 8…12
          sec
          sbc # 8               ; ∈ 0…4
          tax
          lda #$ff
          sta PF1
          lda HealthyPF2, x
          sta PF0
          ;; fall through

DoneHealth:
          .SkipLines 2
          lda # 0
          sta PF0
          sta PF1
          sta PF2
;;; 
          lda WhoseTurn
          beq PlayerChooseMove

          jmp ScreenDone

PlayerChooseMove:
          jsr Prepare48pxMobBlob

          lda StatusFX
          .BitBit StatusSleep
          beq NotAsleep
Asleep:
          .ldacolu COLORANGE, $e
          sta COLUP0
          sta COLUP1
          .SetPointer SleepsText
          jsr CopyPointerText
          .FarJSR TextBank, ServiceDecodeAndShowText
          jmp ScreenDone

NotAsleep:
          and #StatusMuddle
          beq NotMuddled
Muddled:
          .ldacolu COLGRAY, $e
          sta COLUP0
          sta COLUP1
          .SetPointer MuddleText
          jsr CopyPointerText
          .FarJSR TextBank, ServiceDecodeAndShowText
          lda GameMode
          cmp #ModeCombatDoMove
          beq MoveOK
          jmp ScreenDone

NotMuddled:
          ldx MoveSelection
          bne NotRunAway
          .ldacolu COLRED , $a
          gne ShowSelectedMove

NotRunAway:
          lda BitMask - 1, x
          bit MovesKnown
          beq NotMoveKnown
          .ldacolu COLTURQUOISE, $e
          gne ShowSelectedMove

NotMoveKnown:
          .ldacolu COLGRAY, 0
          ;; fall through
ShowSelectedMove:
          sta COLUP0
          sta COLUP1

          .FarJSR TextBank, ServiceShowMove

UserControls:
          lda NewButtons
          beq ScreenDone
          and #PRESSED
          bne ScreenDone

GoDoMove:
          ldx MoveSelection
          beq RunAway
          dex
          lda BitMask, x
          and MovesKnown
          bne DoUseMove
MoveNotOK:
          lda #SoundBump
          sta NextSound

          gne ScreenDone

DoUseMove:
          ldx MoveTarget
          beq MoveOK
          lda MonsterHP - 1, x
          beq MoveNotOK
MoveOK:
          lda #ModeCombat
          sta GameMode
          lda #SoundChirp
          sta NextSound
          gne CombatAnnouncementScreen

RunAway:
          lda #SoundHappy
          sta NextSound

          lda #ModeMap
          sta GameMode
          .if TV != NTSC
          .SkipLines 19
          .fi
          ;; gne RunningAway
;;; 
ScreenDone:
RunningAway:
          .if TV == NTSC
          .SkipLines 3
          .fi

          lda GameMode
          cmp #ModeCombat
          bne Leave
GoLoop:
          jmp Loop

Leave:
          cmp #ModeCombatDoMove
          beq GoLoop
          cmp #ModeMap
          bne +
          .SkipLines 32
          jmp GoMap
+
          cmp #ModeGrizzardStats
          bne +
          lda #ModeCombat
          sta DeltaY
          .WaitScreenBottom
          jmp GrizzardStatsScreen
+
          cmp #ModeCombatAnnouncement
          beq CombatAnnouncementScreen
          cmp #ModeCombatNextTurn
          beq ExecuteCombatMove.NextTurn
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

SleepsText:
          .MiniText "SLEEPS"
MuddleText:
          .MiniText "MUDDLE"

          .bend
