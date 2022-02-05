;;; Grizzards Source/Routines/AtariAgeSave-EEPROM-Driver.s
;;;
;;; AtariAgeSave EEPROM Driver
;;;
;;; COMING SOON from Fred Quimby
;;;
;;; Adapted for Turbo Assembler by Bruce-Robert Pocock, 2022
SaveGameSignatureString:
          .text SaveGameSignature

;;; 

          ;; The AtariVox EEPROM driver is about 192 bytes ($c0)
          ;; This fill maxxes out bank 0,1 for AA Airex PAL/SECAM
          ;; if we need more room things gonna get ugly 😎
          .fill $ac, $ea

i2cStartRead:
          ;; TODO

i2cStartWrite:
          ;; TODO

i2cTxByte:
          ;; TODO

i2cRxByte:
          ;; TODO

i2cRxSkipACK:
          ;; TODO

i2cStopRead:
          ;; TODO

i2cStopWrite:
          ;; TODO
          rts

i2cK:
          jsr i2cTxByte
          jsr i2cStopWrite
          jmp i2cStartRead      ; tail call

i2cWaitForAck:
          ;; Wait for acknowledge bit
-
          jsr i2cStartWrite
          bcs -
          jmp i2cStopWrite      ; tail call

          SaveWritesPerScreen = $20
