;;; Grizzards Source/Routines/EraseSlotSignature.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
EEPROMFail:
	jsr i2cStopWrite
          lda #ModeNoAtariVox
          sta GameMode
	brk

EraseSlotSignature: .block
          jsr i2cStartWrite
          bcs EEPROMFail
	lda #>SaveGameSlotPrefix
	clc
	adc SaveGameSlot
          jsr i2cTxByte
          lda #<SaveGameSlotPrefix
          jsr i2cTxByte
       
          lda # 0
          jsr i2cTxByte

          jsr i2cStopWrite

          lda # 0
          sta SaveSlotBusy

          rts

          .bend
