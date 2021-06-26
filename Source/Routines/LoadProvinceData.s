;;; Grizzards Source/Routines/ReadProvinceData.s
;;; Copyright © 2021 Bruce-Robert Pocock

LoadProvinceData:   .block
          ;; Province data are 8 bytes blocks starting at $20
          ;; in the master block.
          jsr i2cStartWrite

          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot
          jsr i2cTxByte
          lda CurrentProvince
          asl a
          asl a
          asl a                 ; × 8
          adc # $20
          jsr i2cTxByte

          jsr i2cStopWrite
          jsr i2cStartRead

          ldx # 0
-
          jsr i2cRxByte
          sta ProvinceFlags, x
          inx
          cpx # 8
          bne -

          jmp i2cStopRead       ; tail call

          .bend
