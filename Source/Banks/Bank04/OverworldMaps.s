;;; Grizzards Source/Banks/Bank04/OverworldMaps.s
;;; Copyright © 2021 Bruce-Robert Pocock

          ;; How many maps are in these tables?
MapCount:
          .byte 47

;;; Foreground and background colors
;;; Remember SECAM and don't make these too similar

MapColors:
          ;; 0
          .colors COLINDIGO, COLSPRINGGREEN
          .colors COLGREEN, COLSPRINGGREEN
          .colors COLGREEN, COLSPRINGGREEN
          .colors COLGREEN, COLSPRINGGREEN
          .colors COLTEAL, COLSPRINGGREEN
          .colors COLCYAN, COLSPRINGGREEN
          .colors COLCYAN, COLSPRINGGREEN
          .colors COLGREEN, COLGRAY
          .colors COLGREEN, COLGRAY
          .colors COLCYAN, COLGRAY
          ;; 10
          .colors COLTURQUOISE, COLGRAY
          .colors COLGREEN, COLGRAY
          .colors COLTEAL, COLGRAY
          .colors COLCYAN, COLGRAY
          .colors COLCYAN, COLGRAY
          .colors COLTURQUOISE, COLGRAY
          .colors COLTURQUOISE, COLGRAY
          .colors COLTURQUOISE, COLGRAY
          .colors COLTURQUOISE, COLGRAY
          .colors COLBLUE, COLGRAY
          ;; 20
          .colors COLBLUE, COLGRAY
          .colors COLINDIGO, COLBLUE
          .colors COLINDIGO, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLPURPLE, COLGRAY
          .colors COLPURPLE, COLGRAY
          .colors COLPURPLE, COLGRAY
          .colors COLPURPLE, COLGRAY
          .colors COLPURPLE, COLGRAY
          .colors COLMAGENTA, COLGOLD
          ;; 30
          .colors COLMAGENTA, COLGOLD
          .colors COLMAGENTA, COLGOLD
          .colors COLMAGENTA, COLGOLD
          .colors COLMAGENTA, COLGOLD
          .colors COLRED, COLGOLD
          .colors COLRED, COLGOLD
          .colors COLRED, COLGOLD
          .colors COLORANGE, COLGOLD
          .colors COLORANGE, COLGOLD
          .colors COLORANGE, COLGOLD
          ;; 40
          .colors COLMAGENTA, COLGOLD
          .colors COLRED, COLGOLD
          .colors COLORANGE, COLGOLD
          .colors COLRED, COLGOLD
          .colors COLRED, COLGOLD
          .colors COLORANGE, COLGOLD
          .colors COLORANGE, COLGOLD

;;; Links up, down, left, right are map indices in this bank
MapLinks:
          .byte $ff, $ff, $ff, $ff
          .byte $ff, 7, $ff, 2
          .byte $ff, $ff, 1, 3
          .byte $ff, $ff, 2, 4
          .byte $ff, $ff, 3, 5
          ;; 5
          .byte $ff, 9, 4, 6
          .byte $ff, $ff, 5, $ff
          .byte 1, 8, $ff, $ff
          .byte 7, $ff, $ff, 11   ; TODO link S
          .byte 5, 14, $ff, $ff
          ;; 10
          .byte $ff, 15, $ff, $ff
          .byte $ff, $ff, 8, 12
          .byte $ff, $ff, 11, 13
          .byte $ff, $ff, 12, 14
          .byte 9, 17, 13, 15
          ;; 15
          .byte 10, 16, 14, $ff  ; TODO link E
          .byte 15, $ff, $ff, $ff
          .byte 14, $ff, 18, 16
          .byte $ff, 23, 19, 17
          .byte $ff, $ff, 20, 18
          ;; 20
          .byte $ff, $ff, $ff, 19
          .byte $ff, 24, 23, 22
          .byte $ff, $ff, 21, 23
          .byte 18, 26, 22, 21
          .byte 21, $ff, $ff, $ff
          ;; 25
          .byte $ff, $ff, 28, 26
          .byte 23, 32, 25, 27
          .byte $ff, $ff, 26, 28
          .byte $ff, $ff, 27, 25
          .byte $ff, 44, $ff, 30
          ;; 30
          .byte $ff, 43, 29, 31
          .byte $ff, 34, 30, 32
          .byte 26, 35, 31, 33
          .byte $ff, 36, 32, 40
          .byte 31, 37, 43, 35
          ;; 35
          .byte 32, 38, 34, 36
          .byte 33, 39, 35, 41
          .byte 34, $ff, 46, 38
          .byte 35, $ff, 37, 39
          .byte 36, $ff, 38, 42
          ;; 40
          .byte $ff, 41, 33, $ff
          .byte 40, 42, 36, $ff
          .byte 41, $ff, 39, $ff
          .byte 30, 46, 44, 34
          .byte 29, 45, $ff, 43
          ;; 45
          .byte 44, $ff, $ff, 46
          .byte 43, $ff, 45, 37

;;; RLE Map data for each screen.

;;; Note that it can be reused, so the same basic layout, potentially
;;; in different colors, can appear in several places.
          MapRLE = (
          ;; 0
          Map_Closed,
          Map_Arc,
          Map_EWPassage,
          Map_EWFat,
          Map_Wiggle,
          ;; 5
          Map_Arc,
          Map_EWPassage,
          Map_Narrow,
          Map_FourWay,
          Map_Bulge,
          ;; 10
          Map_NorthGlobe,
          Map_EWPassage,
          Map_EWPassage,
          Map_EWPassage,
          Map_FourWay,
          ;; 15
          Map_FourWay,
          Map_SouthGlobe,
          Map_Bow,
          Map_Arc,
          Map_EWPassage,
          ;; 20
          Map_EWFat,
          Map_Split,
          Map_SplitBoxes,
          Map_SplitMaze,
          Map_SouthGlobe,
          ;; 25
          Map_EWFat,
          Map_FourWay,
          Map_EWFat,
          Map_EWFat,
          Map_FullTop,
          ;; 30
          Map_FullTop,
          Map_ClosedNorth,
          Map_OpenNorth,
          Map_ClosedNorth,
          Map_Island,
          ;; 35
          Map_Clear,
          Map_Clear,
          Map_BottomLine,
          Map_BottomLine,
          Map_BottomLine,
          ;; 40
          Map_FullTop,
          Map_Clear,
          Map_BottomLine,
          Map_Clear,
          Map_Clear,
          ;; 45
          Map_BottomLine,
          Map_BottomLine
          )

MapRLEL:  .byte <MapRLE
MapRLEH:  .byte >MapRLE

;;; Maps can have left or right sides added by the Ball
;;;
;;; This lets the exits be asymmetrical, even though the playfield is in
;;; reflected mode
;;; $80 = left, $40 = right ball.
MapSides:
          .byte 0, $80, 0, 0, 0
          .if DEMO = 1
          .byte 0, $40, $80, $80, 0 ; block off area to left of screen 8
          .else
          .byte 0, $40, 0, $80, 0
          .fi
          ;; 10
          .byte 0, 0, 0, 0, 0
          .if DEMO = 1
          ; block off area to right of screen 15 and left of 17
          .byte $40, $40, $c0, 0, $80 
          .else
          .byte 0, $40, $40, 0, $80
          .fi
          ;; 20
          .byte 0, 0, 0, 0, 0
          .byte 0, 0, 0, 0, $80
          ;; 30
          .byte 0, 0, 0, 0, 0
          .byte 0, 0, 0, 0, 0
          ;; 40
          .byte $40, $40, $40, 0, $80
          .byte $80, 0

;;; The Sprites Lists
;;;
;;; Each screen can have a list of sprites here, ending with a zero
;;; byte. Each sprite is a 5-byte structure, with its type, X, Y,
;;; action, and action-parameter listed.
;;;
;;; A fixed sprite appears at the given position and stays there.
;;; Moving sprites wander the screen, obeying walls.
;;; Random encounters occupy a sprite data slot but are not actually
;;; visible on the screen.
MapSprites:
          ;; Room 0
          .byte $ff              ; not removeable
          .byte SpriteFixed     ; fixed position sprite
          .byte $7d, $42         ; x, y position
          .byte SpriteDoor, 3   ; action

          .if DEMO != 1         ; hide doors 2,3,4 from demo

          .byte $ff
          .byte SpriteFixed
          .byte $b5, $26
          .byte SpriteProvinceDoor | $10, 0

          .byte $ff
          .byte SpriteFixed
          .byte $43, $26
          .byte SpriteProvinceDoor | $20, 0

          .byte $ff
          .byte SpriteFixed
          .byte $7d, $0f
          .byte SpriteProvinceDoor | $30, 0

          .fi
          
          .byte 0               ; end of list

          ;; Room 1
          .byte $ff
          .byte SpriteWander
          .byte 75, 65         ; x, y position
          .byte SpriteCombat, 3

          .byte $ff
          .byte SpriteWander
          .byte 100, 65         ; x, y position
          .byte SpriteCombat, 0

          .byte $ff
          .byte SpriteWander
          .byte 100, 25         ; x, y position
          .byte SpriteCombat, 1

          .byte 0               ; end of list

          ;; Room 2
          .byte $ff
          .byte SpriteWander
          .byte 100, 32         ; x, y position
          .byte SpriteCombat, 0

          .byte 0
          
          ;; Room 3
          .byte $ff
          .byte SpriteFixed
          .byte $7d, $31         ; x, y
          .byte SpriteGrizzardDepot, 0

          .byte 0
          
          ;; Room 4
          .byte 0
          
          ;; Room 5
          .byte 0

          ;; Room 6
          .byte 0

          ;; Room 7
          .byte $ff
          .byte SpriteFixed
          .byte $7c, $2a
          .byte SpriteCombat, 2

          .byte 0

          ;; Room 8
          .byte 0

          ;; Room 9
          .byte 0

          ;; Room 10
          .byte 0

          ;; Room 11
          .byte 0

          ;; Room 12
          .byte 0

          ;; Room 13
          .byte 0
          

	;;Room 14
	.byte 0

	;;Room 15
	.byte 0

	;;Room 16
	.byte 0

	;;Room 17
	.byte 0

	;;Room 18
	.byte 0

	;;Room 19
          .byte $ff
          .byte SpriteFixed
          .byte $3b, $28         ; x, y
          .byte SpriteGrizzardDepot, 0

	.byte 0

	;;Room 20
	.byte 0

	;;Room 21
	.byte 0

	;;Room 22
	.byte 0

	;;Room 23
	.byte 0

	;;Room 24
	.byte 0

	;;Room 25
	.byte 0

	;;Room 26
	.byte 0

	;;Room 27
	.byte 0

	;;Room 28
	.byte 0

	;;Room 29
	.byte 0

	;;Room 30
	.byte 0

	;;Room 31
	.byte 0

	;;Room 32
	.byte 0

	;;Room 33
	.byte 0

	;;Room 34
	.byte 0

	;;Room 35
	.byte 0

	;;Room 36
	.byte 0

	;;Room 37
	.byte 0

	;;Room 38
	.byte 0

	;;Room 39
	.byte 0

	;;Room 40
	.byte 0

	;;Room 41
	.byte 0

	;;Room 42
	.byte 0

	;;Room 43
	.byte 0

	;;Room 44
	.byte 0

	;;Room 45
	.byte 0

	;;Room 46
	.byte 0

          .fill 200
