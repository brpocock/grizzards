;;; Grizzards Source/Banks/Bank05/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 0

          Signs = ( Sign_Beware, Sign_FireSwamp, NPC_SouthGate, NPC_TunnelBlocked, NPC_TunnelOpen, NPC_Artifact, NPC_TakeArtifact1, NPC_TakeArtifact2, NPC_TookArtifact, Sign_LostMines, Sign_SpiralWoods, Sign_TrebleVillage, NPC_TrebleVillage, Sign_TrebleDocks, Sign_WesternRoad, NPC_Artifact1Scared, Sign_FullGame, Sign_CannotEnter, Sign_GameOver1, Sign_GameOver2 )
          
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
          .SignText "TO THE SOUTH"
          .SignText "ARE TUNNELS "
          .SignText "TO THE FIELD"
          .SignText "WHERE MANY  "
          .SignText "PEOPLE LIVE.", Sign_TunnelClosed, Sign_SpiralWoodsOpen
          .byte ModeSignpostDone
;;; 3
NPC_TunnelBlocked:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "I CAN'T OPEN"
          .SignText "THE TUNNELS "
          .SignText "WITHOUT THE "
          .SignText "2 ARTIFACTS."
          .SignText "BRING THEM. "
          .byte ModeSignpostSetFlag, 16
;;; 4
NPC_TunnelOpen:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "NOW THAT YOU"
          .SignText "BROUGHT THEM"
          .SignText "I CAN OPEN  "
          .SignText "THE TUNNELS."
          .SignText "END OF DEMO."
          .byte ModeSignpostInquire
          .byte 18, 19
          .SignText "INFO  DONE  "
;;; 5
NPC_Artifact:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "I HAVE 1 OF "
          .SignText "THE TWO     "
          .SignText "ARTIFACTS.  "
          .SignText "WHO SAYS YOU"
          .SignText "CAN TAKE IT?"
          .byte ModeSignpostDone
;;; 6
NPC_TakeArtifact1:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "I HAVE 1 OF "
          .SignText "THE TWO     "
          .SignText "ARTIFACTS.  "
          .SignText "TAKE THIS TO"
          .SignText "THE TUNNELS."
          .byte ModeSignpostPoints
          .word $0020
          .byte ModeSignpostSetFlag, 18
;;; 7
NPC_TakeArtifact2:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "I HAVE 1 OF "
          .SignText "THE TWO     "
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
          .SignText "  LOST MINE "
          .SignText " - CLOSED - "
          .SignText "   DUE TO   "
          .SignText "  CAVE-IN.  "
          .SignText "            "
          .byte ModeSignpostInquire
          .byte 16, 17
          .SignText "LEAVE ENTER "
;;; 10
Sign_SpiralWoods:
          .colu COLGRAY, 0
          .colu COLBROWN, $6
          .SignText "            "
          .SignText "SPIRAL WOODS"
          .SignText " - CLOSED - "
          .SignText "NO ENTRANCE."
          .SignText "            "
          .byte ModeSignpostInquire
          .byte 16, 17
          .SignText "LEAVE ENTER "

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
          .byte ModeSignpostSetFlag, 19

;;; 13
Sign_TrebleDocks:
          .colu COLBLUE, $e
          .colu COLCYAN, $2
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
Sign_FullGame:
          .colu COLTURQUOISE, $e
          .colu COLGRAY, 0
          .SignText "            "
          .SignText "THIS AREA IS"
          .SignText "FOUND IN THE"
          .SignText "FULL GAME.  "
          .SignText "            "
          .byte ModeSignpostDone

;;; 17
Sign_CannotEnter:
          .colu COLTURQUOISE, $e
          .colu COLGRAY, 0
          .SignText "            "
          .SignText "YOU CAN NOT "
          .SignText "CONTINUE TO "
          .SignText "GO THAT WAY."
          .SignText "            "
          .byte ModeSignpostDone

;;; 18
Sign_GameOver1:     
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "COMING IN   "
          .SignText "2022, THE   "
          .SignText "FULL GAME IS"
          .SignText "MUCH LARGER."
          .SignText "ATARIAGE.COM"
          .byte ModeSignpostSetFlag, 1

;;; 19
Sign_GameOver2:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "THANKS FOR  "
          .SignText "TRYING IT.  "
          .SignText "LOOK FOR THE"
          .SignText "FULL GAME AT"
          .SignText "ATARIAGE.COM"
          .byte ModeSignpostSetFlag, 1
