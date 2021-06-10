SaveToSlot:	.block
	jsr i2cStartWrite
	bcs SaveRetry

	lda #>SaveGameSlotPrefix
	clc
	adc SaveGameSlot
	jsr i2cTxByte
	lda #<SaveGameSlotPrefix
	jsr i2cTxByte

	ldx # 0
WriteSignatureLoop:
	lda SaveGameSignatureString, x
	jsr i2cTxByte
	inx
	cpx # 5
	bne WriteSignatureLoop

	ldx # 0
WriteGlobalLoop:
	lda GlobalGameData, x
	jsr i2cTxByte
	inx
	cpx # EndGlobalGameData - GlobalGameData + 1
	bne WriteGlobalLoop

	;; TODO save provincial data

	jsr i2cStopWrite
	
        rts

SaveRetry:
          .SleepX 50
          jmp SaveToSlot
	.bend
