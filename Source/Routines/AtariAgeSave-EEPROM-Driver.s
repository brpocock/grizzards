;;; Grizzards Source/Routines/AtariAgeSave-EEPROM-Driver.s
;;;
;;; AtariAgeSave EEPROM Driver
;;;
;;; Based on AtariVoxEEPROMDriver
;;;
;;; Original by Alex Herbert, 2004
;;;
;;; Converted and adapted by Bruce-Robert Pocock, 2017, 2020-2022
SaveGameSignatureString:
          .text SaveGameSignature

          i2cControlPort = $fff0
          i2cWritePort = $fff1
          i2cReadPort = $fff2

          i2cSDAMask = $04
          i2cSCLMask = $08

          SaveWritesPerScreen = $20
;;; 
i2cSCL0:  .macro
          lda # 0
          sta i2cWritePort
          .endm

i2cSCL1:  .macro
          lda #i2cSCLMask
          sta i2cWritePort
          .endm

i2cSDAIn: .macro
          lda #i2cSCLMask
          sta i2cControlPort
          .endm

i2cSDAOut: .macro
          lda #i2cSCLMask | i2cSDAMask
          sta i2cControlPort
          .endm

i2cReset: .macro
          lda #0
          sta i2cControlPort
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
          lda # 1
          rol a
          asl a
          asl a
          sta i2cControlPort ; SDA = !C
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
          lda i2cReadPort
          lsr a
          lsr a
          lsr a ; C = SDA
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

          .fill 32              ; In case this has to grow
