;;; Grizzards Source/Banks/Bank08/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 0

          Signs = ( Sign_Beware, Sign_FireSwamp, NPC_SouthGate, NPC_TunnelBlocked, NPC_TunnelOpen, NPC_Artifact, NPC_TakeArtifact1, NPC_TakeArtifact2, NPC_TookArtifact, Sign_LostMines, NPC_RandomVillager, Sign_TrebleVillage, NPC_TrebleVillage, Sign_TrebleDocks, Sign_WesternRoad, NPC_Artifact1Scared, NPC_BrokenRadio, Sign_TunnelClosed, Sign_SpiralWoodsOpen, Sign_PortLionShip, Sign_TunnelMazeBlocked, NPC_LostPendant, Random_FoundPendant, NPC_ReturnPendant )
          
SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

;;; 0
Sign_Beware:
          .colu COLGRAY, 0
          .colu COLYELLOW, $f
          .SignText "BEWARE! THIS"
          .SignText "ROUTE LEADS "
          .SignText "TO MANY EVIL"
          .SignText "MONSTERS.   "
          .SignText "BE CAREFUL! "
          .byte ModeSignpostDone

;;; 1
Sign_FireSwamp:
          .colu COLRED, 0
          .colu COLRED, $f
          .SignText "NOW ENTERING"
          .SignText "THE FIRE BOG"
          .SignText "BE WARY OF  "
          .SignText "FLAME DOGGOS"
          .SignText "AND R.O.U.S."
          .byte ModeSignpostDone

;;; 2
NPC_SouthGate:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "YOU SHOULD  "
          .SignText "LEAVE TREBLE"
          .SignText "SOON.       "
          .SignText "WHERE WILL  "
          .SignText "YOU GO NOW? "
          .byte ModeSignpostInquire
          .byte 88, 89
          .SignText "SOUTH WEST  "

;;; 3
NPC_TunnelBlocked:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "I CAN'T OPEN"
          .SignText "THE TUNNELS "
          .SignText "WITHOUT THE "
          .SignText "2 ARTIFACTS."
          .SignText "YOU'LL HELP?"
          .byte ModeSignpostInquire
          .byte 90, 91
          .SignText "HELP  NO    "

;;; 4
NPC_TunnelOpen:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .byte $ff, 1, 95
          .SignText "NOW THAT YOU"
          .SignText "BROUGHT THEM"
          .SignText "I CAN OPEN  "
          .SignText "THE TUNNELS "
          .SignText "TO ANCHOR.  "
          .byte ModeSignpostPoints
          .word $0050
          .byte ModeSignpostSetFlag, 1

;;; 5
NPC_Artifact:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "I HAVE ONE  "
          .SignText "OF THE TWO  "
          .SignText "ARTIFACTS.  "
          .SignText "WHO SAYS YOU"
          .SignText "CAN TAKE IT?"
          .byte ModeSignpostDone

;;; 6
NPC_TakeArtifact1:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "THANKS FOR  "
          .SignText "SAVING ME.  "
          .SignText "TAKE THIS   "
          .SignText "ARTIFACT TO "
          .SignText "THE TUNNELS."
          .byte ModeSignpostPoints
          .word $0020
          .byte ModeSignpostSetFlag, 18

;;; 7
NPC_TakeArtifact2:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "I HAVE ONE  "
          .SignText "OF THE TWO  "
          .SignText "ARTIFACTS.  "
          .SignText "TAKE THIS TO"
          .SignText "THE TUNNELS."
          .byte ModeSignpostPoints
          .word $0025
          .byte ModeSignpostSetFlag, 17

;;; 8
NPC_TookArtifact:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "I HOPE MY   "
          .SignText "ARTIFACT CAN"
          .SignText "HELP YOU TO "
          .SignText "DEFEAT ALL  "
          .SignText "THE MONSTERS"
          .byte ModeSignpostDone
;;; 9
Sign_LostMines:
          .colu COLGRAY, 0
          .colu COLBROWN, $6
          .SignText "-LOST  MINE-"
          .SignText "A MAZE OF   "
          .SignText "TWISTY      "
          .SignText "PASSAGES,   "
          .SignText "ALL ALIKE.  "
          .byte ModeSignpostDone
;;; 10
NPC_RandomVillager:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "THE MONSTERS"
          .SignText "HAVE BEEN   "
          .SignText "TROUBLING   "
          .SignText "OUR VILLAGE."
          .SignText "            "
          .byte ModeSignpostDone

;;; 11
Sign_TrebleVillage:
          .colu COLRED, 0
          .colu COLGOLD, $8
          .SignText "   TREBLE   "
          .SignText "   VILLAGE  "
          .SignText "FLEE NOW!   "
          .SignText "THE MONSTERS"
          .SignText "ARE COMING! "
          .byte ModeSignpostDone

;;; 12
NPC_TrebleVillage:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "I'M GETTING "
          .SignText "OUT OF HERE!"
          .SignText "THE MONSTERS"
          .SignText "KEEP GETTING"
          .SignText "CLOSER TO US"
          .byte ModeSignpostPoints
          .word $0003
          .byte ModeSignpostSetFlag, 19

;;; 13
Sign_TrebleDocks:
          .colu COLBLUE, $e
          .colu COLCYAN, $2
          .byte $ff, 26, 19
          .SignText "TREBLE DOCKS"
          .SignText "TO PORT LION"
          .SignText "            "
          .SignText "NO SHIPS ARE"
          .SignText "IN PORT NOW."
          .byte ModeSignpostDone

;;; 14
Sign_WesternRoad:
          .colu COLGRAY, $0
          .colu COLBROWN, $8
          .SignText "<- LOST MINE"
          .SignText "      SPIRAL"
          .SignText "    WOODS ->"
          .SignText "      TUNNEL"
          .SignText "  COMPLEX ->"
          .byte ModeSignpostDone

;;; 15
NPC_Artifact1Scared:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "I HAVE THE  "
          .SignText "ARTIFACT    "
          .SignText "HIDDEN FROM "
          .SignText "THE MONSTERS"
          .SignText "SAVE ME!    "
          .byte ModeSignpostDone

;;; 16
NPC_BrokenRadio:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .byte $ff, 27, 59     ; radio fixed
          .SignText "IF YOU FIX  "
          .SignText "MY RADIO SET"
          .SignText "I COULD CALL"
          .SignText "FOR A SHIP  "
          .SignText "TO PORT LION"
          .byte ModeSignpostSetFlag, 25

;;; 17
Sign_TunnelClosed:
          .colu COLGRAY, 0
          .colu COLBROWN, $8
          .SignText "TUNNELS TO  "
          .SignText "SOUTH FIELD "
          .SignText "AND ANCHOR  "
          .SignText "VILLAGE     "
          .SignText "ARE CLOSED. "
          .byte ModeSignpostDone

;;; 18
Sign_SpiralWoodsOpen:
          .colu COLGRAY, 0
          .colu COLBROWN, $6
          .SignText "NOW ENTERING"
          .SignText "SPIRAL WOODS"
          .SignText "            "
          .SignText "- DANGER ! -"
          .SignText "            "
          .byte ModeSignpostDone

;;; 19
Sign_PortLionShip:
          .colu COLBLUE, $e
          .colu COLCYAN, $2
          .SignText "TREBLE DOCKS"
          .SignText "A SHIP IS   "
          .SignText "HERE, GOING "
          .SignText "TO PORT LION"
          .SignText "WANT TO GO? "
          .byte ModeSignpostInquire
          .byte 84, 85
          .SignText "BOARD STAY  "

;;; 20
Sign_TunnelMazeBlocked:
          .colu COLINDIGO, $4
          .colu COLBLUE, $e
          .SignText "BLOCKADE IS "
          .SignText "LOCKED DUE  "
          .SignText "TO DANGER OF"
          .SignText "A CAVE GRUE."
          .SignText "NO ENTRY.   "
          .byte ModeSignpostDone

;;; 21
NPC_LostPendant:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .byte $ff, 28, 22
          .SignText "I TRAINED   "
          .SignText "GRIZZARDS   "
          .SignText "TOO. I LOST "
          .SignText "A PENDANT   "
          .SignText "IN THE WOODS"
          .byte ModeSignpostDone

;;; 22
Random_FoundPendant:
          .colu COLGRAY, $f
          .colu COLGRAY, $0
          .SignText "YOU HAVE    "
          .SignText "FOUND A     "
          .SignText "PENDANT ON  "
          .SignText "A LEAF ON   "
          .SignText "THE GROUND. "
          .byte ModeSignpostSetFlag, 28

;;; 23
NPC_ReturnPendant:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "YOU'RE GREAT"
          .SignText "THAT'S MY   "
          .SignText "PENDANT. YOU"
          .SignText "CAN HAVE    "
          .SignText "THIS KEY.   "
          .byte ModeSignpostClearFlag, 63
          
