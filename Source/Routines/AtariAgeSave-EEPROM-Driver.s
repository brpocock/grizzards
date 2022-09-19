;;; Grizzards Source/Routines/AtariAgeSave-EEPROM-Driver.s
;;;
;;; AtariAgeSave EEPROM Driver
;;;
;;; Based on AtariVoxEEPROMDriver
;;;
;;; Original by Alex Herbert, 2004
;;;
;;; Converted and adapted by Bruce-Robert Pocock, 2017, 2020-2022
;;;
;;; Adapted for AtariAge save circuit by Fred Quimby (batari)

SaveGameSignatureString:
          .text SaveGameSignature

          i2cClockPort0 = $1ff0
          i2cClockPort1 = $1ff1
          i2cDataPort0 = $1ff2
          i2cDataPort1 = $1ff3
          i2cReadPort = $1ff4

          SaveWritesPerScreen = $20
;;; 
i2cSDA0:  .macro
          nop i2cDataPort0
         .endm

i2cSDA1:  .macro
          nop i2cDataPort1
          .endm

i2cSCL0:  .macro ; Setting SDA=0 seems to require changing SDA=1 to possibly allow the bus to float
          nop i2cDataPort1
          nop i2cClockPort0
         .endm

i2cSCL1:  .macro
          nop i2cClockPort1
          .endm

i2cSDAIn: .macro
          nop i2cDataPort1 ; float SDA
          .endm

i2cSDAOut: .macro ; no action needs to be done
          nop
          .endm

i2cReset: .macro ; float SDA
          .i2cDataPort1
          .endm

i2cStart: .macro
          .i2cSCL1
          .i2cSDAOut
          .endm

i2cStop:  .macro
          .i2cSCL0
          .i2cSDAOut
          .i2cSCL1
          .i2cReset
          .endm

i2cTxBit: .macro
          .i2cSCL0
          bcs Send0
          .i2cSDA1
          bcs Sent1 ; sending 1 is potentially slower so pad with branch
Send0:
          .i2cSDA0 ; Sending 0 is fast so no need to pad
Sent1:
          .i2cSCL1
          .endm

i2cTxACK: .macro
          .i2cSCL0
          .i2cSDAOut
          .i2cSCL1
          .endm

i2cTxNAK: .macro
          .i2cSCL0
          .i2cSDAIn
          .i2cSCL1
          .endm

i2cRxBit: .macro
          .i2cSCL0
          .i2cSDAIn
          .i2cSCL1
          lda i2cReadPort ; C = SDA
          lsr
          .endm

i2cRxACK: .macro
          .i2cRxBit
          .endm

          EEPROMRead = %10100001
          EEPROMWrite = %10100000
;;; 
i2cStartRead:
          clv               ; Use V to flag if previous byte needs ACK
          .i2cStart
          lda # EEPROMRead
          bvc i2cTxByte

i2cStartWrite:
          .i2cStart
          lda # EEPROMWrite

i2cTxByte:
          eor #$ff
          sta Temp

          ldy # 8           ; loop (bit) counter
i2cTxByteLoop:
          asl Temp          ; next bit into C
          .i2cTxBit
          dey
          bne i2cTxByteLoop

          .i2cRxACK         ; receive ACK bit
          rts

i2cRxByte:
          ldy # 8           ; loop (bit) counter
          bvc i2cRxSkipACK

          .i2cTxACK

i2cRxByteLoop:
          .i2cRxBit
          rol Temp          ; rotate C into scratchpad
          dey
          bne i2cRxByteLoop

          lda Temp
          rts

i2cRxSkipACK:
          bit VBit          ; set V - next byte/s require ACK
VBit:
          bvs i2cRxByteLoop

i2cStopRead:
          bvc i2cStopWrite

          .i2cTxNAK

i2cStopWrite:
          .i2cStop
          rts

          ;; The following functions added by BRPocock, not found in the
          ;; standard library code
i2cK:                           ; K is "switch over to (you) sending" in Morse code
          jsr i2cTxByte
i2cK2:                          ; switch without a final byte to send
          jsr i2cStopWrite

          jmp i2cStartRead      ; tail call

i2cWaitForAck:
          ;; Wait for acknowledge bit
-
          jsr i2cStartWrite

          bcs -
          jmp i2cStopWrite      ; tail call
