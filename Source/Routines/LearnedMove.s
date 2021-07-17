;;; Grizzards Source/Routines/LearnedMove.s
;;; Copyright © 2021 Bruce-Robert Pocock

LearnedMove:        .block

          ;; Call with the move ID stashed in Temp
          lda #ModeLearnedMove
          sta GameMode
Loop:
          jsr VSync
          jsr VBlank
          .SkipLines (KernelLines - 35) / 2

          lda Temp
          jsr ShowMove.WithDecodedMoveID

          .SkipLines (KernelLines - 35) / 2
          jsr Overscan

          lda NewSWCHB
          beq SwitchesDone
          .BitBit SWCHBReset
          bne SwitchesDone
          lda #ModeColdStart
          sta GameMode
SwitchesDone:

          lda GameMode
          cmp #ModeLearnedMove
          beq +
          cmp #ModeColdStart
          beq GoColdStart
          rts

+
          jmp Loop

          .bend
