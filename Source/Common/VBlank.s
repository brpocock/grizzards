;;; Grizzards Source/Common/VBlank.s
;;; Copyright © 2021 Bruce-Robert Pocock

          .weak
          DoVBlankWork = 0
          .endweak

VBlank: .block
          lda # ( 76 * VBlankLines ) / 64 - 1
          sta TIM64T
          sta WSYNC

          .if DoVBlankWork != 0
          jsr DoVBlankWork
          .fi

          lda # 0
          sta NewSWCHA
          sta NewSWCHB
          sta NewINPT4

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
          lda INPT4
          and #$80
          cmp DebounceINPT4
          beq +
          sta DebounceINPT4
          ora #$01              ; guarantee at least one "1" bit
          sta NewINPT4
+

FillVBlank:
          lda TIMINT
          bpl FillVBlank

          stx WSYNC
          ldx # 0
          stx VBLANK
          rts
          .bend
