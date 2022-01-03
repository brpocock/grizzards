;;; Grizzards Source/Banks/Bank05/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 33

          Signs = ( NPC_TrainEm, NPC_Gary1, NPC_GaryBad, NPC_Slacker, NPC_LastMove, NPC_GaryMirror, NPC_GaryVindicated, NPC_Fishing, NPC_FoundRing, NPC_TrebleRefugee, NPC_HowLong, NPC_FatTony, NPC_WelcomePortLion, NPC_LookUpCliff, NPC_Hellmouth, NPC_CanYouSwim, NPC_Allen )
          
SignH:    .byte >(Signs)
SignL:    .byte <(Signs)


;;; 33
NPC_TrainEm:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "GRIZZARDS   "
          .SignText "CAN DEFEAT  "
          .SignText "MONSTERS IF "
          .SignText "YOU TRAIN   "
          .SignText "THEM WELL.  "
          .byte ModeSignpostDone

;;; 34
NPC_Gary1:
          .colu COLINDIGO, 2
          .colu COLTURQUOISE, $f
          .SignText "MIRANDA     "
          .SignText "TALKS TOO   "
          .SignText "MUCH ABOUT  "
          .SignText "OLD STUFF.  "
          .SignText "HOW BORING! "
          .byte ModeSignpostDone
;;; 35
NPC_GaryBad:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "GARY DOESN'T"
          .SignText "LIKE MIRANDA"
          .SignText "VERY MUCH.  "
          .SignText "THEY FIGHT  "
          .SignText "OFTEN.      "
          .byte ModeSignpostDone

;;; 36
NPC_Slacker:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "GARY LIVES  "
          .SignText "JUST SOUTH  "
          .SignText "OF ME. SUCH "
          .SignText "A GROUCHY   "
          .SignText "SLACKER!    "
          .byte ModeSignpostDone

;;; 37
NPC_LastMove:
          .colu COLBLUE, 0
          .colu COLCYAN, $9
          .SignText "I CAN TRAIN "
          .SignText "ANY OF YOUR "
          .SignText "GRIZZARDS   "
          .SignText "THEIR LAST  "
          .SignText "MOVE.       "
          .byte ModeTrainLastMove

;;; 38
NPC_GaryMirror:
          .colu COLINDIGO, 2
          .colu COLTURQUOISE, $f
          .SignText "NO, I DON'T "
          .SignText "KNOW WHERE  "
          .SignText "MIRANDA'S   "
          .SignText "DUMB MIRROR "
          .SignText "HAS GOT TO. "
          .byte ModeSignpostDone

;;; 39
NPC_GaryVindicated:
          .colu COLINDIGO, 2
          .colu COLTURQUOISE, $f
          .SignText "SO SHE'S GOT"
          .SignText "HER MIRROR  "
          .SignText "BACK. SEE IF"
          .SignText "SHE'LL EVER "
          .SignText "APOLOGIZE.  "
          .byte ModeSignpostDone

;;; 40
NPC_Fishing:
          .colu COLINDIGO, 0
          .colu COLCYAN, $9
          .SignText "I FISH HERE "
          .SignText "WHENEVER THE"
          .SignText "MONSTERS LET"
          .SignText "ME BE, WHICH"
          .SignText "IS NOT OFTEN"
          .byte ModeSignpostDone

;;; 41
NPC_FoundRing:
          .colu COLINDIGO, 0
          .colu COLCYAN, $9
          .SignText "YOU LOOKING "
          .SignText "FOR A MAGIC "
          .SignText "RING? I     "
          .SignText "FOUND THIS  "
          .SignText "IN THE SEA. "
          .byte ModeSignpostSetFlag, 13

;;; 42
NPC_TrebleRefugee:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "PORT LION IS"
          .SignText "PRETTY SAFE,"
          .SignText "NOT LIKE MY "
          .SignText "HOME TOWN,  "
          .SignText "TREBLE.     "
          .byte ModeSignpostDone

;;; 43
NPC_HowLong:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "PEOPLE FLEE "
          .SignText "HERE FROM   "
          .SignText "OTHER TOWNS."
          .SignText "HOW LONG IS "
          .SignText "IT SAFE?    "
          .byte ModeSignpostDone

;;; 44
NPC_FatTony:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "FAT TONY WAS"
          .SignText "RAISED HERE,"
          .SignText "AND HE KNOWS"
          .SignText "ALL ABOUT   "
          .SignText "OUR ISLAND. "
          .byte ModeSignpostDone

;;; 45
NPC_WelcomePortLion:
          .colu COLINDIGO, $f
          .colu COLTURQUOISE, 2
          .SignText "I'M FAT TONY"
          .SignText "WELCOME TO  "
          .SignText "PORT LION.  "
          .SignText "I'M THE BEST"
          .SignText "AT GEOGRAPHY"
          .byte ModeSignpostDone

;;; 46
NPC_LookUpCliff:
          .colu COLINDIGO, $f
          .colu COLTURQUOISE, 2
          .SignText "IT'S ME, FAT"
          .SignText "TONY. DID   "
          .SignText "YOU EVER SEE"
          .SignText "CLIFFS SO   "
          .SignText "VERY TALL?  "
          .byte ModeSignpostDone

;;; 47
NPC_Hellmouth:
          .colu COLINDIGO, $f
          .colu COLTURQUOISE, 2
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

