;;; Grizzards Source/Banks/Bank0b/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 74

          Signs = ( NPC_RadioFix, NPC_RadioDone, NPC_Villager2, NPC_Villager3, Sign_BewareCyclops, NPC_Lover1, NPC_Lover2, NPC_Lover2NoNote, NPC_Lover1Requited, NPC_Lover1End )

SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

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
