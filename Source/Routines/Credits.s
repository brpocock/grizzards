;;; Grizzards Source/Routines/Credits.s
;;; Copyright © 2021 Bruce-Robert Pocock

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

          .SetPointer WithText
          jsr ShowPointerText
          .SetPointer LoveText
          jsr ShowPointerText
          .SetPointer ToText
          jsr ShowPointerText
          .SetPointer ZephyrText
          jsr ShowPointerText

          .SkipLines 40

          .SetPointer DatestampText
          jsr ShowPointerText
          
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

WithText:
          .MiniText " WITH "
LoveText:
          .MiniText " LOVE "
ToText:
          .MiniText "  TO  "
ZephyrText:
          .MiniText "ZEPHYR"

          DateString = format("%04d%02d%02d", YEARNOW, MONTHNOW, DATENOW)
          DateString6 = DateString[2:]
DatestampText:
          .MiniText DateString6
          .bend
