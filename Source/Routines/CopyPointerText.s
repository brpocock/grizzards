;;; Grizzards Source/Routines/CopyPointerText.s
;;; Copyright © 2021 Bruce-Robert Pocock
CopyPointerText:
          ldy # 0
-
          lda (Pointer), y
          sta StringBuffer, y
          iny
          cpy # 6
          bne -
          
          rts
