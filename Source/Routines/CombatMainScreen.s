;;; Grizzards Source/Routines/CombatMainScreen.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CombatMainScreen:   .block

BackToPlayer:
          .mva MoveSelection, LastPlayerCombatMove
          .mva GameMode, #ModeCombat
          .mva AlarmCountdown, # 4

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
          lda EnemyHP, x
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
            bpl +
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
            bpl +
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

          .mva DeltaY, #ModeCombat
          .WaitScreenBottom
          .if NTSC != TV
            .SkipLines 5
          .fi
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

MaybeReadyToAnnounce:
          beq Announce

          jsr FindMonsterMove
          lda MoveDeltaHP, x
          bpl Announce

          ;; It's a healing move, are we sure?
          ldx WhoseTurn
          lda EnemyHP - 1, x
          cmp MonsterMaxHP
          blt Announce

          lda #ModeCombat
          sta GameMode
          jmp Loop

Announce:
          ;; falls through to CombatAnnouncementScreen
          
          .bend
