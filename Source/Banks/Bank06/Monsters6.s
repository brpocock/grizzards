;;; Grizzards Source/Banks/Bank06/Monsters6.s
;;; Copyright © 2021 Bruce-Robert Pocock
Monsters: 
          .MiniText "WICKED"
          .MiniText "SLIME "
          .byte 14               ; art
          .colu COLGREEN, $f
          .byte $20, $6         ; ATK/DEF, + score for defeating (BCD)
          
          .MiniText "HORRID"
          .MiniText "SLIME "
          .byte 14               ; art
          .colu COLRED, $f
          .byte $21, $6        ; ATK/DEF, score
          
          .MiniText "VORPAL"
          .MiniText "BUNNY "
          .byte 0
          .colu COLGOLD, $4
          .byte $22, $6
          
          .MiniText "R.O.  "
          .MiniText "  U.S."
          .byte 1
          .colu COLGOLD, $0
          .byte $32, $15

	.MiniText "LECTRO"
	.MiniText " SHEEP"
	.byte 2
	.colu COLBLUE, $8
	.byte $22, $15

	.MiniText "VIKING"
	.MiniText "TURTLE"
	.byte 3
	.colu COLBLUE, $8
	.byte $33, $15

	.MiniText "CRAZY "
	.MiniText "   FOX"
	.byte 4
	.colu COLBLUE, $8
	.byte $44, $50

	.MiniText "WATER "
	.MiniText " KITTY"
	.byte 5
	.colu COLBLUE, $8
	.byte $00, $20
;;; 8
	.MiniText "FLAME "
	.MiniText " DOGGO"
	.byte 6
	.colu COLRED, $d
	.byte $32, $35

	.MiniText "FUZZIE"
	.MiniText "  BEAR"
	.byte 7
	.colu COLBLUE, $8
	.byte $44, $10

;;; 10

	.MiniText "METAL "
	.MiniText " MOUSE"
	.byte 8
	.colu COLBLUE, $8
	.byte $44, $10

	.MiniText "FIRE  "
	.MiniText " PANDA"
	.byte 9
	.colu COLBLUE, $8
	.byte $32, $35

	.MiniText "LEGGY "
	.MiniText "MUTANT"
	.byte 10
	.colu COLBLUE, $8
	.byte $55, $10

	.MiniText "SKY   "
	.MiniText "MUTANT"
	.byte 11
	.colu COLBLUE, $8
	.byte $55, $10

	.MiniText "WILL-O"
	.MiniText " -WISP"
	.byte 12
	.colu COLBLUE, $8
	.byte $41, $10

	.MiniText "BUTTER"
	.MiniText "   FLY"
	.byte 13
	.colu COLBLUE, $8
	.byte $03, $10

	.MiniText "SCARY "
	.MiniText "   RAT"
	.byte 1
	.colu COLBLUE, $8
	.byte $55, $10

	.MiniText "MONSTR"
	.MiniText "  17  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  18  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  19  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  20  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  21  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  22  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  23  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  24  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  25  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  26  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  27  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  28  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  29  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  30  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  31  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  32  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  33  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  34  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  35  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  36  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  37  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  38  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  39  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  40  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  41  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  42  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  43  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  44  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  45  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  46  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  47  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  48  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10

	.MiniText "MONSTR"
	.MiniText "  49  "
	.byte 2
	.colu COLBLUE, $8
	.byte $00, $10
