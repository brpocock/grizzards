;;; Grizzards Source/Banks/Bank05/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 0

          Signs = (Sign_Beware, Sign_FireSwamp, NPC_SouthGate, NPC_TunnelBlocked, NPC_TunnelOpen, NPC_Artifact, NPC_TakeArtifact1, NPC_TakeArtifact2, NPC_TookArtifact, Sign_LostMines, NPC_RandomVillager, Sign_TrebleVillage, NPC_TrebleVillage, Sign_TrebleDocks, Sign_WesternRoad, NPC_Artifact1Scared)
          
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
          .SignText "PEOPLE LIVE."
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
          .SignText "THE TUNNELS "
          .SignText "TO ANCHOR.  "
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
          .SignText "I HAVE ONE  "
          .SignText "OF THE TWO  "
          .SignText "ARTIFACTS.  "
          .SignText "TAKE THIS TO"
          .SignText "THE TUNNELS."
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
