;;; Grizzards Source/Routines/ColdStart.s
;;; Copyright © 2021 Bruce-Robert Pocock
;;; Cold start routines
;;;
;;; This routine is called once at startup, and must be in Bank 0.
;;;
;;; After a Game Over, this may be called again to return to the title
;;; screen with a full reset.
ColdStart:
	.block
          sei
          cld
          ;; On cold start, on a real 6507, .S = $fd, but 
          ;; on a 7800, or some knockoffs maybe, .S = $ff. By
          ;; stashing the low bit, we can adjust things for
          ;; the 2600 or not. Stash the stack pointer in .X here…
          tsx
          lda #ENABLED          ; turn off display, and
          sta VSYNC
          sta VBLANK
          ldy #0                ; clear sound so we don't squeak
          sty AUDC0
          sty AUDC1
          sty AUDV0             ; (I hear it's really bad squeaky on SECAM?)
          sty AUDV1

          sty SWACNT
          
          ;; only set inputs on the bits that we can actually read
          ;; AKA the “Combat flags trick”
          .if TV == SECAM
          lda # $ff - (SWCHBReset | SWCHBSelect | SWCHBP0Advanced | SWCHBP1Advanced)
          .else
          lda # $ff - (SWCHBReset | SWCHBSelect | SWCHBColor | SWCHBP0Advanced | SWCHBP1Advanced)
          .fi
          sta SWBCNT
	
ResetStack:
          ldx #$ff
          txs

          ldx #0
          stx GameMode
          
          ;; Fall through to DetectConsole
	.bend
