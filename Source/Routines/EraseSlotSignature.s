;;; Grizzards Source/Routines/EraseSlotSignature.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

EraseSlotSignature: .block
          jsr i2cStartWrite

	lda #>SaveGameSlotPrefix
	clc
	adc SaveGameSlot
          jsr i2cTxByte

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

;;; Audited 2022-02-15 BRPocock
