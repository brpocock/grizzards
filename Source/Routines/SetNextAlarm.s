;;; Grizzards Source/Routines/SetNextAlarm.s
;;; Copyright © 2021, Bruce-Robert Pocock

SetNextAlarm:
          tax
          lda ClockMinutes
          sta AlarmMinutes
          txa
          clc
          adc ClockSeconds
          cmp # 60
          bmi +
          sec
          sbc # 60
          inc AlarmMinutes
+
          sta AlarmSeconds
          rts
