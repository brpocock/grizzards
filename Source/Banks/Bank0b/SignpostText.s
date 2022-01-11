;;; Grizzards Source/Banks/Bank0b/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 47

          Signs = ( NPC_Hellmouth, NPC_CanYouSwim, NPC_Allen, NPC_Miranda1, NPC_SueMirror, NPC_Sue, NPC_MirandaMirror, NPC_MirandaTip1, NPC_MirandaTip2, NPC_MirandaTip3, NPC_NeedRing, NPC_GotRing, NPC_FixedRadio, NPC_PeterThanksAgain, NPC_GaryPlayerMirror, NPC_LabyrinthOpen )
          
SignH:    .byte >(Signs)
SignL:    .byte <(Signs)


;;; 47
NPC_Hellmouth:
          .colu COLINDIGO, $f
          .colu COLTURQUOISE, 2
          .byte $ff, 12, 57     ; need ring
          .SignText "IT'S ME, FAT"
          .SignText "TONY. IN AN "
          .SignText "OLD STORY,  "
          .SignText "THIS WAS THE"
          .SignText "ROAD TO HELL"
          .byte ModeSignpostDone

;;; 48
NPC_CanYouSwim:
          .colu COLINDIGO, $f
          .colu COLTURQUOISE, 2
          .SignText "IT'S ME, FAT"
          .SignText "TONY. CAN   "
          .SignText "YOU SWIM? IF"
          .SignText "NOT, THE SEA"
          .SignText "IS DANGEROUS"
          .byte ModeSignpostDone

;;; 49
NPC_Allen:
          .colu COLBLUE, $9
          .colu COLCYAN, 0
          .SignText "I'M ALLEN.  "
          .SignText "THEY SAY IN "
          .SignText "LEGENDS THE "
          .SignText "MONSTERS ARE"
          .SignText "FROM HELL.  "
          .byte ModeSignpostSetFlag, 6

;;; 50
NPC_Miranda1:
          .colu COLPURPLE, 0
          .colu COLTURQUOISE, $c
          .byte $ff, 8, 53      ; found mirror
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
          .byte ModeSignpostSetFlag, 8

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
          .byte $ff, 9, 54      ; returned mirror
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
          .byte $ff, 10, 55     ; heard legend 1
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
          .byte $ff, 11, 56     ; heard legend 2
          .SignText "THEY SAY IF "
          .SignText "YOU WANT TO "
          .SignText "GO INTO HELL"
          .SignText "IT'S THROUGH"
          .SignText "A LABYRINTH."
          .byte ModeSignpostSetFlag, 11

;;; 56
NPC_MirandaTip3:
          .colu COLPURPLE, 0
          .colu COLTURQUOISE, $c
          .byte $ff, 12, 64     ; heard legend 3
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
          .byte $ff, 13, 62     ; got the ring
          .SignText "IN THE OLD  "
          .SignText "STORIES, A  "
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

;;; 59
NPC_FixedRadio:
          .colu COLINDIGO, 0
          .colu COLBLUE, $9
          .SignText "MY RADIO IS "
          .SignText "FIXED! THE  "
          .SignText "SHIP TO PORT"
          .SignText "LION IS AT  "
          .SignText "TREBLE DOCK."
          .byte ModeSignpostSetFlag, 26

;;; 60
NPC_PeterThanksAgain:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "THANKS FOR  "
          .SignText "SAVING PETER"
          .SignText "IF I CAN DO "
          .SignText "ANYTHING FOR"
          .SignText "YOU JUST SAY"
          .byte ModeSignpostDone

;;; 61
NPC_GaryPlayerMirror:
          .colu COLINDIGO, 2
          .colu COLTURQUOISE, $f
          .byte $ff, 9, 39      ; mirror returned
          .SignText "I TOLD HER I"
          .SignText "DID NOT TAKE"
          .SignText "THAT STUPID "
          .SignText "MIRROR, BUT "
          .SignText "SHE'S DUMB. "
          .byte ModeSignpostDone
          
;;; 62
NPC_LabyrinthOpen:
          .colu COLINDIGO, $f
          .colu COLTURQUOISE, 2
          .byte $ff, 56, 58     ; need to reveal
          .SignText "A LABYRINTH "
          .SignText "BEYOND THAT "
          .SignText "DOOR MAY BE "
          .SignText "WHERE THE   "
          .SignText "BOSS BEAR IS"
          .byte ModeSignpostDone

