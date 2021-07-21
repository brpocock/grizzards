;;; Grizzards Source/Routines/SetNextAlarm.s
;;; Copyright © 2021, Bruce-Robert Pocock

SetNextAlarm:
          clc
          adc ClockSeconds
          cmp # 60
          bmi +
          sec
          sbc # 60
+
          sta AlarmSeconds
          rts
