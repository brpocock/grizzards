;;; Grizzards Source/Routines/GrizzardMetamorphoseP.s
;;; Copyright © 2022 Bruce-Robert Pocock

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
