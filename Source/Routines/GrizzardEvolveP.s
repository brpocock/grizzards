;;; Grizzards Source/Routines/GrizzardEvolveP.s
;;; Copyright © 2022 Bruce-Robert Pocock

GrizzardEvolveP:    .block

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
