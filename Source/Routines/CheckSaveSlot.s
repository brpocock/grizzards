;;; Grizzards Source/Routines/CheckSaveSlot.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
EEPROMFail:
          jsr i2cStopWrite
          lda #ModeNoAtariVox
          sta GameMode
          brk

CheckSaveSlot: .block
          jsr SeedRandom

	jsr i2cStartWrite
	bcs EEPROMFail

          lda SaveGameSlot
          clc
          adc #>SaveGameSlotPrefix
          jsr i2cTxByte
          lda #<SaveGameSlotPrefix
          jsr i2cK

          ldx # 0
          jsr i2cRxByte
          beq MaybeDeleted
ReadLoop:
          cmp SaveGameSignatureString, x
          bne SlotEmpty
          inx
          jsr i2cRxByte
          cpx # 5
          bne ReadLoop

          jsr i2cStopRead

          ldy # 1               ; slot busy
          sty SaveSlotBusy

          jmp ReadSlotName

SlotEmpty:
          jsr i2cStopRead
          ldy # 0               ; slot empty
          sty SaveSlotBusy
          sty SaveSlotErased
          rts

MaybeDeleted:
          inx
ReadLoop0:
          jsr i2cRxByte
          cmp SaveGameSignatureString, x
          bne SlotEmpty
          inx
          cpx # 5
          bne ReadLoop0

          jsr i2cStopRead

          lda # 0
          sta SaveSlotBusy
          lda # 1
          sta SaveSlotErased

          ;; fall through

ReadSlotName:
          jsr i2cWaitForAck

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
          beq MaybeDeleted
          inx
          cpx # 6
          bne LoadNameLoop
          lda #$80

          jsr i2cStopRead

          rts

	.bend
