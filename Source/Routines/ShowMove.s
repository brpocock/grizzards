;;; Grizzards Source/Routines/ShowMove.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

ShowMove: .block
;;; Default entry point is only useful for the player, used for the menu.
          ldy MoveSelection
          beq WithDecodedMoveID
          dey

          .mva Pointer + 1, #>GrizzardMoves

          lda CurrentGrizzard
          asl a
          asl a
          asl a
          adc #<GrizzardMoves
          bcc +
          inc Pointer + 1
+
          sta Pointer
          lda (Pointer), y
          tay

;;; Alternate entry point, when you already know the move ID
WithDecodedMoveID:              ; move ID is in Y register
          .mva Pointer + 1, # 0

          tya                   ; move number
          and #$3f         ; there are only 64 moves XXX paranoid much?

          asl a                 ; × 2
          asl a                 ; × 4 (won't overflow)
          sta Pointer
          asl a                 ; × 8
          rol Pointer + 1
          adc Pointer           ; × 12
          bcc +
          inc Pointer + 1
          clc
+
          adc #<MovesTable
          bcc +
          inc Pointer + 1
+
          sta Pointer

          lda Pointer + 1
          clc
          adc #>MovesTable
          sta Pointer + 1

          jsr ShowPointerText

          lda Pointer
          clc
          adc # 6
          bcc +
          inc Pointer + 1
+
          sta Pointer

          jsr CopyPointerText

          ;; Suppress line with all blanks
          ldx # 6
-
          lda StringBuffer - 1, x
          cmp #$28              ; blank space
          bne DrawLine2
          dex
          bne -

          rts                   ; return without drawing

DrawLine2:
          jmp DecodeAndShowText ; tail call

          .bend

;;; Audited 2022-02-16 BRPocock
