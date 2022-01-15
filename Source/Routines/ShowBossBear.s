;;; Grizzards Source/Routines/ShowBossBear.s
;;; Copyright © 2022 Bruce-Robert Pocock

ShowBossBear:
          jsr Prepare48pxMobBlob

          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1

          .SetUpFortyEight BossBear
          ldy #BossBear.Height
          sty LineCounter
          jsr ShowPicture

          rts
