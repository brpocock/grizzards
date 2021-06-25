;;; Grizzards Source/Routines/DecodeText.s
;;; Copyright © 2021 Bruce-Robert Pocock
DecodeText:	.block
	lda #>Font
	sta pp0h
	sta pp1h
	sta pp2h
	sta pp3h
	sta pp4h
	sta pp5h

	.for i := 0, i < 6, i += 1
	lda StringBuffer + i
          clc
          asl a
          asl a
          adc StringBuffer + i
	sta PixelPointers + i * 2
	.next

	rts
	.bend
