;;; Grizzards Source/Routines/CombatMainScreen.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CombatMainScreen:   .block

BackToPlayer:
          .mva MoveSelection, LastPlayerCombatMove
          .mva AlarmCountdown, # 4
MonsterThwarted:
          ;; The  MonsterThwarted entry  point  is used  when a  monster
	;; thinks  it wants  to choose  a healing  move, but  it has  not
	;; actually been injured yet.
          .mva GameMode, #ModeCombat

          lda StatusFX
          .BitBit StatusSleep
          beq NotAsleep1

          .SetUtterance Phrase_Sleeping

NotAsleep1:
          and #StatusMuddle
          beq NotMuddled1

          .SetUtterance Phrase_Muddled

NotMuddled1:

FindPlayerMove:
          .FarJSR TextBank, ServiceFetchGrizzardMove

          .mvx CombatMoveSelected, Temp
MoveFound:
          lda MoveDeltaHP, x
          sta CombatMoveDeltaHP

          ldx # 0

          lda CombatMoveDeltaHP
          bmi GotTarget

          ;; copied into CombatVBlank also
TargetFirstMonster:
-
          lda EnemyHP, x
          bne TargetFirst

          inx
          cpx # 5
          bne -

TargetFirst:
          inx
GotTarget:
          stx MoveTarget

          .WaitScreenBottom

          jmp LoopFirst
;;; 
Loop:
          .switch TV

          .case NTSC

            .WaitScreenBottom

          .case PAL

            ldx WhoseTurn
            beq +

            ;; skip a few lines because it's the monsters' turn
            ;; (no, this doesn't make any sense)
            lda INTIM
            sec
            sbc # 5
            sta TIM64T
+
            .WaitScreenBottom
            stx WSYNC
            stx WSYNC

          .case SECAM

            ;; Modified WaitScreenBottom
            .WaitForTimer
            lda AlarmCountdown
            bne +
            stx WSYNC
+
            stx WSYNC
            jsr Overscan

          .endswitch

LoopFirst:
          .WaitScreenTopMinus 1, 0
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
          bpl MinorCombatArt

          ;; XXX this check should not be necessary but is here for bug #409
          ;; it prevents an unwinnable boss fight where monsters 2+ exist.
          lda EnemyHP + 1
          ora EnemyHP + 2
          ora EnemyHP + 3
          ora EnemyHP + 4
          ora EnemyHP + 5
          bne MinorCombatArt

MajorCombatArt:
          .FarJSR MonsterBank, ServiceDrawBoss

          jmp DelayAfterMonsters

MinorCombatArt:
          .mvy CombatMajorP, # 0      ; should have already been the case, but bugs are buggy.
          ;; I don't know why this is sometimes set.
          ;; XXX once #409 is closed maybe the prior 2 lines can go
          .FarJSR MonsterBank, ServiceDrawMonsterGroup

DelayAfterMonsters:
          .if SECAM == TV
            stx WSYNC
          .fi
;;; 
BeginPlayerSection:
          .ldacolu COLBLUE, $f
          sta COLUP0
          sta COLUP1
          .ldacolu COLGRAY, $2
          ldx WhoseTurn
          bne BGBottom

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

          .if SECAM == TV       ; XXX no color for SECAM due to space limits!
            .ldacolu COLGREEN, $f
            sta COLUPF
          .else
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
          .fi

DrawHealthPF:
          ldy # 0               ; XXX necessary?
          sty pp0l
          sty pp1l
          sty pp2l
          cpx # 8
          bge FullPF2

          lda HealthyPF2, x
          sta pp2l
          gne ReadyHealth

FullPF2:
          .mva pp2l, #$ff
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
          gne ReadyHealth

FullPF1:                        ; ∈ 8…12
          sec
          sbc # 8               ; ∈ 0…4
          tax
          .mva pp1l, #$ff
          lda HealthyPF2, x
          sta pp0l
          ;; fall through

ReadyHealth:
          stx WSYNC
          .mva PF0, pp0l
          .mva PF1, pp1l
          .mva PF2, pp2l
          .SkipLines 3
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

          .switch TV
          .case NTSC, SECAM
            .ldacolu COLTURQUOISE, $e
          .case PAL
            .ldacolu COLTURQUOISE, $8
          .endswitch
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

          and #ButtonI
          bne ScreenDone

GoDoMove:
          ldx MoveSelection
          beq RunAway

          dex
          lda BitMask, x
          and MovesKnown
          bne DoUseMove

MoveNotOK:
          .mva NextSound, #SoundBump
          gne ScreenDone

DoUseMove:
          ldx MoveTarget
          beq MoveOK

          lda EnemyHP - 1, x
          beq MoveNotOK

MoveOK:
          .mva LastPlayerCombatMove, MoveSelection
          .mva GameMode, #ModeCombat
          .mva NextSound, #SoundBlip
          gne CombatAnnouncementScreen

RunAway:
          .mva NextSound, #SoundHappy
          .mva GameMode, #ModeMap

          .switch TV
          .case NTSC

            stx WSYNC

          .case PAL

            .SkipLines 18

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
	
            .SkipLines 30

          .case NTSC

            .SkipLines 31
	
          .endswitch
          jmp GoMap

NotGoingToMap:
          cmp #ModeGrizzardStats
          bne NotGoingToStats

          .mva DeltaY, #ModeCombat
          .WaitScreenBottom
          .switch TV
          .case NTSC
            ;; no op
          .case SECAM
            .SkipLines 5
          .case PAL
            .SkipLines 2
          .endswitch
	jmp GrizzardStatsScreen

NotGoingToStats:
          cmp #ModeCombatAnnouncement
          beq MaybeReadyToAnnounce

          cmp #ModeCombatNextTurn
          beq ExecuteCombatMove.NextTurn

          ;; brk ; same as $00 in the next byte
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
;;; 
MaybeReadyToAnnounce:
          ldx WhoseTurn
          beq Announce

          ldy MoveSelection
          jsr FindMonsterMove
          lda MoveDeltaHP, x
          bpl Announce

          ;; It's a healing move, are we sure?
          ldx WhoseTurn
          lda EnemyHP - 1, x
          cmp MonsterMaxHP
          blt CombatAnnouncementScreen

          jmp MonsterThwarted

Announce:
          ;; falls through to CombatAnnouncementScreen
          stx WSYNC
          
          .bend
