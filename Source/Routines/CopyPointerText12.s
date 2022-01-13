;;; Grizzards Source/Routines/CopyPointerText12.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
CopyPointerText12:
          ldy # 8
-
          lda (Pointer), y
          sta SignpostLineCompressed, y
          dey
          bpl -
          
          rts
