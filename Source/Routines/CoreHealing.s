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

MinHealing:
          lda # 1               ; never completely fail to heal
HealsCommon:
          sta MoveHP
          clc
          adc DefenderHP
          cmp DefenderMaxHP
          blt HealingBelowMax

          lda DefenderMaxHP
          sec
          sbc DefenderHP
          sta MoveHP
          lda DefenderMaxHP

HealingBelowMax:
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
