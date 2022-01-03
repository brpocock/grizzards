;;; Grizzards Source/Banks/Bank05/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 50

          Signs = ( NPC_Miranda1, NPC_SueMirror, NPC_Sue, NPC_MirandaMirror, NPC_MirandaTip1, NPC_MirandaTip2, NPC_MirandaTip3, NPC_NeedRing, NPC_GotRing )
          
SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

;;; 50
NPC_Miranda1:
          .colu COLPURPLE, 0
          .colu COLTURQUOISE, $c
          .SignText "I'M MIRANDA."
          .SignText "I'VE LOST MY"
          .SignText "FAVORITE    "
          .SignText "MIRROR, IF  "
          .SignText "YOU SEE IT. "
          .byte ModeSignpostSetFlag, 7
          
;;; 51
NPC_SueMirror:
          .colu COLMAGENTA, $f
          .colu COLINDIGO, 0
          .SignText "OH, MIRANDA "
          .SignText "LEFT THAT   "
          .SignText "OLD MIRROR  "
          .SignText "HERE AGAIN. "
          .SignText "TAKE IT.    "
          .byte ModeSignpostDone

;;; 52
NPC_Sue:
          .colu COLMAGENTA, $f
          .colu COLINDIGO, 0
          .SignText "I'M SUE. MY "
          .SignText "FRIEND IS AN"
          .SignText "EXPERT AT   "
          .SignText "LEGENDS,    "
          .SignText "MIRANDA.    "
          .byte ModeSignpostDone

;;; 53
NPC_MirandaMirror:
          .colu COLPURPLE, 0
          .colu COLTURQUOISE, $c
          .SignText "YOU'VE FOUND"
          .SignText "MY MIRROR.  "
          .SignText "LET'S TALK  "
          .SignText "ABOUT THOSE "
          .SignText "OLD LEGENDS."
          .byte ModeSignpostSetFlag, 9

;;; 54
NPC_MirandaTip1:
          .colu COLPURPLE, 0
          .colu COLTURQUOISE, $c
          .SignText "THEY SAY YOU"
          .SignText "CAN FIND THE"
          .SignText "BOSSES OF   "
          .SignText "MONSTERS IN "
          .SignText "HELL.       "
          .byte ModeSignpostSetFlag, 10

;;; 55
NPC_MirandaTip2:
          .colu COLPURPLE, 0
          .colu COLTURQUOISE, $c
          .SignText "THEY SAY IF "
          .SignText "YOU WANT TO "
          .SignText "INTO HELL IT"
          .SignText "IS THROUGH A"
          .SignText "LABYRINTH.  "
          .byte ModeSignpostSetFlag, 11

;;; 56
NPC_MirandaTip3:
          .colu COLPURPLE, 0
          .colu COLTURQUOISE, $c
          .SignText "MAYBE FAT   "
          .SignText "TONY CAN    "
          .SignText "SHOW YOU THE"
          .SignText "LABYRINTH'S "
          .SignText "ENTRANCE.   "
          .byte ModeSignpostSetFlag, 12

;;; 57
NPC_NeedRing:
          .colu COLINDIGO, $f
          .colu COLTURQUOISE, 2
          .SignText "IN THE OLD  "
          .SignText "STORES, A   "
          .SignText "MAGIC RING  "
          .SignText "OPENS THE   "
          .SignText "LABYRINTH.  "
          .byte ModeSignpostSetFlag, 15

;;; 58
NPC_GotRing:
          .colu COLINDIGO, $f
          .colu COLTURQUOISE, 2
          .SignText "WITH THIS   "
          .SignText "MAGIC RING, "
          .SignText "I WILL NOW  "
          .SignText "REVEAL THE  "
          .SignText "LABYRINTH.  "
          .byte ModeSignpostClearFlag, 56

