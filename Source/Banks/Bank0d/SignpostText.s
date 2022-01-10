;;; Grizzards Source/Banks/Bank0d/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 79

          Signs = ( NPC_Lover1, NPC_Lover2, NPC_Lover2NoNote, NPC_Lover1Requited, NPC_Lover1End )
          
SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

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
