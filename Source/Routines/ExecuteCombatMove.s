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
          beq +
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
          ;; .A has the inverted HP to be gained
          ;; (alter by random factor)
          eor #$ff
          sta MoveHP
          jsr CalculateAttackMask

          sta Temp
          jsr Random

          bmi MonsterHealsMinusHP

MonsterHealsPlusHP:
          and Temp
          clc
          adc MoveHP
          sta MoveHP
          gne MonsterHealsCommon

MonsterHealsZero:
          ldy # 0
          sty MoveHP
          geq MonsterHealsCommon

MonsterHealsMinusHP:
          and Temp
          sta Temp
          cmp MoveHP
          bge MonsterHealsZero

          lda MoveHP
          sec
          sbc Temp
          bpl MonsterHealsCommon

          lda # 0

MonsterHealsCommon:
          ldx WhoseTurn
          clc
          adc EnemyHP - 1, x
          cmp # 199
          blt +
          lda # 199
+
          sta EnemyHP - 1, x
          lda MoveHP
          eor #$ff              ; negate the value to mean "gained"
          sta MoveHP

MonsterBuff:
          ldx CombatMoveSelected
          lda MoveEffects, x
          sta Temp
          jsr Random

          and Temp
          sta MoveStatusFX

          ldx WhoseTurn
          ora EnemyStatusFX - 1, x
          sta EnemyStatusFX - 1, x

          .mva MoveHitMiss, # 1

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
          lda CombatMajorP
          beq +
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
          ;; add to score the amount for that monster
          lda GrizzardXP
          cmp # 199
          bge +
          inc GrizzardXP
+

          ldx # 1               ; 1× scoring…
          lda CombatMajorP
          beq +
          inx                   ; 2 × scoring
+

          lda Potions
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
          sta Score +1
          bcc ScoreNoCarry

          inc Score + 2
          bne ScoreNoCarry

          lda #$99
          sta Score + 1
          sta Score + 2
          sta Score
ScoreNoCarry:

          dex
          bne IncrementScore

          cld

RandomLearn:
          ;; Player has a small chance of learning a random move here
          jsr Random
          sta Temp
          and #$30              ; 1:4 odds
          bne DoneRandomLearn

          lda #$07
          and Temp
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
          lda # 0               ; zero on negative

          jmp WaitOutScreen
;;; 
PlayerHeals:
          ;; .A has the inverted HP to be gained
          ;; (alter by random factor)
          eor #$ff
          sta MoveHP
          jsr CalculateAttackMask

          sta Temp
          jsr Random

          bmi PlayerHealsMinusHP

PlayerHealsPlusHP:
          and Temp
          clc
          adc MoveHP
          sta MoveHP
          gne PlayerHealsCommon

PlayerHealsMinusHP:
          and Temp
          sta Temp
          lda MoveHP
          sec
          sbc Temp
          bpl PlayerHealsCommon

          lda # 0
PlayerHealsCommon:
          clc
          adc CurrentHP
          cmp MaxHP
          blt +
          lda MaxHP
+
          sta CurrentHP
          lda #$ff              ; negate the value to mean "gained"
          eor MoveHP
          sta MoveHP
PlayerBuff:
          ldx CombatMoveSelected
          .mva MoveHitMiss, # 1

          lda MoveEffects, x
          sta Temp
          jsr Random

          and Temp
          sta MoveStatusFX
          ora StatusFX
          sta StatusFX
          ;;  fall through
;;; 
WaitOutScreen:
          lda MoveHitMiss
          beq SoundForMiss

          lda #SoundHit
          gne +
SoundForMiss:
          lda #SoundMiss
+
          sta NextSound

          .WaitScreenBottom
          .if TV != NTSC
            stx WSYNC
          .fi
;;; 
          .FarJSR TextBank, ServiceCombatOutcome
;;; 
          .WaitScreenTop

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

          bpl NextTurn

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
          cmp #8
          blt CheckMove

DidNotLearn:
          jmp NextTurn

AfterTryingToLearn:
          ;; Move number is still in Temp from above
          ;; … which is the input for ServiceLearntMove
          .FarJSR MapServicesBank, ServiceLearntMove
;;; 
NextTurn:
          inc WhoseTurn
          ldx WhoseTurn
          dex
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
