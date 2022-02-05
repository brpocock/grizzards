;;; Grizzards Source/Routines/CombatMainScreen.s
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
          .switch TV

          .case NTSC

            .WaitScreenBottom

          .case PAL

            .WaitScreenBottom
            lda WhoseTurn
            bne NWait0
            .SkipLines 2
            lda MoveSelection
            bne NWait0
            .SkipLines 1
NWait0:
            lda CombatMajorP
            beq +
            stx WSYNC
+

          .case SECAM

            ;; Modified WaitScreenBottom
            .WaitForTimer
            .SkipLines 8
            lda WhoseTurn
            bne +
            stx WSYNC
+
            stx WSYNC
            ;; if not RUN AWAY 
            lda MoveSelection
            bne +
            stx WSYNC
+
            lda MoveTarget
            bne +
            stx WSYNC
+
            lda CombatMajorP
            beq +
            .SkipLines 4
+

            stx WSYNC

            jsr Overscan

          .endswitch

LoopFirst:
          .WaitScreenTopMinus 1, 3
          jsr Prepare48pxMobBlob

          .switch TV
          .case NTSC

            .ldacolu COLRED, 0
            ldx WhoseTurn
            bne +
            .ldacolu COLGRAY, $8
+

          .case PAL

            .ldacolu COLRED, $8
            ldx WhoseTurn
            bne +
            .ldacolu COLGRAY, $8
+
          
          .case SECAM

            lda #COLWHITE
            ldx WhoseTurn
            bne +
            lda #COLBLACK
+

          .endswitch
BGTop:
          sta COLUBK
          .ldacolu COLYELLOW, $f
          sta COLUP0
          sta COLUP1

;;; 
MonstersDisplay:
          lda CurrentCombatEncounter
          cmp # 92              ; Boss Bear encounter
          bne MonsterWithName
BossBearDisplay:
          .SkipLines 20
          .FarJSR StretchBank, ServiceShowBossBear
          .SkipLines 20
          jmp DelayAfterMonsters

MonsterWithName:
          jsr ShowMonsterName

          .if DEMO
            ldy # MonsterColorIndex
            lda (CurrentMonsterPointer), y
            sta COLUP0
            ;; COLUP1 overwritten for “regular” fights but needed for bosses
            sta COLUP1
          .fi

          lda WhoseTurn         ; show highlight on monster moving
          beq +
          sta MoveTarget
+

          lda CombatMajorP
          beq MinorCombatArt
          lda MonsterHP + 1
          ora MonsterHP + 2
          ora MonsterHP + 3
          ora MonsterHP + 4
          ora MonsterHP + 5
          bne MinorCombatArt

MajorCombatArt:
          .FarJSR MonsterBank, ServiceDrawBoss
          jmp DelayAfterMonsters

MinorCombatArt:
          ldy # 0
          sty CombatMajorP
          .FarJSR MonsterBank, ServiceDrawMonsterGroup
DelayAfterMonsters:
          ;; no actual delay now
;;; 
BeginPlayerSection:
          .ldacolu COLBLUE, $f
          sta COLUP0
          sta COLUP1
          lda WhoseTurn
          beq PlayerBGBottom
          .ldacolu COLGRAY, $2
          jmp BGBottom
PlayerBGBottom:
          .if TV == SECAM
            lda #COLMAGENTA
          .else
            .ldacolu COLINDIGO, $4
          .fi
BGBottom:
          stx WSYNC
          sta COLUBK

DrawGrizzardName:
          .FarJSR TextBank, ServiceShowGrizzardName

DrawGrizzard:
          .FarJSR AnimationsBank, ServiceDrawGrizzard
;;; 
DrawHealthBar:
          stx WSYNC

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
          ldy # 0
          sty pp0l
          sty pp1l
          sty pp2l
          cpx # 8
          bge FullPF2
          lda HealthyPF2, x
          sta pp2l
          gne DoneHealth

FullPF2:
          lda #$ff
          sta pp2l
          txa                   ; ∈ 8…99
          and #$f8
          lsr a                  ; ∈ 4…50
          lsr a                  ; ∈ 2…25
          lsr a                  ; ∈ 1…12
          tax
          cpx # 8
          bge FullPF1
          lda HealthyPF1, x
          sta pp1l
          gne DoneHealth

FullPF1:                        ; ∈ 8…12
          sec
          sbc # 8               ; ∈ 0…4
          tax
          lda #$ff
          sta pp1l
          lda HealthyPF2, x
          sta pp0l
          ;; fall through

DoneHealth:
          stx WSYNC
          lda pp0l
          sta PF0
          lda pp1l
          sta PF1
          lda pp2l
          sta PF2
          .SkipLines 4
          ldy # 0
          sty PF0
          sty PF1
          sty PF2
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
          gne ScreenDone

NotMuddled:
          ldx MoveSelection
          bne NotRunAway

          .ldacolu COLRED, $a
          gne ShowSelectedMove

NotRunAway:
          stx WSYNC

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
          stx WSYNC
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
          lda #SoundBlip
          sta NextSound
          gne CombatAnnouncementScreen

RunAway:
          lda #SoundHappy
          sta NextSound

          lda #ModeMap
          sta GameMode

          .switch TV
          .case PAL
            .SkipLines 17
          .case SECAM
            .SkipLines 19
          .endswitch
;;; 
ScreenDone:

          lda GameMode
          cmp #ModeCombat
          bne Leave

GoLoop:
          jmp Loop

Leave:
          cmp #ModeCombatDoMove
          beq GoLoop
          cmp #ModeMap
          bne NotGoingToMap

          .switch TV
          .case PAL,SECAM
            .SkipLines 32
          .case NTSC
            .SkipLines 31
          .endswitch
          jmp GoMap

NotGoingToMap:
          cmp #ModeGrizzardStats
          bne NotGoingToStats

          lda #ModeCombat
          sta DeltaY
          .WaitScreenBottom
          .if NTSC != TV
          .SkipLines 5
          .fi
	jmp GrizzardStatsScreen

NotGoingToStats:
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
