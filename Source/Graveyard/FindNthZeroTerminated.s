;;; Grizzards Source/Routines/FindNthZeroTerminated.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

FindNthZeroTerminated:        .block
          ;; Finds the nth (xth) zero-terminated string starting after Pointer.
          ;; Updates Pointer to point to the head of that string.
          ;; Each string must be ≤ 255 bytes in length,
          ;; but they can total much more.

          cpx # 0
          beq Done

          ldy # 0
SearchMore:         
          lda (Pointer),y
          beq StringEnd

          iny
          bne SearchMore

StringEnd:
          tya
          clc
          adc Pointer
          bcc +
          inc Pointer + 1
+
          dex
          bne SearchMode

Done:     

          rts
          .bend
