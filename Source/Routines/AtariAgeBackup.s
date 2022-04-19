;;; Grizzards Source/Routines/AtariAgeBackup.s
;;; Copyright © 2022 Bruce-Robert Pocock

AtariAgeBackup:     .block

          .WaitScreenBottom
          .WaitScreenTop

          jsr SKi2cStartWrite

          lda #>SKSaveGameSlotPrefix
          clc
          adc SaveGameSlot 
          jsr SKi2cTxByte

          lda #<SKSaveGameSlotPrefix
          jsr SKi2cTxByte

          jsr i2cStartWrite

          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot 
          jsr i2cTxByte

          lda #<SaveGameSlotPrefix
          jsr i2cK

CopyPages:
          ldx # 0
-
          jsr i2cRxByte
          jsr SKi2cTxByte

          dex
          bne -

          jsr i2cStopRead
          jsr SKi2cStopWrite

          rts

          .bend

AtariAgeRestore:    .block

          .WaitScreenBottom
          .WaitScreenTop

          jsr SKi2cStartWrite

          lda #>SKSaveGameSlotPrefix
          clc
          adc SaveGameSlot 
          jsr SKi2cTxByte

          lda #<SKSaveGameSlotPrefix
          jsr SKi2cK

          jsr i2cStartWrite

          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot 
          jsr i2cTxByte

          lda #<SaveGameSlotPrefix
          jsr i2cTxByte

CopyPages:
          ldx # 0
-
          jsr SKi2cRxByte
          jsr i2cTxByte

          dex
          bne -

          jsr i2cStopWrite
          jsr SKi2cStopRead

          rts

          .bend

          .fill BankEndAddress - 6 - *, "AtariAge.com "

          jmp AtariAgeBackup
          jmp AtariAgeRestore
