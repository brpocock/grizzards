;;; Grizzards Source/Routines/MapScreenKernel.s
;;; Copyright © 2021 Bruce-Robert Pocock
;;;
;;; Kernel for map screens
;;;

DoMap: .block

	;; Set up SECAM colors
	;;
	;; Translating colors for each screen for SECAM is actually
	;; possible, but the current impl is just to hard-code these
	;; colors here.
	.if TV == SECAM
	lda #COLGREEN
	sta COLUPF
	lda #COLBLACK
	sta COLUBK
	lda #COLYELLOW
	sta COLUP0
	sta COLUP1
	.fi

	;; Find the map lines pointers for the current map.
	ldx CurrentMap
FindMap:

	;; Perform VSYNC and start VBLANK timer
	lda #ENABLED
	ldy #0
	sta WSYNC
	sta VSYNC
	sta VBLANK
	sta WSYNC
	sta WSYNC
	sta WSYNC

	sty VSYNC
	lda #( VBlankLines * 76 / 64 )
	sta TIM64T

	ldy #0

	cpx #0
	beq FoundMap
SearchNextMap:	
	lda (MapPointer),y
	clc
	adc MapPointer
	beq NAddMapPointer
	inc MapPointer + 1
NAddMapPointer:	
	sta MapPointer
	dex
	bne SearchNextMap

FoundMap:
	iny			; .y = 1
	;; skip flags byte
	iny			; .y = 2
	lda (MapPointer),y
	sta COLUBK
	iny
	lda (MapPointer),y
	sta COLUPF

	;; Skip exits for now
	ldy #11
	lax (MapPointer),y
	beq SpritesDone

SkipNextSprite:
	iny			; X
	iny			; Y
	iny			; interaction code
	iny			; interaction option
	iny			; graphics
	iny			; color

	dex
	bne SkipNextSprite
	
SpritesDone:
	lda MapPointer + 1
	sta MapLinesPointer + 1
	tya
	clc
	adc MapPointer
	bcc +
	inc MapLinesPointer + 1
+
	sta MapLinesPointer

	;; ...

	jmp IntoVBlank

	;; Start a frame with VBlanking

FrameReady:

	lda #ENABLED
	ldy #0
	sta WSYNC
	sta VSYNC
	sta VBLANK
	sta WSYNC
	sta WSYNC
	sta WSYNC

	sty VSYNC
	lda #( VBlankLines * 76 / 64 )
	sta TIM64T

	;; We are now in VBLANK no matter which route we took to get here
IntoVBlank:
	nop
	
	;; Prepare a sprite, honoring flicker rules

	;; Pick which sprite to display based on a round-robin
PickASprite:
	inc SpriteFlicker
	lda SpriteFlicker
	ldy #11
	cmp MapPointer,y
	bne FlickerThatSprite
	lda #0
	sta SpriteFlicker
FlickerThatSprite:

	;; TODO position sprite

	;; TODO set COLUP1
	
	;; TODO

	;; Prepare the player sprite
PreparePlayerSprite:	
	.block

	lda PlayerX
	sec
	sta WSYNC
WaitForRESP0:
	sbc #15
	bcc WaitForRESP0
	eor #7
	asl a
	asl a
	asl a
	asl a
	nop			; burn 2 cycles
	sta HMP0 
	sta RESP0
	.bend

	;; Perform HMOVE for both sprites
	sta WSYNC
	sta HMOVE
	sta HMCLR

	;; Force colors to grays if switch is set to B&W
	.if TV != SECAM
	lda #SWCHBColor
	bit SWCHB
	beq TVisColor
	lda #COLGRAY | 14
	sta COLUBK
	lda #COLGRAY | 6
	sta COLUPF
	lda #COLGRAY | 2
	sta COLUP0
	sta COLUP1
TVisColor:
	.fi

	;; Wait for the end of VBLANK
WaitOutVBLANK:	
	lda INTIM
	bne WaitOutVBLANK
	sta WSYNC
	sta VBLANK 		; .a = 0

EndOfVBLANK:	
	ldx #0
	sta WSYNC
	
NextMapLines:	
	ldy #0
	lda (MapLinesPointer),y
	bpl MoreMapLines
	jmp MapLinesDone

MoreMapLines:	
	sta MapLinesRepeat
	iny
	
	iny
	lda (MapLinesPointer),y
	sta PF0
	iny
	lda (MapLinesPointer),y
	sta PF1
	iny
	lda (MapLinesPointer),y
	sta PF2
	lda MapLinesPointer
	clc
	adc #5

	sta WSYNC

	;; sprites TODO

	sta WSYNC
	
	dec MapLinesRepeat
	inx
	beq NextMapLines

	;; sprites TODO

	;; 
	
MapLinesDone:	
	nop

	;; Set up overscan with a timer
DoOverscan:	
	
	lda #ENABLED
	sta VBLANK

	lda #( OverscanLines * 76 / 64 )
	
	; TODO .UpdateSound

	;; Check the joystick & select switch
ScanSwitches:
	nop

ScanStick:
	lda #P0StickUp
	bit SWCHA
	bne SkipMoveUp

MoveUp:
	inc PlayerY
	lda PlayerY
	cmp #192
	bne SkipMoveUp

	lda #0
	sta PlayerY
	ldy #4
	jmp MoveScreen
	
SkipMoveUp:
	lda #P0StickDown
	bit SWCHA
	bne SkipMoveDown

MoveDown:	
	dec PlayerY
	lda PlayerY
	cmp #$ff
	bne SkipMoveDown

	lda #191
	sta PlayerY
	ldy #5
	jmp MoveScreen

SkipMoveDown:
	lda #P0StickLeft
	bit SWCHA
	bne SkipMoveLeft

MoveLeft:
	lda #$ff
	sta REFP0
	
	dec PlayerX
	lda PlayerX
	cmp #$ff
	bne SkipMoveLeft

	lda #159
	sta PlayerX
	ldy #6
	jmp MoveScreen

SkipMoveLeft:
	lda #P0StickRight
	bit SWCHA
	bne SkipMoveRight

MoveRight:
	lda #0
	sta REFP0
	
	inc PlayerX
	lda PlayerX
	cmp #160
	bne SkipMoveRight

	lda #0
	sta PlayerX
	ldy #7
	jmp MoveScreen	

SkipMoveRight:
	nop

CheckSelect:
	lda SWCHBSelect
	bit SWCHB
	bne SkipSelect

SelectDown:
	;; TODO

SkipSelect:
	nop

	;; Check for player near to the Special Exit
	;; "Near to" is within the 8px × 8px box
	lda PlayerX
	and #$f8
	cmp SpecialX
	bne NotSpecial

	lda PlayerY
	and #$f8
	cmp SpecialY
	bne NotSpecial

	ldy #8
	jmp MoveScreen

NotSpecial:	

	;; TODO additional overscan work

	;; Wait for the end of the overscan period
WaitOutOverscan:
	lda INTIM
	bne WaitOutOverscan
	sta WSYNC

	;; And loop back to the next frame
	jmp FrameReady

;;; 

MoveScreen:
	;; .y = link to new screen index
	lda (MapPointer),y
	sta CurrentMap

	;; Finish out overscan here
WaitToMoveScreen:
	lda INTIM
	bne WaitToMoveScreen
	sta WSYNC

	tax
	jmp FindMap

	.bend
