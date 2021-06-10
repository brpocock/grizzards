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
	.byte \String[0] * 5
	.byte \String[1] * 5
	.byte \String[2] * 5
	.byte \String[3] * 5
	.byte \String[4] * 5
	.byte \String[5] * 5
	.enc "none"
	.endm

	
SetUpTextConstant:	.macro String
	lda #>Font
	sta pp0h
	sta pp1h
	sta pp2h
	sta pp3h
	sta pp4h
	sta pp5h

	.enc "minifont"
	lda #<(\String[0] * Font.Height) 
	sta pp0l
	lda #<(\String[1] * Font.Height)
	sta pp1l
	lda #<(\String[2] * Font.Height)
	sta pp2l
	lda #<(\String[3] * Font.Height)
	sta pp3l
	lda #<(\String[4] * Font.Height)
	sta pp4l
	lda #<(\String[5] * Font.Height)
	sta pp5l
	.enc "none"
	
	.endm	

	.enc "none"
	
