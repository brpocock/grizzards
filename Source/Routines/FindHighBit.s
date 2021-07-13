;;; Grizzards Source/Routines/FindHighBit.s
;;; Copyright © 2021 Bruce-Robert Pocock

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
          .byte %00000000
          .byte %00000000
          .byte %000000001
          .byte %00000011
          .byte %00000111
          .byte %00001111
          .byte %00011111
          .byte %00111111
          .byte %011111111
