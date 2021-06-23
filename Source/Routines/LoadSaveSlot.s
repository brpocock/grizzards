LoadSaveSlot: .block
          jsr CheckSaveSlot
          bcc ReallyLoadIt

          jmp SelectSlot

ReallyLoadIt:
          jsr i2cStartWrite
          lda SaveGameSlot
          clc
          adc #>SaveGameSlotPrefix
          jsr i2cTxByte
          lda #<SaveGameSlotPrefix
          jsr i2cTxByte
          jsr i2cStopWrite
          jsr i2cStartRead

          ldx #5
DiscardSignature:
          jsr i2cRxByte
          dex
          bne DiscardSignature

          ldx # 0
ReadGlobalLoop:
          jsr i2cRxByte
          sta GlobalGameData, x
          inx
          cpx # EndGlobalGameData - GlobalGameData + 1
          bne ReadGlobalLoop

          jsr i2cStopRead

ReadProvinceData:
          jsr i2cStartWrite

          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot
          jsr i2cTxByte
          lda CurrentProvince
          asl a
          asl a
          adc # EndGlobalGameData - GlobalGameData + 1
          jsr i2cTxByte
          
          jsr i2cStopWrite
          jsr i2cStartRead

          jsr i2cRxByte
          lda ProvinceFlags + 0
          jsr i2cRxByte
          lda ProvinceFlags + 1
          jsr i2cRxByte
          lda ProvinceFlags + 2
          jsr i2cRxByte
          lda ProvinceFlags + 3

          jsr i2cStopRead

ReadGrizzardData:
          jsr i2cStartWrite

          jsr SetGrizzardAddress

          jsr i2cStartRead

          jsr i2cRxByte
          sta GrizzardAttack
          jsr i2cRxByte
          sta GrizzardDefense
          jsr i2cRxByte
          sta GrizzardAcuity
          jsr i2cRxByte
          sta MovesKnown
          jsr i2cRxByte
          sta MaxHP

          jsr i2cStopRead
          
          ;; Make sure debounced switch doesn't return us to the title screen immediately
          lda SWCHB
          sta DebounceSWCHB

          ;; Return to place last blessed
          lda #ModeMap
          sta GameMode
          lda BlessedX
          sta PlayerX
          lda BlessedY
          sta PlayerY

          jmp GoMap

          .bend
