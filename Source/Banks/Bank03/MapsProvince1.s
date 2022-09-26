;;; Grizzards Source/Banks/Bank03/MapsProvince1.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          ;; How many maps are in these tables?
MapCount = 69

;;; Foreground and background colors
;;; Remember SECAM and don't make these too similar

MapColors:
          ;; 0
          .colors COLBLUE, COLBLUE ; unused
          .colors COLBLUE, COLBLUE ; unused
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          ;; 10
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLGRAY, COLGRAY
          .colors COLBLUE, COLBLUE
          ;; 15
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          ;; 20
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          ;; 25
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          ;; 30
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          ;; 35
          .colors COLBLUE, COLBLUE
          .colors COLBLUE, COLBLUE
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          ;; 40
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          ;; 45
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          ;; 50
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          ;; 55
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          .colors COLINDIGO, COLINDIGO
          ;; 60
          .colors COLINDIGO, COLINDIGO
          .colors COLPURPLE, COLPURPLE
          .colors COLPURPLE, COLPURPLE
          .colors COLPURPLE, COLPURPLE
          .colors COLPURPLE, COLPURPLE
          ;; 65
          .colors COLPURPLE, COLPURPLE
          .colors COLPURPLE, COLPURPLE
          .colors COLPURPLE, COLPURPLE
          .colors COLBLUE, COLBLUE
          
;;; Links up, down, left, right are map indices in this bank
MapLinks:
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, 3, $ff
          .byte $ff, $ff, 4, 2
          .byte $ff, $ff, 5, 3
          ;; 5
          .byte $ff, $ff, 6, 4
          .byte $ff, $ff, 8, 7
          .byte $ff, $ff, 6, 2
          .byte 11, 9, 10, 6
          .byte 10, 12, 8, 7
          ;; 10
          .byte 11, 12, 9, 7
          .byte 9, 8, 10, 13
          .byte 10, 8, 11, 13
          .byte 8, 8, 8, 8
          .byte $ff, 18, 68, 15
          ;; 15
          .byte $ff, 19, 14, 16
          .byte $ff, 20, 15, $ff
          .byte 68, 21, $ff, 18
          .byte 14, 22, 17, 19
          .byte 15, 23, 18, 20
          ;; 20
          .byte 16, 24, 19, $ff
          .byte 17, 25, $ff, 22
          .byte 18, 26, 21, 23
          .byte 19, 27, 22, 24
          .byte 20, 28, 23, $ff
          ;; 25
          .byte 21, 29, $ff, 26
          .byte 22, 30, 25, 27
          .byte 23, 31, 26, 28
          .byte 24, 32, 27, $ff
          .byte 25, 33, $ff, 30
          ;; 30
          .byte 26, 34, 29, 31
          .byte 27, 35, 30, 32
          .byte 28, 36, 31, $ff
          .byte 29, $ff, $ff, 34
          .byte 30, $ff, 33, 35
          ;; 35
          .byte 31, $ff, 34, 36
          .byte 32, $ff, 35, $ff
          .byte $ff, 41, $ff, 38
          .byte $ff, 42, 37, 39
          .byte $ff, 43, 38, 40
          ;; 40
          .byte $ff, 44, 39, $ff
          .byte 37, 45, $ff, 42
          .byte 38, 46, 41, 43
          .byte 39, 47, 42, 44
          .byte 40, 48, 43, $ff
          ;; 45
          .byte 41, 49, $ff, 46
          .byte 42, 50, 45, 47
          .byte 43, 51, 46, 48
          .byte 44, 52, 47, $ff
          .byte 45, 53, $ff, 50
          ;; 50
          .byte 46, 54, 49, 51
          .byte 47, 55, 50, 52
          .byte 48, 56, 51, $ff
          .byte 49, 57, $ff, 54
          .byte 50, 58, 53, 55
          ;; 55
          .byte 51, 59, 54, 56
          .byte 52, 60, 55, $ff
          .byte 53, $ff, $ff, 58
          .byte 54, $ff, 57, 59
          .byte 55, $ff, 58, 60
          ;; 60
          .byte 56, $ff, 59, $ff
          .byte $ff, 63, $ff, $ff
          .byte $ff, 65, $ff, 63
          .byte 61, 66, 62, 54
          .byte $ff, 67, 63, $ff
          ;; 65
          .byte 62, $ff, $ff, 66
          .byte 63, $ff, 65, 67
          .byte 64, $ff, 66, $ff
          .byte $ff, 17, $ff, 14

;;; RLE Map data for each screen.

;;; Note that it can be reused, so the same basic layout, potentially
;;; in different colors, can appear in several places.
          ;; 0
          _ := ( Map_EWPassage, Map_EWFat, Map_Pinch, Map_Pinch, Map_EWFat )
          ;; 5
          _ ..= ( Map_Pinch, Map_Pinch, Map_EWFat, Map_FourWay, Map_FourWay )
          ;; 10
          _ ..= ( Map_FourWay, Map_FourWay, Map_FourWay, Map_FourWay, Map_ACE )
          ;; 15
          _ ..= ( Map_ACEF, Map_ABCF, Map_BEF, Map_BEFG, Map_BFG )
          ;; 20
          _ ..= ( Map_BEF, Map_EF, Map_EF, Map_EF, Map_EF )
          ;; 25
          _ ..= ( Map_BCDE, Map_BCE, Map_BCEG, Map_BCDE, Map_ACEF )
          ;; 30
          _ ..= ( Map_CDEF, Map_EF, Map_AF, Map_DE, Map_ADG )
          ;; 35
          _ ..= ( Map_DE, Map_BCDEF, Map_AG, Map_ADG, Map_AD )
          ;; 40
          _ ..= ( Map_ABCF, Map_BEF, Map_ABEF, Map_ABE, Map_BDE )
          ;; 45
          _ ..= ( Map_BCEF, Map_BCFG, Map_BCDEF, Map_ABCF, Map_BEF )
          ;; 50
          _ ..= ( Map_BFG, Map_ABDEF, Map_BEF, Map_BCEF, Map_BCEF )
          ;; 55
          _ ..= ( Map_ACEF, Map_CEF, Map_BCDE, Map_DEF, Map_DE )
          ;; 60
          _ ..= ( Map_BCDE, Map_ABCF, Map_ABEF, Map_B, Map_ABCEF )
          ;; 65
          _ ..= ( Map_BCDE, Map_BDE, Map_BDF, Map_ACF )
          MapRLE = _

MapRLEL:  .byte <MapRLE
MapRLEH:  .byte >MapRLE

;;; Maps can have left or right sides added by the Ball
;;;
;;; This lets the exits be asymmetrical, even though the playfield is in
;;; reflected mode
;;; $80 = left, $40 = right ball.
MapSides:
          .byte 0, 0, $40, 0, 0
          .byte 0, 0, 0, 0, 0
          ;; 10
          .byte 0, 0, 0, 0, 0
          .byte $40, 0, $80, 0, 0
          ;; 20
          .byte $40, $80, $40, $80, $40
          .byte 0, 0, 0, 0, $80
          ;; 30
          .byte $40, $80, $40, $80, 0
          .byte $40, 0, $80, 0, $40
          ;; 40
          .byte 0, $80, 0, 0, $40
          .byte 0, 0, 0, 0, $80
          ;; 50
          .byte 0, 0, $40, 0, 0
          .byte $80, $40, 0, $80, $40
          ;; 60
          .byte 0, 0, $80, $40, 0
          .byte 0, $80, $40, $80

;;; 
SpriteList:
          ;; Room 0 (unused)
          .byte 0

          ;; Room 1 (unused)
          .byte 0

          ;; Room 2 (Mine Entrance), Tier 8
          .byte $ff, SpriteFixed
          .byte $b6, $20
          .byte SpriteProvinceDoor | $00, 8

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 18

          .byte 0

          ;; Room 3, Tier 8
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 19

          .byte 0

          ;; Room 4, Tier 8
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 41

          .byte 0

          ;; Room 5, Tier 8
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 18

          .byte 0

          ;; Room 6, Tier 8
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 19

          .byte 0

          ;; Room 7, Tier 8
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 41

          .byte 0

          ;; Room 8, Tier 8
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 18

          .byte 0

          ;; Room 9, Tier 8
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 19

          .byte 0

          ;; Room 10, Tier 8
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 41

          .byte 0

          ;; Room 11, Tier 8
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 18

          .byte 0

          ;; Room 12, Tier 8
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 19

          .byte 0
 
          ;; Room 13, Tier 8
          .byte $ff, SpriteFixed
          .byte $ac, $3c
          .byte SpriteGrizzardDepot, 0

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteGrizzard, 12 ; Splodo

          .byte 0

          ;; Room 14, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 23

          .byte 0, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 16

          .byte 0

          ;; Room 15, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 56

          .byte $ff, SpriteFixed
          .byte $8b, $0e
          .byte SpriteDoor, 39

          .byte 0

          ;; Room 16, Tier 13
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 89

          .byte $ff, SpriteFixed
          .byte $8a, $30
          .byte SpriteDoor, 40

          .byte 0

          ;; Room 17, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 57

          .byte 0

          ;; Room 18, Tier 12
          .byte $ff, SpriteFixed
          .byte $89, $0e
          .byte SpriteGrizzardDepot, 0

          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 58

          .byte $ff, SpriteFixed
          .byte $53, $1d
          .byte SpriteSign, 67  ; find Andrew

          .byte 1, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 27

          .byte 0

          ;; Room 19, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 59

          .byte 2, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 13

          .byte 0

          ;; Room 20, Tier 13
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 42

          .byte 3, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 19

          .byte 0

          ;; Room 21, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 82

          .byte 4, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 24

          .byte 0

          ;; Room 22, Tier 12
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 83

          .byte 5, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 29

          .byte 0

          ;; Room 23, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 84

          .byte 6, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 85

          .byte 0

          ;; Room 24, Tier 13
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 43

          .byte $ff, SpriteFixed
          .byte $70, $30
          .byte SpriteDoor, 48

          .byte 7, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 18

          .byte 0

          ;; Room 25, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 76

          .byte $ff, SpriteFixed
          .byte $6c, $30
          .byte SpriteSign, 32  ; Timmy lever

          .byte 8, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 4

          .byte 0

          ;; Room 26, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 77

          .byte 0

          ;; Room 27, Tier 12
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 78

          .byte $ff, SpriteFixed
          .byte $6e, $0f
          .byte SpriteDoor, 51

          .byte $ff, SpriteFixed
          .byte $bb, $1d
          .byte SpriteSign, 71  ; read runes

          .byte 9, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 12

          .byte 0

          ;; Room 28, Tier 13
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 44

          .byte 10, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 74

          .byte 0

          ;; Room 29, Tier 12
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 33

          .byte $ff, SpriteFixed
          .byte $6f, $12
          .byte SpriteDoor, 62

          .byte 11, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 11

          .byte 0

          ;; Room 30, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 34

          .byte $ff, SpriteFixed
          .byte $b0, $40
          .byte SpriteSign, 69  ; find TImmy

          .byte 12, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 6

          .byte 0

          ;; Room 31, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 23

          .byte 0

          ;; Room 32, Tier 12
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 56

          .byte 13, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 88

          .byte 0

          ;; Room 33, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 57

          .byte 14, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 21

          .byte 0

          ;; Room 34, Tier 12
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 58

          .byte 15, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 3

          .byte 0

          ;; Room 35, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 59

          .byte 16, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 0

          .byte 0

          ;; Room 36, Tier 12
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 82

          .byte $ff, SpriteFixed
          .byte $6b, $31
          .byte SpriteGrizzardDepot, 0

          .byte $ff, SpriteFixed
          .byte $bf, $38
          .byte SpriteProvinceDoor | $20, 28 ; door to cliffs

          .byte 0

          ;; Room 37, Tier 14
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 54

          .byte 61, SpriteFixed
          .byte $3a, $0e
          .byte SpriteProvinceDoor | $20, 9

          .byte 17, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 76

          .byte 0

          ;; Room 38, Tier 14
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 55

          .byte 0

          ;; Room 39, Tier 14
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 64

          .byte $ff, SpriteFixed
          .byte $8b, $0e
          .byte SpriteDoor, 15

          .byte 18, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 89

          .byte 0

          ;; Room 40, Tier 14
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 65

          .byte $ff, SpriteFixed
          .byte $8a, $30
          .byte SpriteDoor, 16

          .byte 19, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 42

          .byte 0

          ;; Room 41, Tier 14
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 66

          .byte 20, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 50

          .byte 0

          ;; Room 42, Tier 14
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 67

          .byte 0

          ;; Room 43, Tier 14
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 68

          .byte 21, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 54

          .byte 0

          ;; Room 44, Tier 14
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 69

          .byte 22, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 65

          .byte 0

          ;; Room 45, Tier 14
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 54

          .byte 23, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 66

          .byte 0

          ;; Room 46, Tier 14
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 55

          .byte 62, SpriteFixed
          .byte $88, $31
          .byte SpriteProvinceDoor | $20, 65

          .byte 24, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 72

          .byte 0

          ;; Room 47, Tier 14
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 56

          .byte 0

          ;; Room 48, Tier 13
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 52

          .byte $ff, SpriteFixed
          .byte $70, $30
          .byte SpriteDoor, 24

          .byte $ff, SpriteFixed
          .byte $80, $10
          .byte SpriteSign, 31  ; Andrew lever

          .byte 25, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 41

          .byte 0

          ;; Room 49, Tier 14
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 69

          .byte 26, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 48

          .byte 0

          ;; Room 50, Tier 14
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 68

          .byte $ff, SpriteFixed
          .byte $7c, $0d
          .byte SpriteDoor, 61

          .byte 27, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 78

          .byte 0

          ;; Room 51, Tier 13
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 51

          .byte $ff, SpriteFixed
          .byte $6e, $0f
          .byte SpriteDoor, 27

          .byte 28, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 17

          .byte 0

          ;; Room 52, Tier 13
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 50

          .byte 29, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 37

          .byte 0

          ;; Room 53, Tier 14
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 67

          .byte 30, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 53

          .byte 0

          ;; Room 54, Tier 13
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 47

          .byte 0

          ;; Room 55, Tier 13
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 46

          .byte 31, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 60

          .byte 0

          ;; Room 56, Tier 13
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 45

          .byte 32, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 86

          .byte 0

          ;; Room 57, Tier 14
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 72

          .byte 60, SpriteFixed
          .byte $7d, $31
          .byte SpriteProvinceDoor | $20, 4

          .byte 0

          ;; Room 58, Tier 13
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 44

          .byte 33, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 30

          .byte 0

          ;; Room 59, Tier 13
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 43

          .byte 34, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 14

          .byte 0

          ;; Room 60, Tier 13
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 42

          .byte 0

          ;; Room 61, Tier 13
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 40

          .byte $ff, SpriteFixed
          .byte $7c, $0d
          .byte SpriteDoor, 50

          .byte 35, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 20

          .byte 0

          ;; Room 62, Tier 13
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 89

          .byte $ff, SpriteFixed
          .byte $6f, $12
          .byte SpriteDoor, 29

          .byte 36, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 80

          .byte 0

          ;; Room 63, Tier 13
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 52

          .byte 37, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 23

          .byte 0

          ;; Room 64, Tier 13
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 51

          .byte $ff, SpriteWander
          .byte $bc, $38
          .byte SpriteCombat, 20 ; cyclops

          .byte $ff, SpriteFixed
          .byte $bc, $38
          .byte SpriteSign, 30  ; Fred lever

          .byte 0

          ;; Room 65, Tier 13
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 50

          .byte 38, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 87

          .byte 0

          ;; Room 66, Tier 13
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 47

          .byte $ff, SpriteFixed
          .byte 0, 0
          .byte SpriteGrizzard, 15 ; Theref

          .byte 39, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 56

          .byte 0

          ;; Room 67, Tier 13
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 46

          .byte $ff, SpriteFixed
          .byte $89, $31
          .byte SpriteSign, 68  ; find Fred

          .byte 40, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 82

          .byte 0

          ;; Room 68, Tier 12
          .byte $ff, SpriteRandomEncounter
          .byte 0, 0
          .byte SpriteCombat, 34

          .byte 41, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 74

          .byte 0
