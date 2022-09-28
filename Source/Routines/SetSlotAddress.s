;;; Grizzards Source/Routines/SetSlotAddress.s
;;; Copyright © 2022 Bruce-Robert Pocock

          .if !ATARIAGESAVE
EEPROMFail:
          jsr i2cStopWrite

          .mva GameMode, #ModeNoAtariVox
          brk
          .fi

SetSlotAddress:     .block

          .if ATARIAGESAVE
            lda SaveGameSlot
            jmp i2cStartWrite   ; tail call
          .else
            jsr i2cStartWrite
            bcs EEPROMFail

            lda SaveGameSlot
            clc
            adc #>SaveGameSlotPrefix
            jmp i2cTxByte       ; tail call
          .fi
          .bend
