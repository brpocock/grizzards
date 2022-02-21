;;; Grizzards Source/Routines/DetectGenesis.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

DetectGenesis:      .block
          ;; Look for a Genesis game pad by assuming that the C button is
          ;; not being held down by dumping the paddle ports and checking
          ;; their levels after a frame

          .WaitScreenTop
          .mva VBLANK, # VBlankGroundINPT0123
          .WaitScreenBottom
          .WaitScreenTop

          lda INPT0
          bpl NotGenesis

          lda INPT1
          bpl NotGenesis

          lda SWCHB
          ora #SWCHBP0Genesis
          gne DoneGenesis

NotGenesis:
          lda SWCHB
          and #~SWCHBP0Genesis
DoneGenesis:
          sta SWCHB

          .WaitScreenBottom

          ;; falls through to Attract.s
          .bend

;;; Audited 2022-02-16 BRPocock
