;;; Grizzards Source/Routines/SetCurrentGrizzard.s
;;; Copyright © 2022 Bruce-Robert Pocock

SetCurrentGrizzard:       .block
          jsr i2cWaitForAck

          jsr i2cStartWrite

          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot
          jsr i2cTxByte

          lda # 5 + CurrentGrizzard - GlobalGameData
          jsr i2cTxByte

          lda CurrentGrizzard
          jsr i2cTxByte

          jmp i2cStopWrite      ; tail call

          .bend

;;; Audited 2022-02-16 BRPocock
