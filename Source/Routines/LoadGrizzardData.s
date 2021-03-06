;;; Grizzards Source/Routines/LoadGrizzardData.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

LoadGrizzardData:   .block
          lda CurrentGrizzard

          jsr SetGrizzardAddress

          jsr i2cK2             ; K without send

          ldx # 0
-
          jsr i2cRxByte

          sta MaxHP, x
          inx
          cpx # 5
          blt -

          jsr i2cStopRead

          .mva CurrentHP, MaxHP

          ;; Make sure debounced switch doesn't return us to the title screen immediately
          .mva DebounceSWCHB, SWCHB

          ;; Return to place last blessed
          .mva PlayerX, BlessedX
          .mva PlayerY, BlessedY

          rts

          .bend

;;; Audited 2022-02-16 BRPocock
