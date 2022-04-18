;;; Grizzards Source/Routines/CoreAttack.s
;;; Copyright © 2021-2022, Bruce-Robert Pocock

CoreAttack:         .block
          jsr Random
          and #$0f              ; crit chance = 1⁄16
          beq CriticalHit

          lda AttackerAttack
          jsr CalculateAttackMask

          sta Temp              ; attacker attack mask

          jsr Random

          bmi NegativeRandom

PositiveRandom:
          and Temp              ; attacker attack mask → attack variation
          clc
          adc AttackerAttack
          gne HitMissP

CriticalHit:
          lda CombatMoveDeltaHP
          asl a
          sta CriticalHitP
          gne AttackHit1

NegativeRandom:
          and Temp              ; attacker attack mask
          sta Temp              ; attack variation
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

          sta Temp              ; damage variation mask

          lda WhoseTurn
	beq ExtraDifficult    ; player always hits hard

          lda DebounceSWCHB
          and #SWCHBP0Advanced
          bne ExtraDifficult    ; monsters only hit hard in Advanced mode

          jsr Random

          jmp HitMinus

ExtraDifficult:
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
          bge DidNotKill

KilledDefender:
          ldy # 0
          sty DefenderHP
          sty DefenderStatusFX
          geq NoStatusFX

DidNotKill:
          sec
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
          bne Done

NoStatusFX:
          lda MoveHP
          bne Done
          .mvy CriticalHitP, # 0

Done:
          .mva MoveHitMiss, # 1
          rts

          .bend
