;;; Grizzards Source/Routines/GrizzardEvolveP.s
;;; Copyright © 2022 Bruce-Robert Pocock

GrizzardEvolveP:    .block

          lda CurrentGrizzard
          ;; × 5
          sta Temp
          asl a
          asl a
          clc
          adc Temp

          adc # 3
          tay

          lda GrizzardStartingStats, y
          sta Temp
          rts

          .bend
