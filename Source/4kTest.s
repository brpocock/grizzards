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
          .WaitScreenTop

          .mva COLUBK, #$68
          .mva COLUPF, #$0f

          jsr Prepare48pxMobBlob

          .SetPointer HelloText

          jsr ShowPointerText

          jmp Loop

          .bend

HelloText:
          .enc "minifont"
          .text "HELLO!"

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
          .include "ShowText.s"
          .include "DecodeScore.s"
          .include "WaitScreenBottom.s"

ShowPointerText:
          jsr CopyPointerText
          jsr DecodeText
          jmp ShowText

Failure:  jmp *                 ; XXX

Overscan: rts

          .align $100
          .include "Prepare48pxMobBlob.s"

          
          EndBank = *

          .if ATARIAGESAVE

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
          .fi

;;; 6507 special vectors
;;;
          * = RESVEC             ; CPU reset and BRK (IRQ) vectors (no NMI)
          .word ColdStart

          * = IRQVEC
          .word Failure

          .if * != $0000
            .error "Bank ", BANK, " does not end at $ffff, but ", * - 1
          .fi
          
