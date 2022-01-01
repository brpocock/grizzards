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

Inc16cc .macro address
          .block
          inc \address
          bcc _cc
          inc \address + 1
_cc:
          .bend
          .endm

Inc16 .macro address
          clc
          .Inc16cc \address
          .endm

Sub16cs .macro address, subtrahend
          .block
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
          lsr

          .case 3
          ;;18 bytes, 30 cycles
          sta \temp
          lsr
          adc #21
          lsr
          adc \temp
          ror
          lsr
          adc \temp
          ror
          lsr
          adc \temp
          ror
          lsr

          .case 4
          ;;2 bytes, 4 cycles
          lsr
          lsr

          .case 5
          ;;18 bytes, 30 cycles
          sta \temp
          lsr
          adc #13
          adc \temp
          ror
          lsr
          lsr
          adc \temp
          ror
          adc \temp
          ror
          lsr
          lsr

          .case 6
          ;;17 bytes, 30 cycles
          lsr
          sta \temp
          lsr
          lsr
          adc \temp
          ror
          lsr
          adc \temp
          ror
          lsr
          adc \temp
          ror
          lsr

          .case 7
          ;;Divide by 7 (From December '84 Apple Assembly Line)
          ;;15 bytes, 27 cycles
          sta \temp
          lsr
          lsr
          lsr
          adc \temp
          ror
          lsr
          lsr
          adc \temp
          ror
          lsr
          lsr

          .case 8
          ;;3 bytes, 6 cycles
          lsr
          lsr
          lsr

          .case 9
          ;;17 bytes, 30 cycles
          sta \temp
          lsr
          lsr
          lsr
          adc \temp
          ror
          adc \temp
          ror
          adc \temp
          ror
          lsr
          lsr
          lsr

          .case 10
          ;;17 bytes, 30 cycles
          lsr
          sta \temp
          lsr
          adc \temp
          ror
          lsr
          lsr
          adc \temp
          ror
          adc \temp
          ror
          lsr
          lsr

          .case 11
          ;;20 bytes, 35 cycles
          sta \temp
          lsr
          lsr
          adc \temp
          ror
          adc \temp
          ror
          adc \temp
          ror
          lsr
          adc \temp
          ror
          lsr
          lsr
          lsr

          .case 12
          ;;17 bytes, 30 cycles
          lsr
          lsr
          sta \temp
          lsr
          adc \temp
          ror
          lsr
          adc \temp
          ror
          lsr
          adc \temp
          ror
          lsr

          .case 13
          ;; 21 bytes, 37 cycles
          sta \temp
          lsr
          adc \temp
          ror
          adc \temp
          ror
          adc \temp
          ror
          lsr
          lsr
          clc
          adc \temp
          ror
          lsr
          lsr
          lsr

          .case 14
          ;;1⁄14 = 1⁄7 × 1⁄2
          ;;16 bytes, 29 cycles
          sta \temp
          lsr
          lsr
          lsr
          adc \temp
          ror
          lsr
          lsr
          adc \temp
          ror
          lsr
          lsr
          lsr

          .case 15
          ;;14 bytes, 24 cycles
          sta \temp
          lsr
          adc #4
          lsr
          lsr
          lsr
          adc \temp
          ror
          lsr
          lsr
          lsr

          .case 16
          ;;4 bytes, 8 cycles
          lsr
          lsr
          lsr
          lsr

          .case 17
          ;;18 bytes, 30 cycles
          sta \temp
          lsr
          adc \temp
          ror
          adc \temp
          ror
          adc \temp
          ror
          adc #0
          lsr
          lsr
          lsr
          lsr

          .case 18
          ;;Divide by 18 = 1⁄9 × 1⁄2
          ;;18 bytes, 32 cycles
          sta \temp
          lsr
          lsr
          lsr
          adc \temp
          ror
          adc \temp
          ror
          adc \temp
          ror
          lsr
          lsr
          lsr
          lsr

          .case 19
          ;;17 bytes, 30 cycles
          sta \temp
          lsr
          adc \temp
          ror
          lsr
          adc \temp
          ror
          adc \temp
          ror
          lsr
          lsr
          lsr
          lsr

          .case 20
          ;;18 bytes, 32 cycles
          lsr
          lsr
          sta \temp
          lsr
          adc \temp
          ror
          lsr
          lsr
          adc \temp
          ror
          adc \temp
          ror
          lsr
          lsr

          .case 21
          ;;20 bytes, 36 cycles
          sta \temp
          lsr
          adc \temp
          ror
          lsr
          lsr
          lsr
          lsr
          adc \temp
          ror
          adc \temp
          ror
          lsr
          lsr
          lsr
          lsr

          .case 22
          ;;21 bytes, 34 cycles
          lsr
          cmp #33
          adc #0
          sta \temp
          lsr
          adc \temp
          ror
          adc \temp
          ror
          lsr
          adc \temp
          ror
          lsr
          lsr
          lsr

          .case 23
          ;;19 bytes, 34 cycles
          sta \temp
          lsr
          lsr
          lsr
          adc \temp
          ror
          adc \temp
          ror
          lsr
          adc \temp
          ror
          lsr
          lsr
          lsr
          lsr

          .case 24
          ;;15 bytes, 27 cycles
          lsr
          lsr
          lsr
          sta \temp
          lsr
          lsr
          adc \temp
          ror
          lsr
          adc \temp
          ror
          lsr

          .case 25
          ;;16 bytes, 29 cycles
          sta \temp
          lsr
          lsr
          lsr
          adc \temp
          ror
          lsr
          adc \temp
          ror
          lsr
          lsr
          lsr
          lsr

          .case 26
          ;;21 bytes, 37 cycles
          lsr
          sta \temp
          lsr
          adc \temp
          ror
          adc \temp
          ror
          adc \temp
          ror
          lsr
          lsr
          adc \temp
          ror
          lsr
          lsr
          lsr

          .case 27
          ;;15 bytes, 27 cycles
          sta \temp
          lsr
          adc \temp
          ror
          lsr
          lsr
          adc \temp
          ror
          lsr
          lsr
          lsr
          lsr

          .case 28
          ;;14 bytes, 24 cycles
          lsr
          lsr
          sta \temp
          lsr
          adc #2
          lsr
          lsr
          adc \temp
          ror
          lsr
          lsr

          .case 29
          ;;20 bytes, 36 cycles
          sta \temp
          lsr
          lsr
          adc \temp
          ror
          adc \temp
          ror
          .rept 3
          lsr
          .next
          adc \temp
          ror
          .rept 4
          lsr
          .next

          .case 30
          ;;14 bytes, 26 cycles
          sta \temp
          .rept 4
          lsr
          .next
          sec
          adc \temp
          ror
          .rept 4
          lsr
          .next

          .case 31
          ;;14 bytes, 26 cycles
          sta \temp
          lsr
          lsr
          lsr
          lsr
          lsr
          adc \temp
          ror
          lsr
          lsr
          lsr
          lsr

          .case 32
          lsr
          lsr
          lsr
          lsr
          lsr

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
          asl

          .case 3
          sta \temp
          asl
          adc \temp

          .case 4
          asl
          asl

          .case 5
          sta \temp
          asl
          asl
          adc \temp

          .case 6
          .Mul 3, \temp
          asl

          .case 7
          sta \temp
          asl
          asl
          asl
          sbc \temp

          .case 8
          asl
          asl
          asl

          .case 12
          .Mul 6, \temp
          asl

          .case 14
          .Mul 7, \temp
          asl

          .case 15
          sta \temp
          .rept 4
          asl
          .next
          sbc \temp

          .case 16
          .rept 4
          asl
          .next

          .case 32
          .rept 5
          asl
          .next

          .default
          .error "no optimized code to multiply by ", \factor

          .endswitch
          .endm

;;;
