;;; Grizzards Source/Banks/Bank06/Monsters6.s
;;; Copyright © 2021 Bruce-Robert Pocock
Monsters: 
          .SignText "WICKEDSLIME "
          .byte 14               ; art
          .colu COLGREEN, $f
          .byte 2, 1, 2, $6         ; ATK, DEF, HP, + score for defeating (BCD)
          .byte 0

          .SignText "HORRIDSLIME "
          .byte 14               ; art
          .colu COLRED, $f
          .byte 3, 2, 3, $6        ; ATK, DEF, HP, score
          .byte 0
          
          .SignText "VORPALBUNNY "
          .byte 0
          .colu COLGOLD, $4
          .byte 6, 4, 5, $10
          .byte 0
          
          .SignText "R.O.    U.S."
          .byte 1
          .colu COLBROWN, $8
          .byte 2, 2, 6, $15
          .byte 0

          .SignText "LECTRO SHEEP"
          .byte 2
          .colu COLBLUE, $8
          .byte 2, 5, 7, $15
          .byte 0

          .SignText "VIKINGTURTLE"
          .byte 3
          .colu COLTURQUOISE, $8
          .byte 5, 15, 9, $15
          .byte 0

          .SignText "CRAZY    FOX"
          .byte 4
          .colu COLRED, $e
          .byte 15, 15, 15, $50
          .byte 0

          .SignText "WATER  KITTY"
          .byte 5
          .colu COLBLUE, $e
          .byte 10, 6, 9, $20
          .byte 0
;;; 8
          .SignText "FLAME  DOGGO"
          .byte 6
          .colu COLRED, $c
          .byte 15, 6, 8, $35
          .byte 0

          .SignText "FUZZIE  BEAR"
          .byte 7
          .colu COLBROWN, $8
          .byte 12, 12, 12, $10
          .byte 0

;;; 10

          .SignText "METAL  MOUSE"
          .byte 8
          .colu COLGRAY, $f
          .byte 12, 20, 10, $10
          .byte 0

          .SignText "FIRE   PANDA"
          .byte 9
          .colu COLORANGE, $e
          .byte 15, 10, 10, $35
          .byte 0

          .SignText "LEGGY MUTANT"
          .byte 10
          .colu COLBLUE, $8
          .byte $05, $05, $05, $10
          .byte 0

          .SignText "SKY   MUTANT"
          .byte 11
          .colu COLBLUE, $8
          .byte $05, $05, $05, $10
          .byte 0

          .SignText "WILL-O -WISP"
          .byte 12
          .colu COLCYAN, $e
          .byte 20, 5, 1, $10
          .byte 0

          .SignText "BUTTER   FLY"
          .byte 13
          .colu COLBLUE, $8
          .byte 0, $03, $03, $10
          .byte 0

          .SignText "SCARY    RAT"
          .byte 1
          .colu COLBLUE, $8
          .byte $05, $05, $05, $10
          .byte 0

          .SignText "CAVE    GRUE"
          .byte 1
          .colu COLBLUE, $8
          .byte 3, 3, 30, $45
          .byte 0

          .SignText "CAVE  BAT   "
          .byte 20
          .colu COLGRAY, $8
          .byte 2, 2, 10, $10
          .byte 0

          .SignText "MONSTR  19  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  20  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  21  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  22  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  23  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  24  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  25  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  26  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  27  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  28  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  29  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  30  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  31  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  32  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  33  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  34  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  35  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  36  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  37  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  38  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  39  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  40  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  41  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  42  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  43  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  44  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0

          .SignText "MONSTR  45  "
          .byte 2
          .colu COLBLUE, $8
          .byte 0, 0, 0, $10
          .byte 0
