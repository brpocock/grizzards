;;; Grizzards Source/Routines/HighScore.s
;;; Copyright © 2022 Bruce-Robert Pocock

HighScore:          .block
          .FarJSR MapServicesBank, ServiceCheckHighScore
          lda Score
          cmp #$ff
          beq NextMode

          ora Score + 1
          ora Score + 2
          beq NextMode

          .WaitScreenBottom
Loop:
          .WaitScreenTop
LoopFirst:
          lda # 0
          stx WSYNC
          sta COLUBK
          .ldacolu COLYELLOW, $e
          sta COLUP0
          sta COLUP1

          .SkipLines 20

          .SetPointer HighText
          jsr ShowPointerText

          .SetPointer ScoreText
          jsr ShowPointerText

          .SkipLines 20

          jsr FinalScore

          lda AlarmCountdown
          beq NextMode

CheckSwitches:
          lda NewSWCHB
          beq CheckFire

          and #SWCHBSelect
          beq LoopMe

CheckFire:
          lda NewButtons
          beq LoopMe

          and #ButtonI
          bne LoopMe

SelectSlot:
          .mva GameMode, #ModeSelectSlot
          rts

LoopMe:
          .WaitScreenBottom
          jmp Loop

NextMode:
          .mva AlarmCountdown, # 8
          .mva GameMode, #ModePublisherPresents
          rts
          
          .enc "minifont"
HighText:
          .text " HIGH "
ScoreText:
          .text "SCORE "

          .bend
