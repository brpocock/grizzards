;;; Grizzards Source/Banks/Bank0b/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 73

          Signs = ( NPC_Radio, NPC_RadioFix, NPC_RadioDone, NPC_Villager2, NPC_Villager3, Sign_BewareCyclops, NPC_Lover1, NPC_Lover2, NPC_Lover2NoNote, NPC_Lover1Requited, NPC_Lover1End, Sign_ShipToPortLion, Sign_StayInTreble, NPC_FishingWantRing, NPC_FishingWantMirror, NPC_RouteToAnchor, NPC_RouteToPortLion, NPC_GetArtifacts, NPC_NoArtifacts, NPC_DoTrain, NPC_DoNotTrain, Sign_Grue, NPC_TunnelAlreadyOpen, Sign_SailBackToTreble, Sign_StayInPortLion, NPC_Hungry )

SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

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


;;; 79
NPC_Lover1:
          .colu COLMAGENTA, $e
          .colu COLGREEN, $2
          .SignText "PLEASE TAKE "
          .SignText "THIS NOTE TO"
          .SignText "MY BELOVED  "
          .SignText "IN TREBLE.  "
          .SignText "I MISS THEM!"
          .byte ModeSignpostClearFlag, 56

;;; 80
NPC_Lover2:
          .colu COLSPRINGGREEN, $e
          .colu COLMAGENTA, $2
          .byte $ff, 56, 81
          .SignText "YOU HAVE    "
          .SignText "BROUGHT ME  "
          .SignText "A GREAT NOTE"
          .SignText "WE'LL MEET  "
          .SignText "AGAIN SOON. "
          .byte ModeSignpostClearFlag, 57

;;; 81
NPC_Lover2NoNote:
          .colu COLSPRINGGREEN, $e
          .colu COLMAGENTA, $2
          .SignText "MY BELOVED  "
          .SignText "IS FAR AWAY "
          .SignText "IN ANCHOR.  "
          .SignText "IT'S UNSAFE "
          .SignText "TO GET THERE"
          .byte ModeSignpostDone

;;; 82
NPC_Lover1Requited:
          .colu COLMAGENTA, $e
          .colu COLGREEN, $2
          .byte $ff, 57, 79
          .SignText "I LOVE THEM "
          .SignText "SO MUCH!    "
          .SignText "THANK YOU,  "
          .SignText "YOU'VE DONE "
          .SignText "A GOOD DEED."
          .byte ModeSignpostPoints
          .word $0100
          .byte ModeSignpostClearFlag, 58
          
;;; 83
NPC_Lover1End:
          .colu COLMAGENTA, $e
          .colu COLGREEN, $2
          .byte $ff, 58, 82
          .SignText "WHEN YOU'VE "
          .SignText "DEFEATED ALL"
          .SignText "THE MONSTERS"
          .SignText "WE CAN BE   "
          .SignText "TOGETHER.   "
          .byte ModeSignpostDone

;;; 84
Sign_ShipToPortLion:
          .colu COLBLUE, $e
          .colu COLCYAN, $2
          .SignText "THE SHIP TO "
          .SignText "PORT LION IS"
          .SignText "DEPARTING.  "
          .SignText "            "
          .SignText "ALL ABOARD! "
          .byte ModeSignpostWarp, 2, 0

;;; 85
Sign_StayInTreble:
          .colu COLBLUE, $e
          .colu COLCYAN, $2
          .SignText "THE SHIP TO "
          .SignText "PORT LION   "
          .SignText "WILL WAIT   "
          .SignText "FOR A WHILE."
          .SignText "            "
          .byte ModeSignpostDone

;;; 86
NPC_FishingWantRing:
          .colu COLINDIGO, 0
          .colu COLCYAN, $9
          .byte $ff, 13, 63     ; already got the ring
          .SignText "YOU LOOKING "
          .SignText "FOR A MAGIC "
          .SignText "RING? I     "
          .SignText "FOUND THIS  "
          .SignText "IN THE SEA. "
          .byte ModeSignpostSetFlag, 13

;;; 87
NPC_FishingWantMirror:
          .colu COLINDIGO, 0
          .colu COLCYAN, $9
          .byte $ff, 15, 41     ; also looking for ring?
          .SignText "MIRANDA HAS "
          .SignText "ALWAYS LOST "
          .SignText "THAT MIRROR "
          .SignText "AT SUE'S    "
          .SignText "HOUSE.      "
          .byte ModeSignpostDone


;;; 88
NPC_RouteToAnchor:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "TO THE SOUTH"
          .SignText "ARE TUNNELS "
          .SignText "TO THE FIELD"
          .SignText "WHERE MANY  "
          .SignText "PEOPLE LIVE."
          .byte ModeSignpostDone

;;; 89
NPC_RouteToPortLion:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "SHIPS DON'T "
          .SignText "COME TO THIS"
          .SignText "DOCK UNLESS "
          .SignText "YOU CALL    "
          .SignText "ON THE RADIO"
          .byte ModeSignpostDone

;;; 90
NPC_GetArtifacts:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "THERE ARE   "
          .SignText "2 ARTIFACTS "
          .SignText "THAT WERE IN"
          .SignText "TREBLE. FIND"
          .SignText "THEM BOTH.  "
          .byte ModeSignpostSetFlag, 16

;;; 91
NPC_NoArtifacts:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "THE PEOPLE  "
          .SignText "IN ANCHOR   "
          .SignText "NEED YOUR   "
          .SignText "HELP AGAINST"
          .SignText "THE MONSTERS"
          .byte ModeSignpostSetFlag, 16

;;; 92
NPC_DoTrain:
          .colu COLBLUE, 0
          .colu COLCYAN, $9
          .SignText "NOW YOUR    "
          .SignText "GRIZZARD CAN"
          .SignText "USE THEIR   "
          .SignText "LAST MOVE   "
          .SignText "FOR SURE.   "
          .byte ModeTrainLastMove

;;; 93
NPC_DoNotTrain:
          .colu COLBLUE, 0
          .colu COLCYAN, $9
          .SignText "BRING ME ANY"
          .SignText "GRIZZARD YOU"
          .SignText "WANT ME TO  "
          .SignText "TRAIN AND I "
          .SignText "WILL DO IT. "
          .byte ModeSignpostDone

;;; 94
Sign_Grue:
          .colu COLRED, $4
          .colu COLGRAY, $a
          .SignText "CAVES ARE   "
          .SignText "PITCH BLACK."
          .SignText "YOU MAY BE  "
          .SignText "EATEN BY A  "
          .SignText "GRUE.       "
          .byte ModeSignpostDone

;;; 95
NPC_TunnelAlreadyOpen:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "THE TUNNELS "
          .SignText "ARE OPEN. GO"
          .SignText "CAREFULLY!  "
          .SignText "ANCHOR IS IN"
          .SignText "DANGER.     "
          .byte ModeSignpostDone

;;; 96
Sign_SailBackToTreble:
          .colu COLBLUE, $e
          .colu COLCYAN, $2
          .SignText "            "
          .SignText "SAILING BACK"
          .SignText "TO TREBLE   "
          .SignText "NOW.        "
          .SignText "            "
          .byte ModeSignpostWarp, 0, 19

;;; 97
Sign_StayInPortLion:
          .colu COLBLUE, $e
          .colu COLCYAN, $2
          .SignText "WE'LL WAIT  "
          .SignText "TO RETURN TO"
          .SignText "TREBLE UNTIL"
          .SignText "YOU'RE READY"
          .SignText "THEN.       "
          .byte ModeSignpostDone

;;; 98
NPC_Hungry:
          .colu COLSPRINGGREEN, $e
          .colu COLGOLD, $2
          .byte $ff, 1, 99
          .SignText "THESE AWFUL "
          .SignText "MONSTERS ARE"
          .SignText "MAKING IT SO"
          .SignText "HARD TO GET "
          .SignText "LUXURIES TOO"
          .byte ModeSignpostDone
