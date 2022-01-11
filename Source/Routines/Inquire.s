;;; Grizzards Source/Routines/Inquire.s
;;; Copyright © 2022, Bruce-Robert Pocock

Inquire:  .block

          ldy # 0
          lda (SignpostText), y

          ;; FIXME

          rts

          .bend
