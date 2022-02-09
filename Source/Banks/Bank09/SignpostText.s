;;; Grizzards Source/Banks/Bank09/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 23

          Signs = ( NPC_ReturnPendant, NPC_HaveKey, NPC_LostChild, NPC_IAmLost, NPC_ReturnChild, NPC_ChildReward, Sign_Labyrinth, Sign_KeyFred, Sign_KeyAndrew, Sign_KeyTimmy, NPC_TrainEm, NPC_Gary1, NPC_GaryBad, NPC_Slacker, NPC_LastMove, NPC_GaryMirror, NPC_GaryVindicated, NPC_Fishing, NPC_FoundRing, NPC_TrebleRefugee, NPC_HowLong, NPC_FatTony, NPC_WelcomePortLion, NPC_LookUpCliff, NPC_Hellmouth )

SignH:    .byte >(Signs)
SignL:    .byte <(Signs)
          
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
          .SignText "THIS COOKIE "
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
          .byte $ff, 7, 38      ; looking for mirror
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
          .byte ModeSignpostInquire
          .byte 92, 93
          .SignText "TRAIN LATER "

;;; 38
NPC_GaryMirror:
          .colu COLINDIGO, 2
          .colu COLTURQUOISE, $f
          .byte $ff, 8, 61      ; have mirror, haven't returned
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
          .byte $ff, 15, 41     ; looking for ring?
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
          .SignText "I FIND MANY "
          .SignText "THINGS IN   "
          .SignText "THE SEA. YOU"
          .SignText "LOOKING FOR "
          .SignText "SOMETHING?  "
          .byte ModeSignpostInquire
          .byte 86, 87
          .SignText "RING  MIRROR"

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
          .SignText "TONY. LOOK  "
          .SignText "UP AT HOW   "
          .SignText "TALL THE    "
          .SignText "CLIFFS ARE! "
          .byte ModeSignpostDone

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

