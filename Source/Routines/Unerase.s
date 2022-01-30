;;; Grizzards Source/Routines/Unerase.s
;;; Copyright © 2022 Bruce-Robert Pocock

Unerase:       .block

          jsr i2cStartWrite
          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot
          jsr i2cTxByte
          lda #<SaveGameSlotPrefix
          jsr i2cTxByte

          lda SaveGameSignatureString ; first char of string
          jsr i2cTxByte
          jsr i2cStopWrite

          lda #$ff
          sta SaveSlotChecked

          lda #ModeSelectSlot
          sta GameMode

          jsr i2cWaitForAck

          rts
          .bend
