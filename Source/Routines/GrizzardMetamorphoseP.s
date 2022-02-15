;;; Grizzards Source/Routines/GrizzardMetamorphoseP.s
;;; Copyright © 2022 Bruce-Robert Pocock

          ;; If CurrentGrizzard can metamorphose, the Grizzard into which it can
          ;; do will be returned in Y, else Y = 0
GrizzardMetamorphoseP:    .block
          lda CurrentGrizzard
          ;; × 5
          asl a
          asl a
          clc
          adc CurrentGrizzard

          adc # 3
          tay

          lda GrizzardStartingStats, y
          tay
          rts

          .bend

;;; Audited 2022-02-15 BRPocock
