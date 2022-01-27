;;; Grizzards Source/Routines/FindHighBit.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; XXX These two routines are nearly identical
;;; is it worth it to factor out a common prefix subroutine?

FindHighBit:        .block
          tay
          ldx # 7
-
          tya
          and BitMask, x
          bne +
          dex
          bne -
          lda # 0
          rts
+
          lda BitMask, x        ; the only line that differs
          rts

          .bend

CalculateAttackMask:          .block
          tay
          ldx # 7
-
          tya
          and BitMask, x
          bne +
          dex
          bne -
          lda # 0
          rts
+
          lda AttackMask, x     ; the only line that differs
          rts

          .bend
;;; 

AttackMask:
          .byte 1, 3, 7, 15, 31, 63, 127, 255
