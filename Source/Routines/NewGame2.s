;;; Grizzards Source/Routines/NewGame2.s
;;; Copyright © 2022 Bruce-Robert Pocock

NewGame2: .block
          ;; This is part of StartNewGame, but we ran out of ROM in bank
          ;; 1, so it  got shifted back to bank 0,  because it still has
          ;; to bang  on the SaveKey/EEPROM  so there's really  no place
          ;; else to  stick it. It's  not logically separate,  it's just
          ;; from running out of space at the Very Last Minute.
WipeGrizzards:
          .WaitScreenTop

          jsr StartAddress

          lda #$40
          ldx # 12 * 5
          jsr WipeSome

          jsr ChangeAddress

          lda #$80
          ldx # 12 * 5
          jsr WipeSome

          jsr ChangeAddress

          lda #$c0
          ldx # 7 * 5
          jsr WipeSome

          jsr i2cStopWrite
          jsr i2cWaitForAck

DoneWipingGrizzards:
          jmp SaveToSlot        ; tail call
;;; 
WipeSome:
          jsr i2cTxByte
Wiping:
          lda # 0
          jsr i2cTxByte
          dex
          bne Wiping
          rts
;;; 
ChangeAddress:
          jsr i2cStopWrite
          jsr i2cWaitForAck
          ;; f all through
StartAddress:
          .if ATARIAGESAVE
            lda SaveGameSlot
            jmp i2cStartWrite   ; tail call
          .else
            jsr i2cStartWrite
            lda #>SaveGameSlotPrefix
            clc
            adc SaveGameSlot
            jmp i2cTxByte       ; tail call
          .fi

          .bend
