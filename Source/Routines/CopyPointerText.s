;;; Grizzards Source/Routines/CopyPointerText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CopyPointerText:    .block
          ldy # 5
Loop:
          lda (Pointer), y
          sta StringBuffer, y
          dey
          bpl Loop
          
          rts

          .bend

;;; Audited 2022-02-15 BRPocock
