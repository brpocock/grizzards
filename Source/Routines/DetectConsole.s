;;; Extracted from:
;;; Program:      Collect 3
;;; Program by:   Darrell Spice, Jr
;;; Last Update:  January 20, 2020
;;;
;;; More information available here:
;;; https://atariage.com/forums/forum/262-cdfj/

;;; Console Detection Routine
;;;
;;; By AtariAge user Batari —
;;; https://atariage.com/forums/topic/63710-detecting-the-console/?tab=comments#comment-819710
;;;
;;; normally we'd use CLEAN_START, but to detect if console is 2600 or 7800
;;; we need to take a look at the ZP RAM values in $80, $D0, and $D1 before
;;; zeroing out RAM
;;;
;;;   if $D0 contains $2C and $D1 contains $A9 then
;;;       system = 7800           // game was loaded from Harmony menu on a 7800
;;;   else if both contain $00 then
;;;       system = ZP RAM $80     // game was flashed to Harmony/Melody so CDFJ
;;;                               // driver checked $D0 and $D1 for us and saved
;;;                               // results in $80
;;;   else
;;;       system = 2600           // game was loaded from Harmony menu on a 2600

DetectConsole:      .block        
        ldy #0              ; assume system = 2600        
        ldx $d0
        beq confirmFlashed ; if $00 then game might be flashed on Harmony/Melody
        cpx #$2c
        bne is2600         ; if not $2C then loaded via Harmony Menu on 2600        
        ldx $d1
        cpx #$a9
        bne is2600
        dey                 ; 7800: y=$FF
        bne is7800           ; this will always branch
        
confirmFlashed:     
        ldx $d1
        bne is2600         ; if not $00 then loaded via Harmony Menu on 2600
        ldy $80             ; else get the value saved by the CDFJ driver

;;; end of console detection routine, y contains results

is2600:
          lda SWCHB
          and #~SWCHB7800
          jmp End

is7800:
          lda SWCHB
          ora #SWCHB7800
End:
          sta SWCHB
          ;; fall through to DetectGenesis
          .bend
