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
          gne Ready

AltFrame:
          .SetUpFortyEight BossBear2

Ready:
          jmp ShowPicture       ; tail call

          .bend

;;; Audited 2022-02-16 BRPocock
