;;; Grizzards Source/Routines/SetSlotAddress.s
;;; Copyright © 2022 Bruce-Robert Pocock

          .if ATARIAGESAVE

StartI2C: .macro
          lda SaveGameSlot
          jsr i2cStartWrite
          bcc +
          brk
+
          .endm

          .else

StartI2C: .macro
          jsr SetSlotAddress
          .endm

EEPROMFail:
          jsr i2cStopWrite

          .mva GameMode, #ModeNoAtariVox
          brk

SetSlotAddress:     .block

            jsr i2cStartWrite
            bcs EEPROMFail

            lda SaveGameSlot
            clc
            adc #>SaveGameSlotPrefix
            jmp i2cTxByte       ; tail call

          .bend

          .fi
          
