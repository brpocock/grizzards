;;; Grizzards Source/Routines/ColdStart.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

;;; Cold start routines
;;;
;;; This routine is called once at startup, and must be in Bank 0.
;;;
;;; It must never be called again, or you'll lose '7800 detection.

ColdStart:         .block
          sei
          cld
          ;; On cold start, on a real 6507, .S = $fd, but 
          ;; on a 7800, or some knockoffs maybe, .S = $ff. By
          ;; stashing the low bit, we can adjust things for
          ;; the 2600 or not. Stash the stack pointer in .X here…
          ;; 
          ;; Note:  we're not  actually  using that  now, the  zero-page
	;; console detection routine should be more reliable according to
	;; common wisdom around the AtariAge boards.
          ;;;; tsx

          lda # 0
          ldy #$2c              ; reset TIA
ZeroTIALoop:
          sta 0, y
          dey
          bne ZeroTIALoop

          lda #ENABLED          ; turn off display
          sta VSYNC
          sta VBLANK

          sty SWACNT            ; Y = 0
          sty SWBCNT

          sty SystemFlags
	
ResetStack:
          .mvx s, #$ff

          inx                   ; X = 0
          stx GameMode
          
          ;; Fall through to DetectConsole
	.bend

;;; Audited 2022-02-16 BRPocock
