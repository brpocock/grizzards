;;; Grizzards Source/Routines/FindMonsterMove.s
;;; Copyright © 2021, 2022 Bruce-Robert Pocock

FindMonsterMove:    .block
          ;; Y = move selection

          .mvaw Pointer, MonsterMoves
          .mva Pointer + 1, #>MonsterMoves

          ldx CurrentCombatEncounter
          lda EncounterMonster, x
          asl a
          asl a
          .Add16a Pointer

          lda (Pointer), y
          sta CombatMoveSelected

          rts

          .bend

;;; Audited 2022-04-18 BRPocock
