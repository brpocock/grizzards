;;; Grizzards Source/Routines/Credits.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

Credits:  .block
          .WaitScreenBottom
          .SetUtterance Phrase_Credits
          sta AttractHasSpoken
Loop:
          .WaitScreenTop
          .SkipLines 21

          .ldacolu COLINDIGO, $e
          sta COLUP0
          sta COLUP1

          .SetPointer WithLoveText
          jsr ShowPointerText12
          .SetPointer ZephyrText
          jsr ShowPointerText12

          .SkipLines 80

          .SetPointer DatestampText
          jsr ShowPointerText12
          
          lda NewButtons
          beq StayCredits
          bmi StayCredits

Bye:
          lda #ModeAttractCopyright
          sta GameMode
          jmp Attract.DoneKernel

StayCredits:

          .WaitScreenBottom
          jmp Loop

          .bend
