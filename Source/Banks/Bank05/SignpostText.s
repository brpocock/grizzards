;;; Grizzards Source/Banks/Bank05/SignpostText.s
;;; Copyright © 2021 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.
          
          Signs = (Sign_Beware, Sign_FireSwamp, NPC_SouthGate, NPC_TunnelBlocked, NPC_TunnelOpen, NPC_Artifact, NPC_TakeArtifact1, NPC_TakeArtifact2, Sign_LostMines, Sign_SpiralWoods)

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
          .byte ModeSignpostSetFlag
          .byte 16
;;; 4
NPC_TunnelOpen:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "NOW THAT YOU"
          .SignText "BROUGHT THEM"
          .SignText "I CAN OPEN  "
          .SignText "THE TUNNELS."
          .SignText "END OF DEMO."
          .byte ModeSignpostDone
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
          .byte ModeSignpostSetFlag
          .byte 18
;;; 7
NPC_TakeArtifact2:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "I HAVE 1 OF "
          .SignText "THE TWO     "
          .SignText "ARTIFACTS.  "
          .SignText "TAKE THIS TO"
          .SignText "THE TUNNELS."
          .byte ModeSignpostSetFlag
          .byte 17
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
          .SignText " LOST MINES "
          .SignText " - CLOSED - "
          .SignText "DUE TO CAVE-"
          .SignText "IN.         "
          .SignText "            "
          .byte ModeSignpostDone
;;; 10
Sign_SpiralWoods:
          .colu COLGRAY, 0
          .colu COLBROWN, $6
          .SignText "            "
          .SignText "SPIRAL WOODS"
          .SignText " - CLOSED - "
          .SignText "NO ENTRANCE."
          .SignText "            "
          .byte ModeSignpostDone

          
	
; LocalWords:  Grizzards
