;;; Grizzards Source/Routines/SetCurrentGrizzard.s
;;; Copyright © 2022 Bruce-Robert Pocock

SetCurrentGrizzard:       .block
          jsr i2cWaitForAck

          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartWrite
          bcs EEPROMFail

          .if !ATARIAGESAVE
            lda SaveGameSlot
            clc
            adc #>SaveGameSlotPrefix
            jsr i2cTxByte
          .fi

          lda # 5 + CurrentGrizzard - GlobalGameData
          jsr i2cTxByte

          lda CurrentGrizzard
          jsr i2cTxByte

          jmp i2cStopWrite      ; tail call

          .bend

