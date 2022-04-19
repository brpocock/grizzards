;;; Grizzards Source/Routines/AtariVox-EEPROM-Driver-Alt.s
;;;
;;; AtariVox EEPROM Driver (with alternative names for everything)
;;;
;;; By Alex Herbert, 2004
;;;
;;; Converted for 64tass by Bruce-Robert Pocock, 2017, 2020-2022

          SKi2cSDAMask = $04
          SKi2cSCLMask = $08
;;; 
SKi2cSCL0:  .macro
          lda # 0
          sta SWCHA
          .endm

SKi2cSCL1:  .macro
          lda #SKi2cSCLMask
          sta SWCHA
          .endm

SKi2cSDAIn: .macro
          lda #SKi2cSCLMask
          sta SWACNT
          .endm

SKi2cSDAOut: .macro
          lda #SKi2cSCLMask | SKi2cSDAMask
          sta SWACNT
          .endm

SKi2cReset: .macro
          lda #0
          sta SWACNT
          .endm

SKi2cStart: .macro
          .SKi2cSCL1
          .SKi2cSDAOut
          .endm

SKi2cStop:  .macro
          .SKi2cSCL0
          .SKi2cSDAOut
          .SKi2cSCL1
          .SKi2cReset
          .endm

SKi2cTxBit: .macro
          .SKi2cSCL0
          lda # 1
          rol a
          asl a
          asl a
          sta SWACNT ; SDA = !C
          .SKi2cSCL1
          .endm

SKi2cTxACK: .macro
          .SKi2cSCL0
          .SKi2cSDAOut
          .SKi2cSCL1
          .endm

SKi2cTxNAK: .macro
          .SKi2cSCL0
          .SKi2cSDAIn
          .SKi2cSCL1
          .endm

SKi2cRxBit: .macro
          .SKi2cSCL0
          .SKi2cSDAIn
          .SKi2cSCL1
          lda SWCHA
          lsr a
          lsr a
          lsr a ; C = SDA
          .endm

SKi2cRxACK: .macro
          .SKi2cRxBit
          .endm

          SKEEPROMRead = %10100001
          SKEEPROMWrite = %10100000
;;; 
SKi2cStartRead:
          clv               ; Use V to flag if previous byte needs ACK
          .SKi2cStart
          lda # SKEEPROMRead
          bvc SKi2cTxByte

SKi2cStartWrite:
          .SKi2cStart
          lda # SKEEPROMWrite

SKi2cTxByte:
          eor #$ff
          sta Temp

          ldy # 8           ; loop (bit) counter
SKi2cTxByteLoop:
          asl Temp          ; next bit into C
          .SKi2cTxBit
          dey
          bne SKi2cTxByteLoop

          .SKi2cRxACK         ; receive ACK bit
          rts

SKi2cRxByte:
          ldy # 8           ; loop (bit) counter
          bvc SKi2cRxSkipACK

          .SKi2cTxACK

SKi2cRxByteLoop:
          .SKi2cRxBit
          rol Temp          ; rotate C into scratchpad
          dey
          bne SKi2cRxByteLoop

          lda Temp
          rts

SKi2cRxSkipACK:
          bit SKVBit          ; set V - next byte/s require ACK
SKVBit:
          bvs SKi2cRxByteLoop

SKi2cStopRead:
          bvc SKi2cStopWrite

          .SKi2cTxNAK

SKi2cStopWrite:
          .SKi2cStop
          rts

          ;; The following functions added by BRPocock, not found in the
          ;; standard library code
SKi2cK:                           ; K is "switch over to (you) sending" in Morse code
          jsr SKi2cTxByte
SKi2cK2:                          ; switch without a final byte to send
          jsr SKi2cStopWrite

          jmp SKi2cStartRead      ; tail call

SKi2cWaitForAck:
          ;; Wait for acknowledge bit
-
          jsr SKi2cStartWrite

          bcs -
          jmp SKi2cStopWrite      ; tail call

;;; Audited 2022-02-15 BRP
