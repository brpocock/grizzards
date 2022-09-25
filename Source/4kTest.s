;;;
;;;
;;; *** GRIZZARDS ***
;;;
;;;
;;; Copyright © 2021-2022, Bruce-Robert Pocock
;;;

;;; Source/4kTest.s for new EEPROM


          BANK = $00

          .include "StartBank.s"
          .include "48Pixels.s"

          .include "Font.s"

          ;; falls through to
          .include "ColdStart.s"
          ;; falls through to

DoLocal:
Main:     .block

Loop:
          .WaitScreenBottom
          .SkipLines 30
          .WaitScreenTop

          .mva COLUBK, #$68
          .mva COLUPF, #$0f

          jsr Prepare48pxMobBlob

          .SetPointer TopText
          jsr ShowPointerText

          lda SWCHA
          and #P0StickUp
          bne DoRead

DoWrite:
          jsr i2cStartWrite
          lda #$01
          jsr i2cTxByte
          lda #$1a
          jsr i2cTxByte
          jsr Random
          and #$1f
          jsr i2cTxByte
          jsr i2cStopWrite

DoRead:
          .SetPointer ReadText
          jsr CopyPointerText

          jsr i2cStartWrite
          lda #$01
          jsr i2cTxByte
          lda #$1a
          jsr i2cTxByte
          jsr i2cStopWrite
          jsr i2cStartRead
          jsr i2cRxByte
          sta StringBuffer + 5
          jsr i2cStopRead
          jsr DecodeAndShowText
          jmp Loop

          .bend

          .enc "minifont"
TopText:
          .text "ACKNAK"

ReadText:
          .text "READ.0"

          .if ATARIAGESAVE
            .include "AtariAgeSave-EEPROM-Driver.s"
          .else
            .include "AtariVox-EEPROM-Driver.s"
          .fi

          .include "CheckSaveSlot.s"
          .include "EraseSlotSignature.s"

          .include "Random.s"
          .include "VSync.s"
          .include "VBlank.s"

          .include "CopyPointerText.s"
          .include "DecodeText.s"
          .include "DecodeScore.s"
          .include "WaitScreenBottom.s"

ShowPointerText:
          jsr CopyPointerText
DecodeAndShowText:
          jsr DecodeText
          jmp ShowText

Failure:  jmp *                 ; XXX

Overscan: rts

          .align $100
          .include "Prepare48pxMobBlob.s"
          .include "ShowText.s"

          EndBank = *

            ;; Save-to-cart hotspots
            * = $fff0
            ;;  SCL & SDA write lines, data irrelevant.
            ;;  Using this for Stella's benefit.
            .text "effb"
            ;; SDA reads return these values for 0/1 bits
            .byte 0, 1

            ;; for Stella's benefit
            * = $fff8
            .text "efef"

;;; 6507 special vectors
;;;
          * = RESVEC             ; CPU reset and BRK (IRQ) vectors (no NMI)
          .word ColdStart

          * = IRQVEC
          .word Failure

          .if * != $0000
            .error "Bank ", BANK, " does not end at $ffff, but ", * - 1
          .fi
          
