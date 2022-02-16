;;; Grizzards Source/Routines/SaveGrizzard.s
;;; Copyright © 2021,2022 Bruce-Robert Pocock

SaveGrizzard:       .block
          .WaitScreenBottom
          .WaitScreenTopMinus 3, -1
          ;; We have 30 potential Grizzards, which make up 5 bytes each.
          ;; So we store 0-11 in the first block, then 12-23 in the second block,
          ;; and 24-30 in the last block. Nominally, we could do something
          ;; exciting with the remaining 4 bytes in blocks 1 and 2 or the
          ;; remaining 34 bytes in block 3, but they're left alone for now.

          lda CurrentGrizzard
          jsr SetGrizzardAddress

          ldx # 0
-
          lda MaxHP, x
          jsr i2cTxByte

          inx
          cpx # 5
          bne -

          jsr i2cStopWrite

          jmp WaitScreenBottomSub ; tail call
   
          .bend

;;; Audited 2022-02-16 BRPocock
