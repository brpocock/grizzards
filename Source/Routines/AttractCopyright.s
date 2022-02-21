;;; Grizzards Source/Routines/AttractCopyright.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CopyrightMode:      .block
          .SkipLines 24

          .ldacolu COLTURQUOISE, $e
          sta COLUP0
          sta COLUP1

          .SetPointer CopyrightText
          jsr ShowPointerText12

          .SetPointer CopyrightYearText
          jsr ShowPointerText12

          .SetPointer BruceRobertText
          jsr ShowPointerText12

          .SetPointer PocockText
          jsr ShowPointerText12

          lda AlarmCountdown
          bne StillCopyright

          .mva AlarmCountdown, # 60
          .mva GameMode, #ModeAttractStory
;;; 
StillCopyright:
          lda NewSWCHA
          beq Done
          and #P0StickUp
          bne Done
          .mva GameMode, #ModeCreditSecret

Done:
          jmp Attract.DoneKernel

          .bend

;;; Audited 2022-2-15 BRPocock
