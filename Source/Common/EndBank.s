;;; Common logic at the end of every ROM bank.

EndBank:

          BankEndAddress = $ff20      ; keep this as high as possible
          ;; The magic number  above: you can just raise it  to, say,
          ;; $ff70,  and then  the assembler  will bitch  at you  about its
          ;; being too high, and tell you  what to lower it to. Careful,
          ;; though, this has to be more than any bank uses.
          .if (* > BankEndAddress) || (* < $f000)
          .error "Bank ", BANK, " overran ROM space (ending at ", *, ")"
          .fi

          .proff
          ;; Fill with cute junk
          .fill BankEndAddress - *, format("brp/grizzards/%d-%d-%d/", YEARNOW, MONTHNOW, DATENOW)
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

          .warn format("bank %d has %d bytes left (%.1f%%)", BANK, Wired - EndBank, ( (Wired - EndBank) * 100.0 / (Wired - $f000) ) )

;;; The "Wired memory" is present in every bank and must occupy exactly
;;; the same number of bytes.
;;; In addition, the ProSystem wants a 2600 signature here, and the
;;; triggers for bank switching appear overlain here as well.

          * = BankEndAddress
Wired:

;;; Bank-switching jump commands:

;;; Cold-start the system.
GoColdStart:
          BankJump ColdStart, ColdStartBank

;;; Jump to the SelectSlot routine. (Is this needed?)
GoSelectSlot:
          BankJump SelectSlot, ColdStartBank

;;; Go to the current map memory bank, and jump to DoMap.
;;; If we're not in a map memory bank after the bank switch,
;;; then we must not be in map mode (hopefully), so jump
;;; back to Dispatch.
          .weak
          DoMap = Dispatch
          .endweak
GoMap:
          ldx CurrentMapBank
          sta BankSwitch0, x
          jmp DoMap

;;; Go to the current combat memory bank, and jump to DoCombat.
;;; In non-combat banks, jump to Dispatch.
          .weak
          DoCombat = Dispatch
          .endweak
GoCombat:
          ldx CurrentCombatBank
          sta BankSwitch0, x
          jmp DoCombat

;;; Go to the current chat memory bank, and jump to DoChat.
;;; In non-chat banks, jump to Dispatch.
          .weak
          DoChat = Dispatch
          .endweak
GoChat:
          ldx CurrentChatBank
          sta BankSwitch0, x
          jmp DoChat

;;; Perform a far call to a memory bank with a specific local
;;; service routine to perform; eg, this is how we handle sounds
;;; and will be handling the VSync routines in the 2M version.
          .weak
          DoLocal = Dispatch
          .endweak
FarCall:
          lda #BANK
          pha
          sta BankSwitch0, x
          jmp DoLocal

;;; Return from a FarCall. In fact, jump to any address in any
;;; memory bank by stuffing the stack.
FarReturn:
          pla
          tax
          sta BankSwitch0, x
          rts

;;; BRK vector jumps to the routine Failure in Bank 0
;;; (the Sad Face routine)
Break:
          BankJump Failure, FailureBank

;;; Save and Quit
GoSaveAndQuit:
          BankJump SaveAndQuit, ColdStartBank

;;; The main "traffic cop" dispatch routine. Whenever a "kernel" is done
;;; doing its own thing, it can set GameMode and jump here to have a new
;;; kernel initialized to handle the next phase of the game.
Dispatch:
          lda GameMode
          and #$f0

          beq GoColdStart
          cmp #$10
          beq GoColdStart
          cmp #$20
          beq GoSelectSlot
          cmp #$30
          beq GoMap
          cmp #$40
          beq GoCombat
          jmp GoChat

;;; End of wired memory
WiredEnd:
          .if $ff80 < WiredEnd
          .error "Wired ROM ends at ", *, " ; must end before $ff80. Adjust start of wired ROM at top of EndBank.s to ", format("$%x", (Wired + $ff80 - *))
          .fi

          .if $ff70 > WiredEnd
          .warn "Wired memory could be moved up, ended at ", format("%x", WiredEnd), " but can end as late as $ff7f"
          .fi

;;; 
;;; This stuff is just set to make sure the ProSystem will drop to VCS
;;; compatibility mode for sure.

          * = $ff80
          .offs -$f000

          .fill ($fff7 - $ff80 + 1), 0        ; 7800 crypto key (designed to fail)

          * = $fff8
          .offs -$f000

;;; The KnownZeroInEveryBank allows pointer to point to a fixed zero,
;;; which has proven to be useful on occassion.

KnownZeroInEveryBank:
          .byte 0                                ; 7800 region code: no regions enabled
          .byte $f0                              ; 7800 recognition
          ;; on the 7800 this says ROM begins at $f000 (true) and
          ;; since 0 ≠ 7 we are not a 7800 tape (also true)

;;; Bank switch hotspots for F4 style bank switching that we're using for now.
          BankSwitch0 = $fff4
          BankSwitch1 = $fff5
          BankSwitch2 = $fff6
          BankSwitch3 = $fff7
          BankSwitch4 = $fff8
          BankSwitch5 = $fff9
          BankSwitch6 = $fffa
          BankSwitch7 = $fffb

;;; 6502 special vectors
;;;
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
