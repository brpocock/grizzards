;;; Grizzards Source/Routines/ShowBossBear.s
;;; Copyright © 2022 Bruce-Robert Pocock

ShowBossBear:       .block
          jsr Prepare48pxMobBlob

          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1

          lda #$20
          bit ClockFrame
          beq AltFrame
          .SetUpFortyEight BossBear
          ldy #BossBear.Height
          gne Ready

AltFrame:
          .SetUpFortyEight BossBear2
          ldy #BossBear2.Height

Ready:
          sty LineCounter
          jmp ShowPicture       ; tail call

          .bend
