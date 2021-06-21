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
          jsr i2cStartWrite     ; This seems to crash?

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

          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot
          adc # 3
          sta Pointer + 1
          
          lda CurrentGrizzard
          asl a
          asl a                 ; × 4
          adc CurrentGrizzard   ; × 5
          sta Pointer
          and #$c0
          bne SendGrizzardAddress
          ldx # 6               ; ÷ 64
-
          clc
          ror a
          dex
          bne -
          adc Pointer + 1
          sta Pointer + 1
          lda Pointer
          and #$3f
          sta Pointer

SendGrizzardAddress:          
          lda Pointer + 1
          jsr i2cTxByte
          lda Pointer
          jsr i2cTxByte
          
          lda GrizzardAttack
          jsr i2cTxByte
          lda GrizzardDefense
          jsr i2cTxByte
          lda GrizzardAccuracy
          jsr i2cTxByte
          lda MovesKnown
          jsr i2cTxByte
          lda MaxHP
          jsr i2cTxByte

	jsr i2cStopWrite
	
          rts

SaveRetry:
          .SleepX 50
          jmp SaveToSlot
	.bend
