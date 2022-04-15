;;; Grizzards Source/Routines/FindMonsterMove.s
;;; Copyright © 2021, 2022 Bruce-Robert Pocock

FindMonsterMove:
          .mva Pointer + 1, #>MonsterMoves

          clc
          ldx CurrentCombatEncounter
          lda EncounterMonster, x
          asl a
          asl a
          adc #<MonsterMoves
          bcc +
          inc Pointer + 1
+
          sta Pointer

          lax (Pointer), y      ; Y = MoveSelection
          stx CombatMoveSelected

          rts
