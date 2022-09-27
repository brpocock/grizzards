;;; Grizzards Source/Routines/EraseSlotSignature.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

EraseSlotSignature: .block
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

          lda #<SaveGameSlotPrefix
          jsr i2cTxByte

          lda # 0
          jsr i2cTxByte

          jsr i2cStopWrite

          ldy # 0
          sty SaveSlotBusy
          lda #$ff
          sta SaveSlotChecked

          jsr i2cWaitForAck     ; required!

          rts

          .bend
