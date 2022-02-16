;;; Grizzards Source/Common/48Pixels.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
;;; Macros for setting up 48px graphics and text

SetUpFortyEight:	.macro Graphics

          .if (< \Graphics) == 0

          lda #>\Graphics
	sta pp0h
          sta pp1h
          sta pp2h
          sta pp3h
          sta pp4h
          sta pp5h
          dec pp0h

          .else

          .warn "Graphics not page-aligned: ", \Graphics

	lda #>(\Graphics + \Graphics.Height * 0 - 1)
	sta pp0h
	lda #>(\Graphics + \Graphics.Height * 1 - 1)
	sta pp1h
	lda #>(\Graphics + \Graphics.Height * 2 - 1)
	sta pp2h
	lda #>(\Graphics + \Graphics.Height * 3 - 1)
	sta pp3h
	lda #>(\Graphics + \Graphics.Height * 4 - 1)
	sta pp4h
	lda #>(\Graphics + \Graphics.Height * 5 - 1)
	sta pp5h

          .fi

	lda #<(\Graphics + \Graphics.Height * 0 - 1)
	sta pp0l
	lda #<(\Graphics + \Graphics.Height * 1 - 1)
	sta pp1l
	lda #<(\Graphics + \Graphics.Height * 2 - 1)
	sta pp2l
	lda #<(\Graphics + \Graphics.Height * 3 - 1)
	sta pp3l
	lda #<(\Graphics + \Graphics.Height * 4 - 1)
	sta pp4l
	lda #<(\Graphics + \Graphics.Height * 5 - 1)
	sta pp5l

          ldy #\Graphics.Height
          sty LineCounter

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

          .enc "minifont-extended"
	.cdef "09", 0
	.cdef "az", 10
	.cdef "AZ", 10
	.cdef "..", 36
	.cdef "!!", 37
	.cdef "??", 38
	.cdef "--", 39
	.cdef "  ", 40
          .cdef ",,", 41
          .cdef "''", 42
          .cdef "<<", 43
          .cdef ">>", 44
	.enc "none"

MiniText:	.macro String
	.enc "minifont"
          .if len(\String) != 6
          .error "String length for .MiniText must be 6 ", \String, " is ", len(\String)
          .fi
	.byte \String[0]
	.byte \String[1]
	.byte \String[2]
	.byte \String[3]
	.byte \String[4]
	.byte \String[5]
	.enc "none"
	.endm

Pack6:   .macro byteA, byteB, byteC, byteD
          .byte ((\byteA & $3f) << 2) | ((\byteB & $30) >> 4)
          .byte ((\byteB & $0f) << 4) | ((\byteC & $3c) >> 2)
          .byte ((\byteC & $03) << 6) | (\byteD & $3f)
          .endm

SignText: .macro string
          .enc "minifont-extended"
          .if len(\string) != 12
          .error "String length for .SignText must be 12 ", \string, " is ", len(\string)
          .fi
          .Pack6 \string[0], \string[1], \string[2], \string[3]
          .Pack6 \string[4], \string[5], \string[6], \string[7]
          .Pack6 \string[8], \string[9], \string[10], \string[11]
	.enc "none"
	.endm

	.enc "none"

;;; Audited 2022-02-16 BRPocock
