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

          .SkipLines 20

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

          .SkipLines 40

          DateString = format("%04d%02d%02d", YEARNOW, MONTHNOW, DATENOW)
          DateString6 = DateString[2:]

          .LoadString DateString6
          jsr ShowText
          
          .SkipLines KernelLines - 158

          lda NewINPT4
          beq +
          bpl DoneAttractKernel
+

          lda NewSWCHB
          beq StayCredits
          .BitBit SWCHBReset
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
