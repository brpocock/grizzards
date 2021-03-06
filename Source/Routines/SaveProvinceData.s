;;; Grizzards Source/Routines/SaveProvinceData.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

SaveProvinceData:   .block
          .WaitScreenTop
PositionProvinceData:
          jsr i2cStartWrite

	lda #>SaveGameSlotPrefix
	clc
	adc SaveGameSlot
	jsr i2cTxByte

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

;;; Audited 2022-02-16 BRPocock
