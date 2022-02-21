;;; Grizzards Source/Routines/DecodeText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

DecodeText:	.block
	lda #>Font
	sta pp0h
	sta pp1h
	sta pp2h
	sta pp3h
	sta pp4h
	sta pp5h

          clc
          ldx # 6
          ldy # 11
StringTimes5:                   ; multiply char by 5 (scan lines)
          lda StringBuffer - 1, x
          asl a
          asl a
          adc StringBuffer - 1, x
          sta PixelPointers - 1, y
          dey
          dey
          dex
          bne StringTimes5

	rts
	.bend

;;; Audited 2022-02-15 BRPocock
