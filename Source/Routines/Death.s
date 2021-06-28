;;; Grizzards Source/Routines/Death.s
;;; Copyright © 2021 Bruce-Robert Pocock

Death:    .block

          ;; Blow away the stack, we're starting over
          ldx #$ff
          txs

          lda #$ad
          pha
          lda #$de
          pha
          
          brk                   ; TODO

          .bend
