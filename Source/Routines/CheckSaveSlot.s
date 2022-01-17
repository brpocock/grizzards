;;; Grizzards Source/Routines/CheckSaveSlot.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
CheckSaveSlot: .block
          jsr SeedRandom
          
	jsr i2cStartWrite
	bcc CheckSignature
	jmp EEPROMFail

CheckSignature:
	lda SaveGameSlot
          sta SaveSlotChecked
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

ReadSlotName:
          jsr i2cStopRead

          ;; Wait for acknowledge bit
-
          jsr i2cStartWrite
          bcs -
          jsr i2cStopWrite

          jsr i2cStartWrite
          lda SaveGameSlot
          clc
          adc #>SaveGameSlotPrefix
          jsr i2cTxByte
          lda #<SaveGameSlotPrefix + $1a
          jsr i2cTxByte
          jsr i2cStopWrite
          jsr i2cStartRead

          ldx # 0
-
          jsr i2cRxByte
          sta NameEntryBuffer, x
          inx
          cpx # 6
          bne -

          lda #$80
          gne Leave

SlotEmpty:           
	lda # 0			; Nope, not in use
Leave:
          sta SaveSlotBusy
	jsr i2cStopRead
	rts
	
	.bend
