SetGrizzardAddress:
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
          jmp i2cTxByte
