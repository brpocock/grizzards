;;; Grizzards Source/Routines/FetchGrizzardMove.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          ;; Call with MoveSelection set to the move index within the set of moves for this Grizzard
FetchGrizzardMove:
          ldx MoveSelection
          beq FetchedRunAway
          dex
          stx Temp
          lda CurrentGrizzard
          asl a
          asl a
          asl a
          clc                   ; XXX isn't this already clear per asl a?
          adc Temp
          tax
          lda GrizzardMoves, x
          tax
FetchedRunAway:
          stx Temp
          rts
