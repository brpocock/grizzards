;;; Grizzards Source/Routines/EraseSlotSignature.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

EraseSlotSignature: .block
          .StartI2C

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
