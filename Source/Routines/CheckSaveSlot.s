CheckSaveSlot: .block
          jsr SeedRandom
          
	jsr i2cStartWrite
	bcc CheckSignature
	jmp EEPROMFail

CheckSignature:
	lda SaveGameSlot
	clc
	adc #>SaveGameSlotPrefix
	jsr i2cTxByte
	lda #<SaveGameSlotPrefix 
	jsr i2cTxByte
	jsr i2cStopWrite
	jsr i2cStartRead
	ldx #0
ReadLoop:
	jsr i2cRxByte
	cmp SaveGameSignatureString, x
	bne SlotEmpty
	inx
	cpx # 5
        bne ReadLoop
	jsr i2cStopRead
	clc			; Yes, it's in use
	rts
SlotEmpty:           
	jsr i2cStopRead
	sec			; Nope, not in use
	rts
	
	.bend
