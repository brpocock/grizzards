;;; Grizzards. Source/Routines/CheckAndSetHighScore.s
;;; Copyright © 2022 Bruce-Robert Pocock

          .if !ATARIAGESAVE
            .error "Not supported"
          .fi
          
CheckHighScore:     .block
          ;; NOT specific to player's save game slot, it's always on the
          ;; end of Slot 0
          lda # 0
          jsr i2cStartWrite
          lda #$f7
          jsr i2cTxByte
          lda # 0
          jsr i2cStartRead
          ldx # 0
-
          jsr i2cRxByte
          sta NameEntryBuffer, x
          inx
          cpx # 6
          bne -
          jsr i2cRxByte
          sta Score + 2
          jsr i2cRxByte
          sta Score + 1
          jsr i2cRxByte
          sta Score + 0
          jsr i2cStopRead

          rts
          .bend
          
SetHighScore:       .block
          ;; NOT specific to player's save game slot, it's always on the
          ;; end of Slot 0
          lda Score + 2
          ;; Jatibu sets score to start with "F0"
          cmp #$99
          bge DoneHighScore

          lda # 0
          jsr i2cStartWrite
          lda #$fd
          jsr i2cTxByte
          lda # 0
          jsr i2cStartRead
          jsr i2cRxByte
          cmp #$ff
          beq SetHighScore

          cmp Score + 2
          bne Decide

          jsr i2cRxByte
          cmp Score + 1
          bne Decide

          jsr i2cRxByte
          cmp Score + 0
Decide:
          bge NotHighScore

          jsr i2cStopRead

SetHighScore:
          ;; NOTE, CheckSaveSlot must have  just been called to populate
          ;; player's  name   into  NameEntryBuffer,  this   happens  in
          ;; WinnerFireworks just before it calls us.
SaveHighScore:
          lda # 0
          jsr i2cStartWrite
          lda #$f7
          jsr i2cTxByte
          ldx # 0
-
          lda NameEntryBuffer, x
          jsr i2cTxByte
          inx
          cpx # 6
          bne -
          lda Score + 2
          jsr i2cTxByte
          lda Score + 1
          jsr i2cTxByte
          lda Score + 0
          jsr i2cTxByte
          jsr i2cStopWrite

DoneHighScore:
          rts

NotHighScore:
          jsr i2cStopRead
          rts


          .bend
