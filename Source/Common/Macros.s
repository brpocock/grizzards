;;;
;;; Copyright © 2016,2017,2020 Bruce-Robert Pocock (brpocock@star-hope.org)
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
          .if ((* % $100) >= $fb) && ((* % 100) <= $fd)
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
