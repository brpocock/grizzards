;;; Grizzards Source/Routines/SetCurrentGrizzard.s
;;; Copyright © 2022 Bruce-Robert Pocock

SetCurrentGrizzard:       .block
          jsr i2cWaitForAck

          .StartI2C

          lda # 5 + CurrentGrizzard - GlobalGameData
          jsr i2cTxByte

          lda CurrentGrizzard
          jsr i2cTxByte

          jmp i2cStopWrite      ; tail call

          .bend

