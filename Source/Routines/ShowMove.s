;;; Grizzards Source/Routines/ShowMove.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
ShowMove: .block

;;; Default entry point is only useful for the player, used for the menu.
          ldy MoveSelection
          beq MoveRunAway
          dey

          lda #>GrizzardMoves
          sta Pointer + 1

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

MoveRunAway:

WithDecodedMoveID:              ; move ID is in Y register

          lda #>MovesTable
          sta Pointer + 1
          tya                   ; move number
          and #$3f         ; there are only 64 moves
          clc

          asl a
          asl a                 ; × 4
          sta Pointer
          asl a                 ; × 8
          bcc +
          inc Pointer + 1
+
          clc
          adc Pointer           ; × 12
          bcc +
          inc Pointer + 1
+
          clc
          adc #<MovesTable
          bcc +
          inc Pointer + 1
+
          sta Pointer

          jsr CopyPointerText
          jsr DecodeText
          jsr ShowText

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
