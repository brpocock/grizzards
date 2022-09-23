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

          SaveWritesPerScreen = $20

          i2cSDAMask = $04
          i2cSCLMask = $08
;;; 
i2cSCL0:  .macro
          nop $1ff0
          .endm

i2cSCL1:  .macro
          nop $1ff1
          .endm

i2cSDA0:  .macro
          nop $1ff2
          .endm

i2cSDA1:  .macro
          nop $1ff3
          .endm

i2cSDAIn: .macro
          nop $1ff3
          .endm

i2cStart: .macro ; SDA transitions 1 to 0 during SCL=1
          .i2cSCL0
          .i2cSDA1
          .i2cSCL1
          .i2cSDA0
          .endm

i2cStop:  .macro ; SDA transitions 0 to 1 during SCL=1
          .i2cSCL0
          .i2cSDA0
          .i2cSCL1
          .i2cSDA1
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
          sta Temp

          ldy # 8           ; loop (bit) counter
i2cTxByteLoop:
          asl Temp          ; next bit into C
          .i2cSCL0
          bcc Send0
          .i2cSDA1
          bcs Send1
Send0:
          .i2cSDA0
Send1:
          dey
          .i2cSCL1
          bne i2cTxByteLoop
          .i2cSCL0
          .i2cSDA1
          .i2cSCL1 ; to enable read of ACK bit
          lda $1FF4
          lsr
          rts

i2cRxByte:
          ldy # 8           ; loop (bit) counter
          bvc i2cRxSkipACK

          .i2cSCL0 ; send ACK
          .i2cSDA1
          .i2cSDA0 ; Seems to want to send 1->0?
          .i2cSCL1

i2cRxByteLoopStart:
          .i2cSDAIn
i2cRxByteLoop:
          .i2cSCL0
          .i2cSCL1
          lda $1FF4 ; get bit from EEPROM
          lsr
          rol Temp          ; rotate C into scratchpad
          dey
          bne i2cRxByteLoop

          lda Temp
          rts

i2cRxSkipACK:
          bit VBit          ; set V - next byte/s require ACK
VBit:
          bvs i2cRxByteLoopStart

i2cStopRead:
          bvc i2cStopWrite

          .i2cSCL0
          .i2cSDA0 ; seems to go from 0->1??
          .i2cSDA1
          .i2cSCL1

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
          jsr i2cStartWrite

          bcs i2cWaitForAck
          jmp i2cStopWrite      ; tail call
