;; Grizzards Source/Banks/Bank06/Monsters6.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
Monsters:
;;; 0
          .SignText "WICKEDSLIME "
          .byte Monster_SlimeSmall               ; art
          .mcolu COLGREEN, $f
          .byte 2, 1, 2         ; ATK, DEF, HP
          .word $0006           ;  score for defeating (BCD)

;;; 1
          .SignText "HORRIDSLIME "
          .byte Monster_SlimeSmall               ; art
          .mcolu COLRED, $f
          .byte 3, 2, 3       ; ATK, DEF, HP
          .word $0007

;;; 2
          .SignText "VORPALBUNNY "
          .byte Monster_Bunny
          .mcolu COLGOLD, $4
          .byte 6, 4, 5
          .word $0010
          
          .SignText "R.O.    U.S."
          .byte Monster_Rodent
          .mcolu COLBROWN, $8
          .byte 2, 2, 6
          .word $0015

;;; 4
          .SignText "LECTRO SHEEP"
          .byte Monster_Sheep
          .mcolu COLBLUE, $8
          .byte 2, 5, 7
          .word $0015

          .SignText "VIKINGTURTLE"
          .byte Monster_Turtle
          .mcolu COLTURQUOISE, $8
          .byte 5, 15, 9
          .word $0015

          .SignText "CRAZY    FOX"
          .byte Monster_Fox
          .mcolu COLRED, $e
          .byte 15, 15, 15
          .word $0050

          .SignText "WATER  KITTY"
          .byte Monster_Cat
          .mcolu COLBLUE, $e
          .byte 10, 6, 9
          .word $0020
;;; 8
          .SignText "FLAME  DOGGO"
          .byte Monster_Dog
          .mcolu COLRED, $c
          .byte 15, 6, 8
          .word $0035

          .SignText "CREEPYSPIDER"
          .byte Monster_Spider
          .mcolu COLBROWN, $8
          .byte 12, 12, 12
          .word $0010
;;; 10

          .SignText "METAL  MOUSE"
          .byte Monster_Mouse
          .mcolu COLGRAY, $6
          .byte 12, 20, 10
          .word $0053

          .SignText "FIRE   PANDA"
          .byte Monster_Firefox
          .mcolu COLORANGE, $e
          .byte 15, 10, 10
          .word $0035

          .SignText "LEGGY MUTANT"
          .byte Monster_TwoLegs
          .mcolu COLBLUE, $8
          .byte $05, $05, $05
          .word $0010

          .SignText "SKY   MUTANT"
          .byte Monster_Mutant
          .mcolu COLBLUE, $8
          .byte $05, $05, $05
          .word $0010

          .SignText "WILL-O -WISP"
          .byte Monster_WillOWisp
          .mcolu COLCYAN, $e
          .byte 20, 5, 1
          .word $0010

          .SignText "BUTTER   FLY"
          .byte Monster_Butterfly
          .mcolu COLBLUE, $8
          .byte 0, $03, $03
          .word $0010
;;; 16
          .SignText "SCARY    RAT"
          .byte Monster_Rodent
          .mcolu COLBROWN, $8
          .byte 10, 5, 25
          .word $0026

          .SignText "CAVE    GRUE"
          .byte Monster_Rodent
          .mcolu COLBLUE, $8
          .byte 6, 5, 30
          .word $0045

          .SignText "CAVE  BAT   "
          .byte Monster_Bat
          .mcolu COLGRAY, $8
          .byte 4, 2, 10
          .word $0010

          .SignText "VENOM  SHEEP"
          .byte Monster_Sheep
          .mcolu COLGREEN, $f
          .byte 9, 4, 50
          .word $0035
;;; 20
          .SignText "1 EYEDCYCLOP"
          .byte Monster_Cyclops
          .mcolu COLPURPLE, $8
          .byte 20, 20, 60
          .word $0500

          .SignText "FIERCERAPTOR"
          .byte Monster_Raptor
          .mcolu COLORANGE, $8
          .byte 10, 10, 10
          .word $0010

          .SignText "DEVIL  EAGLE"
          .byte Monster_Eagle
          .mcolu COLRED, $8
          .byte 10, 10, 10
          .word $0010

          .SignText "ROUND  ROBIN"
          .byte Monster_Bird
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0010
;;; 24
          .SignText "GIANT  CRAB "
          .byte Monster_Crab
          .mcolu COLTURQUOISE, $8
          .byte 16, 16, 16
          .word $0160
;;; 25
          .SignText "BIGGER CRAB "
          .byte Monster_Crab
          .mcolu COLCYAN, $8
          .byte 14, 14, 14
          .word $0140

          .SignText " MEAN ROBBER"
          .byte Monster_Human
          .mcolu COLBROWN, $f
          .byte 10, 10, 10
          .word $0010

          .SignText "GIANT SLIME "
          .byte Monster_SlimeBig
          .mcolu COLINDIGO, $8
          .byte 10, 10, 10
          .word $0010
;;; 28
          .SignText "DRAGON FRED "
          .byte Monster_Dragon
          .mcolu COLBLUE, $0
          .byte 60, 60, 175
          .word $2000

          .SignText "DRAGONANDREW"
          .byte Monster_Dragon
          .mcolu COLCYAN, $4
          .byte 50, 50, 150
          .word $1500
;;; 30
          .SignText "DRAGON TIMMY"
          .byte Monster_Dragon
          .mcolu COLGREEN, $8
          .byte 70, 70, 200
          .word $2500

          .SignText " UBER  SLIME"
          .byte Monster_SlimeBig
          .mcolu COLBROWN, $f
          .byte 10, 10, 10
          .word $0010
;;; 32
          .SignText "DESERT EAGLE"
          .byte Monster_Eagle
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0010

          .SignText "CRAZEDROBBER"
          .byte Monster_Human
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0010

          .SignText "GREAT  WYRM "
          .byte Monster_Serpent
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0010
;;; 35
          .SignText "POISON ASP  "
          .byte Monster_Serpent
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0010

          .SignText "GRABBYCRABBY"
          .byte Monster_Crab
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0010
;;; 37
          .SignText "GIANT  BAT  "
          .byte Monster_Bat
          .mcolu COLGRAY, $4
          .byte 10, 10, 10
          .word $0100
;;; 38
          .SignText " MAZE JAGUAR"
          .byte Monster_Cat
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0010
;;; 39
          .SignText "GIANT SPIDER"
          .byte Monster_Spider
          .mcolu COLORANGE, $e
          .byte 50, 5, 40
          .word $0038
;;; 40
          .SignText "MONSTR  40  "
          .byte Monster_Bunny
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0010

          .SignText "MONSTR  41  "
          .byte Monster_Bunny
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0010

          .SignText "MONSTR  42  "
          .byte Monster_Bunny
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0010

          .SignText "MONSTR  43  "
          .byte Monster_Bunny
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0010

          .SignText "MONSTR  44  "
          .byte Monster_Bunny
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0010
;;; 45
          .SignText " BOSS  BEAR "
          .byte $ff             ; special graphics
          .mcolu COLGRAY, 0
          .byte 80, 80, 250
          .word $5000
