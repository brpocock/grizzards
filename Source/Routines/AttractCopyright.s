;;; Grizzards Source/Routines/AttractCopyright.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CopyrightMode:      .block
          lda AttractHasSpoken
          cmp #<Phrase_TitleCopyright
          beq DoneCopyrightSpeech

          lda #>Phrase_TitleCopyright
          sta CurrentUtterance + 1
          lda #<Phrase_TitleCopyright
          sta CurrentUtterance
          sta AttractHasSpoken
DoneCopyrightSpeech:
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

          lda # 60
          sta AlarmCountdown
          lda #ModeAttractStory
          sta GameMode
;;; 
StillCopyright:
          lda NewSWCHA
          beq Done
          and #P0StickUp
          bne Done
          lda #ModeCreditSecret
          sta GameMode

Done:
          jmp Attract.DoneKernel

          .bend
