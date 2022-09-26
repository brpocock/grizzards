;;; Grizzards Source/Routines/Unerase.s
;;; Copyright © 2022 Bruce-Robert Pocock

Unerase:       .block

          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartWrite
          .if !ATARIAGESAVE
            lda #>SaveGameSlotPrefix
            clc
            adc SaveGameSlot
            jsr i2cTxByte
          .fi
          lda #<SaveGameSlotPrefix
          jsr i2cTxByte

          lda SaveGameSignatureString ; first char of string
          jsr i2cTxByte

          jsr i2cStopWrite

          .mva SaveSlotChecked, #$ff
          .mva GameMode, #ModeSelectSlot
          jsr i2cWaitForAck

          rts
          .bend
