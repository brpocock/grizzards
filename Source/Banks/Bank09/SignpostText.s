;;; Grizzards Source/Banks/Bank09/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 16

          Signs = (NPC_BrokenRadio, Sign_TunnelClosed, Sign_SpiralWoodsOpen, Sign_PortLionShip, Sign_TunnelMazeBlocked, NPC_LostPendant, Random_FoundPendant, NPC_ReturnPendant, NPC_HaveKey, NPC_LostChild, NPC_IAmLost, NPC_ReturnChild, NPC_ChildReward, Sign_Labyrinth, Sign_KeyFred, Sign_KeyAndrew, Sign_KeyTimmy)
          
SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

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
          .SignText "NEXT SHIP TO"
          .SignText "PORT LION   "
          .SignText "DEPARTING.  "
          .SignText "ALL ABOARD! "
          .byte ModeSignpostWarp, 2, 0

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

;;; 24
NPC_HaveKey:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "THAT KEY CAN"
          .SignText "OPEN MY CAVE"
          .SignText "TO THE NORTH"
          .SignText "WHERE I LEFT"
          .SignText "MY GRIZZARDS"
          .byte ModeSignpostDone

;;; 25
NPC_LostChild:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .byte $ff, 0, 27      ; found Peter already
          .SignText "MY SON PETER"
          .SignText "HAS GONE    "
          .SignText "MISSING NEAR"
          .SignText "THE TOP OF  "
          .SignText "THE CLIFFS! "
          .byte ModeSignpostClearFlag,  63

;;; 26
NPC_IAmLost:
          .colu COLINDIGO, $4
          .colu COLTURQUOISE, $f
          .SignText "MY NAME IS  "
          .SignText "PETER. I    "
          .SignText "WANT TO GO  "
          .SignText "HOME TO PORT"
          .SignText "LION NOW.   "
          .byte ModeSignpostSet0And63

;;; 27
NPC_ReturnChild:
          .colu COLINDIGO, $0
          .colu COLTURQUOISE, $f
          .byte $ff, 1, 28      ; already returned Peter
          .SignText "PETER! YOU  "
          .SignText "ARE HOME!   "
          .SignText "    -  -    "
          .SignText "DADDY! I'M  "
          .SignText "SAFE NOW.   "
          .byte ModeSignpostSetFlag, 1

;;; 28
NPC_ChildReward:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .byte $ff, 2, 60      ; already been rewarded
          .SignText "THANK YOU   "
          .SignText "FOR SAVING  "
          .SignText "PETER. HAVE "
          .SignText "THIS -FIXME-"
          .SignText "AS A REWARD."
          .byte ModeSignpostSetFlag, 2

;;; 29
Sign_Labyrinth:
          .colu COLRED, $f
          .colu COLGRAY, 0
          .SignText "LABYRINTH   "
          .SignText "SIGNPOST    "
          .SignText "            "
          .SignText "TODO        "
          .SignText "            "
          .byte ModeSignpostDone

;;; 30
Sign_KeyFred:
          .colu COLBROWN, 0          
          .colu COLBLUE, $f
          .SignText "THIS LEVER  "
          .SignText "UNLOCKS THE "
          .SignText "DOOR TO THE "
          .SignText "DREADED     "
          .SignText "DRAGON FRED."
          .byte ModeSignpostClearFlag, 60

;;; 31
Sign_KeyAndrew:
          .colu COLGREEN, 0
          .colu COLYELLOW, $f
          .SignText "THIS LEVER  "
          .SignText "UNLOCKS THE "
          .SignText "DOOR TO THE "
          .SignText "EVIL DRAGON "
          .SignText "ANDREW.     "
          .byte ModeSignpostClearFlag, 61

;;; 32
Sign_KeyTimmy:
          .colu COLCYAN, 0
          .colu COLCYAN, $f
          .SignText "THIS LEVER  "
          .SignText "UNLOCKS THE "
          .SignText "DOOR TO THE "
          .SignText "WICKED      "
          .SignText "DRAGON TIMMY"
          .byte ModeSignpostClearFlag, 62


