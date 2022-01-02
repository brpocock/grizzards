;;; Grizzards Source/Banks/Bank06/Monsters6.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
Monsters: 
          .SignText "WICKEDSLIME "
          .byte Monster_SlimeSmall               ; art
          .colu COLGREEN, $f
          .byte 2, 1, 2         ; ATK, DEF, HP
          .word $0006           ;  score for defeating (BCD)

          .SignText "HORRIDSLIME "
          .byte Monster_SlimeSmall               ; art
          .colu COLRED, $f
          .byte 3, 2, 3       ; ATK, DEF, HP
          .word $0007
          
          .SignText "VORPALBUNNY "
          .byte Monster_Bunny
          .colu COLGOLD, $4
          .byte 6, 4, 5
          .word $0010
          
          .SignText "R.O.    U.S."
          .byte Monster_Rodent
          .colu COLBROWN, $8
          .byte 2, 2, 6
          .word $0015

          .SignText "LECTRO SHEEP"
          .byte Monster_Sheep
          .colu COLBLUE, $8
          .byte 2, 5, 7
          .word $0015

          .SignText "VIKINGTURTLE"
          .byte Monster_Turtle
          .colu COLTURQUOISE, $8
          .byte 5, 15, 9
          .word $0015

          .SignText "CRAZY    FOX"
          .byte Monster_Fox
          .colu COLRED, $e
          .byte 15, 15, 15
          .word $0050

          .SignText "WATER  KITTY"
          .byte Monster_Cat
          .colu COLBLUE, $e
          .byte 10, 6, 9
          .word $0020
;;; 8
          .SignText "FLAME  DOGGO"
          .byte Monster_Dog
          .colu COLRED, $c
          .byte 15, 6, 8
          .word $0035

          .SignText "FUZZIE  BEAR"
          .byte Monster_Bear
          .colu COLBROWN, $8
          .byte 12, 12, 12
          .word $0010
;;; 10

          .SignText "METAL  MOUSE"
          .byte Monster_Mouse
          .colu COLGRAY, $f
          .byte 12, 20, 10
          .word $0010

          .SignText "FIRE   PANDA"
          .byte Monster_Firefox
          .colu COLORANGE, $e
          .byte 15, 10, 10
          .word $0035

          .SignText "LEGGY MUTANT"
          .byte Monster_TwoLegs
          .colu COLBLUE, $8
          .byte $05, $05, $05
          .word $0010

          .SignText "SKY   MUTANT"
          .byte Monster_Mutant
          .colu COLBLUE, $8
          .byte $05, $05, $05
          .word $0010

          .SignText "WILL-O -WISP"
          .byte Monster_WillOWisp
          .colu COLCYAN, $e
          .byte 20, 5, 1
          .word $0010

          .SignText "BUTTER   FLY"
          .byte Monster_Butterfly
          .colu COLBLUE, $8
          .byte 0, $03, $03
          .word $0010
;;; 16
          .SignText "SCARY    RAT"
          .byte Monster_Rodent
          .colu COLBLUE, $8
          .byte $05, $05, $05
          .word $0010

          .SignText "CAVE    GRUE"
          .byte Monster_Rodent
          .colu COLBLUE, $8
          .byte 6, 5, 30
          .word $0045

          .SignText "CAVE  BAT   "
          .byte Monster_Bat
          .colu COLGRAY, $8
          .byte 2, 2, 10
          .word $0010

          .SignText "VENOM  SHEEP"
          .byte Monster_Sheep
          .colu COLGREEN, $f
          .byte 9, 4, 50
          .word $0035
;;; 20
          .SignText "1 EYEDCYCLOP"
          .byte Monster_Cyclops
          .colu COLPURPLE, $8
          .byte 20, 20, 60
          .word $0120

          .SignText "FIERCERAPTOR"
          .byte Monster_Raptor
          .colu COLORANGE, $8
          .byte 0, 0, 0
          .word $0010

          .SignText "DEVIL  EAGLE"
          .byte Monster_Eagle
          .colu COLRED, $8
          .byte 0, 0, 0
          .word $0010

          .SignText "ROUND  ROBIN"
          .byte Monster_Bird
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010
;;; 24
          .SignText "GIANT  CRAB "
          .byte Monster_Crab
          .colu COLTURQUOISE, $8
          .byte 0, 0, 0
          .word $0010
;;; 25
          .SignText "BIGGER CRAB "
          .byte Monster_Crab
          .colu COLCYAN, $8
          .byte 0, 0, 0
          .word $0010

          .SignText " MEAN ROBBER"
          .byte Monster_Human
          .colu COLBROWN, $f
          .byte 0, 0, 0
          .word $0010

          .SignText "GIANT SLIME "
          .byte Monster_SlimeBig
          .colu COLINDIGO, $8
          .byte 0, 0, 0
          .word $0010
;;; 28
          .SignText "DRAGON FRED "
          .byte Monster_Dragon
          .colu COLRED, $0
          .byte 50, 50, 200
          .word $1000

          .SignText "DRAGONANDREW"
          .byte Monster_Dragon
          .colu COLRED, $4
          .byte 50, 50, 200
          .word $1000
;;; 30
          .SignText "DRAGON TIMMY"
          .byte Monster_Dragon
          .colu COLRED, $8
          .byte 50, 50, 200
          .word $1000

          .SignText " UBER  SLIME"
          .byte Monster_SlimeBig
          .colu COLBROWN, $f
          .byte 0, 0, 0
          .word $0010
;;; 32
          .SignText "DESERT EAGLE"
          .byte Monster_Eagle
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010

          .SignText "CRAZEDROBBER"
          .byte Monster_Human
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010

          .SignText "GREAT  WYRM "
          .byte Monster_Serpent
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010
;;; 35
          .SignText "POISON ASP  "
          .byte Monster_Serpent
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010

          .SignText "GRABBYCRABBY"
          .byte Monster_Crab
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010

          .SignText "MONSTR  37  "
          .byte Monster_Bunny
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010

          .SignText "MONSTR  38  "
          .byte Monster_Bunny
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010

          .SignText "MONSTR  39  "
          .byte Monster_Bunny
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010
;;; 40
          .SignText "MONSTR  40  "
          .byte Monster_Bunny
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010

          .SignText "MONSTR  41  "
          .byte Monster_Bunny
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010

          .SignText "MONSTR  42  "
          .byte Monster_Bunny
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010

          .SignText "MONSTR  43  "
          .byte Monster_Bunny
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010

          .SignText "MONSTR  44  "
          .byte Monster_Bunny
          .colu COLBLUE, $8
          .byte 0, 0, 0
          .word $0010
;;; 45
          .SignText " BOSS  BEAR "
          .byte Monster_Bear
          .colu COLBLUE, $8
          .byte 50, 50, 200
          .word $2500
