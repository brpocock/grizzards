;;; Grizzards Source/Routines/ExecuteCombatMove.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

ExecuteCombatMove:  .block
          ;; Draw one blank frame whilst we do arithmetic
          ;; These calculations take a variable amount of time

          .WaitScreenTopMinus 2, 0

          lda # 0
          sta MoveHP
          sta MoveHitMiss
          sta MoveStatusFX
          sta CriticalHitP

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
          tay                   ; Attack score
          ldx WhoseTurn
          lda EnemyStatusFX - 1, x
          and #StatusAttackDown
          beq +
          tya
          lsr a
          tay
+
          lda EnemyStatusFX - 1, x
          and #StatusAttackUp
          beq +
          tya
          asl a
          tay
+

          ;; Bosses get double attack scores
          lda CombatMajorP
          beq +
          tya
          asl a
          tay
+

          ;;  TODO #359 crown mode double attack scores

          sty AttackerAttack

          lda GrizzardDefense
          tay
          lda StatusFX
          and #StatusDefendUp
          beq +
          tya
          asl a
          tay
+
          lda StatusFX
          and #StatusDefendDown
          beq +
          tya
          lsr a
          tay
+
          sty DefenderDefend

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
          ;; fall through
MonsterHealsPlusHP:
          and Temp
          clc
          adc MoveHP
          sta MoveHP
          gne MonsterHealsCommon

MonsterHealsZero:
          lda # 0
          sta MoveHP
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
          ;; fall through
MonsterHealsCommon:
          ldx WhoseTurn
          clc
          adc MonsterHP - 1, x
          cmp # 199
          blt +
          lda # 199
+
          sta MonsterHP - 1, x
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

          lda # 1
          sta MoveHitMiss

          jmp WaitOutScreen
;;; 
PlayerMove:
          lda CombatMoveDeltaHP
          bmi PlayerHeals

PlayerAttacks:
          ldx GrizzardAttack
          lda StatusFX
          .BitBit StatusAttackDown
          beq +
          txa
          ror a
          tax
+
          lda StatusFX
          .BitBit StatusAttackUp
          beq +
          txa
          asl a
          tax
+
          txa
          sta AttackerAttack

          ldx MoveTarget
          lda EnemyStatusFX - 1, x
          sta DefenderStatusFX

          and #StatusDefendDown
          beq +
          tya
          lsr a
          tay
+
          lda DefenderStatusFX
          and #StatusDefendUp
          beq +
          tya
          asl a
          tay
+

          ;; Bosses get double defend scores
          lda CombatMajorP
          beq +
          tya
          asl a
          tay
+

          ;; Crown mode TODO #359 double defend scores

          sty DefenderDefend

          lda MonsterHP - 1, x
          sta DefenderHP

          jsr CoreAttack

          ldx MoveTarget
          lda DefenderStatusFX
          sta EnemyStatusFX - 1, x

          lda DefenderHP
          sta MonsterHP - 1, x

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

          sed

IncrementScore:
          ldy # MonsterPointsIndex
          lda (CurrentMonsterPointer), y
          clc
          adc Score
          bcc ScoreNoCarry
          clc
          inc Score + 1
          bcc ScoreNoCarry
          clc
          inc Score + 2
          bcc ScoreNoCarry
          lda #$99
          sta Score + 1
          sta Score + 2
ScoreNoCarry:
          sta Score

          iny                   ; MonsterPointsIndex + 1
          lda (CurrentMonsterPointer), y
          clc
          adc Score + 1
          bcc ScoreNoCarry2
          clc
          inc Score + 2
          bcc ScoreNoCarry2
          lda #$99
          sta Score
          sta Score + 2
ScoreNoCarry2:
          sta Score + 1

          dex
          bne IncrementScore

          cld

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
          ;; fall through
PlayerHealsCommon:
          clc
          adc CurrentHP
          cmp MaxHP
          blt +
          lda MaxHP
+
          sta CurrentHP
          lda MoveHP
          eor #$ff              ; negate the value to mean "gained"
          sta MoveHP

PlayerBuff:
          ldx CombatMoveSelected
          lda # 1
          sta MoveHitMiss

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

          lda #1
          sta pp1h        ; using this as our loop counter

CheckMove:
          sta MoveSelection
          .FarJSR TextBank, ServiceFetchGrizzardMove
          lda Temp
          cmp CombatMoveSelected
          bne CheckNextMove

          sta pp1l
          jsr Random
          and #$01
          bne DidNotLearn

          ldx pp1h
          dex                   ; bit index of move to learn
          lda BitMask, x
          bit MovesKnown
          bne DidNotLearn       ; already know this move
LearntMove:
          ora MovesKnown
          sta MovesKnown
          ldy # 1
          gne AfterTryingToLearn

CheckNextMove:
          inc pp1h
          lda pp1h
          cmp #8
          blt CheckMove
          ;; fall through
DidNotLearn:
          ldy # 0

AfterTryingToLearn:
          cpy # 0
          beq NextTurn

          lda pp1l
          sta Temp
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
          lda MonsterHP, x
          beq NextTurn

          lda # 6
          sta AlarmCountdown
BackToMain:
          jmp CombatMainScreen
;;; 

CoreAttack:
          jsr Random
          and #$0f
          beq CriticalHit

          lda AttackerAttack
          jsr CalculateAttackMask
          sta Temp
          jsr Random
          bmi NegativeRandom
PositiveRandom:
          and Temp
          clc
          adc AttackerAttack
          jmp HitMissP

CriticalHit:
          lda CombatMoveDeltaHP
          sta CriticalHitP
          asl a
          gne AttackHit

NegativeRandom:
          and Temp
          sta Temp
          lda AttackerAttack
          sec
          sbc Temp
          bpl HitMissP
          lda # 0

HitMissP:
          sta AttackerAttack
          cmp DefenderDefend
          blt AttackMiss

AttackHit:
          lda CombatMoveDeltaHP
AttackHit1:
          jsr CalculateAttackMask
          sta Temp
          jsr Random
          bmi HitMinus
HitPlus:
          and Temp
          clc
          adc CombatMoveDeltaHP
          gne HitCommon

AttackMiss:
          lda CombatMoveDeltaHP
          lsr a
          bne AttackHit1

          sta MoveHP
          sta MoveHitMiss
          rts

HitMinus:
          and Temp
          sta Temp
          lda CombatMoveDeltaHP
          sec
          sbc Temp
          bpl HitCommon

          lda # 0

HitCommon:
          sta MoveHP
          lda DefenderHP
          cmp MoveHP
          beq KilledDefender
          blt KilledDefender

DidNotKill:
          ;; sec — BLT = BCC, so carry is set here
          sbc MoveHP
          sta DefenderHP
          jsr Random
          ldx CombatMoveSelected
          and MoveEffects, x
          jsr FindHighBit
          beq NoStatusFX

SetStatusFX:
          tay
          bit DefenderStatusFX
          bne NoStatusFX
          sta MoveStatusFX
          ora DefenderStatusFX
          sta DefenderStatusFX

NoStatusFX:
          lda # 1
          sta MoveHitMiss
          rts

KilledDefender:
          lda # 0
          sta DefenderHP
          sta DefenderStatusFX
          geq NoStatusFX

;;; 
          .bend
