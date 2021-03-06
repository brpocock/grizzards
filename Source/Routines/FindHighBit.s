;; Grizzards Source/Routines/FindHighBit.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

FindHighBit:        .block
          ldx # 8
          clc
-
          dex
          beq Return0

          rol a
          bcc -

          lda BitMask, x
          rts

Return0:                        ; also jumped to, from below in CalculateAttackMask
          lda # 0
          rts

          .bend
;;; 
CalculateAttackMask:          .block
          ldx # 8
          clc
-
          dex
          beq FindHighBit.Return0

          rol a
          bcc -

          lda AttackMask, x     ; the only line that differs
          rts

          .bend
;;; 
AttackMask:
          .byte 1, 1, 3, 7, 15, 31, 63, 127
          ;; ↑ XXX experimental; below is the original
          ;; .byte 1, 3, 7, 15, 31, 63, 127, 255

;;; Audited 2022-02-15 BRPocock
