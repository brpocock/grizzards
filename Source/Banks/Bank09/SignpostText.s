;;; Grizzards Source/Banks/Bank05/SignpostText.s
;;; Copyright © 2021 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 17

          Signs = (Sign_TunnelClosed, Sign_SpiralWoodsOpen, Sign_PortLionShip, Sign_TunnelMazeBlocked, NPC_LostPendant, Random_FoundPendant, NPC_ReturnPendant, NPC_HaveKey)
          
SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

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
          .SignText "NEXT SHIP TO"
          .SignText "PORT LION   "
          .SignText "DEPARTING.  "
          .SignText "ALL ABOARD! "
          .byte ModeSignpostDone

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
          .SignText "I USED TO   "
          .SignText "BE A TRAINER"
          .SignText "TOO. I LOST "
          .SignText "A PENDANT   "
          .SignText "IN THE MINE."
          .byte ModeSignpostDone

;;; 22
Random_FoundPendant:
          .colu COLGRAY, $f
          .colu COLGRAY, $0
          .SignText "YOU HAVE    "
          .SignText "FOUND A     "
          .SignText "PENDANT     "
          .SignText "IN THE DUST "
          .SignText "OF THE MINE."
          .byte ModeSignpostSetFlag, 28

;;; 23
NPC_ReturnPendant:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .byte $ff, 63, 24
          .SignText "YOU'RE GREAT"
          .SignText "THAT'S MY   "
          .SignText "PENDANT. YOU"
          .SignText "CAN HAVE    "
          .SignText "THIS KEY.   "
          .byte ModeSignpostClearFlag, 63

;;; 24
NPC_HaveKey:       
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "THAT KEY CAN"
          .SignText "OPEN MY CAVE"
          .SignText "TO THE NORTH"
          .SignText "WITH TRAINER"
          .SignText "SUPPLIES.   "
          .byte ModeSignpostDone

;;; 25
