;;; Grizzards Source/Routines/LoadSaveSlot.s
;;; Copyright © 2021 Bruce-Robert Pocock
LoadSaveSlot: .block
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

ReadProvinceData:
          ;; Province data are 8 bytes blocks starting at $20
          ;; in the master block.
          jsr i2cStartWrite

          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot
          jsr i2cTxByte
          lda CurrentProvince
          asl a
          asl a
          asl a                 ; × 8
          adc # $20
          jsr i2cTxByte

          jsr i2cStopWrite
          jsr i2cStartRead

          ldx # 0
-
          jsr i2cRxByte
          sta ProvinceFlags, x
          inx
          cpx # 8
          bne -

          jsr i2cStopRead

ReadGrizzardData:
          ;; Grizzard data is weirder storage layout.
          ;; We save 12 grizzards at 5 bytes each in each of
          ;; the 3 blocks following the master block. That
          ;; leaves 6 in the final block and half of it is blank.

          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot
          sta Pointer + 1

          ;; First, figure out which block the current Grizzard
          ;; can be found in.
          lda CurrentGrizzard
          cmp # 12
          bmi InBlock1
          cmp # 24
          bmi InBlock2
          sec
          sbc # 24
          tax
          lda # 3
          jmp ReadyToReadGrizzard

InBlock1:
          tax
          lda # 1
          jmp ReadyToReadGrizzard

InBlock2:
          sec
          sbc # 12
          tax
          lda # 2
          ;; fall through

ReadyToReadGrizzard:
          asl a
          asl a
          asl a
          asl a
          asl a
          asl a                 ; × $40 (64)
          sta Pointer           ; start of the block we want
          txa                   ; index within the block
          sta Temp
          asl a
          asl a                 ; × 4
          clc
          adc Temp              ; × 5

          adc Pointer
          sta Pointer

          ;; Finally we know our offset, let's read it.
          jsr i2cStartWrite
          lda Pointer + 1
          jsr i2cTxByte
          lda Pointer
          jsr i2cTxByte
          jsr i2cStopWrite
          jsr i2cStartRead

          jsr i2cRxByte
          cmp #$ff              ; WtF?
          beq LoadFailed
          sta GrizzardAttack
          jsr i2cRxByte
          sta GrizzardDefense
          jsr i2cRxByte
          sta GrizzardAcuity
          jsr i2cRxByte
          sta MovesKnown
          jsr i2cRxByte
          sta MaxHP
          sta CurrentHP

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

LoadFailed:
          lda #SoundMiss
          sta NextSound
          jmp SelectSlot
          
          .bend
