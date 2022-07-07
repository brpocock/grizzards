;;; Grizzards Source/Routines/Write12Chars.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .align $20            ; XXX alignment
Write12Chars:       .block

          ldy # 0
          sty REFP0
          sty REFP1
          sty GRP0
          sty GRP1
          sty VDELP0
          sty VDELP1
          lda #NUSIZ3CopiesMed
          sta NUSIZ0
          sta NUSIZ1
TextLineLoop:
;;; 
          ;; Unpack 6-bits-per-character packed text
          ;; This saves 25% of string storage space at the cost of
          ;; this increased complexity here.
          ldy # 4
          .UnpackRight SignpostLineCompressed

          jsr DecodeText

          ;; Move to the alternate pointers
          ldx # 12
-
          lda PixelPointers, x
          sta SignpostAltPixelPointers, x
          dex
          bpl -

          ;; Unpack left now and decode
          ldy # 0
          .UnpackLeft SignpostLineCompressed

          jsr DecodeText

          .Add16 SignpostWork, # 9

          jmp AlignedCode

          .align $20            ; XXX

AlignedCode:
          .page

          sta HMCLR
          stx WSYNC

PositionPlayers:
          .SleepX 12
          ldy #$80
          sty HMP0
          ldy #$a0
          sty HMP1
          .Sleep 10
          stx RESP0
          .Sleep 3
          stx RESP1

          stx WSYNC
          .SleepX 71
          stx HMOVE             ; Cycle 74 HMOVE

          ;; TODO alternate?
          jmp AlignedRight

          .endp

;;; 
DrawInterleavedLine:       .macro Origin

          ldy SignpostScanline
	lda (\Origin + 0), y
          sta GRP0
	lda (\Origin + 2), y
          sta GRP1
          nop
          lax (\Origin + 4), y
          lda (\Origin + 6), y
          stx GRP0
          sta GRP1
          lax (\Origin + 8), y
          lda (\Origin + 10), y
          stx GRP0
          sta GRP1
 
          .endm
;;; 
          .align $100           ; TODO
AlignedLeft:
          .page

          stx WSYNC
          ldy # 4
          sty SignpostScanline
          .Sleep 3
InterleavedLoopLeft:
          .DrawInterleavedLine SignpostAltPixelPointers
          .SleepX 4            ; align cycle 71(74) HMOVE
          ldx # 0               ; -8px
          stx HMP0
          stx HMP1
          stx HMOVE
          .SleepX 9
          .DrawInterleavedLine PixelPointers
          .SleepX 7            ; align cycle 73(76) HMOVE
          ldx #$80              ; +8px
          stx HMP0
          stx HMP1
          stx HMOVE
          ldy # 0
          sty GRP0
          sty GRP1
          dec SignpostScanline
          stx WSYNC
          nop
          bpl InterleavedLoopRight

          rts

AlignedRight:
          
          stx WSYNC
          ldy # 4
          sty SignpostScanline
          .Sleep 3
InterleavedLoopRight:
          .DrawInterleavedLine SignpostAltPixelPointers
          .SleepX 4            ; align cycle 71(74) HMOVE
          ldx # 0               ; -8px
          stx HMP0
          stx HMP1
          stx HMOVE
          .SleepX 9
          .DrawInterleavedLine PixelPointers
          .SleepX 7            ; align cycle 73(76) HMOVE
          ldx #$80              ; +8px
          stx HMP0
          stx HMP1
          stx HMOVE
          ldy # 0
          sty GRP0
          sty GRP1
          dec SignpostScanline
          stx WSYNC
          nop
          bpl InterleavedLoopRight ; TODO Left

          .endp

          rts

          .bend

