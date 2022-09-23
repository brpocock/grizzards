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
          EEPROMRead = %10100001
          EEPROMWrite = %10100000
;;; 

i2cWait:  .macro
          nop
          .endm
          
i2cStartRead:
          nop i2cDataPort1
          nop i2cClockPort1

          .i2cWait

          nop i2cDataPort0
          nop i2cClockPort0

          lda # EEPROMRead

          jmp i2cTxByte         ; tail call

i2cStartWrite:
          nop i2cDataPort1
          nop i2cClockPort1

          .i2cWait

          nop i2cDataPort0
          nop i2cClockPort0

          lda # EEPROMRead

          jmp i2cTxByte         ; tail call

i2cTxByte:          .block
          sta Temp
          ldy # 8               ; bits to send
i2cTxByteLoop:
          lda # 0
          rol Temp
          bcc Send0

Send1:
          nop i2cDataPort1
          bcs SendClock

Send0:
          nop i2cDataPort0

SendClock:
          nop i2cClockPort1

          nop

          lda i2cReadPort
          nop i2cClockPort0
          dey
          bne i2cTxByteLoop

GetAck:
          nop i2cDataPort1
          nop i2cClockPort1

          nop

          lda i2cReadPort
          lsr a
          nop i2cClockPort0

          rts

          .bend
          
i2cRxByte:          .block
          ldy # 8           ; loop (bit) counter

          nop i2cDataPort1
i2cRxByteLoop:
          nop i2cClockPort1

          nop

          lda i2cReadPort
          ror a
          rol Temp

          nop i2cClockPort0
          dey
          bne i2cRxByteLoop

          rts

          .bend

i2cStopRead:
i2cStopWrite:
          nop i2cDataPort0

          nop

          nop i2cClockPort0

          nop

          nop i2cDataPort0

          rts
;;; 
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
