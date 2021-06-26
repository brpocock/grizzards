;;; Grizzards Source/Routines/SaveToSlot.s
;;; Copyright © 2021 Bruce-Robert Pocock
SaveToSlot:	.block

;;; Note: The 26LC256 memory is segmented into 64-byte pages and it
;;; is only possible to write to a single page at a time.   

;;; ↑ from the AtariVox.rtf manual

;;; In order  to get around this  limitation and do smaller  updates per
;;; each province and per each Grizzard, we do some truly weird shit
;;; in this file (compared to a "normal" AtariVox game)

ReadProvincesIntoSwap:
          ;; First, read all four provinces game flags into core
          ;; in the "Swap" space which we'll zero after saving.
          ;; These start at offset $20 into the first block
          jsr i2cStartWrite
          lda SaveGameSlot
          clc
          adc #>SaveGameSlotPrefix
          jsr i2cTxByte
          lda #<SaveGameSlotPrefix + $20
          jsr i2cTxByte
          jsr i2cStopWrite
          jsr i2cStartRead

          ldx # 0
-
          jsr i2cRxByte
          sta SwapStart, x
          inx
          cpx #$20
          bne -

UpdateCurrentProvince:
          ;; Set up .y to point to the end of the affected swap space
          lda CurrentProvince
          clc
          adc # 1
          asl a
          asl a
          asl a
          tay

          ;; Our current ProvinceFlags overwrite whatever
          ;; was just loaded into the swap area
          ldx # 8
-
          lda ProvinceFlags - 1, x
          sta SwapStart - 1, y
          dey
          dex
          bne -

          jsr i2cStopRead

WriteMasterBlock:
          ;; OK, now we're going to actually write the Master block,
          ;; this is a 5 byte signature, then the Global vars space
          ;; (which must end before $20) and then the 32 bytes of
          ;; Province flags (8 bytes × 4 provinces)

          ;; First set the write pointer up for the first block of this
          ;; save game slot ($1700, $1800, or $1900)
	jsr i2cStartWrite

	lda #>SaveGameSlotPrefix
	clc
	adc SaveGameSlot
	jsr i2cTxByte
	lda #<SaveGameSlotPrefix
	jsr i2cTxByte

          ;; The signature is how we can tell that the slot is
          ;; occupied. Really any 2 bytes that are not $00 or $ff
          ;; would suffice, but this works too and we can
          ;; actually spare the space.
	ldx # 0
WriteSignatureLoop:
	lda SaveGameSignatureString, x
	jsr i2cTxByte
	inx
	cpx # 5
	bne WriteSignatureLoop

          ;; The GlobalGameData block has all the persistent vars
          ;; that are not ProvinceFlags or Grizzard stats.
	ldx # 0
WriteGlobalLoop:
	lda GlobalGameData, x
	jsr i2cTxByte
	inx
	cpx # GlobalGameDataLength
	bne WriteGlobalLoop

          ;; Pad out to $20
          ldx # 32 - 5 - GlobalGameDataLength
WritePadAfterGlobal:
          lda # $55             ; totally arbitrary pad value
          jsr i2cTxByte
          dex
          bne WritePadAfterGlobal

          ;; The Province data was previously staged in a block
          ;; of RAM; now, we push the entire block down. This
          ;; brings us to the end of the first save game block.
WriteProvinceData:
          ldx # 0
-
          lda SwapStart, x
          jsr i2cTxByte
          inx
          cpx # 32             ; 4 provinces × 8 bytes of flags each
          bne -

          jsr i2cStopWrite

          ;; Tail Call
          jmp SaveGrizzard

SaveRetry:
          jsr Random
          tax
-
          dex
          bne -

          jmp SaveToSlot
	.bend
