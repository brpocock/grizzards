;;; Grizzards Source/Routines/CheckSaveSlot.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

CheckSaveSlot: .block
          ;; Check SaveGameSlot for a save game
          ;; Returns values of Potions (crown bit $80),
          ;; player name in NameEntryBuffer,
          ;; and sets SaveSlotBusy and SaveSlotErased to
          ;; either $00 for false or non-zero for true
          jsr SeedRandom

          .StartI2C

          lda #<SaveGameSlotPrefix
          jsr i2cTxByte
          .if !ATARIAGESAVE
            jsr i2cStopWrite
          .fi
          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartRead

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

          gne ReadSlotName

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

          ldx # 0
          stx SaveSlotBusy
          inx                   ; X ← 1
          stx SaveSlotErased
          ;; fall through
ReadSlotName:
          jsr i2cWaitForAck

          .StartI2C

          lda #<SaveGameSlotPrefix + $1a ; Name offset
          jsr i2cTxByte
          .if !ATARIAGESAVE
            jsr i2cStopWrite
          .fi
          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartRead

          ldx # 0
LoadNameLoop:
          jsr i2cRxByte

          sta NameEntryBuffer, x
          inx
          cpx # 6
          bne LoadNameLoop

          lda #$80

          jsr i2cStopRead

ReadCrownBit:
          jsr i2cWaitForAck

          .StartI2C

          lda #<SaveGameSlotPrefix + 5 + Potions - GlobalGameData
          jsr i2cTxByte

          .if !ATARIAGESAVE
            jsr i2cStopWrite
          .fi
          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartRead

          jsr i2cRxByte

          sta Potions

          jsr i2cStopRead

          rts

	.bend
