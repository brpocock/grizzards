ShowMove:
          ldy MoveSelection
          beq MoveRunAway
          dey
          
          lda #<GrizzardMoves
          sta Pointer
          
          lda CurrentGrizzard
          asl a
          asl a
          asl a
          adc #>GrizzardMoves
          bcc +
          inc Pointer + 1
+
          sta Pointer
          lda (Pointer), y
          tay

MoveRunAway:        
          
          lda # >MovesTable
          sta Pointer + 1
          tya                   ; move number
          clc

          asl a
          asl a                 ; × 4
          sta Pointer
          asl a                 ; × 8
          adc Pointer           ; × 12
          adc # <MovesTable
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
