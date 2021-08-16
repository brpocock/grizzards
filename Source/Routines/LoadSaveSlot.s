;;; Grizzards Source/Routines/LoadSaveSlot.s
;;; Copyright © 2021 Bruce-Robert Pocock
LoadSaveSlot: .block
          .WaitScreenBottom
          stx WSYNC
          .WaitScreenTop
          jsr CheckSaveSlot
          bcc ReallyLoadIt

          jmp SelectSlot

ReallyLoadIt:
          ;; OK, loading is much more straightforward than saving.
          ;; When saving, we have to write entire blocks at a time.
          ;; When loading, we can jump around and pick the values
          ;; that interest us directly.
          jsr i2cStartWrite
          lda SaveGameSlot
          clc
          adc #>SaveGameSlotPrefix
          jsr i2cTxByte
          lda #<SaveGameSlotPrefix
          jsr i2cTxByte
          jsr i2cStopWrite
          jsr i2cStartRead

DiscardSignature:
          jsr i2cRxByte
          cmp #SaveGameSignature[0]
          bne LoadFailed
          jsr i2cRxByte
          cmp #SaveGameSignature[1]
          bne LoadFailed
          jsr i2cRxByte
          cmp #SaveGameSignature[2]
          bne LoadFailed
          jsr i2cRxByte
          cmp #SaveGameSignature[3]
          bne LoadFailed
          jsr i2cRxByte
          cmp #SaveGameSignature[4]
          bne LoadFailed

          ldx # 0
ReadGlobalLoop:
          ;; Read the global game data straight into core
          jsr i2cRxByte
          sta GlobalGameData, x
          inx
          cpx # GlobalGameDataLength
          bne ReadGlobalLoop

          jsr i2cStopRead

          .WaitScreenBottom
          .WaitScreenTop

          jsr LoadProvinceData

          jsr LoadGrizzardData

          .WaitScreenBottom
          jmp GoMap

LoadFailed:
          lda #SoundMiss
          sta NextSound
          jmp SelectSlot
          
          .bend
