;;; Grizzards Source/Routines/CopyPointerText12.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CopyPointerText12:  .block
          ldy # 8
Loop:
          lda (Pointer), y
          sta SignpostLineCompressed, y
          dey
          bpl Loop
          
          rts

          .bend
