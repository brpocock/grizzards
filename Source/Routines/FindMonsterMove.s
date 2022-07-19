;;; Grizzards Source/Routines/FindMonsterMove.s
;;; Copyright © 2021, 2022 Bruce-Robert Pocock

FindMonsterMove:    .block
          ;; Y = move selection

          .mva Pointer + 1, #>MonsterMoves

          ldx CurrentCombatEncounter
          lda EncounterMonster, x
          asl a
          asl a
          ; clc ;; already clear after ASL A (x < 64)
          adc #<MonsterMoves
          bcc +
          inc Pointer + 1
+
          sta Pointer

          lax (Pointer), y
          sta CombatMoveSelected

          rts

          .bend

;;; Audited 2022-07-14 BRPocock
