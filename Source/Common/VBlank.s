;;; Grizzards Source/Common/VBlank.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .weak
          DoVBlankWork = 0
          .endweak

VBlank: .block
          stx WSYNC
          .TimeLines VBlankLines

          lda # 0
          sta NewSWCHA
          sta NewSWCHB
          sta NewButtons

          lda SWCHA
          and #$f0
          cmp DebounceSWCHA
          beq +
          sta DebounceSWCHA
          sta NewSWCHA          ; at least two directions will be "1" bits
+
          lda SWCHB
          cmp DebounceSWCHB
          beq +
          sta DebounceSWCHB
          ora #$40              ; guarantee at least one "1" bit
          sta NewSWCHB
+

          lda SWCHB
          .BitBit SWCHBP0Genesis
          beq NotGenesis
          lda INPT1
          and #PRESSED
          lsr a
          sta NewButtons
          jmp FireButton
NotGenesis:
          lda #$40
          sta NewButtons
FireButton:
          lda INPT4
          and #PRESSED
          ora NewButtons

          cmp DebounceButtons
          bne ButtonsChanged
          lda # 0
          sta NewButtons
          geq DoneButtons

ButtonsChanged:
          sta DebounceButtons
          ora #$01              ; guarantee non-zero if it changed
          sta NewButtons

          and #$40              ; C button pressed?
          bne DoneButtons
          lda NewSWCHB
          ora #~SWCHBSelect     ; zero = Select button pressed
          sta NewSWCHB
          sta DebounceSWCHB
DoneButtons:

          .if DoVBlankWork != 0
          jsr DoVBlankWork
          .fi

          .WaitForTimer

          ldx # 0
          stx VBLANK
          rts
          .bend
