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

          .StartI2C

          lda CurrentGrizzard
          pha                   ; CurrentGrizzard

          WipeGrizzard = CurrentGrizzard

          .mva WipeGrizzard, #$40
Wipe16Bytes:
          ldx #$10
          lda WipeGrizzard
          jsr WipeSome

          jsr ChangeAddress

          lda WipeGrizzard
          clc
          adc #$10
          cmp #$e0
          sta WipeGrizzard
          blt Wipe16Bytes

          lda #$e0
          ldx # 4
          jsr WipeSome

          pla                   ; CurrentGrizzard
          sta CurrentGrizzard

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
          .if ATARIAGESAVE
            lda SaveGameSlot
            jmp i2cStartWrite
          .else
            jmp SetSlotAddress
          .fi
          .bend
