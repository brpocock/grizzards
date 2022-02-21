;;; Grizzards Source/Routines/DecodeScore.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

DecodeScore:        .block
          lda Score             ; rightmost digit
          and #$0f
          sta StringBuffer + 5

          lda Score + 1
          and #$0f
          sta StringBuffer + 3

          lda Score + 2
          and #$0f
          sta StringBuffer + 1

          lda Score
          lsr a
          lsr a
          lsr a
          lsr a
          sta StringBuffer + 4

          lda Score + 1
          lsr a
          lsr a
          lsr a
          lsr a
          sta StringBuffer + 2

          lda Score + 2         ; leftmost digit
          lsr a
          lsr a
          lsr a
          lsr a
          sta StringBuffer + 0

          rts
          .bend

;;; Audited 2022-02-15 BRPocock
