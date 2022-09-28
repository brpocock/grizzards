;;; Grizzards Source/Routines/LoadProvinceData.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

LoadProvinceData:   .block
          ;; Province data are 8 bytes blocks starting at $20
          ;; in the master block.
          .StartI2C

          lda CurrentProvince
          asl a
          asl a
          asl a                 ; × 8
          ora # $20
          jsr i2cTxByte
          jsr i2cStopWrite
          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartRead

          ldx # 0
-
          jsr i2cRxByte

          sta ProvinceFlags, x
          inx
          cpx # 8
          bne -

          jsr i2cStopRead

          ;; Fill last byte with $ff if flag 55 = 0
          lda ProvinceFlags + 6
          bmi +

          ora #$80
          sta ProvinceFlags + 6
          .mva ProvinceFlags + 7, #$ff

+
          rts

          .bend

