CopyPointerText:
          ldy # 0
-
          lda (Pointer), y
          sta StringBuffer, y
          iny
          cpy # 6
          bne -
          
          rts
