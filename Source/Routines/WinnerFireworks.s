;;; Grizzards Source/Routines/WinnerFireworks.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
WinnerFireworks:    .block

          lda #SoundRoar
          sta NextSound

Loop:
          .WaitScreenBottom
          .WaitScreenTop
          .ldacolu COLRED, $e
          sta COLUBK
          .ldacolu COLRED, $0
          sta COLUP0
          sta COLUP1

          jsr Prepare48pxMobBlob

          .FarJSR AnimationsBank, ServiceFinalScore

          .SkipLines KernelLines / 5
          
          .SetUpFortyEight BossBearDies
          ldy #BossBearDies.Height
          sty LineCounter
          jsr ShowPicture

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

