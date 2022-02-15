;;; Grizzards Source/Routines/LoadSaveSlot.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

LoadSaveSlot: .block
          .WaitScreenBottom
          stx WSYNC
          .if TV != NTSC
          stx WSYNC
          .fi
          .WaitScreenTop

ReallyLoadIt:
          jsr i2cStartWrite

          lda SaveGameSlot
          clc
          adc #>SaveGameSlotPrefix
          jsr i2cTxByte

          lda #<SaveGameSlotPrefix
          jsr i2cK

DiscardSignature:
          ldx # 0
-
          jsr i2cRxByte

          cmp SaveGameSignatureString, x
          bne LoadFailed

          inx
          cpx # 5
          blt -

          ldx # 0
ReadGlobalLoop:
          ;; Read the global game data straight into core
          jsr i2cRxByte

          sta GlobalGameData, x
          inx
          cpx # GlobalGameDataLength
          bne ReadGlobalLoop

          jsr i2cStopRead

          lda CurrentMap
          sta NextMap

          .WaitScreenBottom
          .WaitScreenTop

          jsr LoadProvinceData

          jsr LoadGrizzardData

          .FarJSR MapServicesBank, $ff

OKLoaded:
          .WaitScreenBottom
          jmp GoMap

LoadFailed:
          lda #SoundMiss
          sta NextSound
          jmp SelectSlot

          .bend

;;; Audited 2022-02-15 BRPocock
