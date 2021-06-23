SetGrizzardAddress:
          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot
          sta Pointer + 1
          
          lda CurrentGrizzard
          asl a
          asl a                 ; × 4
          adc CurrentGrizzard   ; × 5

          adc # NumProvinces * 4 + EndGlobalGameData - GlobalGameData + 1
          
          sta Pointer

SendGrizzardAddress:          
          lda Pointer + 1
          jsr i2cTxByte
          lda Pointer
          jmp i2cTxByte
