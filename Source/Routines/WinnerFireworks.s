;;; Grizzards Source/Routines/WinnerFireworks.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
WinnerFireworks:    .block

Loop:
          .WaitScreenBottom
          .WaitScreenTop
          .ldacolu COLRED, $e
          sta COLUBK
          .ldacolu COLRED, $0
          sta COLUP0
          sta COLUP1

          .SetUpFortyEight BossBearDies
          ldy #BossBearDies.Height
          jsr ShowPicture

          .FarJSR AnimationsBank, ServiceFinalScore

;;; 
          lda NewSWCHB
          beq +
          and #SWCHBReset
          beq Leave
+
          jmp Loop

Leave:
          jmp GoColdStart

          .bend

