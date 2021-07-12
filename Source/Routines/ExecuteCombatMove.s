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
          jmp WaitOutScreen     ; TODO

;;; 

MonsterHeals:
          jmp WaitOutScreen     ; TODO

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

PlayerAttackHitCommon:
          sta MoveHP
          ldx MoveTarget
          lda MonsterHP, x
          sec
          sbc MoveHP
          bpl +
          lda # 0               ; zero on negative
+
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

          ;; Any status FX to apply to the player?

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
