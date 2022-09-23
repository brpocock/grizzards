;;; Grizzards Source/Routines/CheckSaveSlot.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock


CheckSaveSlot: .block
          ;; Check SaveGameSlot for a save game
          ;; Returns values of Potions (crown bit $80),
          ;; player name in NameEntryBuffer,
          ;; and sets SaveSlotBusy and SaveSlotErased to
          ;; either $00 for false or non-zero for true
          jsr SeedRandom

          .mva SaveSlotBusy, #$ff
          .mva SaveSlotErased, # 0

          jsr i2cStartWrite

          lda SaveGameSlot
          clc
          adc #>SaveGameSlotPrefix
          jsr i2cTxByte

          lda #<SaveGameSlotPrefix + $1a ; Name offset
          jsr i2cK

          ldx # 0
LoadNameLoop:
          jsr i2cRxByte

          sta NameEntryBuffer, x
          inx
          cpx # 6
          bne LoadNameLoop

          lda #$80

          jmp i2cStopRead

	.bend
