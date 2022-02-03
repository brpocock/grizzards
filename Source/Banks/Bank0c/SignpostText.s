;;; Grizzards Source/Banks/Bank0c/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 90

          Signs = ( NPC_GetArtifacts, NPC_NoArtifacts, NPC_DoTrain, NPC_DoNotTrain, Sign_Grue, NPC_TunnelAlreadyOpen, Sign_SailBackToTreble, Sign_StayInPortLion, NPC_Hungry, NPC_HungryCookie, NPC_NoCookieForYou, NPC_CookieGiven, NPC_HadCookie, Game_Win1, NPC_Potions, NPC_GotPotions, NPC_MineHint )

SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

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

;;; 99
NPC_HungryCookie:
          .colu COLSPRINGGREEN, $e
          .colu COLGOLD, $2
          .byte $ff, 22, 102
          .SignText "IT'S HARD TO"
          .SignText "GET LUXURIES"
          .SignText "THESE DAYS. "
          .SignText "MAY I HAVE A"
          .SignText "COOKIE?     "
          .byte ModeSignpostInquire
          .byte 101, 100
          .SignText " GIVE  KEEP "

;;; 100
NPC_NoCookieForYou:
          .colu COLSPRINGGREEN, $e
          .colu COLGOLD, $2
          .SignText "WHEN YOU DO "
          .SignText "DEFEAT ALL  "
          .SignText "THE MONSTERS"
          .SignText "THERE WILL  "
          .SignText "BE COOKIES. "
          .byte ModeSignpostDone

;;; 101
NPC_CookieGiven:
          .colu COLSPRINGGREEN, $e
          .colu COLGOLD, $2
          .SignText "YOU ARE THE "
          .SignText "BEST!       "
          .SignText "I'LL TELL MY"
          .SignText "FRIENDS ALL "
          .SignText "ABOUT YOU.  "
          .byte ModeSignpostPoints
          .word $0100
          .byte ModeSignpostSetFlag, 22

;;; 102
NPC_HadCookie:
          .colu COLSPRINGGREEN, $e
          .colu COLGOLD, $2
          .SignText "THAT WAS THE"
          .SignText "BEST COOKIE."
          .SignText "I'LL NAME   "
          .SignText "MY KID AFTER"
          .SignText "YOU FOR SURE"
          .byte ModeSignpostDone

;;; 103
Game_Win1:
          .colu COLGRAY, 0
          .colu COLGOLD, $e
          .SignText "YOU HAVE HIT"
          .SignText "THE FINAL   "
          .SignText "BLOW OF THE "
          .SignText "BATTLE! THE "
          .SignText "BOSS BEAR..."
          .byte ModeWinnerFireworks

;;; 104
NPC_Potions:
          .colu COLMAGENTA, $e
          .colu COLGREEN, $2
          .SignText "YOU SEEM TO "
          .SignText "BE LOW ON   "
          .SignText "POTIONS. I  "
          .SignText "WILL GIVE   "
          .SignText "YOU TEN.    "
          .byte ModeSignpostPotions, 10
          .byte ModeSignpostDone

;;; 105
NPC_GotPotions:
          .colu COLMAGENTA, $e
          .colu COLGREEN, $2
          .SignText "IF YOU RUN  "
          .SignText "LOW ON      "
          .SignText "POTIONS, I  "
          .SignText "WILL GIVE   "
          .SignText "YOU SOME.   "
          .byte ModeSignpostDone

;;; 106
NPC_MineHint:
          .colu COLGRAY, 0
          .colu COLSEAFOAM, $e
          .SignText "DOWN, UP,   "
          .SignText "DOWN, RIGHT "
          .SignText "IN THE MINE "
          .SignText "IS THE      "
          .SignText "SECRET.     "
          .byte ModeSignpostDone
