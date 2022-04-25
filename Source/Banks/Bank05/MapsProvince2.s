;;; Grizzards Source/Banks/Bank05/MapsProvince2.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          ;; How many maps are in these tables?
MapCount = 67

;;; Foreground and background colors
;;; Remember SECAM and don't make these too similar

MapColors:
          ;; 0
          .colors COLBLUE, COLBROWN
          .colors COLBLUE, COLBROWN
          .colors COLBLUE, COLTURQUOISE
          .colors COLBLUE, COLTURQUOISE
          .colors COLBLUE, COLTURQUOISE
          .colors COLGREEN, COLSPRINGGREEN
          .colors COLGREEN, COLSPRINGGREEN
          .colors COLGREEN, COLSPRINGGREEN
          .colors COLGREEN, COLSPRINGGREEN
          .colors COLGREEN, COLSPRINGGREEN
          ;; 10
          .colors COLCYAN, COLCYAN
          .colors COLCYAN, COLCYAN
          .colors COLCYAN, COLCYAN
          .colors COLCYAN, COLCYAN
          .colors COLBLUE, COLBROWN
          .colors COLBLUE, COLBROWN
          .colors COLBLUE, COLBROWN
          .colors COLBLUE, COLBROWN
          .colors COLRED, COLBROWN
          .colors COLRED, COLBROWN
          ;; 20
          .colors COLRED, COLBROWN
          .colors COLRED, COLBROWN
          .colors COLRED, COLBROWN
          .colors COLRED, COLBROWN
          .colors COLRED, COLBROWN
          .colors COLRED, COLBROWN
          .colors COLRED, COLBROWN
          .colors COLRED, COLBROWN
          .colors COLRED, COLBROWN
          .colors COLRED, COLBROWN
          ;; 30
          .colors COLSEAFOAM, COLGREY
          .colors COLINDIGO, COLGREY
          .colors COLMAGENTA, COLGREY
          .colors COLORANGE, COLGREY
          .colors COLBLUE, COLBROWN
          .colors COLGOLD, COLGREY
          .colors COLSPRINGGREEN, COLGREY
          .colors COLTEAL, COLGREY
          .colors COLBROWN, COLGREY
          .colors COLBLUE, COLBROWN
          ;; 40
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLGREEN
          .colors COLGREEN, COLBROWN
          .colors COLGREEN, COLBROWN
          ;; 50
          .colors COLGREEN, COLBROWN
          .colors COLBLUE, COLBROWN
          .colors COLBLUE, COLBROWN
          .colors COLBLUE, COLBROWN
          .colors COLSEAFOAM, COLSEAFOAM
          .colors COLINDIGO, COLINDIGO
          .colors COLMAGENTA, COLMAGENTA
          .colors COLORANGE, COLORANGE
          .colors COLGOLD, COLGOLD
          .colors COLSPRINGGREEN, COLSPRINGGREEN
          ;; 60
          .colors COLTEAL, COLTEAL
          .colors COLBROWN, COLBROWN
          .colors COLCYAN, COLCYAN
          .colors COLCYAN, COLCYAN
          .colors COLCYAN, COLCYAN
          .colors COLCYAN, COLCYAN
          .colors COLCYAN, COLCYAN
          ;; ↑ 66

;;; Links up, down, left, right are map indices in this bank
MapLinks:
          .byte $ff, $ff, 1, $ff
          .byte 18, $ff, 14, 0
          .byte $ff, 3, $ff, $ff
          .byte 2, 4, $ff, $ff
          .byte 3, $ff, $ff, $ff
          ;; 5
          .byte $ff, 6, $ff, $ff
          .byte 5, 7, $ff, $ff
          .byte 6, 8, $ff, $ff
          .byte 7, $ff, $ff, 9
          .byte $ff, $ff, 8, $ff
          ;; 10
          .byte $ff, 12, $ff, $ff
          .byte $ff, 62, $ff, 12
          .byte 10, 63, 11, 13
          .byte $ff, 64, 12, $ff
          .byte 19, $ff, 15, 1
          ;; 15
          .byte 20, $ff, 16, 14
          .byte 21, $ff, 17, 15
          .byte 22, $ff, $ff, 16
          .byte 24, 1, 19, $ff
          .byte 25, 14, 20, 18
          ;; 20
          .byte 26, 15, 21, 19
          .byte 27, 16, 22, 20
          .byte 28, 17, 23, 21
          .byte 29, $ff, $ff, 22
          .byte 30, 18, 25, $ff
          ;; 25
          .byte 31, 19, 26, 24
          .byte 32, 20, 27, 25
          .byte 33, 21, 28, 26
          .byte 34, 22, 29, 27
          .byte $ff, 23, $ff, 28
          ;; 30
          .byte 35, 24, 31, $ff
          .byte 36, 25, 32, 30
          .byte 37, 26, 33, 31
          .byte 38, 27, 34, 32
          .byte 39, 28, $ff, 33
          ;; 35
          .byte 40, 30, 36, $ff
          .byte 41, 31, 37, 35
          .byte 42, 32, 38, 36
          .byte 43, 33, 39, 37
          .byte $ff, 34, $ff, 38
          ;; 40
          .byte 44, 35, 41, $ff
          .byte 45, 36, 42, 40
          .byte 46, 37, 43, 41
          .byte 47, 38, $ff, 42
          .byte $ff, 40, 45, $ff
          ;; 45
          .byte 48, 41, 46, 44
          .byte 49, 42, 47, 45
          .byte 50, 43, $ff, 46
          .byte 51, 45, 49, $ff
          .byte 52, 46, 50, 48
          ;; 50
          .byte 53, 47, $ff, 49
          .byte $ff, 48, 52, $ff
          .byte $ff, 49, 53, 51
          .byte $ff, 50, $ff, 52
          .byte $ff, $ff, $ff, $ff
          ;; 55
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, $ff, $ff
          ;; 60
          .byte $ff, $ff, $ff, $ff
          .byte $ff, $ff, $ff, $ff
          .byte 11, $ff, $ff, 63
          .byte 12, $ff, 62, 64
          .byte 13, 66, 63, $ff
          ;; 65
          .byte $ff, $ff, $ff, 66
          .byte 64, $ff, 65, $ff

;;; RLE Map data for each screen.

;;; Note that it can be reused, so the same basic layout, potentially
;;; in different colors, can appear in several places.
          ;; 0
          _ := ( Map_SouthDock, Map_SouthShore, Map_DoorBottom, Map_DoorTopBottom, Map_DoorTop )
          ;; 5
          _ ..= ( Map_DoorBottom, Map_OpenBottomDoorTop, Map_ClosedSides, Map_OpenTopDoorSides, Map_EWOval )
          ;; 10
          _ ..= ( Map_DoorBottom, Map_DoorBottomSplit, Map_DoorTopSplit, Map_OpenSidesSplit, Map_SouthShore )
          ;; 15
          _ ..= ( Map_SouthShore, Map_SouthShore, Map_SouthShore, Map_NorthGate, Map_NorthCliff )
          ;; 20
          _ ..= ( Map_NorthCliff, Map_NorthGate, Map_NorthCliff, Map_NorthCliffSouthWall, Map_FourWay )
          ;; 25
          _ ..= ( Map_EWPassage, Map_EWPassage, Map_FourWay, Map_EWLarge, Map_EWLarge )
          ;; 30
          _ ..= ( Map_House, Map_HouseSouthWall, Map_HouseSouthWall, Map_House, Map_SouthWallCorners )
          ;; 35
          _ ..= ( Map_House, Map_House, Map_House, Map_House, Map_NorthWallCorners )
          ;; 40
          _ ..= ( Map_NorthCliffTown, Map_NorthCliffTown, Map_NorthGateCorners, Map_NorthCliffTown, Map_EWLarge )
          ;; 45
          _ ..= ( Map_EWPassage, Map_FatFourWay, Map_EWLarge, Map_SouthWall, Map_SouthGate )
          ;; 50
          _ ..= ( Map_SouthWall, Map_NorthShore, Map_NorthShore, Map_NorthShore, Map_InHouse )
          ;; 55
          _ ..= ( Map_InHouse, Map_InHouse, Map_InHouse, Map_InHouse, Map_InHouse )
          ;; 60
          _ ..= ( Map_InHouse, Map_InHouse, Map_OpenSidesDoorTop, Map_OpenSides, Map_ClosedTop )
          ;; 65
          ;; special non-existing rooms 67 & 68 define alternate RLE backgrounds for “wave motions”
          _ ..= ( Map_EWOval, Map_OpenTopDoorSides, Map_SouthShore2, Map_NorthShore2 )

          MapRLE = _

MapRLEL:  .byte <MapRLE
MapRLEH:  .byte >MapRLE

;;; Maps can have left or right sides added by the Ball
;;;
;;; This lets the exits be asymmetrical, even though the playfield is in
;;; reflected mode
;;; $80 = left, $40 = right ball.
MapSides:
          .byte $40, 0, 0, 0, 0
          .byte 0, 0, 0, $80, $40
          ;; 10
          .byte 0, $80, 0, $40, 0
          .byte 0, 0, $80, $40, 0
          ;; 20
          .byte 0, 0, 0, $80, $40
          .byte 0, 0, 0, 0, $80
          ;; 30
          .byte $40, 0, 0, 0, $80
          .byte $40, 0, 0, 0, $80
          ;; 40
          .byte $40, 0, 0, $80, $40
          .byte 0, 0, $80, $40, 0
          ;; 50
          .byte $80, $40, 0, $80, 0
          .byte 0, 0, 0, 0, 0
          ;; 60
          .byte 0, 0, $80, 0, $40
          .byte $80, $40

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
SpriteList:
          ;; Room 0, Tier 0
          .byte $ff, SpriteWander
          .byte $4d, $1a
          .byte SpritePerson, 45 ; Fat Tony is best at geography

          .byte $ff, SpriteFixed
          .byte $ba, $25
          .byte SpriteSign, 66  ; docks to Treble
          
          .byte 0

          ;; Room 1, Tier 9
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 60 ; Grabby Crabby

          .byte $ff, SpriteFixed
          .byte $82, $16
          .byte SpriteSign, 49  ; Port Lion village

          .byte 0

          ;; Room 2, Dragon
          .byte 50, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 93 ; Fred

          .byte 0

          ;; Room 3, Dragon's Lair Entrance
          .byte $ff, SpriteFixed
          .byte $b3, $35
          .byte SpriteGrizzardDepot, 0

          .byte 0, SpriteWander
          .byte $52, $34
          .byte SpritePerson, 26 ; Peter (found now)

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 49

          .byte 0

          ;; Room 4, Dragon's Lair Entrance / Tier 15
          .byte $ff, SpriteFixed
          .byte $7a, $36
          .byte SpriteProvinceDoor | $10, 57

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 48
          .byte 0

          ;; Room 5, Dragon
          .byte 51, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 94 ; Andrew

          .byte 0

          ;; Room 6, Tier 15
          .byte $ff, SpriteFixed
          .byte $3e, $1d
          .byte SpriteGrizzardDepot, 0

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 79

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 78

          .byte 0

          ;; Room 7, Tier 15
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 73

          .byte 0

          ;; Room 8, Tier 15
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 72

          .byte 0

          ;; Room 9, Tier 15
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 53 ; Crazy Skull

          .byte $ff, SpriteFixed
          .byte $80, $10
          .byte SpriteProvinceDoor | $10, 37

          .byte 0

          ;; Room 10, Dragon
          .byte 52, SpriteWander
          .byte 0, 0
          .byte SpriteMajorCombat, 95 ; Timmy

          .byte 0

          ;; Room 11, Tier 15
          .byte $ff, SpriteFixed
          .byte $60, $10
          .byte SpriteGrizzardDepot, 0

          .byte 0

          ;; Room 12, Tier 15
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 49

          .byte 0

          ;; Room 13, Tier 15
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 48

          .byte 0

          ;;Room 14, Tier 9
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 61

          .byte 0

          ;;Room 15, Tier 9
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 62

          .byte 0

          ;;Room 16, Tier 9
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 63

          .byte 0

          ;;Room 17, Tier 9
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 39

          .byte 0

          ;;Room 18, Tier 10
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 22

          .byte 0

          ;;Room 19, Tier 10
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 30

          .byte 0

          ;;Room 20, Tier 10
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 31

          .byte 0

          ;;Room 21, Tier 10
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 32

          .byte 0

          ;;Room 22, Tier 10
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 22

          .byte 0

          ;;Room 23, Tier 0
          .byte $ff, SpriteFixed
          .byte $70, $10
          .byte SpritePerson, 46 ; Fat Tony look up @ cliffs

          .byte $ff, SpriteFixed
          .byte 0, 0
          .byte SpriteGrizzard, 4 ; Petty

          .byte 0

          ;;Room 24, Tier 10
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 30

          .byte 0

          ;;Room 25, Tier 10
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 31

          .byte 0

          ;;Room 26, Tier 10
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 32

          .byte 0

          ;;Room 27, Tier 10
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 22

          .byte 0

          ;;Room 28, Tier 10
          .byte 56, SpriteFixed
          .byte $6f, $12
          .byte SpriteProvinceDoor | $10, 36 ; Labyrinth Entrance

          .byte $ff, SpriteFixed
          .byte $6f, $3c
          .byte SpritePerson, 47 ; road to Hades

          .byte 0

          ;;Room 29, Tier 10
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 32

          .byte 0

          ;;Room 30
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 54

          .byte 0

          ;;Room 31
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 55

          .byte 0

          ;;Room 32
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 56

          .byte 0

          ;;Room 33
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 57

          .byte 0

          ;;Room 34
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpritePerson, 43 ; how long is it safe?

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpritePerson, 44 ; Fat Tony is smart

          .byte 0

          ;;Room 35
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 58

          .byte 0

          ;;Room 36
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 59

          .byte 0

          ;;Room 37
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 60

          .byte 0

          ;;Room 38
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 61

          .byte 0

          ;;Room 39
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpritePerson, 98 ; hungry

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpritePerson, 42 ; Treble refugee
          
          .byte 0

          ;;Room 40, Tier 11
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 14

          .byte 0

          ;;Room 41, Tier 11
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 20

          .byte 0

          ;;Room 42, Tier 11
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 80

          .byte 0

          ;;Room 43, Tier 11
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 81

          .byte 0

          ;;Room 44, Tier 11
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 20

          .byte 0

          ;;Room 45, Tier 11
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 14

          .byte 0

          ;;Room 46, Tier 11
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 80

          .byte 0

          ;; Room 47, Tier 11
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 81

          .byte 0

          ;; Room 48, Tier 11
          .byte 16, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 14

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 20

          .byte 0

          ;; Room 49, Tier 0
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpritePerson, 49 ; Fat Tony — sea is dangerous

          .byte 0

          ;; Room 50, Tier 11
          .byte 18, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 14

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 20

          .byte $ff, SpriteFixed
          .byte 0, 0
          .byte SpriteGrizzard, 7 ; Firend

          .byte 0

          ;; Room 51, Tier 9
          .byte $ff, SpriteFixed
          .byte $b0, $2a
          .byte SpritePerson, 107 ; fishing fisherman

          .byte 19, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 61 ; grabby crabby × 2

          .byte 0

          ;; Room 52, Tier 9
          .byte 20, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 62

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 38

          .byte 0

          ;; Room 53, Tier 9
          .byte 11, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 61

          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 39

          .byte 0

          ;; Room 54
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 30

          .byte $ff, SpriteWander
          .byte $7c, $18
          .byte SpritePerson, 33 ; Train 'em

          .byte 0

          ;; Room 55
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 31

          .byte $ff, SpriteWander
          .byte $7c, $18
          .byte SpritePerson, 25 ; Peter's dad

          .byte 0

          ;; Room 56
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 32

          .byte $ff, SpriteWander
          .byte $7c, $18
          .byte SpritePerson, 34 ; Gary

          .byte 0

          ;; Room 57
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 33

          .byte $ff, SpriteWander
          .byte $7c, $18
          .byte SpritePerson, 50 ; Miranda

          .byte 0

          ;; Room 58
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 35

          .byte $ff, SpriteWander
          .byte $7c, $18
          .byte SpritePerson, 35 ; They fight

          .byte 0

          ;; Room 59
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 36

          .byte $ff, SpriteWander
          .byte $7c, $18
          .byte SpritePerson, 52 ; Sue

          .byte 0

          ;; Room 60
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 37

          .byte $ff, SpriteWander
          .byte $7c, $18
          .byte SpritePerson, 36 ; Gary's a slacker

          .byte 0

          ;; Room 61
          .byte $ff, SpriteFixed
          .byte $7c, $2f
          .byte SpriteDoor, 38

          .byte $ff, SpriteWander
          .byte $7c, $18
          .byte SpritePerson, 37 ; Last Move guy

          .byte $ff, SpriteFixed
          .byte $93, $3d
          .byte SpriteGrizzardDepot, 0

          .byte 0

          ;; Room 62, Tier 15
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 72

          .byte 0

          ;; Room 63, Tier 15
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 53

          .byte 0

          ;; Room 64, Tier 15
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 49

          .byte 0

          ;; Room 65, Tier 15
          .byte $ff, SpriteFixed
          .byte $47, $20
          .byte SpriteProvinceDoor | $10, 46

          .byte 0

          ;; Room 66, Tier 15
          .byte $ff, SpriteWander
          .byte 0, 0
          .byte SpriteCombat, 79

          .byte 0
