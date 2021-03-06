;;; Grizzards Source/Banks/Bank04/MapsProvince0.so
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          ;; How many maps are in these tables?
MapCount = 65
;;; 
;;; Foreground and background colors

MapColors:
          ;; 0
          .colors COLINDIGO, COLCYAN
          .colors COLINDIGO, COLBROWN
          .colors COLINDIGO, COLBROWN
          .colors COLINDIGO, COLBROWN
          .colors COLRED, COLRED
          .colors COLRED, COLRED
          .colors COLRED, COLRED
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLRED, COLRED
          ;; 10
          .colors COLGREEN, COLSPRINGGREEN
          .colors COLGRAY, COLBROWN
          .colors COLGRAY, COLBROWN
          .colors COLGRAY, COLBROWN
          .colors COLCYAN, COLGRAY
          .colors COLGREEN, COLSPRINGGREEN
          .colors COLGREEN, COLSPRINGGREEN
          .colors COLTURQUOISE, COLBLUE
          .colors COLTURQUOISE, COLBLUE
          .colors COLBLUE, COLBROWN
          ;; 20
          .colors COLBLUE, COLGRAY
          .colors COLINDIGO, COLBLUE
          .colors COLINDIGO, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLPURPLE, COLGRAY
          .colors COLPURPLE, COLPURPLE
          .colors COLPURPLE, COLPURPLE
          .colors COLPURPLE, COLPURPLE
          .colors COLPURPLE, COLPURPLE
          .colors COLMAGENTA, COLBROWN
          ;; 30
          .colors COLMAGENTA, COLBROWN
          .colors COLMAGENTA, COLBROWN
          .colors COLMAGENTA, COLBROWN
          .colors COLMAGENTA, COLBROWN
          .colors COLRED, COLGRAY
          .colors COLGREEN, COLGRAY
          .colors COLRED, COLBROWN
          .colors COLORANGE, COLBROWN
          .colors COLORANGE, COLBROWN
          .colors COLORANGE, COLBROWN
          ;; 40
          .colors COLMAGENTA, COLBROWN
          .colors COLRED, COLBROWN
          .colors COLORANGE, COLBROWN
          .colors COLYELLOW, COLGRAY
          .colors COLBLUE, COLGRAY
          .colors COLORANGE, COLBROWN
          .colors COLORANGE, COLBROWN
          .colors COLGRAY, COLGRAY ; lost mines "lobby"
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          ;; 50
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          ;; 60
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLYELLOW, COLYELLOW
          .colors COLBLUE, COLBLUE
;;; 
;;; Links up, down, left, right are map indices in this bank
MapLinks:
          .byte $ff, $ff, $ff, $ff
          .byte $ff, 7, 19, 2
          .byte $ff, $ff, 1, 3
          .byte $ff, $ff, 2, 4
          .byte $ff, $ff, 3, 5
          ;; 5
          .byte $ff, 9, 4, 6
          .byte $ff, $ff, 5, $ff
          .byte 1, 8, $ff, $ff
          .byte 7, 47, $ff, 11
          .byte 5, 14, $ff, $ff
          ;; 10
          .byte $ff, 15, $ff, $ff
          .byte $ff, $ff, 8, 12
          .byte $ff, $ff, 11, 13
          .byte $ff, $ff, 12, 14
          .byte 9, 17, 13, 15
          ;; 15
          .byte 10, 16, 14, 48
          .byte 15, $ff, $ff, $ff
          .byte 14, $ff, 18, $ff
          .byte $ff, 23, 20, 17
          .byte $ff, $ff, $ff, 1
          ;; 20
          .byte $ff, $ff, $ff, 18
          .byte $ff, 24, 23, 22
          .byte $ff, $ff, 21, 23
          .byte 18, 26, 22, 21
          .byte $ff, 31, $ff, $ff
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
          .byte 8, $ff, $ff, $ff
          .byte 49, $ff, 15, 60
          .byte $ff, 48, $ff, 50
          ;; 50
          .byte $ff, $ff, 49, 51
          .byte $ff, $ff, 50, 52
          .byte $ff, 53, 51, $ff
          .byte 52, 54, $ff, $ff
          .byte 53, $ff, 55, $ff
          ;; 55
          .byte $ff, $ff, 56, 54
          .byte $ff, $ff, 57, 55
          .byte 58, $ff, $ff, 56
          .byte $ff, 57, $ff, 59
          .byte $ff, $ff, 58, 60
          ;; 60
          .byte $ff, $ff, 59, 61
          .byte $ff, $ff, 60, $ff
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, $ff, $ff
;;; 
;;; RLE Map data for each screen.

;;; Note that it can be reused, so the same basic layout, potentially
;;; in different colors, can appear in several places.

          .if DEMO
          ROOM17MAP = Map_BowClosed      ; no exits to east/west in demo
          ROOM8MAP = Map_Bow
          .else
          ROOM17MAP = Map_Bow
          ROOM8MAP = Map_FourWay
          .fi

          ;; 0
          _ := (Map_Indoors, Map_Arc, Map_EWPassage, Map_EWFat, Map_Wiggle)
          ;; 5
          _ ..= (Map_Arc, Map_EWPassage, Map_Narrow, ROOM8MAP, Map_Bulge)
          ;; 10
          _ ..= (Map_NorthGlobe, Map_EWPassage, Map_EWPassage, Map_EWPassage, Map_FourWay)
          ;; 15
          _ ..= (Map_FourWay, Map_SouthGlobe, ROOM17MAP, Map_Arc, Map_EWPassage)
          ;; 20
          _ ..= (Map_EWFat, Map_Split, Map_SplitBoxes, Map_SplitMaze, Map_Closed)
          ;; 25
          _ ..= (Map_EWFat, Map_FourWay, Map_EWFat, Map_EWFat, Map_FullTop)
          ;; 30
          _ ..= (Map_FullTop, Map_ClosedNorth, Map_OpenNorth, Map_ClosedNorth, Map_Island)
          ;; 35
          _ ..= (Map_House, Map_Clear, Map_BottomLine, Map_BottomLine, Map_BottomLine)
          ;; 40
          _ ..= (Map_FullTop, Map_Clear, Map_BottomLine, Map_House, Map_House)
          ;; 45
          _ ..= (Map_BottomLine, Map_BottomLine, Map_SouthGlobe, Map_Bow, Map_Arc)
          ;; 50
          _ ..= (Map_Pinch, Map_Pinch, Map_Arc, Map_Narrow, Map_Bow)
          ;; 55
          _ ..= (Map_Pinch, Map_Pinch, Map_Bow, Map_Arc, Map_Pinch)
          ;; 60
          _ ..= (Map_EWPassage, Map_EWFat, Map_Indoors, Map_Indoors, Map_Indoors)
          ;; 65

          MapRLE = _

MapRLEL:  .byte <MapRLE
MapRLEH:  .byte >MapRLE
;;; 
;;; Maps can have left or right sides added by the Ball
;;;
;;; This lets the exits be asymmetrical, even though the playfield is in
;;; reflected mode
;;; $80 = left, $40 = right ball.
MapSides:
          .byte 0, 0, 0, 0, 0
          .byte 0, $40, 0, $80, 0
          ;; 10
          .byte 0, 0, 0, 0, 0
          .if DEMO
            ;; block off area to right of screen 15
            .byte $40, $40, $40, 0, $80
          .else
            .byte 0, $40, $40, 0, $80
          .fi
          ;; 20
          .byte $80, 0, 0, 0, 0
          .byte 0, 0, 0, 0, $80
          ;; 30
          .byte 0, 0, 0, 0, 0
          .byte 0, 0, 0, 0, 0
          ;; 40
          .byte $40, $40, $40, 0, $80
          .byte $80, 0, 0, $40, $80
          ;; 50
          .byte 0, 0, $40, 0, $40
          .byte 0, 0, $80, $80, 0
          ;; 60
          .byte 0, $40, 0, 0, 0
;;; 
SpriteList:
          ;; Room 0, "Tier 0"
          .byte $ff, SpriteFixed              ; not removeable, fixed position sprite
          .byte $7d, $30         ; x, y position
          .byte SpriteDoor, 3   ; action

          .byte $ff, SpriteFixed
          .byte $7d, $12         ; x, y
          .byte SpriteGrizzardDepot, 0

          .byte 0               ; end of list

          ;; Room 1, Tier 1
          .byte 2, SpriteWander
          .byte $bd, $21
          .byte SpriteCombat, 1 ; 2 Wicked Slimes

          .byte 3, SpriteWander
          .byte $7b, $2c
          .byte SpriteCombat, 3 ; Horrid Slime

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 1 ; 2 Wicked Slimes

          .byte 0

          ;; Room 2, Tier 1
          .byte 5, SpriteWander
          .byte 125, 32         ; x, y position
          .byte SpriteCombat, 1 ; Wicked Slime

          .byte $ff, SpriteFixed
          .byte 100, 32
          .byte SpriteSign, 0   ; Beware

          .if !DEMO
            .byte $ff, SpriteWander
            .byte 120, 32
            .byte SpritePerson, 80 ; lover 2
          .fi

          .byte 0

          ;; Room 3, Tier 0
          .byte $ff, SpriteFixed              ; not removeable,fixed position sprite
          .byte $7d, $30         ; x, y position
          .byte SpriteDoor, 0   ; action

          .byte $ff, SpriteFixed
          .byte 100, 32
          .byte SpriteSign, 11  ; Treble Village

          .byte 19, SpriteWander
          .byte 100, 32
          .byte SpritePerson, 12 ; Fleeing village

          .if !DEMO
            .byte $ff, SpriteWander
            .byte 140, 45
            .byte SpritePerson, 77 ; used to be fun
          .fi

          .byte 0

          ;; Room 4, Tier 3
          .byte 6, SpriteFixed
          .byte $72, $13
          .byte SpriteMajorCombat, 6 ; boss ROUS

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 7 ; 3×ROUS

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 8 ; Flame Doggos

          .byte $ff, SpriteFixed
          .byte $48, $30
          .byte SpriteSign, 1   ; Fire Swamp

          .byte 0

          ;; Room 5, Tier 3
          .byte 22, SpriteWander
          .byte $34, $2c
          .byte SpriteCombat, 8 ; Flame Doggo

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 8 ; Flame Doggo

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 10 ; Fire Panda

          .byte 0

          ;; Room 6, Tier 3
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 8 ; Flame Doggos

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 10 ; Fire Panda

          .byte $ff, SpriteWander
          .byte $b9, $28
          .byte SpritePerson, 7 ; Artifact 2

          .byte $ff, SpriteWander
          .byte $7c, $28
          .byte SpriteGrizzard, 3 ; Flamex

          .byte 0

          ;; Room 7, Tier 1
          .byte 7, SpriteFixed
          .byte $7c, $28
          .byte SpriteCombat, 9 ; 3×Horrid Slimes

          .byte $ff, SpriteFixed
          .byte $7c, $36
          .byte SpriteGrizzard, 5 ; Wetnas

          .byte 0

          ;; Room 8, Tier 2
          .if !DEMO
            .byte $ff, SpriteFixed
            .byte $38, $30
            .byte SpriteProvinceDoor | $10, 2
          .fi

          .byte $ff, SpriteFixed
          .byte $38, $20
          .byte SpriteSign, 9   ; lost mine

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 21 ; Sky mutants

          .byte 0

          ;; Room 9, Tier 3
          .byte 11, SpriteWander
          .byte 0,0
          .byte SpriteCombat, 6 ; Flame Doggos

          .byte 12, SpriteWander
          .byte 0,0
          .byte SpriteCombat, 10 ; Fire Panda

          .byte 13, SpriteWander
          .byte 0,0
          .byte SpriteCombat, 11 ; Flame Doggos

          .byte 14, SpriteWander
          .byte 0,0
          .byte SpriteCombat, 12 ; Fire Pandas

          .byte 0

          ;; Room 10, Tier 4
          .byte 20, SpriteWander
          .byte $80, $28
          .byte SpriteCombat, 4 ; Vorpal bunny

          .byte 21, SpriteWander
          .byte $80, $28
          .byte SpriteCombat, 4 ; Vorpal bunny

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte $ff, SpriteWander
          .byte $80, $28
          .byte SpritePerson, 6 ; artifact 1

          .byte 0

          ;; Room 11, Tier 2
          .byte $ff, SpriteFixed
          .byte $7e, $27
          .byte SpriteSign, 14  ; western road sign

          .byte 9, SpriteFixed
          .byte $b8, $22
          .byte SpriteCombat, 90 ; Sky Mutants

          .byte 10, SpriteFixed
          .byte $b8, $2e
          .byte SpriteCombat, 90 ; Sky Mutants

          .byte 15, SpriteWander
          .byte $7e, $27
          .byte SpriteCombat, 35 ; 3 Robins

          .byte 0

          ;; Room 12, Tier 2
          .byte 4, SpriteWander
          .byte $7e, $27
          .byte SpriteCombat, 21 ; Sky mutants

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 35 ; Robins

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 36 ; 5 Robins

          .byte 0

          ;; Room 13, Tier 2
          .byte 5, SpriteWander
          .byte $7e, $27
          .byte SpriteCombat, 21 ; Sky Mutants

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 36 ; Robins

          .byte 0

          ;; Room 14, Tier 2 + 3
          .byte 51, SpriteWander
          .byte 0,0
          .byte SpriteCombat, 21 ; Sky Mutants

          .byte 52, SpriteWander
          .byte 0,0
          .byte SpriteCombat, 10 ; Fire Pando

          .byte 53, SpriteWander
          .byte 0,0
          .byte SpriteCombat, 11 ; Flame Doggo

          .byte 54, SpriteWander
          .byte 0,0
          .byte SpriteCombat, 36 ; Robins

          .byte 0

          ;; Room 15, Tier 4
          .byte 6, SpriteWander
          .byte $af, $2b
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte $ff, SpriteFixed
          .byte $a0, $2b
          .if DEMO
            .byte SpriteSign, 10  ; Spiral Woods closed
          .else
            .byte SpriteSign, 18  ; Spiral Woods open
          .fi

          .byte 0

          ;; Room 16, Tier 4
          .byte 23, SpriteWander
          .byte $7b, $25
          .byte SpriteCombat, 4 ; Vorpal Bunny

          .byte $ff, SpriteRandomEncounter
          .byte $7b, $25
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte $ff, SpriteRandomEncounter
          .byte $7b, $25
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 4 ;  Vorpal Bunny

          .byte 0

          ;; Room 17, Tier 0
          .byte $ff, SpriteFixed
          .byte $60, $30
          .byte SpritePerson, 3 ; tunnel guardian

          .if !DEMO             ; no room for these signs' text in demo
            .byte 1, SpriteFixed
            .byte $48, $20
            .byte SpriteSign, 17  ; tunnel closed
          .fi

          .byte 0

          ;; Room 18, Tier 0
          .byte $ff, SpriteFixed
          .byte $6f, $35
          .byte SpriteSign, 94  ; may be eaten
          .byte 0

          ;; Room 19, Tier 0 (Docks)
          .byte $ff, SpriteWander
          .byte $3c, $27
          .byte SpritePerson, 2 ; there are tunnels in the south

          .byte $ff, SpriteFixed
          .byte $3c, $20
          .byte SpriteSign, 13  ; Treble Docks to Port Lion

          .byte 0

          ;; Room 20, Tier 0
          .byte $ff, SpriteFixed
          .byte $3b, $28         ; x, y
          .byte SpriteGrizzardDepot, 0

          .byte 0

          .if !DEMO

          ;; Room 21, Tier 5
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 28 ; bats

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 29 ; bats

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 28 ; bats

          .byte 0

          ;; Room 22, Tier 5
          .byte 24, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 24 ; Grue

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 28 ; Bats

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 28 ; Bats

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 29 ; Bats

          .byte 0

          ;; Room 23, Tier 5
          .byte 24, SpriteFixed
          .byte $77, $27
          .byte SpriteSign, 20  ; beware of grue

          .byte 24, SpriteFixed
          .byte $80, $27
          .byte SpriteSign, 20  ; beware of grue

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 28 ; Bats

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 29 ; Bats

          .byte 0

          ;; Room 24, Tier 0 (Grizzards cave)
          .byte $ff, SpriteFixed
          .byte $7d, $10
          .byte SpriteDoor, 31

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteGrizzard, 16 ; Cornet

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteGrizzard, 17 ; Ambren

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteGrizzard, 18 ; Noctis

          .byte 0

          ;; Room 25, Tier 6
          .byte 30, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 25 ; Venom Sheep

          .byte 31, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 26 ; 4 Venom Sheep

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 25 ; Venom Sheep

          .byte 38, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 27 ; Cyclops

          .byte 0

          ;; Room 26, Tier 6
          .byte 32, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 25 ; Venom Sheep

          .byte 33, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 26 ; Venom Sheep

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 25 ; Venom Sheep

          .byte $ff, SpriteFixed
          .byte $91, $24
          .byte SpriteSign, 78  ; Beware Cyclops

          .byte 0

          ;; Room 27, Tier 6
          .byte 34, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 25 ; Venom sheep

          .byte 35, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 26 ; Venom sheep

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 25 ; Venom Sheep

          .byte 0

          ;; Room 28, Tier 6
          .byte 36, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 25 ; Venom Sheep

          .byte 37, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 26 ; Venom Sheep

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 25 ; Venom sheep

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 27 ; Venom sheep

          .byte 0

          ;; Room 29, Tier 7
          .byte 39, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 16 ; one fox

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 13 ; turtle

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 70 ; 2 foxes

          .byte 0

          ;; Room 30, Tier 7
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 13 ; Turtle
          .byte 0

          ;; Room 31, Tier 0
          .byte 63, SpriteFixed
          .byte $53, $1f
          .byte SpriteDoor, 24  ; Grizzard Cave

          .byte 63, SpriteFixed
          .byte $a8, $1f
          .byte SpriteGrizzardDepot, 0

          .byte 0

          ;; Room 32, Tier 0
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpritePerson, 76 ; random villager

          .byte 0

          ;; Room 33, Tier 7
          .byte 45, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 70 ; two foxes

          .byte 0

          ;; Room 34, Tier 0
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpritePerson, 104 ; potions

          .byte 0

          ;; Room 35, Tier 0 — Green house
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 62

          .byte 0

          ;; Room 36, Tier 7
          .byte 46, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 70 ; two foxes

          .byte 0

          ;; Room 37, Tier 0
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpritePerson, 83 ; lover 1

          .byte 0

          ;; Room 38, Tier 0
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpritePerson, 113 ; random villager

          .byte 0

          ;; Room 39, Tier 7
          .byte 47, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 75 ; Radishes

          .byte 0

          ;; Room 40, Tier 7
          .byte 42, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 74 ; Radish

          .byte 0

          ;; Room 41, Tier 7
          .byte 43, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 70 ; two foxes

          .byte 0

          ;; Room 42, Tier 7
          .byte 44, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 70 ; two foxes

          .byte 0

          ;; Room 43, Tier 0 — yellow house
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 63

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpritePerson, 10 ; random villager

          .byte 0

          ;; Room 44, Tier 0 — blue house
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 64

          .byte 0

          ;; Room 45, Tier 7
          .byte 40, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 75 ; radishes

          .byte 41, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 71 ; three foxes

          .byte 0

          ;; Room 46, Tier 7
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 75 ; radishes

          .byte 0

          ;; Room 47, Tier 0
          .if !DEMO
            .byte 29, SpriteFixed
            .byte $44, $1d
            .byte SpritePerson, 73 ; Radio shack
          .fi

          .byte 0

          ;; Room 48, Tier 4
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 4 ; Vorpal Bunny

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte 0

          ;; Room 49, Tier 4
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte 0

          ;; Room 50, Tier 4
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte 0

          ;; Room 51, Tier 4
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte 0

          ;; Room 52, Tier 4
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte 0

          ;; Room 53, Tier 4
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte 0

          ;; Room 54, Tier 4
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte 0

          ;; Room 55, Tier 4
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte 28, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteSign, 22  ; found pendant

          .byte 0

          ;; Room 56, Tier 4
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 4 ; Vorpal Bunny

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte 0

          ;; Room 57, Tier 4
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' wisp

          .byte 0

          ;; Room 58, Tier 4
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte 0

          ;; Room 59, Tier 4
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte 0

          ;; Room 60, Tier 4
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 15 ; Will O' Wisp

          .byte 0

          ;; Room 61, Tier 0
          .byte $ff, SpriteFixed
          .byte $b9, $28
          .byte SpriteGrizzardDepot, 0

          .byte $ff, SpriteWander
          .byte $40, $26
          .byte SpriteGrizzard, 6 ; Windoo

          .byte 0

          ;; Room 62, int Green house
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 35

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpritePerson, 106 ; mine hint

          .byte 0

          ;; Room 63, int Yellow house
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 43

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpritePerson, 16 ; broken radio

          .byte 0

          ;; Room 64, int Blue house
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 44

          .byte $ff, SpriteWander
          .byte 128, 32
          .byte SpritePerson, 21 ; lost pendant

          .byte 0

          .fi                   ; if !DEMO

