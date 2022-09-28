;;; Grizzards Source/Routines/Unerase.s
;;; Copyright © 2022 Bruce-Robert Pocock

Unerase:       .block
          .StartI2C

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
