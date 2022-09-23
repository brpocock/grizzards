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

i2cStartRead:
          clv                   ; previous byte does not need ACK
          lda # EEPROMRead
          bvc i2cSignalStart    ; always taken

i2cStartWrite:
          lda # EEPROMWrite

i2cSignalStart:
          ;; Transition data 1→0 while clock is high
          ;; to signal start of a stream
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
          asl Temp              ; bit into C
          bcc Send0

          nop i2cDataPort1
          bcs SendClock         ; always taken

Send0:
          nop i2cDataPort0

SendClock:
          nop i2cClockPort1
          nop
          nop i2cClockPort0
          dey
          bne Loop

GetAck:
          nop i2cDataPort1
          nop i2cClockPort1
          nop
          lda i2cReadPort
          lsr a                 ; C = SDA
          nop i2cClockPort0
          ;; return C = ACK bit
          rts

          .bend
          
i2cRxByte:          .block
          ldy # 8           ; loop (bit) counter
          bvc SkipAck

          nop i2cClockPort0
          nop i2cDataPort1
          nop i2cClockPort1
          nop
          nop i2cClockPort0

Loop:
          nop i2cClockPort1
          nop
          lda i2cReadPort
          ror a
          rol Temp
          nop i2cClockPort0
          dey
          bne Loop

          lda Temp
          rts

SkipAck:
          bit VBit              ; set V=1
VBit:
          bvs Loop
          .bend

i2cStopRead:
          bvc i2cStopWrite

          ;; send NAK
          nop i2cDataPort0
          nop i2cClockPort1
          nop
          nop i2cClockPort0

i2cStopWrite:
          ;;  A low-to-high transition on the  SDA line while the SCL is
          ;;  high defines a STOP condition
          nop i2cDataPort0
          nop i2cClockPort1
          nop
          nop i2cDataPort1
          nop
          nop i2cClockPort0
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
