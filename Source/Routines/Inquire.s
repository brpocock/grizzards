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

          .SkipLines ( KernelLines - 60 ) / 4

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
          lda SignpostInquiry
          beq StickDone
          lda # 0
          geq StickMoved

DoneStickUp:
          .BitBit P0StickDown
          bne DoneStickDown
          lda SignpostInquiry
          bne StickDone
          lda # 1
StickMoved:
          sta SignpostInquiry
          lda #SoundChirp
          sta NextSound
          gne StickDone

DoneStickDown:
          .BitBit P0StickLeft
          beq BackToSignpost

StickDone:
          lda NewButtons
          beq NoButton
          .BitBit PRESSED
          bne NoButton

          lda #SoundHappy
          sta NextSound

          ldx SignpostInquiry
          lda SignpostFG, x
          sta SignpostIndex

BackToSignpost:
          lda # 0
          sta NewButtons

          .WaitScreenBottom
          .WaitScreenTopMinus 2, 0
          .WaitScreenBottom
          .if NTSC != TV
            .SkipLines 2
          .fi
          ldx # SignpostBank
          jmp FarCall

NoButton:
          .WaitScreenBottom
          jmp Loop

          .bend
