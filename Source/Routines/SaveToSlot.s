;;; Grizzards Source/Routines/SaveToSlot.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

SaveToSlot:	.block
          .WaitScreenBottom
          .WaitScreenTop

WriteMasterBlock:
          ;; OK, now we're going to actually write the Master block,
          ;; this is a 5 byte signature, then the Global vars space
          ;; (which must end before $20) and then the 32 bytes of
          ;; Province flags (8 bytes × 4 provinces)

          ;; First set the write pointer up for the first block of this
          ;; save game slot ($1700, $1800, or $1900)
	jsr i2cStartWrite

	lda #>SaveGameSlotPrefix
	clc
	adc SaveGameSlot
	jsr i2cTxByte

          .if (SaveGameSlotPrefix & $ff) != 0
            .error "Save routines assume that SaveGameSlotPrefix is aligned to $100"
          .fi

	lda # 0
	jsr i2cTxByte

          ;; The signature is how we can tell that the slot is
          ;; occupied. Really any 2 bytes that are not $00 or $ff
          ;; would suffice, but this works too and we can
          ;; actually spare the space.
	ldx # 0
WriteSignatureLoop:
	lda SaveGameSignatureString, x
	jsr i2cTxByte

	inx
	cpx # 5
	bne WriteSignatureLoop

          ;; The GlobalGameData block has all the persistent vars
          ;; that are not ProvinceFlags or Grizzard stats.
	ldx # 0
WriteGlobalLoop:
	lda GlobalGameData, x
	jsr i2cTxByte
	inx
	cpx # GlobalGameDataLength
	bne WriteGlobalLoop

          .WaitScreenBottom
          .WaitScreenTop

          ;; Pad out to $20
          ldx # $20 - 5 - GlobalGameDataLength - 6
WritePadAfterGlobal:
          lda # $fe             ; totally arbitrary pad value
          jsr i2cTxByte
          dex
          bne WritePadAfterGlobal

          jsr i2cStopWrite

          jsr i2cWaitForAck

          .WaitScreenBottom
WriteCurrentProvince:
          jsr SaveProvinceData
          .WaitScreenTop

          jsr i2cWaitForAck

WriteCurrentGrizzard:
          jmp SaveGrizzard      ; tail call

SaveRetry:
          .WaitScreenBottom
          jmp SaveToSlot

	.bend

;;; Audited 2022-02-16 BRPocock
