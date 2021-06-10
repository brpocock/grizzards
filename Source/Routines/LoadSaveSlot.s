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

          ;; TODO load province data for CurrentProvince

          ;; Make sure debounced switch doesn't return us to the title screen immediately
          lda SWCHB
          sta DebounceSWCHB

          ;; Return to place last blessed
          lda #ModeMap
          sta GameMode
          lda BlessedBank
          sta CurrentMapBank
          lda BlessedMap
          sta CurrentMap
          lda BlessedX
          sta PlayerX
          lda BlessedY
          sta PlayerY
          lda BlessedChatBank
          sta CurrentChatBank
          lda BlessedCombatBank
          sta CurrentCombatBank

          rts

          .bend
