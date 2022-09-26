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
          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartWrite
          bcs EEPROMFail

          .if !ATARIAGESAVE
            lda SaveGameSlot
            clc
            adc #>SaveGameSlotPrefix
            jsr i2cTxByte
          .fi

          lda #<SaveGameSlotPrefix
          jsr i2cTxByte
          jsr i2cStopWrite
          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartRead

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

          .mva NextMap, CurrentMap

          .WaitScreenBottom
          .WaitScreenTop

          jsr LoadProvinceData

          jsr LoadGrizzardData

          .FarJSR MapServicesBank, $ff

OKLoaded:
          .WaitScreenBottom
          jmp GoMap

LoadFailed:
          .mva NextSound, #SoundMiss
          jmp SelectSlot

          .bend

