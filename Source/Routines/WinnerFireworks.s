;;; Grizzards Source/Routines/WinnerFireworks.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
WinnerFireworks:    .block

          .WaitScreenBottom
Loop:
          .WaitScreenTop
          .ldacolu COLCYAN, $c
          sta COLUBK
          .ldacolu COLRED, $2
          sta COLUP0
          sta COLUP1

          .SetPointer WinnerText
          jsr ShowPointerText12
          .SetPointer WinnerText + 9
          jsr ShowPointerText12
          .SetPointer WinnerText + 9 * 2
          jsr ShowPointerText12
          .SetPointer WinnerText + 9 * 3
          jsr ShowPointerText12
          .SetPointer WinnerText + 9 * 4
          jsr ShowPointerText12
          ;; TODO: Fireworks display for the winner of the game
          .fill $180, $ea

          .WaitScreenBottom
;;; 
          lda NewSWCHB
          beq +
          .BitBit SWCHBReset
          beq Leave
+
	lda NewButtons
          beq +
          .BitBit PRESSED
          beq Leave
+
          lda AlarmCountdown
          beq Leave
          jmp Loop

Leave:
          .WaitScreenTop
          .FarJMP SaveKeyBank, ServiceAttract

          .bend

WinnerText:
          .SignText "YOU'VE WON  "
          .SignText "THE GAME,   "
          .SignText "BUT IT'S NOT"
          .SignText "FINISHED YET"
          .SignText "SO NO REWARD"
