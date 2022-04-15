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
          lda # 199
          sta DefenderMaxHP

          jsr GeneralHealing

          ldx WhoseTurn
          lda DefenderHP
          sta EnemyHP - 1, x
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
          lda CombatMajorP
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
          ;; add to score the amount for that monster
          lda GrizzardXP
          cmp # 199
          bge +
          inc GrizzardXP
+

          ldx # 1               ; 1× scoring…
          lda CombatMajorP
          bpl +
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
          sta MoveHP            ; base HP to gain

          lda CurrentHP
          sta DefenderHP
          lda StatusFX
          sta DefenderStatusFX
          lda MaxHP
          sta DefenderMaxHP

          jsr GeneralHealing

          lda DefenderHP
          sta CurrentHP
          lda DefenderStatusFX
          sta StatusFX

          jmp WaitOutScreen

;;; 
GeneralHealing:
          lda MoveHP
          eor #$ff
          sta MoveHP
          jsr CalculateAttackMask

          sta Temp
          jsr Random

          bmi HealsMinusHP

HealsPlusHP:
          and Temp
          clc
          adc MoveHP
          gne HealsCommon

HealsMinusHP:
          and Temp
          sta Temp

          lda MoveHP
          sec
          sbc Temp
          bpl HealsCommon

          lda # 0
HealsCommon:
          sta MoveHP
          ldx WhoseTurn
          clc
          adc DefenderHP
          cmp DefenderMaxHP
          blt +
          lda DefenderMaxHP
+
          sta DefenderHP
          lda MoveHP
          eor #$ff              ; invert the value to mean "gained"
          sta MoveHP

Buff:
          ldx CombatMoveSelected
          lda MoveEffects, x
          sta Temp
          jsr Random

          and Temp
          sta MoveStatusFX
          bit DefenderStatusFX
          beq NoBuff

          ora DefenderStatusFX
          sta DefenderStatusFX
          gne DoneHealing

NoBuff:
          ldy # 0
          sty MoveStatusFX

DoneHealing:
          .mva MoveHitMiss, # 1

          rts
;;; 
WaitOutScreen:
          lda MoveHitMiss
          beq SoundForMiss

          lda #SoundHit
          gne SoundReady

SoundForMiss:
          lda #SoundMiss
SoundReady:
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
