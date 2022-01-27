;;; Grizzards Source/Common/EndBank.s
;;; Copyright © 2021-2022, Bruce-Robert Pocock
;;; Common logic at the end of every ROM bank.

EndBank:

          .if DEMO
          BankEndAddress = $ff4c      ; keep this as high as possible
          .else
          BankEndAddress = $ff3a      ; keep this as high as possible
          .fi
          ;; The magic number  above: you can just raise it  to, say,
          ;; $ff70,  and then  the assembler  will bitch  at you  about its
          ;; being too high, and tell you  what to lower it to. Careful,
          ;; though, this has to be more than any bank uses.
          .if (* > BankEndAddress) || (* < $f000)
          .error "Bank ", BANK, " overran ROM space (ending at ", *, "; must end by ", BankEndAddress, ")" 
          .fi

          .proff
          ;; Fill with cute junk
          .enc "Unicode"
          .fill BankEndAddress - *, format("%d-%d-%d%chttps://star-hope.org/games/Grizzards%c", YEARNOW, MONTHNOW, DATENOW, 0, 0)
          .enc "none"
          .pron

BankJump: .macro label, bank
          .block
BankSwitch:
          stx BankControl

          .if BANK == \bank
          jmp \label
          .else
          jmp BankSwitch             ; try again if didn't switch fast enough
          .fi
          .bend
          .endm

          .warn format("bank %d ends at %x with %d bytes left (%.1f%%)", BANK, EndBank, BankEndAddress - EndBank, ( (Wired - EndBank) * 100.0 / (BankEndAddress - $f000) ) )

;;; The "Wired memory" is present in every bank and must occupy exactly
;;; the same number of bytes.
;;; In addition, the ProSystem wants a 2600 signature here, and the
;;; triggers for bank switching appear overlain here as well.

          * = BankEndAddress
Wired:

;;; Bank-switching jump commands:

;;; Cold-start the system.
GoColdStart:
          ldy # ServiceColdStart
          BankJump ColdStart, ColdStartBank

;;; Go to the current map memory bank, and jump to DoMap.
GoMap:
          ldx #$ff              ; smash the stack
          txs
          
          .if DEMO

          sta BankControl
          jmp DoLocal

          .else

          lda CurrentProvince
          bne +
          lda #Province0MapBank
          gne GoGoMap
+
          cmp #2
          beq +
          lda #Province1MapBank
          gne GoGoMap
+
          lda #Province2MapBank
GoGoMap:
          sta BankControl
          jmp DoLocal

          .fi

;;; Go to the current combat memory bank, and jump to DoCombat.
GoCombat:
          ldx #$ff              ; smash the stack
          txs
          lda #CombatBank0To127
          sta BankControl
          jmp DoLocal

;;; Perform a far call to a memory bank with a specific local
;;; service routine to perform; eg, this is how we handle sounds,
;;; text displays, and the common map header and footer code;
;;; anything that does not need data from the local ROM bank.
;;; Note that the total time for jump includes dispatching the
;;; particular service routine that was selected, so this can be
;;; somewhat slow.
FarCall:
          lda #BANK
          pha
          stx BankControl
          jsr DoLocal
          ;; fall through after rts

;;; Return from a FarCall. In fact, jump to any address in any
;;; memory bank by stuffing the stack.
FarReturn:
          pla
          tax
          stx BankControl
          rts

;;; BRK vector jumps to the routine Failure
;;; (the Sad Face routine)
Break:
          lda # BANK
          pha
          BankJump Failure, FailureBank

;;; End of wired memory
WiredEnd:
          .if $ff80 < WiredEnd
          .error "Wired ROM ends at ", *, " ; must end before $ff80. Adjust start of wired ROM at top of EndBank.s to ", format("$%x", (Wired + ($ff80 - WiredEnd)))
          .fi

          .if $ff70 > WiredEnd
          .warn "Wired memory could be moved up, ended at ", format("%x", WiredEnd), " but can end as late as $ff7f"
          .fi

;;; 
;;; This stuff is just set to make sure the ProSystem will drop to VCS
;;; compatibility mode for sure.
          * = $ff80
          .offs -$f000

          ;; Useful constants to save time bit-shifting. Used all over.
BitMask:
          .byte $01, $02, $04, $08, $10, $20, $40, $80
          ;; Also fairly useful.
InvertedBitMask:
          .byte ~$01, ~$02, ~$04, ~$08, ~$10, ~$20, ~$40, ~$80

          ;; a tiny little routine that's used all over the place.
          ;; free up from some wasted space here.
          .if BANK != 7
          .include "WaitScreenBottom.s"
          .fi

          .if BANK != 7
          .if !DEMO || BANK != 5
          .if BANK < 8 || BANK >= 14
          .include "Overscan.s"
          .fi
          .fi
          .fi
          
          .fill ($fff7 - * + 1), 0        ; 7800 crypto key (designed to fail)

;;; The KnownZeroInEveryBank allows pointer to point to a fixed zero,
;;; which has proven to be useful on occassion.

KnownZeroInEveryBank:
          .byte 0                                ; 7800 region code: no regions enabled
          .byte $f0                              ; 7800 recognition
          ;; on the 7800 this says ROM begins at $f000 (true) and
          ;; since 0 ≠ 7 we are not a 7800 tape (also true)

;;; Bank switch control port for F9 style bank switching
          BankControl = $fff9

;;; 6502 special vectors
;;;
          * = NMIVEC
          .offs -$f000
          .word GoColdStart

          * = RESVEC             ; CPU reset and BRK (IRQ) vectors (no NMI)
          .offs -$f000
          .word GoColdStart

          * = IRQVEC
          .offs -$f000
          .word Break

          .if * != $0000
          .error "Bank ", BANK, " does not end at $ffff, but ", * - 1
          .fi


;;;
;;; Grizzards © 2021-2022 Bruce-Robert Pocock.
;;;

;;;
;;;
;;;  FINIS.
;;;
;;;
