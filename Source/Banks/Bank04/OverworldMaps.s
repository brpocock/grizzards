          ;; chat memory bank is common to all maps in this bank
          RelatedChatBank = $01

          ;; How many maps are in these tables?
MapCount:
          .byte 3

;;; Foreground and background colors
;;; Remember SECAM and don't make these too similar

MapFG:
          .colu COLINDIGO, 0
          .colu COLGRAY, 2
          .colu COLGOLD, 0

MapBG:
          .colu COLBLUE, $f
          .colu COLGRAY, $d
          .colu COLGOLD, $f

;;; Links up, down, left, right are map indices in this bank
MapLinks:
          ;; Room 0
          .byte 1, $ff, $ff, 2
          ;; Room 1
          .byte $ff, 0, $ff, $ff
          ;; Room 2
          .byte $ff, $ff, 0, $ff

;;; RLE Map data for each screen.

;;; Note that it can be reused, so the same basic layout, potentially
;;; in different colors, can appear in several places.
          MapRLE = (
          Map_Maze1,
          Map_OpenSouth,
          Map_OpenSides
          )

MapRLEL:  .byte <MapRLE
MapRLEH:  .byte >MapRLE

;;; Maps can have left or right sides added by the Ball
;;;
;;; This lets the exits be asymmetrical, even though the playfield is in
;;; reflected mode
MapSides: .byte $80, $00, $40

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
          .byte SpriteFixed     ; fixed position sprite
          .byte 0               ; sprite art index = person
          .byte 150, 35         ; x, y position
          .byte SpriteCombat      ; action
          .byte 0
          ;; 
          .byte 0               ; end of list
          ;; Room 1
          .byte SpriteFixed     ; fixed position sprite
          .byte 0               ; sprite art index = person
          .byte 75, 65         ; x, y position
          .byte SpriteChat      ; action
          .byte 3               ; chat index 3 = Roton
          ;;
          .byte SpriteFixed     ; fixed position sprite
          .byte 1               ; sprite art index = monster
          .byte 100, 65         ; x, y position
          .byte SpriteCombat   ; action
          .byte 0               ; combat index
          ;;
          .byte 0               ; end of list
          ;; Room 2
          .byte SpriteFixed
          .byte 1               ; sprite art index = monster
          .byte 150, 65         ; x, y
          .byte SpriteCombat
          .byte 0               ; combat index
          .byte 0               ; end of list

;;; RLE data for each screen layout
;;;
;;; Repeat count, PF0, PF1, PF2
Map_ClosedSouth:
          .byte 4,  %11110000, %11111111, %00000000
          .byte 67, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_OpenSouth:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 67, %00110000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %00000000

Map_OpenSides:
          .byte 4,  %11110000, %11111111, %11111111
          .byte 67, %00000000, %00000000, %00000000
          .byte 4,  %11110000, %11111111, %11111111

Map_Maze1:
          .byte 4,  %11110000, %11111111, %11110000
          .byte 16, %00000000, %00000000, %00010000
          .byte 36, %11000000, %11110000, %00000000
          .byte 16, %10000000, %00000000, %00010000
          .byte 4,  %11110000, %11111111, %11111111

;;; Sprite art

SpriteArt:

PersonSprite:
          .byte %00110011
          .byte %00110011
          .byte %00111111
          .byte %00111111
          .byte %11111111
          .byte %00001100
          .byte %00011110
          .byte %00001100

          .byte %01100110
          .byte %01100110
          .byte %00111111
          .byte %11111111
          .byte %00111111
          .byte %00001100
          .byte %00011110
          .byte %00001100

MonsterSprite:
          .byte %11111111
          .byte %11111111
          .byte %01111110
          .byte %00111100
          .byte %00000000
          .byte %00000000
          .byte %00000000
          .byte %00000000

          .byte %11111111
          .byte %11111111
          .byte %11111111
          .byte %01111110
          .byte %00111100
          .byte %00000000
          .byte %00000000
          .byte %00000000

SpriteColor:
          .colu COLRED, 8
          .colu COLGREEN, 8

