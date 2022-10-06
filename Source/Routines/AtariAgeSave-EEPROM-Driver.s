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
          .enc "Unicode"
          .text SaveGameSignature

          i2cClockPort0 = $1ff0
          i2cClockPort1 = $1ff1
          i2cDataPort0 = $1ff2
          i2cDataPort1 = $1ff3
          i2cReadPort = $1ff4

          SaveWritesPerScreen = $20
;;; 

          EEPROMRead = $a1
          EEPROMWrite = $a0
;;; 

i2cStartRead:
          ;; Read page in A (0-7)
          asl a
          ora # EEPROMRead
          jmp i2cSignalStart    ; gne

i2cStartWrite:
          asl a
          ora # EEPROMWrite

i2cSignalStart:
          ;; Transition data 1→0 while clock is high
          ;; to signal start of a stream
          nop i2cClockPort0
          nop i2cDataPort1
          nop i2cClockPort1
          nop
          nop i2cDataPort0
          nop
          nop i2cClockPort0
          ;; fall through
i2cTxByte:          .block
          sta Temp
          ldy # 8               ; bits to send
Loop:
          nop i2cClockPort0
          asl Temp              ; bit into C
          bcc Send0

Send1:
          nop i2cDataPort1
          jmp SendClock         ; always taken gcs

Send0:
          nop i2cDataPort0

SendClock:
          nop i2cClockPort1
          nop
          dey
          bne Loop

GetAck:
          nop i2cClockPort0
          nop i2cDataPort1
          nop i2cClockPort1
          nop
          lda i2cReadPort
          lsr a                 ; C = SDA
          nop i2cClockPort0
          ;; return C = ACK bit (0 = ACK)
          rts

          .bend
          
i2cRxByte:          .block
          ldy # 8           ; loop (bit) counter
          nop i2cDataPort1
Loop:
          nop i2cClockPort0
          nop i2cClockPort1
          nop
          lda i2cReadPort
          lsr a
          rol Temp
          dey
          bne Loop

          ;; send ACK (zero)
          nop i2cClockPort0
          nop i2cDataPort0
          nop i2cClockPort1
          nop
          nop i2cClockPort0

          lda Temp
          rts

          .bend

i2cStopRead: .block
          ;; Read and discard a byte in order  to get a chance to NAK it
          ;; to end the talker's string.
          ldy # 8
          nop i2cDataPort1
Loop:
          nop i2cClockPort0
          nop i2cClockPort1
          nop
          dey
          bne Loop

          nop i2cClockPort0

          nop i2cClockPort1
          nop
          nop i2cClockPort0

          ;; fall through to send STOP condition also.
          .bend

i2cStopWrite:
          ;;  A low-to-high transition on the  SDA line while the SCL is
          ;;  high defines a STOP condition
          nop i2cClockPort0
          nop i2cDataPort0
          nop i2cClockPort1
          nop
          nop i2cDataPort1
          nop
          nop i2cClockPort0

          rts
;;; 
          ;; The following function added by BRPocock, not found in the
          ;; standard library code
i2cWaitForAck:
          lda SaveGameSlot
          ;; Wait for acknowledge bit
          jsr i2cStartWrite

          bcs i2cWaitForAck
          jmp i2cStopWrite      ; tail call
