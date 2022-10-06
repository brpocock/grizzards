;;; Grizzards Source/Banks/Bank0c/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 99

          Signs = ( NPC_HungryCookie, NPC_NoCookieForYou, NPC_CookieGiven, NPC_HadCookie, Game_Win1, NPC_Potions, NPC_GotPotions, NPC_MineHint, NPC_FishMonsters, Credits_1, Credits_2, Credits_3, Credits_4, Credits_5, NPC_Villager4, Sign_NewGamePlus, Sign_EasterEgg )

SignH:    .byte >(Signs)
SignL:    .byte <(Signs)

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
          .Response "GIVE  ", "KEEP  "

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
          .colu COLINDIGO, 0
          .colu COLCYAN, $9
          .SignText "YOU SEEM TO "
          .SignText "BE LOW ON   "
          .SignText "POTIONS. I  "
          .SignText "WILL GIVE   "
          .SignText "YOU TEN.    "
          .byte ModeSignpostPotions, 10
          .byte ModeSignpostDone

;;; 105
NPC_GotPotions:
          .colu COLINDIGO, 0
          .colu COLCYAN, $9
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

;;; 107
NPC_FishMonsters:
          .colu COLINDIGO, 0
          .colu COLCYAN, $9
          .byte $ff, 19, 40    ; monsters defeated?
          .SignText "I JUST CAME "
          .SignText "HERE TO FISH"
          .SignText "BUT THESE   "
          .SignText "MONSTERS ARE"
          .SignText "ATTACKING ME"
          .byte ModeSignpostDone

;;; 108
Credits_1:
          .colu COLTURQUOISE, 0
          .colu COLGRAY, $e
          .SignText "YOU HAVE WON"
          .SignText " GRIZZARDS! "
          .SignText "            "
          .SignText "SYREX HAS   "
          .SignText "BEEN SAVED! "
          .byte ModeSignpostNext, 109

;;; 109
Credits_2:
          .colu COLTURQUOISE, 0
          .colu COLGRAY, $e
          .SignText "DESIGNED AND"
          .SignText "PROGRAMMED  "
          .SignText "     BY     "
          .SignText "BRUCE-ROBERT"
          .SignText "POCOCK      "
          .byte ModeSignpostNext, 110

;;; 110
Credits_3:
          .colu COLTURQUOISE, 0
          .colu COLGRAY, $e
          .SignText "MUSIC AND   "
          .SignText "ADDITIONAL  "
          .SignText "ART BY      "
          .SignText "ZEPHYR SALZ "
          .SignText "            "
          .byte ModeSignpostNext, 111

;;; 111
Credits_4:
          .colu COLTURQUOISE, 0
          .colu COLGRAY, $e
          .SignText "HARDWARE BY "
          .SignText " FRED QUIMBY"
          .SignText "PUBLISHED BY"
          .SignText " ALBERT     "
          .SignText " YARUSSO    "
          .byte ModeSignpostNext, 112

;;; 112
Credits_5:
          .colu COLTURQUOISE, 0
          .colu COLGRAY, $e
          .SignText "THANKS TO   "
          .SignText "OUR TESTERS "
          .SignText "AND EVERYONE"
          .SignText "IN ATARIAGE "
          .SignText "FORUMS.     "
          .byte ModeSignpostNext, 114

;;; 113
NPC_Villager4:
          .colu COLINDIGO, 0
          .colu COLTURQUOISE, $9
          .SignText "THE MONSTERS"
          .SignText "ATTACKED    "
          .SignText "TREBLE FIRST"
          .SignText "BUT THEY'RE "
          .SignText "COMING HERE."
          .byte ModeSignpostDone

;;; 114
Sign_NewGamePlus:
          .colu COLTURQUOISE, 0
          .colu COLGRAY, $e
          .SignText "PRESS GAME  "
          .SignText "RESET SWITCH"
          .SignText "TO RESTART  "
          .SignText "WITH YOUR   "
          .SignText "GRIZZARDS.  "
          .byte ModeWinnerWinning

;;; 115
Sign_EasterEgg:
          .colu COLGRAY, 0
          .colu COLGRAY, $e
          .SignText "<BUILD INFO>"
          .if PUBLISHER
            .SignText "ATARIAGE.COM"
          .else
            .SignText "PUBLIC BUILD"
          .fi
          .SignText format(" %04d-%02d-%02d ", YEARNOW, MONTHNOW, DATENOW)
          .SignText format(" J%03d T%02d%02d ", JULIANDATENOW, HOURNOW, MINUTENOW)
          .SignText format("%-12s", ConfigPartNumber)
          .byte ModeSignpostDone
