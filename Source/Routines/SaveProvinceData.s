;;; Grizzards Source/Routines/SaveProvinceData.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

SaveProvinceData:   .block
          .WaitScreenTop
PositionProvinceData:
          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartWrite
          .if !ATARIAGESAVE
            lda #>SaveGameSlotPrefix
            clc
            adc SaveGameSlot
            jsr i2cTxByte
          .fi

          lda CurrentProvince
          asl a
          asl a
          asl a                 ; ×8
          ora # $20
          jsr i2cTxByte

WriteProvinceData:
          ldx # 0
-
          lda ProvinceFlags, x
          jsr i2cTxByte

          inx
          cpx # 8             ; 4 provinces × 8 bytes of flags each
          bne -

          jsr i2cStopWrite

          .WaitScreenBottomTail

          .bend
