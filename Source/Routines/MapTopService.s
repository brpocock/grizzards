TopOfScreenService: .block
          
          jsr VSync
          jsr VBlank

          jsr Prepare48pxMobBlob
          
          .ldacolu COLGRAY, $f
          sta COLUP0
          sta COLUP1
          .ldacolu COLGRAY, 0
          sta COLUBK

          lda Pause
          beq DecodeScore
          .LoadString "PAUSED"
          jmp ScoreDone
          
DecodeScore:

          lda Score             ; rightmost digit
          and #$0f
          sta Temp
          rol a
          rol a
          clc
          adc Temp
          sta StringBuffer + 5

          lda Score
          and #$f0
          ror a
          ror a
          sta Temp
          ror a
          ror a
          clc
          adc Temp
          sta StringBuffer + 4

          lda Score + 1
          and #$0f
          sta Temp
          rol a
          rol a
          clc
          adc Temp
          sta StringBuffer + 3

          lda Score + 1
          and #$f0
          ror a
          ror a
          sta Temp
          ror a
          ror a
          clc
          adc Temp
          sta StringBuffer + 2

          lda Score + 2
          and #$0f
          sta Temp
          rol a
          rol a
          clc
          adc Temp
          sta StringBuffer + 1

          lda Score + 2         ; leftmost digit
          and #$f0
          ror a
          ror a
          sta Temp
          ror a
          ror a
          clc
          adc Temp
          sta StringBuffer + 0

ScoreDone:          
          ldy #ServiceDecodeAndShowText
          ldx #TextBank
          jsr FarCall

          lda #CTRLPFREF | CTRLPFBALLSZ4 | CTRLPFPFP
          sta CTRLPF

          lda #0
          sta VDELP0
          sta VDELP1
          sta NUSIZ0
          sta NUSIZ1

          ldx CurrentMap

          .if TV == SECAM
          .ldacolu COLGOLD, $8
          .else
          .ldacolu COLGOLD, $8
          ora BumpCooldown
          .fi
          
          sta COLUP0

          sta HMCLR

          sta WSYNC

          lda PlayerX
          sec
          sta WSYNC
P0HPos:
          sbc #15
          bcs P0HPos
          sta RESP0

          eor #$07
          asl a
          asl a
          asl a
          asl a
          sta HMP0

          lda Facing
          sta REFP0

          ;; sta WSYNC

          ldx SpriteCount
          beq TheEnd

          ldx SpriteFlicker
          inx
          cpx SpriteCount
          bmi FlickerOK
          ldx #0
FlickerOK:
          stx SpriteFlicker

          lda SpriteX, x
          sec
          sta WSYNC
P1HPos:
          sbc #15
          bcs P1HPos
          sta RESP1

          eor #$07
          asl a
          asl a
          asl a
          asl a
          sta HMP1

TheEnd:   
          rts

          .bend
