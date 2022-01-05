;;; Grizzards Source/Banks/Bank05/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 67

          Signs = ( Sign_FindAndrew, Sign_FindFred, Sign_FindTimmy, Sign_DragonHints, Sign_GetDragonHints, Sign_Ancient, NPC_Radio, NPC_RadioFix, NPC_RadioDone )
          
SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

;;; 67
Sign_FindAndrew:
          .colu COLGRAY, 0
          .colu COLGRAY, $f
          .byte $ff, 57, 72     ; runes
          .SignText "THE EVIL    "
          .SignText "DRAGON      "
          .SignText "ANDREW IS IN"
          .SignText "THE NORTH-  "
          .SignText "WEST CORNER."
          .byte ModeSignpostDone

;;; 68
Sign_FindFred:
          .colu COLGRAY, 0
          .colu COLGRAY, $f
          .byte $ff, 57, 72     ; runes
          .SignText "THE DREADED "
          .SignText "DRAGON FRED "
          .SignText "LIVES IN THE"
          .SignText "SOUTHWEST   "
          .SignText "CORNER.     "
          .byte ModeSignpostDone

;;; 69
Sign_FindTimmy:
          .colu COLGRAY, 0
          .colu COLGRAY, $f
          .byte $ff, 57, 72     ; runes
          .SignText "THE WICKED  "
          .SignText "DRAGON TIMMY"
          .SignText "HAS A LAIR  "
          .SignText "AT THE VERY "
          .SignText "CENTER.     "
          .byte ModeSignpostDone

;;; 70
Sign_DragonHints:
          .colu COLGRAY, 0
          .colu COLGRAY, $f
          .byte $ff, 57, 72     ; runes
          .SignText "ALL THREE OF"
          .SignText "THE DRAGONS "
          .SignText "LIVE ON THE "
          .SignText "SECOND LEVEL"
          .SignText "UNDERGROUND."
          .byte ModeSignpostDone

;;; 71
Sign_GetDragonHints:
          .colu COLGRAY, 0
          .colu COLGRAY, $f
          .SignText "NOW YOU CAN "
          .SignText "UNDERSTAND  "
          .SignText "THE ANCIENT "
          .SignText "CARVINGS ON "
          .SignText "THE WALLS.  "
          .byte ModeSignpostClearFlag, 57

;;; 72
Sign_Ancient:
          .colu COLGRAY, $f
          .colu COLGRAY, 0
          .SignText "THERE ARE   "
          .SignText "OLD RUNES   "
          .SignText "CARVED HERE,"
          .SignText "BUT YOU CAN "
          .SignText "NOT READ IT."
          .byte ModeSignpostDone

;;; 73
NPC_Radio:
          .colu COLYELLOW, $f
          .colu COLBLUE, $4
          .byte $ff, 25, 74     ; asked to fix radio
          .SignText "MY RADIO    "
          .SignText "REPAIR SHOP "
          .SignText "IS GOING TO "
          .SignText "HAVE TO SHUT"
          .SignText "FOR MONSTERS"
          .byte ModeSignpostDone

;;; 74
NPC_RadioFix:
          .colu COLYELLOW, $f
          .colu COLBLUE, $4
          .byte $ff, 27, 75     ; already fixed
          .SignText "OH! I CAN   "
          .SignText "TOTALLY FIX "
          .SignText "THAT RADIO  "
          .SignText "FOR YOU. NO "
          .SignText "PROBLEM!    "
          .byte ModeSignpostSetFlag, 27

;;; 75
NPC_RadioDone:
          .colu COLYELLOW, $f
          .colu COLBLUE, $4
          .SignText "I GUESS I   "
          .SignText "OUGHT TO RUN"
          .SignText "AWAY FROM   "
          .SignText "MONSTERS TOO"
          .SignText " - BYE!     "
          .byte ModeSignpostSetFlag, 29
          
