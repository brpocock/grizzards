;;; Grizzards Source/Routines/Credits.s
;;; Copyright © 2021 Bruce-Robert Pocock

Credits:  .block

          lda #>Phrase_Credits
          sta CurrentUtterance + 1
          lda #<Phrase_Credits
          sta CurrentUtterance
          sta AttractHasSpoken
          ldx # 15
          bne LoopFirst         ; always taken
Loop:
          ldx # 21
LoopFirst:
          stx WSYNC
          dex
          bne LoopFirst

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
          
          .SkipLines KernelLines - 159

          lda NewINPT4
          beq +
          bpl Bye
+

          lda NewSWCHB
          beq StayCredits
          .BitBit SWCHBReset
          beq StayCredits
          lda #ModeAttractCopyright
          sta GameMode
Bye:
          jmp Attract.DoneAttractKernel

StayCredits:

          jsr Overscan
          jsr VSync

          jmp Loop

          .bend
