;;; Grizzards Source/Routines/AtariVox-EEPROM-Driver.s
;;;
;;; AtariAgeSave EEPROM Driver
;;;
;;; COMING SOON from Fred Quimby
;;;
;;; Adapted for Turbo Assembler by Bruce-Robert Pocock, 2022
SaveGameSignatureString:
          .text SaveGameSignature

;;; 

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

          SaveWritesPerScreen = $20
