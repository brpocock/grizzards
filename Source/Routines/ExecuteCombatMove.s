;;; Grizzards Source/Common/ExecuteCombatMove.s
;;; Copyright © 2021 Bruce-Robert Pocock

ExecuteCombatMove:  .block

          ;; CombatMainScreen jumps in here without doing its own overscan yet
          jsr Overscan
          ;; Draw one blank frame whilst we do arithmetic
          ;; These calculations take a variable amount of time

          .WaitScreenTop

          lda # 0
          sta MoveHP
          sta MoveHitMiss
          sta MoveStatusFX

DetermineOutcome:
          lda WhoseTurn
          beq PlayerMove

;;; 

MonsterMove:
          ldx CombatMoveSelected
          lda MoveDeltaHP, x
          sta CombatMoveDeltaHP
          bmi MonsterHeals

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
          tay                   ; Attack score
          ldx WhoseTurn
          lda EnemyStatusFX - 1, x
          and #StatusAttackDown
          beq +
          tya
          ror a
          tay
+
          lda EnemyStatusFX - 1, x
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
MonsterAttackPositiveRandom:
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
          cmp MoveHP
          beq MonsterKilledGrizzard
          blt MonsterKilledGrizzard
          sec
          sbc MoveHP
          sta CurrentHP
          bne MonsterDidNotKillGrizzard ; always taken

MonsterKilledGrizzard:
          lda # 0
          sta CurrentHP
          beq MonsterAttackNoStatusFX ; always taken

MonsterDidNotKillGrizzard:
          ;; OK, also, what is the effect on the player's status?
          jsr Random
          ldx CombatMoveSelected
          and MoveEffects, x
          jsr FindHighBit
          beq MonsterAttackNoStatusFX

MonsterAttackSetsStatusFX:
          tay
          and StatusFX
          bne MonsterAttackNoStatusFX
          tya
          sta MoveStatusFX
          ora StatusFX
          sta StatusFX
          ;;  fall through to common code
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
          clc
          adc MonsterHP - 1, x
          cmp # 99
          blt +
          lda # 99
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
PlayerAttackPositiveRandom:
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
          cmp MonsterHP - 1, x
          blt PlayerDidNotKillMonster

PlayerKilledMonster:
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
          beq +                 ; always taken

PlayerDidNotKillMonster:
          lda MonsterHP - 1, x
          sec
          sbc MoveHP
+
          sta MonsterHP - 1, x

          ;; OK, also, what is the effect on the enemy's status?
          jsr Random
          ldx CombatMoveSelected
          and MoveEffects, x
          jsr FindHighBit
          beq PlayerAttackNoStatusFX

PlayerAttackSetsStatusFX:
          ldx MoveTarget
          tay
          and EnemyStatusFX - 1, x
          bne PlayerAttackNoStatusFX ; they already have that status
          tya
          sta MoveStatusFX
          ora EnemyStatusFX - 1, x
          sta EnemyStatusFX - 1, x
          ;; fall through to common code
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

PlayerBuff:
          ldx CombatMoveSelected
          lda MoveEffects, x
          sta Temp
          jsr Random
          and Temp
          sta MoveStatusFX

          lda # 1
          sta MoveHitMiss

          ora StatusFX
          sta StatusFX
          ;;  fall through
;;; 

WaitOutScreen:

          lda MoveHitMiss
          beq SoundForMiss
          lda #SoundHit
          bne +
SoundForMiss:
          lda #SoundHit
+
          sta NextSound
          
          .WaitScreenBottom

          .FarJSR TextBank, ServiceCombatOutcome

NextTurn:
          inc WhoseTurn
          ldx WhoseTurn
          dex
          cpx #6
          bne +
          ldx #0
          stx WhoseTurn
          jmp BackToMain
+
          lda MonsterHP, x
          beq NextTurn

          lda #3
          jsr SetNextAlarm
BackToMain:

          jmp CombatMainScreen

          .bend

;;; 

LevelTable:
          ;; monsters have levels 0…$b for each of their stats
          ;; this table maps those to actual values
          .byte 1, 2, 5, 10,  15, 25, 35, 50
          .byte 60, 70, 80, 90, 99, 99, 99, 99
