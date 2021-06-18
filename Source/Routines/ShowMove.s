ShowMove: 
          lda MoveSelection
          lda # >MovesTable
          sta Pointer + 1
          clc
          asl a
          asl a
          sta Pointer
          asl a
          adc Pointer
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
