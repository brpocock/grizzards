;;; Grizzards Source/Routines/CopyPointerText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
CopyPointerText:
          ldy # 5
-
          lda (Pointer), y
          sta StringBuffer, y
          dey
          bpl -
          
          rts
