;;; Grizzards Source/Common/Math.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
;;; 

;;; Common 16-bit handlers

Add16cc .macro address, addend
          .block
          lda \address
          adc \addend
          bcc _cc
          inc \address + 1
_cc:
          .bend
          .endm

Add16 .macro address, addend
          .block
          clc
          .Add16cc \address, \addend
          sta \address
          .bend
          .endm

Add16a .macro address
          .block
          clc
          adc \address
          bcc _cc
          inc \address + 1
_cc:
          sta \address
          .bend
          .endm

AddWord:  .macro a, b
          .block
          clc
          lda \a
          adc \b
          sta \a
          lda \a + 1
          adc \b + 1
          sta \a + 1
          .bend
          .endm
          
Inc16:    .macro address
          .block
          inc \address
          bne _ne
          inc \address + 1
_ne:
          .bend
          .endm

Sub16cs .macro address, subtrahend
          .block
          lda \address
          sbc \subtrahend
          bcs _cs
          dec \address + 1
_cs:
          .bend
          .endm

Sub16 .macro address, subtrahend
          sec
          .Sub16cs \address, \subtrahend
          sta \address
          .endm

Dec16cs .macro address
          .block
          dec \address
          bcs _cs
          dec \address + 1
_cs:
          .bend
          .endm

Dec16 .macro address
          sec
          .Dec16cs \address
          .endm


Asl16cc .macro address
          .block
          asl \address
          bcc _cc
          asl \address + 1
_cc:
          .bend
          .endm

Asl16 .macro address
          clc
          .Asl16cc \address
          .endm


;;; 

Div .macro denominator, temp
          ;; Unsigned Integer Division Routines
          ;; by Omegamatrix

          .switch \denominator

          .case 0
          .error "Dude, it's a 6502, it doesn't do ∞ very convincingly."

          .case 1
          ;; nil

          .case 2
          ;;1 byte, 2 cycles
          lsr a

          .case 3
          ;;18 bytes, 30 cycles
          sta \temp
          lsr a
          adc #21
          lsr a
          adc \temp
          ror a
          lsr a
          adc \temp
          ror a
          lsr a
          adc \temp
          ror a
          lsr a

          .case 4
          ;;2 bytes, 4 cycles
          lsr a
          lsr a

          .case 5
          ;;18 bytes, 30 cycles
          sta \temp
          lsr a
          adc #13
          adc \temp
          ror a
          lsr a
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          lsr a
          lsr a

          .case 6
          ;;17 bytes, 30 cycles
          lsr a
          sta \temp
          lsr a
          lsr a
          adc \temp
          ror a
          lsr a
          adc \temp
          ror a
          lsr a
          adc \temp
          ror a
          lsr a

          .case 7
          ;;Divide by 7 (From December '84 Apple Assembly Line)
          ;;15 bytes, 27 cycles
          sta \temp
          lsr a
          lsr a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a

          .case 8
          ;;3 bytes, 6 cycles
          lsr a
          lsr a
          lsr a

          .case 9
          ;;17 bytes, 30 cycles
          sta \temp
          lsr a
          lsr a
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a

          .case 10
          ;;17 bytes, 30 cycles
          lsr a
          sta \temp
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          lsr a
          lsr a

          .case 11
          ;;20 bytes, 35 cycles
          sta \temp
          lsr a
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          adc \temp
          ror a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a

          .case 12
          ;;17 bytes, 30 cycles
          lsr a
          lsr a
          sta \temp
          lsr a
          adc \temp
          ror a
          lsr a
          adc \temp
          ror a
          lsr a
          adc \temp
          ror a
          lsr a

          .case 13
          ;; 21 bytes, 37 cycles
          sta \temp
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          adc \temp
          ror a
          lsr a
          lsr a
          clc
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a

          .case 14
          ;;1⁄14 = 1⁄7 × 1⁄2
          ;;16 bytes, 29 cycles
          sta \temp
          lsr a
          lsr a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a

          .case 15
          ;;14 bytes, 24 cycles
          sta \temp
          lsr a
          adc #4
          lsr a
          lsr a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a

          .case 16
          ;;4 bytes, 8 cycles
          lsr a
          lsr a
          lsr a
          lsr a

          .case 17
          ;;18 bytes, 30 cycles
          sta \temp
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          adc \temp
          ror a
          adc #0
          lsr a
          lsr a
          lsr a
          lsr a

          .case 18
          ;;Divide by 18 = 1⁄9 × 1⁄2
          ;;18 bytes, 32 cycles
          sta \temp
          lsr a
          lsr a
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a
          lsr a

          .case 19
          ;;17 bytes, 30 cycles
          sta \temp
          lsr a
          adc \temp
          ror a
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a
          lsr a

          .case 20
          ;;18 bytes, 32 cycles
          lsr a
          lsr a
          sta \temp
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          lsr a
          lsr a

          .case 21
          ;;20 bytes, 36 cycles
          sta \temp
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a
          lsr a

          .case 22
          ;;21 bytes, 34 cycles
          lsr a
          cmp #33
          adc #0
          sta \temp
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a

          .case 23
          ;;19 bytes, 34 cycles
          sta \temp
          lsr a
          lsr a
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a
          lsr a

          .case 24
          ;;15 bytes, 27 cycles
          lsr a
          lsr a
          lsr a
          sta \temp
          lsr a
          lsr a
          adc \temp
          ror a
          lsr a
          adc \temp
          ror a
          lsr a

          .case 25
          ;;16 bytes, 29 cycles
          sta \temp
          lsr a
          lsr a
          lsr a
          adc \temp
          ror a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a
          lsr a

          .case 26
          ;;21 bytes, 37 cycles
          lsr a
          sta \temp
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          adc \temp
          ror a
          lsr a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a

          .case 27
          ;;15 bytes, 27 cycles
          sta \temp
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a
          lsr a

          .case 28
          ;;14 bytes, 24 cycles
          lsr a
          lsr a
          sta \temp
          lsr a
          adc #2
          lsr a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a

          .case 29
          ;;20 bytes, 36 cycles
          sta \temp
          lsr a
          lsr a
          adc \temp
          ror a
          adc \temp
          ror a
          .rept 3
          lsr a
          .next
          adc \temp
          ror a
          .rept 4
          lsr a
          .next

          .case 30
          ;;14 bytes, 26 cycles
          sta \temp
          .rept 4
          lsr a
          .next
          sec
          adc \temp
          ror a
          .rept 4
          lsr a
          .next

          .case 31
          ;;14 bytes, 26 cycles
          sta \temp
          lsr a
          lsr a
          lsr a
          lsr a
          lsr a
          adc \temp
          ror a
          lsr a
          lsr a
          lsr a
          lsr a

          .case 32
          lsr a
          lsr a
          lsr a
          lsr a
          lsr a

          .default
          .error "no optimized code to divide by ", \denominator

          .endswitch

          .endm

;;; 
          ;; *expects carry clear
Mul .macro factor, temp

          .switch \factor
          .case 0
          lda #0

          .case 1
          ;; nothing

          .case 2
          asl a

          .case 3
          sta \temp
          asl a
          adc \temp

          .case 4
          asl a
          asl a

          .case 5
          sta \temp
          asl a
          asl a
          adc \temp

          .case 6
          .Mul 3, \temp
          asl a

          .case 7
          sta \temp
          asl a
          asl a
          asl a
          sbc \temp

          .case 8
          asl a
          asl a
          asl a

          .case 12
          .Mul 6, \temp
          asl a

          .case 14
          .Mul 7, \temp
          asl a

          .case 15
          sta \temp
          .rept 4
          asl a
          .next
          sbc \temp

          .case 16
          .rept 4
          asl a
          .next

          .case 32
          .rept 5
          asl a
          .next

          .default
          .error "no optimized code to multiply by ", \factor

          .endswitch
          .endm

