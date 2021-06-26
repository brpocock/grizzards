;;; Grizzards Source/Routines/SaveGrizzard.s
;;; Copyright © Bruce-Robert Pocock

SaveGrizzard:       .block

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

          .bend
