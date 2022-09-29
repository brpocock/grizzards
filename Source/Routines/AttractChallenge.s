;;; Grizzards Source/Routines/AttractChallenge.s
;;; Copyright © 2022 Bruce-Robert Pocock

AttractChallenge: .block
          .mva EnemyHP, # 1
          .mva AlarmCountdown, # 18
          .mva CombatMajorP, #$80
          .WaitScreenBottom

Loop:
          .WaitScreenTop

          inc ClockFrame
          ldy # 0
          sty COLUPF
          dey                   ; Y = $ff
          sty PF0

          .ldacolu COLGRAY, $c
          stx WSYNC
          sta COLUBK

          .ldacolu COLGRAY, $2
          sta COLUP0
          sta COLUP1

          .SetPointer Challenge1
          jsr ShowPointerText12

          .SetPointer Challenge2
          jsr ShowPointerText12

          .SetPointer Challenge3
          jsr ShowPointerText12

          .SetPointer Challenge4
          jsr ShowPointerText12

          .ldacolu COLBLUE, $8
          sta COLUP0
          sta COLUP1

          .SetPointer Challenge5
          jsr ShowPointerText12

          lda AlarmCountdown
          beq NextPhase

          lda NewSWCHB
          beq CheckFire

          and #SWCHBSelect
          bne LoopMe

CheckFire:
          lda NewButtons
          beq LoopMe

          and #ButtonI
          bne LoopMe

          .mva GameMode, #ModeSelectSlot
          rts
          
LoopMe:
          .WaitScreenBottom
          jmp Loop

NextPhase:
          .if ATARIAGESAVE
            .mva AlarmCountdown, # 30
            .mva GameMode, #ModeAttractHighScore
          .else
            .mva AlarmCountdown, # 8
            .mva GameMode, #ModePublisherPresents
          .fi

          rts

Challenge1:
          .SignText "THE WORLD OF"
Challenge2:
          .SignText "SYREX HAS   "
Challenge3:
          .SignText "BEEN INVADED"
Challenge4:
          .SignText "BY MONSTERS."
Challenge5:
          .SignText "  SAVE IT!  "

ShowPointerText12:
          jsr CopyPointerText12
          jmp Write12Chars
          
          .bend
