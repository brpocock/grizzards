ShowMove: 
          lda # >MovesTable
          sta Pointer + 1
          lda MoveSelection
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
