;;; Grizzards Source/Common/48Pixels.s
;;; Copyright © 2021 Bruce-Robert Pocock
;;; Macros for setting up 48px graphics and text
          

SetUpFortyEight:	.macro Graphics
	lda #<(\Graphics + \Graphics.Height * 0 - 1)
	sta pp0l
	lda #>(\Graphics + \Graphics.Height * 0 - 1)
	sta pp0h
	lda #<(\Graphics + \Graphics.Height * 1 - 1)
	sta pp1l
	lda #>(\Graphics + \Graphics.Height * 1 - 1)
	sta pp1h
	lda #<(\Graphics + \Graphics.Height * 2 - 1)
	sta pp2l
	lda #>(\Graphics + \Graphics.Height * 2 - 1)
	sta pp2h
	lda #<(\Graphics + \Graphics.Height * 3 - 1)
	sta pp3l
	lda #>(\Graphics + \Graphics.Height * 3 - 1)
	sta pp3h
	lda #<(\Graphics + \Graphics.Height * 4 - 1)
	sta pp4l
	lda #>(\Graphics + \Graphics.Height * 4 - 1)
	sta pp4h
	lda #<(\Graphics + \Graphics.Height * 5 - 1)
	sta pp5l
	lda #>(\Graphics + \Graphics.Height * 5 - 1)
	sta pp5h
	
	.endm

	.enc "minifont"
	.cdef "09", 0
	.cdef "az", 10
	.cdef "AZ", 10
	.cdef "..", 36
	.cdef "!!", 37
	.cdef "??", 38
	.cdef "--", 39
	.cdef "  ", 40
	.enc "none"

MiniText:	.macro String
	.enc "minifont"
	.byte \String[0]
	.byte \String[1]
	.byte \String[2]
	.byte \String[3]
	.byte \String[4]
	.byte \String[5]
	.enc "none"
	.endm

	
LoadString:	.macro String
	.enc "minifont"
	lda #\String[0]
	sta StringBuffer + 0
	lda #\String[1]
          sta StringBuffer + 1
	lda #\String[2]
	sta StringBuffer + 2
	lda #\String[3]
          sta StringBuffer + 3
	lda #\String[4]
	sta StringBuffer + 4
	lda #\String[5]
          sta StringBuffer + 5
	.enc "none"
	
	.endm	

	.enc "none"
