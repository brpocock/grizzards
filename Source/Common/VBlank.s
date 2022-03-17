;;; Grizzards Source/Common/VBlank.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .weak
          DoVBlankWork = 0
          .endweak

VBlank: .block
          stx WSYNC
          .TimeLines VBlankLines

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
          ;; lda SWCHB
          ;; .BitBit SWCHBP0Genesis
          ;; beq NotGenesis

          InvertButtons = $e0   ; $e0 for all three

          lda DebounceButtons
          sta Score + 2

          .if BANK != 11
            lda INPT0             ; Button III
            and #PRESSED
            lsr a
            lsr a
            sta Temp
          .fi
          lda INPT1             ; Button II / C
          and #PRESSED
          lsr a
          .if BANK != 11
            ora Temp
          .fi
          sta Temp
          jmp FireButton

NotGenesis:
          .mva Temp, #InvertButtons - $80

FireButton:
          lda INPT4             ; FIRE / I / B
          sta Score
          and #PRESSED          ; $80
          ora Temp
          eor #InvertButtons    ; button down bits are ones now
          sta Temp

          sta Score + 1

          cmp DebounceButtons   ; buttons down bits are ones here too
          bne ButtonsChanged

ButtonsSame:
          sty NewButtons        ; Y = 0 XXX redundant
          geq DoneButtons

ButtonsChanged:
          sta DebounceButtons
          eor #InvertButtons | 1
          sta NewButtons        ; buttons down are 0 bits, $01 to flag change
          and #$40              ; C / II button pressed?
          bne DoneButtonII

          lda NewSWCHB
          ora #~SWCHBSelect     ; zero = Select button pressed
          sta NewSWCHB
          sta DebounceSWCHB
DoneButtonII:
          lda NewButtons
          and #$20
          bne DoneButtons

          lda Pause
          eor #$80
          sta Pause
DoneButtons:

          .if DoVBlankWork != 0
          jsr DoVBlankWork
          ldy # 0
          .fi

          .WaitForTimer

          sty VBLANK            ; Y = 0
          rts
          .bend
