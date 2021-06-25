;;; Grizzards Source/Routines/ShowMove.s
;;; Copyright © 2021 Bruce-Robert Pocock
ShowMove:
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
          
          lda #>MovesTable
          sta Pointer + 1
          tya                   ; move number
          and #$3f         ; there are only 64 moves
          clc

          asl a
          asl a                 ; × 4
          sta Pointer
          asl a                 ; × 8
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
          jmp DecodeAndShowText
