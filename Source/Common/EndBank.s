;;; Common logic at the end of every ROM bank.

EndBank:

          .if DEMO
          BankEndAddress = $ff48      ; keep this as high as possible
          .else
          BankEndAddress = $ff34      ; keep this as high as possible
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
          .fill BankEndAddress - *, format("%d-%d-%d;github:brpocock/grizzards;", YEARNOW, MONTHNOW, DATENOW)
          .pron

BankJump: .macro label, bank
          .block
BankSwitch:
          sta BankSwitch0 + \bank

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

          sta BankSwitch0 + Province0MapBank
          jmp DoLocal

          .else

          lda CurrentProvince
          bne +
          sta BankSwitch0 + Province0MapBank
          jmp DoLocal
+
          cmp #2
          beq +
          sta BankSwitch0 + Province1MapBank
          jmp DoLocal
+
          sta BankSwitch0 + Province2MapBank
          jmp DoLocal

          .fi

;;; Go to the current combat memory bank, and jump to DoCombat.
GoCombat:
          ldx #$ff              ; smash the stack
          txs
          sta BankSwitch0 + CombatBank0To127
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
          sta BankSwitch0, x
          jsr DoLocal

;;; Return from a FarCall. In fact, jump to any address in any
;;; memory bank by stuffing the stack.
FarReturn:
          pla
          tax
          sta BankSwitch0, x
          rts

;;; BRK vector jumps to the routine Failure
;;; (the Sad Face routine)
Break:
          lda # BANK
          pha
          BankJump Failure, FailureBank

;;; Save and Quit
GoQuit:
          BankJump Attract.WarmStart, ColdStartBank

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

BitMask:
          .byte $01, $02, $04, $08, $10, $20, $40, $80
          
          .fill ($fff7 - * + 1), 0        ; 7800 crypto key (designed to fail)

          .if DEMO
          
          * = $fff4
          .offs -$f000

          .text "grizbrp", 0

          .else

          * = $ffe0
          .offs -$f000

          .text "grizbrp", 0
          .switch STARTER
          .case 0
          .text "dirtex", 0, 0
          .case 1
          .text "aquax", 0, 0, 0
          .case 2
          .text "airex", 0, 0, 0
          .endswitch

          .fi

;;; The KnownZeroInEveryBank allows pointer to point to a fixed zero,
;;; which has proven to be useful on occassion.

KnownZeroInEveryBank:
          .byte 0                                ; 7800 region code: no regions enabled
          .byte $f0                              ; 7800 recognition
          ;; on the 7800 this says ROM begins at $f000 (true) and
          ;; since 0 ≠ 7 we are not a 7800 tape (also true)

;;; Bank switch hotspots for F4 style bank switching that we're using for now.
          .if DEMO
          
          BankSwitch0 = $fff4
          BankSwitch1 = $fff5
          BankSwitch2 = $fff6
          BankSwitch3 = $fff7
          BankSwitch4 = $fff8
          BankSwitch5 = $fff9
          BankSwitch6 = $fffa
          BankSwitch7 = $fffb

          .else

          BankSwitch0 = $ffe0
          BankSwitch1 = $ffe1
          BankSwitch2 = $ffe2
          BankSwitch3 = $ffe3
          BankSwitch4 = $ffe4
          BankSwitch5 = $ffe5
          BankSwitch6 = $ffe6
          BankSwitch7 = $ffe7
          BankSwitch8 = $ffe8
          BankSwitch9 = $ffe9
          BankSwitchA = $ffea
          BankSwitchB = $ffeb
          BankSwitchC = $ffec
          BankSwitchD = $ffed
          BankSwitchE = $ffee
          BankSwitchF = $ffef

          .fi

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
;;; Grizzards © 2021 Bruce-Robert Pocock.
;;;

;;;
;;;
;;;  FINIS.
;;;
;;;
