;;; Grizzards Source/Banks/Bank0c/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 63

          Signs = ( NPC_Fishing2, NPC_MirandaLabyrinth, NPC_MirandaDone, Sign_DocksToTreble, Sign_FindAndrew, Sign_FindFred, Sign_FindTimmy, Sign_DragonHints, Sign_GetDragonHints, Sign_Ancient, NPC_Radio, NPC_RadioFix, NPC_RadioDone, NPC_Villager2, NPC_Villager3, Sign_BewareCyclops )
          
SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

;;; 63
NPC_Fishing2:
          .colu COLINDIGO, 0
          .colu COLCYAN, $9
          .SignText "IF I FIND   "
          .SignText "ANY MORE    "
          .SignText "MAGIC ITEMS,"
          .SignText "I'LL LET YOU"
          .SignText "KNOW IT.    "
          .byte ModeSignpostDone

;;; 64
NPC_MirandaLabyrinth:
          .colu COLPURPLE, 0
          .colu COLTURQUOISE, $c
          .byte $ff, 56, 65     ; labyrinth closed still
          .SignText "A LABYRINTH "
          .SignText "MUST HIDE   "
          .SignText "THE BOSSES  "
          .SignText "OF MONSTERS."
          .SignText "UNCOVER IT. "
          .byte ModeSignpostDone

;;; 65
NPC_MirandaDone:
          .colu COLPURPLE, 0
          .colu COLTURQUOISE, $c
          .SignText "THERE ARE 3 "
          .SignText "DRAGONS WHO "
          .SignText "ANSWER TO A "
          .SignText "BOSS BEAR.  "
          .SignText "DEFEAT THEM."
          .byte ModeSignpostDone

;;; 66
Sign_DocksToTreble:
          .colu COLBLUE, $e
          .colu COLCYAN, $2
          .SignText "PORT LION   "
          .SignText "DOCKS TO GO "
          .SignText "TO TREBLE   "
          .SignText "DEPARTING.  "
          .SignText "ALL ABOARD! "
          .byte ModeSignpostWarp, 0, 1

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
          
;;; 76
NPC_Villager2:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "HELLO THERE."
          .SignText "ARE YOU HERE"
          .SignText "TO DEFEAT   "
          .SignText "THESE AWFUL "
          .SignText "MONSTERS?   "
          .byte ModeSignpostDone

;;; 77
NPC_Villager3:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "THIS VILLAGE"
          .SignText "USED TO BE A"
          .SignText "LOT MORE FUN"
          .SignText "BEFORE THESE"
          .SignText "MONSTERS.   "
          .byte ModeSignpostDone

;;; 78
Sign_BewareCyclops:
          .colu COLBLUE, 0
          .colu COLYELLOW, $e
          .SignText "BEWARE OF A "
          .SignText "ONE-EYED    "
          .SignText "MONSTER WHO "
          .SignText "TENDS TO THE"
          .SignText "VENOM SHEEP."
          .byte ModeSignpostDone

