;;; Grizzards Source/Routines/Inquire.s
;;; Copyright © 2022, Bruce-Robert Pocock

Inquire:  .block

          jsr Prepare48pxMobBlob
          .WaitScreenBottom

Loop:
          .WaitScreenTop
          .ldacolu COLGRAY, 0
          sta COLUBK

          .ldacolu COLBLUE, $8
          sta COLUP0
          sta COLUP1

          .SkipLines ( KernelLines - 60 ) / 3 

          .ldacolu COLGRAY, 0
          ldx SignpostInquiry
          bne +
          .ldacolu COLYELLOW, $e
+
          sta COLUBK

          ldy # 0
          .UnpackLeft SignpostLineCompressed
          .FarJSR TextBank, ServiceDecodeAndShowText
          .SkipLines 4

          .ldacolu COLGRAY, 0
          sta COLUBK

          .SkipLines ( KernelLines - 60 ) / 3

          .ldacolu COLGRAY, 0
          ldx SignpostInquiry
          beq +
          .ldacolu COLYELLOW, $e
+
          sta COLUBK

          ldy # 4
          .UnpackRight SignpostLineCompressed
          .FarJSR TextBank, ServiceDecodeAndShowText
          .SkipLines 4

          .ldacolu COLGRAY, 0
          sta COLUBK

          lda NewSWCHA
          beq StickDone

          .BitBit P0StickUp
          bne DoneStickUp
          lda # 0
          sta SignpostInquiry
          geq StickDone

DoneStickUp:
          .BitBit P0StickDown
          bne DoneStickDown
          lda # 1
          sta SignpostInquiry
          gne StickDone

DoneStickDown:
          .BitBit P0StickLeft
          beq BackToSignpost

StickDone:
          lda NewButtons
          beq NoButton
          .BitBit PRESSED
          bne NoButton

          ldx SignpostInquiry
          lda SignpostFG, x
          sta SignpostIndex

BackToSignpost:
          lda # 0
          sta NewButtons

          ;; trash our own return vector
          ldx #$f7
          txs

          .WaitScreenBottom

          ldx # SignpostBank
          jmp FarCall

NoButton:

          .WaitScreenBottom
          jmp Loop

          .bend