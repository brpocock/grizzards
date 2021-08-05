;;; Grizzards Source/Routines/DetectGenesis.s
;;; Copyright © 2021 Bruce-Robert Pocock

DetectGenesis:      .block
          ;; Look for a Genesis game pad by assuming that the C button is
          ;; not being held down by dumping the paddle ports and checking
          ;; their levels after a frame

          .WaitScreenTop
          lda # VBlankGroundINPT0123
          sta VBLANK
          .WaitScreenBottom
          .WaitScreenTop

          ldy #0
          lda INPT0
          bpl +
          lda INPT1
          bpl +

          lda SWCHB
          ora #SWCHBP0Genesis
          sta SWCHB
          jmp GotGenesis
+
          lda SWCHB
          and #~SWCHBP0Genesis
          sta SWCHB
GotGenesis:

          .WaitScreenBottom

          ;; falls through to Attract.s
          .bend
