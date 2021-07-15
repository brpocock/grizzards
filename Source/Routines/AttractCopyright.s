;;; Grizzards Source/Routines/AttractCopyright.s
;;; Copyright © 2021 Bruce-Robert Pocock

CopyrightMode:

          lda AttractHasSpoken
          cmp #<Phrase_TitleCopyright
          beq DoneCopyrightSpeech

          lda #>Phrase_TitleCopyright
          sta CurrentUtterance + 1
          lda #<Phrase_TitleCopyright
          sta CurrentUtterance
          sta AttractHasSpoken

DoneCopyrightSpeech:

          ldx # 29
SkipAboveCopyright:
          stx WSYNC
          dex
          bne SkipAboveCopyright

          .ldacolu COLTURQUOISE, $e
          sta COLUP0
          sta COLUP1

          .SetPointer CopyText
          jsr DecodeAndShowText
          .SetPointer RightText
          jsr DecodeAndShowText
          .SetPointer Text2021
          jsr DecodeAndShowText
          .SetPointer BruceText
          jsr DecodeAndShowText
          .SetPointer RobertText
          jsr DecodeAndShowText
          .SetPointer Pococktext
          jsr DecodeAndShowText

          ldx # KernelLines - 153
SkipBelowCopyright:
          stx WSYNC
          dex
          bne SkipBelowCopyright

          lda ClockSeconds
          cmp AlarmSeconds
          bmi StillCopyright

          lda ClockMinutes
          cmp AlarmMinutes
          bmi StillCopyright

          lda # 30
          jsr SetNextAlarm
          lda #ModeAttractStory
          sta GameMode

StillCopyright:

          lda NewSWCHA
          beq Done
          and #P0StickUp
          bne Done
          lda #ModeCreditSecret
          sta GameMode

Done:
          jmp DoneAttractKernel         

CopyText:
          .MiniText "COPY  "
RightText:
          .MiniText "RIGHT"
Text2021:
          .MiniText "  2021"
BruceText:
          .MiniText "BRUCE-"
RobertText:
          .MiniText "ROBERT"
PocockText:
          .MiniText "POCOCK"

