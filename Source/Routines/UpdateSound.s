;;; Update AtariVox or TV sound.
;;; 
;;; Music pauses when someone is speaking.
;;;

UpdateSound:	.macro
	.block
	lda Utterance
	beq MaybeMusic

	;; TODO AtariVox

MaybeMusic:
	ldy Music
	beq DoneSound


DoneSound:
	nop

	.bend
	.endm
