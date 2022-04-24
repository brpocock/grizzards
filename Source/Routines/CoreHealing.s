;;; Grizzards Source/Common/CoreHealing.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CoreHealing:        .block
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

          lda # 1               ; never completely fail to heal
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

          .bend
