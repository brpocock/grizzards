;;; Grizzards Source/Routines/NewGame2.s
;;; Copyright © 2022 Bruce-Robert Pocock

NewGame2: .block
          ;; This is part of StartNewGame, but we ran out of ROM in bank
          ;; 1, so it  got shifted back to bank 0,  because it still has
          ;; to bang  on the SaveKey/EEPROM  so there's really  no place
          ;; else to  stick it. It's  not logically separate,  it's just
          ;; from running out of space at the Very Last Minute.
WipeProvinceFlags:
          .WaitScreenTop

          .mva CurrentProvince, # 2
          jsr SaveProvinceData
          jsr i2cWaitForAck
          .mva CurrentProvince, # 1
          jsr SaveProvinceData
          jsr i2cWaitForAck
          .mva CurrentProvince, # 0
          ;; Will be handled this time by SaveToSlot later
          .WaitScreenBottom

WipeGrizzards:
          .WaitScreenTop

          lda CurrentGrizzard
          pha                   ; CurrentGrizzard

          WipeGrizzard = CurrentGrizzard

          .mva WipeGrizzard, #$40
Wipe16Bytes:
          ldx #$10
          jsr WipeSome

          lda WipeGrizzard
          clc
          adc #$10
          cmp #$e0
          sta WipeGrizzard
          blt Wipe16Bytes

          ldx # 4
          jsr WipeSome

          pla                   ; CurrentGrizzard
          sta CurrentGrizzard

DoneWipingGrizzards:
          jmp SaveToSlot        ; tail call
;;; 
WipeSome:
          .StartI2C
          lda WipeGrizzard
          jsr i2cTxByte
Wiping:
          lda # 0
          jsr i2cTxByte
          dex
          bne Wiping
          jsr i2cStopWrite
          jmp i2cWaitForAck     ; tail call

          .bend
