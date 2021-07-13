;;; Grizzards Source/Common/ExecuteCombatMove.s
;;; Copyright © 2021 Bruce-Robert Pocock

ExecuteCombatMove:  .block

          jsr Overscan
          ;; Draw one blank frame whilst we do arithmetic
          ;; These calculations take a variable amount of time

          .WaitScreenTop

DetermineOutcome:
          lda WhoseTurn
          beq PlayerMove

MonsterMove:
          ldx CombatMoveSelected
          lda MonsterMoves, x
          tax
          lda MoveDeltaHP, x
          bmi MonsterHeals

;;; 

MonsterAttacks:
          ldy # 14              ; ATK/DEF
          lda (CurrentMonsterPointer), y
          and #$f0
          ror a
          ror a
          ror a
          ror a
          tax
          lda LevelTable, x
          tay
          ldx WhoseTurn
          dex
          lda EnemyStatusFX, x
          and #StatusAttackDown
          beq +
          tya
          ror a
          tay
+
          lda EnemyStatusFX, x
          and #StatusAttackUp
          beq +
          tya
          asl a
          tay
+
          tya
          sta MoveHP            ; temporarily effective Attack score
          jsr CalculateAttackMask
          sta Temp
          jsr Random
          bmi MonsterAttackNegativeRandom

          and Temp
          clc
          adc MoveHP            ; temporarily effective Attack score
          bne MonsterAttackHitMissP ;always taken

MonsterAttackNegativeRandom:
          and Temp
          sta Temp
          ldy # 14
          lda (CurrentMonsterPointer), y
          and #$f0
          ror a
          ror a
          ror a
          ror a
          tax
          lda LevelTable, x
          sec
          sbc Temp
          ;; fall through

MonsterAttackHitMissP:
          tax                   ; stash effective attack strength
          cmp GrizzardDefense
          blt MonsterAttackMiss
          ;; fall through

;;; 

MonsterAttackHit:
          ;; The attack was a success
          ;; What's the effect on the Grizzard's HP?
          lda CombatMoveDeltaHP
          jsr CalculateAttackMask
          sta Temp
          jsr Random
          bmi MonsterAttackHitMinus
MonsterAttackHitPlus:
          and Temp
          clc
          adc CombatMoveDeltaHP
          bne MonsterAttackHitCommon ; always taken

MonsterAttackHitMinus:
          and Temp
          sta Temp
          lda CombatMoveDeltaHP
          sbc Temp
          ;; fall through

MonsterAttackHitCommon:
          sta MoveHP
          lda CurrentHP
          sec
          sbc MoveHP
          bpl +
          lda # 0               ; zero on negative
+
          sta CurrentHP

          ;; OK, also, what is the effect on the player's status?
          jsr Random
          ldx CombatMoveSelected
          and MoveEffects, x
          jsr FindHighBit
          beq MonsterAttackNoStatusFX

MonsterAttackSetsStatusFX:
          and StatusFX
          bne MonsterAttackNoStatusFX
          sta MoveStatusFX
          ora StatusFX
          sta StatusFX

MonsterAttackNoStatusFX:
          lda # 1
          sta MoveHitMiss

          jmp WaitOutScreen

;;; 

MonsterAttackMiss:
          lda # 0
          sta MoveHP
          sta MoveHitMiss
          sta MoveStatusFX

          jmp WaitOutScreen

;;; 

MonsterHeals:
          ;; .A has the negative HP to be gained
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
          bne MonsterHealsCommon ; always taken

MonsterHealsMinusHP:
          and Temp
          sta Temp
          lda MoveHP
          sec
          sbc Temp
          ;; fall through

MonsterHealsCommon:
          ldx WhoseTurn
          dex
          clc
          adc MonsterHP, x
          cmp # 99
          blt +
          lda # 99
+
          sta MonsterHP, x
          lda MoveHP
          eor #$ff              ; negate the value to mean "gained"
          sta MoveHP

          ;; TODO Any status FX to apply to the monster?

;;; 

PlayerMove:
          ldx CombatMoveSelected
          lda MoveDeltaHP, x
          sta CombatMoveDeltaHP
          bmi PlayerHeals

PlayerAttacks:
          ldx GrizzardAttack
          lda StatusFX
          and #StatusAttackDown
          beq +
          txa
          ror a
          tax
+
          lda StatusFX
          and #StatusAttackUp
          beq +
          txa
          asl a
          tax
+
          txa
          sta MoveHP            ; temporarily effective Attack score
          jsr CalculateAttackMask
          sta Temp
          jsr Random
          bmi PlayerAttackNegativeRandom

          and Temp
          clc
          adc MoveHP               ; temporarily effective Attack score
          bne PlayerAttackHitMissP ; always taken

PlayerAttackNegativeRandom:
          and Temp
          sta Temp
          lda GrizzardAttack
          sec
          sbc Temp
          ;; fall through
PlayerAttackHitMissP:
          tax                   ; stash effective attack strength
          ldy # 14              ; ATK/DEF of monster
          lda (CurrentMonsterPointer), y
          and #$0f              ; DEF class
          tay
          lda LevelTable, y     ; effective defend value
          sta Temp
          txa
          cmp Temp
          blt PlayerAttackMiss
          ;; fall through

;;; 

PlayerAttackHit:
          ;; The attack was a success!
          ;; What is the effect on the enemy's HP?
          lda CombatMoveDeltaHP
          jsr CalculateAttackMask
          sta Temp
          jsr Random
          bmi PlayerAttackHitMinus
PlayerAttackHitPlus:
          and Temp
          clc
          adc CombatMoveDeltaHP
          bne PlayerAttackHitCommon ; always taken

PlayerAttackHitMinus:
          and Temp
          sta Temp
          lda CombatMoveDeltaHP
          sbc Temp
          ;; fall through
PlayerAttackHitCommon:
          sta MoveHP
          ldx MoveTarget
          lda MonsterHP, x
          sec
          sbc MoveHP
          bpl PlayerDidNotKillMonster

          ;; add to score the amount for that monster
          ldy # 15              ; score value
          lda (CurrentMonsterPointer) ,y
          sed
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
          sta Score
          sta Score + 1
          sta Score + 2
ScoreNoCarry:
          sta Score

          cld

          lda # 0               ; zero on negative
          ;; fall through
PlayerDidNotKillMonster:
          sta MonsterHP, x

          ;; OK, also, what is the effect on the enemy's status?
          jsr Random
          ldx CombatMoveSelected
          and MoveEffects, x
          jsr FindHighBit
          beq PlayerAttackNoStatusFX

PlayerAttackSetsStatusFX:
          ldx MoveTarget
          tay
          and EnemyStatusFX, x
          bne PlayerAttackNoStatusFX ; they already have that status
          tya
          sta MoveStatusFX
          ora EnemyStatusFX, x
          sta EnemyStatusFX, x

PlayerAttackNoStatusFX:
          lda # 1
          sta MoveHitMiss

          jmp WaitOutScreen

;;; 

PlayerAttackMiss:
          lda # 0
          sta MoveHP
          sta MoveHitMiss
          sta MoveStatusFX

          jmp WaitOutScreen

;;; 

PlayerHeals:
          ;; .A has the negative HP to be gained
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
          bne PlayerHealsCommon ; always taken

PlayerHealsMinusHP:
          and Temp
          sta Temp
          lda MoveHP
          sec
          sbc Temp
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

          ;; TODO Any status FX to apply to the player?

;;; 

WaitOutScreen:
          .WaitScreenBottom

          jmp CombatOutcomeScreen

;;; 

;;; XXX These two routines are nearly identical
;;; is it worth it to factor out a common prefix subroutine?

FindHighBit:
          tay
          ldx # 7
-
          tya
          and BitMask, x
          bne +
          dex
          bne -
          lda # 0
          rts
+
          lda BitMask, x        ; the only line that differs
          rts

CalculateAttackMask:
          tay
          ldx # 7
-
          tya
          and BitMask, x
          bne +
          dex
          bne -
          lda # 0
          rts
+
          lda AttackMask, x     ; the only line that differs
          rts

          .bend
;;; 

AttackMask:
          .byte %011111111
          .byte %00111111
          .byte %00011111
          .byte %00001111
          .byte %00000111
          .byte %00000011
          .byte %000000001
          .byte %00000000
          .byte %00000000

LevelTable:
          ;; monsters have levels 0…$b for each of their stats
          ;; this table maps those to actual values
          .byte 1, 2, 5, 10,  15, 25, 35, 50
          .byte 60, 70, 80, 90, 99, 99, 99, 99
