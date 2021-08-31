;;; Macros.s
;;;
;;; Copyright © 2016,2017,2020,2021 Bruce-Robert Pocock (brpocock@star-hope.org)
;;;
;;;
Sleep:    .macro Cycles
          .if \Cycles < 0
          .error "Can't sleep back-in-time for ", \Cycles, " cycles"
          .else
          .switch \Cycles
        
          .case 0
        
          .case 1
          .error "Cannot sleep 1 cycle (must be 2+)"

          .case 2
          nop

          .case 3
          nop $ea

          .case 4
          nop
          nop

          .case 5
          dec $2d

          .case 6
          nop $ea
          nop $ea

          .case 7
          dec $2d
          nop

          .case 8
          dec $2d
          nop $ea
          .case 9
          dec $2d
          nop
          nop

          .default
          .if 1 == \Cycles & 1
          ;; make sure we can't end up trying to sleep 1
          .Sleep 9
          .Sleep \Cycles - 9
          .else
          .Sleep 8
          .Sleep \Cycles - 8
          .fi
          .endswitch
          .fi
          .endm

        ;; Alternate sleep macro, which will use .x as a
        ;; countdown register. Exits with .x = 0
SleepX: .macro Cycles
          .block
        
          .if \Cycles < 10
          .Sleep \Cycles
          .else
          
          Loopable = \Cycles - 1
          .if ((* % $100) > $fe)
          ;; going to cross page boundary on branch
          ;; so each loop takes 6 cycles instead of 5
          LoopCycles = Loopable / 6
          ModuloCycles = Loopable % 6 + 1
          .else                 ; no page cross
          LoopCycles = Loopable / 5
          ModuloCycles = Loopable % 5
          .fi

          .if ModuloCycles < 2
          .SleepX \Cycles - 2
          nop

        .else
          
          ldx #LoopCycles       ; 2
SleepLoop:
          dex                   ; 2
          bne SleepLoop         ; 2 (3+)
          ;; so overhead of +2 for ldx, -1 for no final branch
          ;; net overhead of +1, with 5 cycles per loop
          ;; if page boundary (dex occurs on $Xfd, $Xfe, $Xff)
          ;; then each loop is 6 cycles.
          .Sleep ModuloCycles

        .fi
        .fi

        .bend
          .endm

;;; 
          
NoPageCrossSince:          .macro start
          .if (>(* - 1)) > (>\start)
          .error "Page crossing where not allowed, between ", \start, " and ", * - 1
          .fi
          .endm

;;; 

Push16 .macro address
          lda \address +1
          pha
          lda \address
          pha
          .endm

Pull16 .macro address
          pla
          sta \address
          pla
          sta \address +1
          .endm

Mov16 .macro target, source
          lda \source
          sta \target
          lda \source + 1
          sta \target + 1
          .endm

Set16 .macro target, value
          lda #<(\value)
          sta \target
          lda #>(\value)
          sta \target + 1
          .endm         
          
;;; 

Locale .macro ThisLang, string
          .if \ThisLang == LANG
          .MiniText \string
          .fi
          .endm
          
;;; 

StyAllGraphics:   .macro
          sty PF0
          sty PF1
          sty PF2
          sty ENABL
          sty ENAM0
          sty ENAM1
          sty GRP0
          sty GRP1
          sty NUSIZ0
          sty NUSIZ1
          sty VDELP0
          sty VDELP1
          .endm
          
ClearAllGraphics: .macro          
          ldy #0
          .StyAllGraphics
          .endm

sound:    .macro volume, control, frequency, duration, end
          .switch FramesPerSecond
          .case 60
          .byte (\volume << 4) | \control, \frequency | ( \end << 7 ), \duration
          .case 50
          .byte (\volume << 4) | \control, \frequency | ( \end << 7 ), ceil( (\duration / 60.0) * 50)
          .default
          .error "Unsupported frame rate: ", FramesPerSecond
          .endswitch
          .endm

TimeLines:          .macro lines
          SkipCycles = 76 * (\lines)
          .if ( (SkipCycles/64) <= $100 )
          lda # (SkipCycles/64) - 1
          sta TIM64T
          .else
          .error "Cannot skip ", \lines, " lines with TIM64T"
          .fi
          .endm
          
WaitScreenTop:      .macro
          jsr VSync
          .if TV == NTSC
          .TimeLines KernelLines - 1
          .else
          lda #$ff              ; 214.74 lines
          sta TIM64T
          .fi
          .endm

WaitScreenTopMinus: .macro NTSCMinus, PALMinus
          jsr VSync
          .if TV == NTSC
          .TimeLines KernelLines - \NTSCMinus
          .else
          .TimeLines 214 - \PALMinus
          .fi
          .endm

WaitForTimer:       .macro
-
          lda INSTAT
          bpl -
          .endm

WaitScreenBottom:      .macro
          jsr WaitScreenBottomSub
          .endm

WaitScreenBottomTail:      .macro
          jmp WaitScreenBottomSub
          .endm
;;; 
KillMusic:          .macro
          lda # 0
          sta AUDC1
          sta AUDV1
          sta AUDF1
          sta NoteTimer
          .endm
;;; 
FarJSR:   .macro bank, service
          .if \bank == BANK
          .error "Don't do FarJSR for the local bank for ", \service
          .fi
          ldy #\service
          ldx #\bank
          jsr FarCall
          .endm

FarJMP:   .macro bank, service
          .if \bank == BANK
          .error "Don't do FarJMP for the local bank for ", \service
          .fi
          ldy #\service
          ldx #\bank
          jmp FarCall
          .endm
;;; 
SetPointer:         .macro value
          lda #>\value
          sta Pointer + 1
          lda #<\value
          sta Pointer
          .endm
;;; 
SkipLines:          .macro length

          .if \length < 5

          .rept \length
          stx WSYNC
          .next

          .else

          ldx # \length
-
          stx WSYNC
          dex
          bne -

          .fi
          .endm
;;; 
BitBit:   .macro constant
          .switch \constant

          .case $01
          bit BitMask

          .case $02
          bit BitMask + 1

          .case $04
          bit BitMask + 2

          .case $08
          bit BitMask + 3

          .case $10
          bit BitMask + 4

          .case $20
          bit BitMask + 5

          .case $40
          bit BitMask + 6

          .case $80
          bit BitMask + 7

          .default
          .error "Constant is not a power-of-two bit value: ", \constant
          .endswitch
          .endm
;;; 
SetBitFlag:         .macro flag
          lda \flag
          lsr a
          lsr a
          lsr a
          tay
          lda \flag
          and #$07
          tax
          lda BitMask, x
          ora ProvinceFlags, y
          sta ProvinceFlags, y
          .endm

ClearBitFlag:       .macro flag
          lda \flag
          lsr a
          lsr a
          lsr a
          tay
          lda \flag
          and #$07
          tax
          lda BitMask, x
          eor #$ff
          and ProvinceFlags, y
          sta ProvinceFlags, y
          .endm
;;; 
SetUtterance:       .macro constant
          lda #>\constant
          sta CurrentUtterance + 1
          lda #<\constant
          sta CurrentUtterance
          .endm
