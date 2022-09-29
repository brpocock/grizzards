;;; Grizzards Source/Routines/ExecuteCombatMove.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

ExecuteCombatMove:  .block
          ;; Draw one blank frame whilst we do arithmetic
          ;; These calculations take a variable amount of time

          .WaitScreenTopMinus 2, 0

          ldy # 0
          sty MoveHP
          sty MoveHitMiss
          sty MoveStatusFX
          sty CriticalHitP

DetermineOutcome:
          lda WhoseTurn
          beq PlayerMove
;;; 
MonsterMove:
          lda CombatMoveDeltaHP
          bmi MonsterHeals

MonsterAttacks:
          ldy #MonsterAttackIndex
          lda (CurrentMonsterPointer), y
          sta AttackerAttack
          ldx WhoseTurn
          lda EnemyStatusFX - 1, x
          and #StatusAttackDown
          beq +
          lsr AttackerAttack
+
          lda EnemyStatusFX - 1, x
          and #StatusAttackUp
          beq +
          asl AttackerAttack
+

          ;; Bosses get double attack ratings
          lda CombatMajorP
          bpl +
          asl AttackerAttack
+

          ;; Crowned players, double attack as well
          bit Potions
          bpl +
          asl AttackerAttack
+

          .mva DefenderDefend, GrizzardDefense
          lda StatusFX
          and #StatusDefendUp
          beq +
          asl DefenderDefend
+
          lda StatusFX
          and #StatusDefendDown
          beq +
          lsr DefenderDefend
+

          .mva DefenderHP, CurrentHP
          .mva DefenderStatusFX, StatusFX

          jsr CoreAttack

          .mva CurrentHP, DefenderHP
          .mva StatusFX, DefenderStatusFX

          jmp WaitOutScreen
;;; 
MonsterHeals:
          sta MoveHP

          lda EnemyHP - 1, x
          sta DefenderHP
          lda EnemyStatusFX - 1, x
          sta DefenderStatusFX
          .mva DefenderMaxHP, MonsterMaxHP

          jsr CoreHealing

          ldx WhoseTurn
          lda DefenderHP
          beq +                 ; HACK (see comment below) #479
          ;; I cannot figure out why, but once in a while a monster tries to
          ;; heal and fails (AtariVox says “MISSED”) and then ends up with
          ;; zero health, without having been killed, and throws everything
          ;; out of whack. I'm out of ideas, so I'm applying a band-aid.
          sta EnemyHP - 1, x
+
          lda DefenderStatusFX
          sta EnemyStatusFX - 1, x

          jmp WaitOutScreen
;;; 
PlayerMove:
          lda CombatMoveDeltaHP
          bmi PlayerHeals

PlayerAttacks:
          ldx GrizzardAttack
          stx AttackerAttack
          lda StatusFX
          .BitBit StatusAttackDown
          beq +
          lsr AttackerAttack
+
          lda StatusFX
          .BitBit StatusAttackUp
          beq +
          asl AttackerAttack
+

          ldx MoveTarget
          lda EnemyHP - 1, x
          sta DefenderDefend

          lda EnemyStatusFX - 1, x
          sta DefenderStatusFX

          .BitBit StatusDefendDown
          beq +
          lsr DefenderDefend
+
          lda DefenderStatusFX
          and #StatusDefendUp
          beq +
          asl DefenderDefend
+

          ;; Bosses get double defend ratings
          bit CombatMajorP
          bpl +
          asl DefenderDefend
+

          ;; Crown mode double defend ratings
          bit Potions
          bpl +
          asl DefenderDefend
+

          lda EnemyHP - 1, x
          sta DefenderHP

          jsr CoreAttack

          ldx MoveTarget
          lda DefenderStatusFX
          sta EnemyStatusFX - 1, x

          lda DefenderHP
          sta EnemyHP - 1, x

          bne WaitOutScreen

PlayerKilledMonster:
          inc GrizzardXP

          ;; add to score the amount for that monster
          ldx # 1               ; 1× scoring…
          bit CombatMajorP
          bpl +
          inx                   ; 2 × scoring
+

          bit Potions
          bpl +
          inx                   ; 2-3× scoring
+

          lda DebounceSWCHB
          and #SWCHBP0Advanced
          bne DoneScoreDifficulty

          inx
DoneScoreDifficulty:
          sed

IncrementScore:
          ldy # MonsterPointsIndex
          lda (CurrentMonsterPointer), y
          clc
          adc Score
          sta Score
          iny                   ; MonsterPointsIndex + 1
          lda (CurrentMonsterPointer), y
          adc Score + 1
          sta Score + 1
          bcc ScoreNoCarry2

          lda Score + 2
          adc # 0
          bcc ScoreNoCarry

          lda #$99
          sta Score
          sta Score + 1
ScoreNoCarry:
          sta Score + 2
ScoreNoCarry2:
          dex
          bne IncrementScore

          cld

RandomLearn:
          ;; Player has a small chance of learning a random move here
          jsr Random
          sta Temp
          and #$30              ; 1:4 odds
          bne DoneRandomLearn

          lda Temp
          and #$07
          tax
          lda BitMask, x
          ora MovesKnown
          cmp MovesKnown
          beq DoneRandomLearn   ; already knew that move

DidRandomLearn:
          sta MovesKnown

          inx
          stx MoveSelection
          .FarJSR TextBank, ServiceFetchGrizzardMove
          ;; Return value is in Temp, which is input for LearntMove
          .FarJSR MapServicesBank, ServiceLearntMove

DoneRandomLearn:
          ldx INTIM
          dex
          .if SECAM == TV
            dex
          .fi
          stx TIM64T
          .WaitScreenBottom
          .if PAL == TV
            stx WSYNC
          .fi
          lda # 0               ; zero on negative — XXX unused?
          jmp GoToOutcome
;;; 
PlayerHeals:
          ;; .A has the inverted HP to be gained
          ;; (alter by random factor)
          sta MoveHP            ; base HP to gain

          lda CurrentHP
          sta DefenderHP
          lda StatusFX
          sta DefenderStatusFX
          lda MaxHP
          sta DefenderMaxHP

          jsr CoreHealing

          lda DefenderHP
          sta CurrentHP
          lda DefenderStatusFX
          sta StatusFX

          ;; jmp WaitOutScreen ; fall through
;;; 
WaitOutScreen:
          .switch TV
          .case PAL,SECAM
            stx WSYNC
            lda WhoseTurn
            beq +
            stx WSYNC
+
          .endswitch
          .WaitScreenBottom
;;; 
GoToOutcome:
          .FarJSR TextBank, ServiceCombatOutcome
;;; 
          .WaitScreenTop
TryToLearnMove:
          ;; If this was a monster's move, could the player learn that move?
          lda WhoseTurn
          beq NextTurn

          .mva pp1h, # 1        ; using this as our loop counter

CheckMove:
          sta MoveSelection
          .FarJSR TextBank, ServiceFetchGrizzardMove

          lda Temp
          cmp CombatMoveSelected
          bne CheckNextMove

          sta pp1l              ; Move number

          jsr Random            ; 50/50 chance of learning

          bpl DidNotLearn

          ldx pp1h              ; Loop index
          dex                   ; bit index of move to learn
          lda BitMask, x
          ora MovesKnown
          cmp MovesKnown
          beq DidNotLearn       ; already know this move

LearntMove:
          sta MovesKnown
          gne AfterTryingToLearn

CheckNextMove:
          inc pp1h              ; loop counter
          lda pp1h
          cmp # 8
          blt CheckMove

DidNotLearn:
          .if SECAM == TV
            .SkipLines 2
          .fi
          jmp NextTurn

AfterTryingToLearn:
          ;; Move number is still in Temp from above
          ;; … which is the input for ServiceLearntMove
          .FarJSR MapServicesBank, ServiceLearntMove
;;; 
NextTurn:
          ldx WhoseTurn
          inc WhoseTurn
          cpx # 6
          bne NotLastMonster

          ldx # 0
          stx WhoseTurn
          jmp CombatMainScreen.BackToPlayer

NotLastMonster:
          lda EnemyHP, x
          beq NextTurn

          .mva AlarmCountdown, # 6
BackToMain:
          jmp CombatMainScreen
;;; 
          .bend
