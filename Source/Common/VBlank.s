;;; Grizzards Source/Common/VBlank.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .weak
          DoVBlankWork = 0
          .endweak

VBlank: .block
          stx WSYNC
          .TimeLines VBlankLines ; actually should have been VBlankWorkLines

          ldy # 0
          sty NewSWCHA
          sty NewSWCHB
          sty NewButtons

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

          lda SystemFlags
          and #SystemFlagP0Gamepad
          beq NotGenesis

          tya                 ; Y = 0
          .if 11 != BANK        ; ran out of space in Bank 11 ($b)
            bit INPT0
            bmi DoneButtonIII

            lda #ButtonIII
DoneButtonIII:
          .fi
          bit INPT1
          bmi DoneButtonII

          ora #ButtonII
DoneButtonII:
NotGenesis:
          bit INPT4
          bmi DoneButtonI

          ora #ButtonI
DoneButtonI:
          sta NewButtons

          cmp DebounceButtons   ; buttons down bits are ones here too
          bne ButtonsChanged

ButtonsSame:
          sty NewButtons        ; Y = 0
          jmp DoneButtons

ButtonsChanged:
          sta DebounceButtons
          eor #ButtonI | ButtonII | ButtonIII | 1
          sta NewButtons      ; buttons down are 0 bits, $01 to flag change
          and #ButtonII       ; C / II button pressed?
          bne DoneButtonIISelect

          lda NewSWCHB
          lda #~SWCHBSelect | $40     ; zero = Select button pressed, $40 = changed
          sta NewSWCHB
DoneButtonIISelect:
          .if 11 != BANK
            lda NewButtons
            and #ButtonIII
            bne DoneButtons

            lda SystemFlags
            eor #SystemFlagPaused
            sta SystemFlags
          .fi
DoneButtons:

          .if DoVBlankWork != 0
            jsr DoVBlankWork
            ldy # 0
          .fi

          .WaitForTimer

          sty VBLANK            ; Y = 0
          rts
          .bend
