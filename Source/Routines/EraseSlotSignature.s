;;; Grizzards Source/Routines/EraseSlotSignature.s
;;; Copyright © 2021 Bruce-Robert Pocock
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
       
          ldx # 0
WriteSignatureLoop:
          lda # 0
          jsr i2cTxByte
          inx
          cpx # 5
          bne WriteSignatureLoop

          jsr i2cStopWrite
       
          rts

          .bend

