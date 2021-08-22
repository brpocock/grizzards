;;; Grizzards Source/Routines/LoadGrizzardData.s
;;; Copyright © 2021 Bruce-Robert Pocock

LoadGrizzardData:   .block
          lda CurrentGrizzard

          jsr SetGrizzardAddress
          jsr i2cStopWrite
          jsr i2cStartRead

          ldx # 0
-
          jsr i2cRxByte
          sta MaxHP, x
          inx
          cpx # 6
          blt -
          
          jsr i2cStopRead

          lda MaxHP
          sta CurrentHP

          ;; Make sure debounced switch doesn't return us to the title screen immediately
          lda SWCHB
          sta DebounceSWCHB

          ;; Return to place last blessed
          lda #ModeMap
          sta GameMode
          lda BlessedX
          sta PlayerX
          lda BlessedY
          sta PlayerY

          rts

          .bend
