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
          clc
          adc Temp
          tax
          lda GrizzardMoves, x
          sta Temp
          rts
FetchedRunAway:
          stx Temp
          rts
