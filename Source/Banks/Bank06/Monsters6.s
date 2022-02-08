;; Grizzards Source/Banks/Bank06/Monsters6.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
Monsters:
;;; 0
          .SignText "WICKEDSLIME " ; Tier 1
          .byte Monster_SlimeSmall
          .mcolu COLGREEN, $f
          .byte 2, 1, 2         ; ATK, DEF, HP
          .word $0005
;;; 1
          .SignText "HORRIDSLIME " ; Tier 1
          .byte Monster_SlimeSmall
          .mcolu COLRED, $f
          .byte 3, 2, 3       ; ATK, DEF, HP
          .word $0008
;;; 2
          .SignText "VORPALBUNNY " ; Tier 4
          .byte Monster_Bunny
          .mcolu COLGOLD, $4
          .byte 6, 4, 10
          .word $0040
;;; 3
          .SignText "R.O.    U.S." ; Tier 3
          .byte Monster_Rodent
          .mcolu COLBROWN, $8
          .byte 2, 2, 6
          .word $0035
;;; 4
          .SignText "LECTRO SHEEP" ; Tier 11
          .byte Monster_Sheep
          .mcolu COLBLUE, $8
          .byte 2, 5, 7
          .word $0110
;;; 5
          .SignText "VIKINGTURTLE" ; Tier 7
          .byte Monster_Turtle
          .mcolu COLTURQUOISE, $8
          .byte 5, 15, 9
          .word $0070
;;; 6
          .SignText "CRAZY    FOX" ; Tier 7
          .byte Monster_Fox
          .mcolu COLRED, $e
          .byte 15, 15, 15
          .word $0070
;;; 7
          .SignText "WATER  KITTY" ; Tier 9
          .byte Monster_Cat
          .mcolu COLBLUE, $e
          .byte 10, 6, 9
          .word $0090
;;; 8
          .SignText "FLAME  DOGGO" ; Tier 3
          .byte Monster_Dog
          .mcolu COLRED, $c
          .byte 15, 6, 8
          .word $0030
;;; 9
          .SignText "CREEPYSPIDER" ; Tier 8
          .byte Monster_Spider
          .mcolu COLBROWN, $8
          .byte 12, 12, 12
          .word $0080
;;; 10
          .SignText "METAL  MOUSE" ; Tier 8
          .byte Monster_Rodent
          .mcolu COLGRAY, $6
          .byte 12, 20, 10
          .word $0080
;;; 11
          .SignText "FIRE   PANDA" ; Tier 3
          .byte Monster_Firefox
          .mcolu COLORANGE, $e
          .byte 15, 10, 10
          .word $0030
;;; 12
          .SignText "LEGGY MUTANT" ; Tier 11
          .byte Monster_TwoLegs
          .mcolu COLBLUE, $8
          .byte 5, 5, 5
          .word $0110
;;; 13
          .SignText "SKY   MUTANT" ; Tier 2
          .byte Monster_Mutant
          .mcolu COLRED, $8
          .byte 5, 15, 5
          .word $0020
;;; 14
          .SignText "WILL-O -WISP" ; Tier 4
          .byte Monster_WillOWisp
          .mcolu COLCYAN, $e
          .byte 20, 5, 1
          .word $0040
;;; 15
          .SignText "BUTTER   FLY" ; Tier 10
          .byte Monster_Butterfly
          .mcolu COLBLUE, $8
          .byte 20, 3, 3
          .word $0100
;;; 16
          .SignText "SCARY    RAT" ; Tier 12
          .byte Monster_Rodent
          .mcolu COLBROWN, $8
          .byte 10, 5, 25
          .word $0120
;;; 17
          .SignText "CAVE    GRUE" ; Tier 5
          .byte Monster_Rodent
          .mcolu COLBLUE, $8
          .byte 6, 5, 30
          .word $0050
;;; 18
          .SignText "CAVE  BAT   " ; Tier 5
          .byte Monster_Bat
          .mcolu COLGRAY, $4
          .byte 4, 2, 10
          .word $0050
;;; 19
          .SignText "VENOM  SHEEP" ; Tier 6
          .byte Monster_Sheep
          .mcolu COLGREEN, $f
          .byte 9, 4, 50
          .word $0060
;;; 20
          .SignText "1 EYEDCYCLOP" ; Tier 6
          .byte Monster_Cyclops
          .mcolu COLPURPLE, $8
          .byte 20, 20, 60
          .word $0060
;;; 21
          .SignText "FIERCERAPTOR" ; Tier 10
          .byte Monster_Bird
          .mcolu COLORANGE, $8
          .byte 10, 10, 10
          .word $0100
;;; 22
          .SignText "DEVIL SKULL " ; Tier 12
          .byte Monster_Skull
          .mcolu COLRED, $8
          .byte 10, 10, 10
          .word $0120
;;; 23
          .SignText "ROUND  ROBIN" ; Tier 2
          .byte Monster_Bird
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0020
;;; 24
          .SignText "GIANT  CRAB " ; Tier 9
          .byte Monster_Crab
          .mcolu COLTURQUOISE, $8
          .byte 16, 16, 16
          .word $0090
;;; 25
          .SignText "BIGGER CRAB " ; Tier 13
          .byte Monster_Crab
          .mcolu COLCYAN, $8
          .byte 14, 14, 14
          .word $0130
;;; 26
          .SignText " MEAN ROBBER" ; 8
          .byte Monster_Human
          .mcolu COLBROWN, $e
          .byte 10, 10, 10
          .word $0080
;;; 27
          .SignText "GIANT SLIME " ; Tier 13
          .byte Monster_SlimeBig
          .mcolu COLINDIGO, $8
          .byte 10, 10, 10
          .word $0130
;;; 28
          .SignText "DRAGON FRED "
          .byte Monster_Dragon
          .mcolu COLBLUE, $0
          .byte 30, 30, 87
          .word $1000
;;; 29
          .SignText "DRAGONANDREW"
          .byte Monster_Dragon
          .mcolu COLCYAN, $4
          .byte 25, 25, 75
          .word $0750
;;; 30
          .SignText "DRAGON TIMMY"
          .byte Monster_Dragon
          .mcolu COLGREEN, $8
          .byte 35, 35, 100
          .word $1250
;;; 31
          .SignText " UBER  SLIME" ; Tier 15
          .byte Monster_SlimeBig
          .mcolu COLBROWN, $f
          .byte 10, 10, 10
          .word $0150
;;; 32
          .SignText "FLYINGSKULL " ; Tier 13
          .byte Monster_Skull
          .mcolu COLTURQUOISE, $e
          .byte 10, 10, 10
          .word $0130
;;; 33
          .SignText "CRAZY SKULL " ; Tier 15
          .byte Monster_Skull
          .mcolu COLMAGENTA, $a
          .byte 10, 10, 10
          .word $0150
;;; 34
          .SignText "GREAT  WYRM " ; Tier 15
          .byte Monster_Serpent
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0150
;;; 35
          .SignText "POISON ASP  " ; Tier 12
          .byte Monster_Serpent
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0120
;;; 36
          .SignText "GRABBYCRABBY" ; Tier 9
          .byte Monster_Crab
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0090
;;; 37
          .SignText "GIANT  BAT  " ; Tier 14
          .byte Monster_Bat
          .mcolu COLGRAY, $4
          .byte 10, 10, 10
          .word $0140
;;; 38
          .SignText " MAZE JAGUAR" ; Tier 14
          .byte Monster_Cat
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0140
;;; 39
          .SignText "GIANT SPIDER" ; Tier 15
          .byte Monster_Spider
          .mcolu COLORANGE, $e
          .byte 50, 5, 40
          .word $0150
;;; 40
          .SignText " FIRE DRAKE " ; Tier 11
          .byte Monster_Dragon
          .mcolu COLORANGE, $8
          .byte 99, 10, 30
          .word $0110
;;; 41
          .SignText " MAN   BULL " ; Tier 12
          .byte Monster_Minotaur
          .mcolu COLBROWN, $8
          .byte 10, 10, 10
          .word $0120
;;; 42
          .SignText "RADISHGOBLIN" ; Tier 7
          .byte Monster_Radish
          .mcolu COLRED, $8
          .byte 10, 10, 10
          .word $0070
;;; 43
          .SignText "TURNIPGOBLIN" ; Tier 12
          .byte Monster_Radish
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0120
;;; 44
          .SignText "MONSTR  44  " ; Tier 15
          .byte Monster_Bunny
          .mcolu COLBLUE, $8
          .byte 10, 10, 10
          .word $0150
;;; 45
          .SignText " BOSS  BEAR "
          .byte $ff             ; special graphics
          .mcolu COLGRAY, 0
          .byte 40, 40, 127
          .word $2500
