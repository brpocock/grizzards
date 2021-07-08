;;; Grizzards Source/Routines/Credits.s
;;; Copyright © 2021 Bruce-Robert Pocock

Credits:  .block

          lda AttractHasSpoken
          cmp #<Phrase_Credits
          beq Loop
          
          lda #>Phrase_Credits
          sta CurrentUtterance + 1
          lda #<Phrase_Credits
          sta CurrentUtterance
          sta AttractHasSpoken

Loop:

          ldx # 74
-
          stx WSYNC
          dex
          bne -

          .ldacolu COLINDIGO, $e
          sta COLUP0
          sta COLUP1

          .LoadString " WITH "
          jsr ShowText
          .LoadString " LOVE "
          jsr ShowText
          .LoadString "  TO  "
          jsr ShowText
          .LoadString "ZEPHYR"
          jsr ShowText

          ldx # KernelLines - 153
-
          stx WSYNC
          dex
          bne -

          lda INPT4
          cmp DebounceINPT4
          beq +
          sta DebounceINPT4
          bmi DoneAttractKernel
+

          lda SWCHB
          cmp DebounceSWCHB
          beq StayCredits
          sta DebounceSWCHB
          and #SWCHBReset
          beq StayCredits
          lda #ModeAttractCopyright
          sta GameMode
          jmp DoneAttractKernel

StayCredits:

          jsr Overscan
          jsr VSync
          jsr VBlank

          jmp Loop

          .bend
