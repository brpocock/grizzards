;; Grizzards Source/Banks/Bank06/Monsters6.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
Monsters:
;;; 0
          .Text12 "WICKEDSLIME " ; Tier 1
          .byte Monster_SlimeSmall
          .mcolu COLGREEN, $f
          .byte 2, 1, 2         ; ATK, DEF, HP
          .word $0005
;;; 1
          .Text12 "HORRIDSLIME " ; Tier 1
          .byte Monster_SlimeSmall
          .mcolu COLRED, $f
          .byte 2, 2, 4
          .word $0008
;;; 2
          .Text12 "VORPALBUNNY " ; Tier 4
          .byte Monster_Bunny
          .mcolu COLGOLD, $4
          .byte 12, 12, 15
          .word $0040
;;; 3
          .Text12 "R.O.    U.S." ; Tier 3
          .byte Monster_Rodent
          .mcolu COLBROWN, $8
          .byte 7, 8, 8
          .word $0035
;;; 4
          .Text12 "LECTRO SHEEP" ; Tier 11
          .byte Monster_Sheep
          .mcolu COLBLUE, $8
          .byte 39, 39, 38
          .word $0110
;;; 5
          .Text12 "VIKINGTURTLE" ; Tier 7
          .byte Monster_Turtle
          .mcolu COLTURQUOISE, $8
          .byte 23, 24, 25
          .word $0070
;;; 6
          .Text12 "CRAZY    FOX" ; Tier 7
          .byte Monster_Fox
          .mcolu COLRED, $e
          .byte 25, 26, 27
          .word $0070
;;; 7
          .Text12 "WATER  KITTY" ; Tier 9
          .byte Monster_Cat
          .mcolu COLBLUE, $e
          .byte 33, 33, 34
          .word $0090
;;; 8
          .Text12 "FLAME  DOGGO" ; Tier 3
          .byte Monster_Dog
          .mcolu COLRED, $c
          .byte 6, 7, 9
          .word $0030
;;; 9
          .Text12 "CREEPYSPIDER" ; Tier 8
          .byte Monster_Spider
          .mcolu COLBROWN, $8
          .byte 28, 28, 29
          .word $0080
;;; 10
          .Text12 "METAL  MOUSE" ; Tier 8
          .byte Monster_Rodent
          .mcolu COLGRAY, $6
          .byte 30, 30, 32
          .word $0080
;;; 11
          .Text12 "FIRE   PANDA" ; Tier 3
          .byte Monster_Firefox
          .mcolu COLORANGE, $e
          .byte 10, 10, 12
          .word $0030
;;; 12
          .Text12 "LEGGY MUTANT" ; Tier 11
          .byte Monster_TwoLegs
          .mcolu COLBLUE, $8
          .byte 40, 40, 43
          .word $0110
;;; 13
          .Text12 "SKY   MUTANT" ; Tier 2
          .byte Monster_Mutant
          .mcolu COLRED, $8
          .byte 4, 5, 6
          .word $0020
;;; 14
          .Text12 "WILL-O -WISP" ; Tier 4
          .byte Monster_WillOWisp
          .mcolu COLCYAN, $e
          .byte 14, 14, 2
          .word $0040
;;; 15
          .Text12 "BUTTER   FLY" ; Tier 10
          .byte Monster_Butterfly
          .mcolu COLBLUE, $8
          .byte 36, 36, 39
          .word $0100
;;; 16
          .Text12 "SCARY    RAT" ; Tier 12
          .byte Monster_Rodent
          .mcolu COLBROWN, $8
          .byte 43, 43, 44
          .word $0120
;;; 17
          .Text12 "CAVE    GRUE" ; Tier 5
          .byte Monster_Rodent
          .mcolu COLBLUE, $8
          .byte 16, 16, 17
          .word $0050
;;; 18
          .Text12 "CAVE  BAT   " ; Tier 5
          .byte Monster_Bat
          .mcolu COLGRAY, $4
          .byte 18, 18, 20
          .word $0050
;;; 19
          .Text12 "VENOM  SHEEP" ; Tier 6
          .byte Monster_Sheep
          .mcolu COLGREEN, $f
          .byte 20, 20, 21
          .word $0060
;;; 20
          .Text12 "1 EYEDCYCLOP" ; Tier 6
          .byte Monster_Cyclops
          .mcolu COLPURPLE, $8
          .byte 22, 22, 24
          .word $0060
;;; 21
          .Text12 "FIERCERAPTOR" ; Tier 10
          .byte Monster_Bird
          .mcolu COLORANGE, $8
          .byte 38, 38, 40
          .word $0100
;;; 22
          .Text12 "DEVIL SKULL " ; Tier 12
          .byte Monster_Skull
          .mcolu COLRED, $8
          .byte 43, 42, 46
          .word $0120
;;; 23
          .Text12 "ROUND  ROBIN" ; Tier 2
          .byte Monster_Bird
          .mcolu COLBLUE, $8
          .byte 6, 6, 8
          .word $0020
;;; 24
          .Text12 "GIANT  CRAB " ; Tier 9
          .byte Monster_Crab
          .mcolu COLTURQUOISE, $8
          .byte 32, 32, 35
          .word $0090
;;; 25
          .Text12 "BIGGER CRAB " ; Tier 13
          .byte Monster_Crab
          .mcolu COLCYAN, $8
          .byte 47, 47, 50
          .word $0130
;;; 26
          .Text12 " MEAN ROBBER" ; 8
          .byte Monster_Human
          .mcolu COLBROWN, $e
          .byte 29, 29, 31
          .word $0080
;;; 27
          .Text12 "GIANT SLIME " ; Tier 13
          .byte Monster_SlimeBig
          .mcolu COLINDIGO, $8
          .byte 48, 48, 51
          .word $0130
;;; 28
          .Text12 "DRAGON FRED "
          .byte Monster_Dragon
          .mcolu COLBLUE, $0
          .byte 30, 30, 87
          .word $1000
;;; 29
          .Text12 "DRAGONANDREW"
          .byte Monster_Dragon
          .mcolu COLCYAN, $4
          .byte 25, 25, 75
          .word $0750
;;; 30
          .Text12 "DRAGON TIMMY"
          .byte Monster_Dragon
          .mcolu COLGREEN, $8
          .byte 35, 35, 100
          .word $1250
;;; 31
          .Text12 " UBER  SLIME" ; Tier 15
          .byte Monster_SlimeBig
          .mcolu COLBROWN, $f
          .byte 55, 55, 57
          .word $0150
;;; 32
          .Text12 "FLYINGSKULL " ; Tier 13
          .byte Monster_Skull
          .mcolu COLTURQUOISE, $e
          .byte 50, 50, 52
          .word $0130
;;; 33
          .Text12 "CRAZY SKULL " ; Tier 15
          .byte Monster_Skull
          .mcolu COLMAGENTA, $a
          .byte 56, 56, 58
          .word $0150
;;; 34
          .Text12 "GREAT  WYRM " ; Tier 15
          .byte Monster_Serpent
          .mcolu COLBLUE, $8
          .byte 51, 51, 54
          .word $0150
;;; 35
          .Text12 "POISON ASP  " ; Tier 12
          .byte Monster_Serpent
          .mcolu COLBLUE, $8
          .byte 44, 44, 47
          .word $0120
;;; 36
          .Text12 "GRABBYCRABBY" ; Tier 9
          .byte Monster_Crab
          .mcolu COLBLUE, $8
          .byte 34, 34, 36
          .word $0090
;;; 37
          .Text12 "GIANT  BAT  " ; Tier 14
          .byte Monster_Bat
          .mcolu COLGRAY, $4
          .byte 52, 52, 55
          .word $0140
;;; 38
          .Text12 " MAZE JAGUAR" ; Tier 14
          .byte Monster_Cat
          .mcolu COLBLUE, $8
          .byte 54, 54, 56
          .word $0140
;;; 39
          .Text12 "GIANT SPIDER" ; Tier 15
          .byte Monster_Spider
          .mcolu COLORANGE, $e
          .byte 57, 57, 59
          .word $0150
;;; 40
          .Text12 " FIRE DRAKE " ; Tier 11
          .byte Monster_Dragon
          .mcolu COLORANGE, $8
          .byte 42, 42, 44
          .word $0110
;;; 41
          .Text12 " MAN   BULL " ; Tier 12
          .byte Monster_Minotaur
          .mcolu COLBROWN, $8
          .byte 46, 46, 48
          .word $0120
;;; 42
          .Text12 "RADISHGOBLIN" ; Tier 7
          .byte Monster_Radish
          .mcolu COLRED, $8
          .byte 26, 26, 28
          .word $0070
;;; 43
          .Text12 "TURNIPGOBLIN" ; Tier 12
          .byte Monster_Radish
          .mcolu COLBLUE, $8
          .byte 44, 44, 45
          .word $0120
;;; 44
          .Text12 "ANUBISJACKAL" ; Tier 15
          .byte Monster_Dog
          .mcolu COLRED, $8
          .byte 58, 58, 60
          .word $0150
;;; 45
          .Text12 " BOSS  BEAR "
          .byte $ff             ; special graphics
          .mcolu COLGRAY, 0
          .byte 40, 40, 127
          .word $2500
