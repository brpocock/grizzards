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

          jsr i2cStopWrite

WriteProvinceData:
          jsr i2cStartWrite

          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot
          jsr i2cTxByte
          lda CurrentProvince
          asl a
          asl a
          adc # EndGlobalGameData - GlobalGameData + 1
          jsr i2cTxByte

          lda ProvinceFlags + 0
          jsr i2cTxByte
          lda ProvinceFlags + 1
          jsr i2cTxByte
          lda ProvinceFlags + 2
          jsr i2cTxByte
          lda ProvinceFlags + 3
          jsr i2cTxByte

          jsr i2cStopWrite

WriteGrizzardData:
          jsr i2cStartWrite
          bcs SaveRetry
          
          jsr SetGrizzardAddress
          
          lda GrizzardAttack
          jsr i2cTxByte
          lda GrizzardDefense
          jsr i2cTxByte
          lda GrizzardAcuity
          jsr i2cTxByte
          lda MovesKnown
          jsr i2cTxByte
          lda MaxHP
          jsr i2cTxByte

	jsr i2cStopWrite
	
          rts

SaveRetry:
          jsr Random
          tax
-
          dex
          bne -

          brk
          jmp SaveToSlot
	.bend

