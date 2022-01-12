;;; Grizzards Source/Common/6BitCompression.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

UnpackLeft:         .macro buffer
          lda \buffer, y
          tax
          and #$fc
          lsr a
          lsr a
          sta StringBuffer + 0

          txa
          and #$03
          asl a
          asl a
          asl a
          asl a
          sta Temp
          iny
          lda \buffer, y
          tax
          and #$f0
          lsr a
          lsr a
          lsr a
          lsr a
          ora Temp
          sta StringBuffer + 1

          txa
          and #$0f
          asl a
          asl a
          sta Temp
          iny
          lda \buffer, y
          tax
          and #$c0
          .rept 6
          lsr a
          .next
          ora Temp
          sta StringBuffer + 2

          txa
          and #$3f
          sta StringBuffer + 3

          iny
          lda \buffer, y
          tax
          and #$fc
          lsr a
          lsr a
          sta StringBuffer + 4

          txa
          and #$03
          asl a
          asl a
          asl a
          asl a
          sta Temp
          iny
          lda \buffer, y
          and #$f0
          lsr a
          lsr a
          lsr a
          lsr a
          ora Temp
          sta StringBuffer + 5

          .endm

UnpackRight:        .macro buffer
          lda \buffer, y
          and #$0f
          asl a
          asl a
          sta Temp
          iny
          lda \buffer, y
          tax
          and #$c0
          .rept 6
          lsr a
          .next
          ora Temp
          sta StringBuffer + 0

          txa
          and #$3f
          sta StringBuffer + 1

          iny
          lda \buffer, y
          tax
          and #$fc
          lsr a
          lsr a
          sta StringBuffer + 2

          txa
          and #$03
          asl a
          asl a
          asl a
          asl a
          sta Temp
          iny
          lda \buffer, y
          tax
          and #$f0
          lsr a
          lsr a
          lsr a
          lsr a
          ora Temp
          sta StringBuffer + 3

          txa
          and #$0f
          asl a
          asl a
          sta Temp
          iny
          lda \buffer, y
          tax
          and #$c0
          .rept 6
          lsr a
          .next
          ora Temp
          sta StringBuffer + 4

          txa
          and #$3f
          sta StringBuffer + 5
          .endm
