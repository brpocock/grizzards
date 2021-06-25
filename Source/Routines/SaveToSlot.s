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

          ;; Now we have 3 more blocks to write.
          ;; We have 30 potential Grizzards, which make up 5 bytes each.
          ;; So we store 0-11 in the first block, which is
          ;; SwapGrizzardBlock = 0, then 12-23 in the second block,
          ;; and 24-30 in the last block. Nominally, we could do something
          ;; exciting with the remaining 4 bytes in blocks 1 and 2 or the
          ;; remaining 34 bytes in block 3, but they're left alone for now.
          lda # 0
          sta SwapGrizzardBlock

ReadGrizzardBlock:
          ;; Read the current block of Grizzard data into the swap
          ;; RAM area. This demolishes literally half of memory.

          ;; FIXME. For reasons I don't know, this loads $ff ff ff …
          ;; even though the memory block is initialized to $00 00 00 …
          ;;
          ;; I suspect I have a bug in the way I'm calling the i2c code,
          ;; because it works correctly in the LoadSaveSlot routine.

          ;; Set the read address into Pointer, we'll re-use it again
          ;; when we're getting ready to write.

          jsr i2cStartWrite
          lda SaveGameSlot
          clc
          adc #>SaveGameSlotPrefix
          sta Pointer + 1
          jsr i2cTxByte
          
          lda SwapGrizzardBlock
          asl a
          asl a
          asl a
          asl a
          asl a
          asl a                 ; × $40 (64)
          adc #<SaveGameSlotPrefix + $40
          sta Pointer
          jsr i2cTxByte

          jsr i2cStopWrite
          jsr i2cStartRead    

          ;; Read the entire block into RAM
          ldx # 0
-
          jsr i2cRxByte
          sta SwapStart, x
          inx
          cpx #$40
          bne -

          jsr i2cStopRead

UpdateCurrentGrizzard:
          ;; If the current Grizzard is in the current memory block,
          ;; we want to overwrite its last-saved (just-loaded) stats
          ;; with its current stats. Note that CurrentHP is
          ;; not saved, this is why the Depot heals the Grizzard
          ;; fully.
          lda CurrentGrizzard
          cmp # 12
          bmi InBlock0
          cmp # 24
          bmi InBlock1
          lda SwapGrizzardBlock
          cmp # 2
          bne NotInBlock
          lda CurrentGrizzard
          sec
          sbc # 24
          jmp InCurrentBlock

InBlock1:
          lda SwapGrizzardBlock
          cmp # 1
          bne NotInBlock
          lda CurrentGrizzard
          sec
          sbc # 12
          jmp InCurrentBlock

InBlock0:
          lda SwapGrizzardBlock
          cmp # 0
          bne NotInBlock
          lda CurrentGrizzard
          ;; fall through

InCurrentBlock:
          ;; .a has the current Grizzard's position relative to
          ;; the current block (e.g. maybe -12 or -24)
          sta Temp
          asl a
          asl a                 ; × 4
          clc
          adc Temp             ; × 5
          tay                   ; Get offset in block to current Grizzard

          ;; Copy the current Grizzard's stats into the block
          lda GrizzardAttack
          sta SwapStart, y
          iny
          lda GrizzardDefense
          sta SwapStart, y
          iny
          lda GrizzardAcuity
          sta SwapStart, y
          iny
          lda MovesKnown
          sta SwapStart, y
          iny
          lda MaxHP
          sta SwapStart, y
          ;; fall through

NotInBlock:         

          ;; Write the block of Grizzards back to the EEPROM
WriteGrizzardBlock:
	jsr i2cStartWrite

          ;; Send the same address that we stashed earlier
          lda Pointer + 1
          jsr i2cTxByte
          lda Pointer
          jsr i2cTxByte

          ldx # 0
-
          lda SwapStart, x
          jsr i2cTxByte
          inx
          cpx #$40
          bne -

          ;; Done writing the current Grizzard block
          jsr i2cStopWrite

          ;; Did we write all 3 blocks of Grizzards back down?
          ldx SwapGrizzardBlock
          inx
          stx SwapGrizzardBlock
          cpx #3
          bne WriteGrizzardBlock

ZeroSwapRAM:
          ;; We have now got Block 3 of Grizzard data in RAM
          ;; taking up half of all memory
          ;;
          ;; The Swap memory overlay is designed so that it
          ;; contains values that can be safely zeroed with
          ;; little effect, although it will do a few things like
          ;; stop playing music or sound effects.
          ldx #$41
          lda # 0
-
          sta SwapStart, x
          dex
          bne -

          ;; Save complete, memory cleared, return to caller.
          rts

SaveRetry:
          jsr Random
          tax
-
          dex
          bne -

          jmp SaveToSlot
	.bend

