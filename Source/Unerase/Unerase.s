;;; Grizzards Source/Unerase/Unerase.s
;;; Copyright © 2021 Bruce-Robert Pocock

          .include "StartBank.s"

          .include "Font.s"

          .warn "Slot prefix ", SaveGameSlotPrefix
          
          .include "ColdStart.s"
          ;; falls through to
SelectSlot:         .block

          lda # 0
          sta SaveGameSlot
Loop:
          jsr VSync

          .if TV == NTSC
          .TimeLines KernelLines * 2/3 - 1
          .else
          .TimeLines KernelLines / 2 - 1
          .fi

          .ldacolu COLCYAN, $e
          sta COLUP0
          sta COLUP1
          .ldacolu COLBLUE, $4
          sta COLUBK

          .SkipLines 16
          jsr Prepare48pxMobBlob
          
          .SetPointer UnText
          jsr ShowPointerText

          .SetPointer EraseText
          jsr ShowPointerText

          jsr CheckSlotStatus

          cpy # 2               ; slot deleted
          beq SlotWasDeleted

          cpy # 0
          beq SlotIsBusy

SlotIsEmpty:
          .SetPointer BlankText
          jmp ShowSlotStatus

SlotWasDeleted:
          .SetPointer ErasedText
          jmp ShowSlotStatus

SlotIsBusy:
          .SetPointer InUseText

ShowSlotStatus:

          .WaitForTimer
          .if TV == NTSC
          .SkipLines 2
          .TimeLines KernelLines / 3 - 1
          .else
          .TimeLines KernelLines / 2 - 1
          .fi

          jsr ShowPointerText

          .SetPointer SlotOneText
          jsr CopyPointerText
          ldx SaveGameSlot
          inx
          stx StringBuffer + 5

          jsr DecodeText
          jsr ShowText

          .WaitForTimer

          lda # ( 76 * OverscanLines ) / 64 - 1
          sta TIM64T
FillOverscan:
          lda INSTAT
          bpl FillOverscan

          sta WSYNC

          lda NewSWCHB
          beq SkipSwitches
          and #SWCHBReset
          beq SlotOK

          lda NewSWCHB
          and #SWCHBSelect
          beq SwitchSelectSlot

SkipSwitches:
          jmp Loop

SwitchSelectSlot:
          inc SaveGameSlot
          lda SaveGameSlot
          cmp # 3
          blt GoBack
          lda #0
          sta SaveGameSlot
GoBack:
          jmp Loop

SlotOK:
          jsr CheckSlotStatus
          cpy # 2               ; slot was erased
          bne GoBack

ActuallyUnErase:
          jsr i2cStartWrite
          lda #>SaveGameSlotPrefix
          clc
          adc SaveGameSlot
          jsr i2cTxByte
          lda #<SaveGameSlotPrefix
          jsr i2cTxByte

          lda #"g"[0]
          jsr i2cTxByte
          jsr i2cStopWrite

          jmp Loop
          
          .bend

CheckSlotStatus:    .block
          ;; If the slot has a signature, it's in use.
          ;; If the signature has a null byte in the first
          ;; character but is otherwise valid, it's been
          ;; erased and can probably be recovered.

          jsr i2cStartWrite
          lda SaveGameSlot
          clc
          adc #>SaveGameSlotPrefix
          jsr i2cTxByte
          lda #<SaveGameSlotPrefix
          jsr i2cTxByte
          jsr i2cStopWrite
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
          ldy # 0               ; slot busy
          rts

SlotEmpty:
          jsr i2cStopRead
          ldy # 1               ; slot empty
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
          ldy # 2               ; slot deleted
          rts

          .bend
          
ShowPointerText:
          jsr CopyPointerText
          jsr DecodeText
          jmp ShowText          ; tail call

UnText:
          .MiniText "UN-   "
EraseText:
          .MiniText " ERASE"
SlotOneText:
          .MiniText "SLOT 1"
InUseText:
          .MiniText "IN USE"
BlankText:
          .MiniText "BLANK "
ErasedText:
          .MiniText "ERASED"
          
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"
          .include "VSync.s"
          .include "VBlank.s"
          .include "AtariVox-EEPROM-Driver.s"
          .include "CopyPointerText.s"
          .include "DecodeText.s"
          .include "ShowText.s"

BitMask:
          .byte 1, 2, 4, 8, $10, $20, $40, $80
          
;;; End of ROM vectors
          * = NMIVEC
          .offs -$f000
          .word ColdStart

          * = RESVEC
          .offs -$f000
          .word ColdStart

          * = IRQVEC
          .offs -$f000
          .word ColdStart

          .if * != $0000
          .error "Should end at $ffff, not ", * - 1
          .fi
