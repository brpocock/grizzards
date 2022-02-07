;;; Grizzards Source/Banks/Bank0c/SignpostText.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Order of sign texts MUST match the texts in SignpostSpeech.txt or it all goes to Hell.

          FirstSignpost = 100

          Signs = ( NPC_NoCookieForYou, NPC_CookieGiven, NPC_HadCookie, Game_Win1, NPC_Potions, NPC_GotPotions, NPC_MineHint, NPC_FishMonsters )

SignH:    .byte >(Signs)
SignL:    .byte <(Signs)


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
