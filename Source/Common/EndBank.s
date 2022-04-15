;;; Grizzards Source/Common/EndBank.s
;;; Copyright © 2021-2022, Bruce-Robert Pocock
;;; Common logic at the end of every ROM bank.

EndBank:

          .if DEMO
            BankEndAddress = $ff76      ; keep this as high as possible
          .else
            BankEndAddress = $ff4e      ; keep this as high as possible
          .fi
          .if (* > BankEndAddress) || (* < $f000)
            .error "Bank ", BANK, " overran ROM space (ending at ", *, "; must end by ", BankEndAddress, ")"
          .else
            .warn format("bank %d ends at %x with %d bytes left (%.1f%%)", BANK, EndBank, BankEndAddress - EndBank, ( (Wired - EndBank) * 100.0 / (BankEndAddress - $f000) ) )
          .fi
;;; 
          .proff
          ;; Fill with cute junk
            .enc "Unicode"
            .fill BankEndAddress - *, format("%d-%d-%d%chttps://star-hope.org/games/Grizzards%c", YEARNOW, MONTHNOW, DATENOW, 0, 0)
            .enc "none"
          .pron
;;; 
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
;;; 

;;; The "Wired memory" is present in every bank and must occupy exactly
;;; the same number of bytes.
;;; In addition, the ProSystem wants a 2600 signature here, and the
;;; triggers for bank switching appear overlain here as well.

          * = BankEndAddress
Wired:

;;; Bank-switching jump commands:

;;; Cold-start the system.
GoColdStart:
          .BankJump ColdStart, ColdStartBank

;;; Go to the current map memory bank, and jump to DoMap.
GoMap:
          .mvx s, #$ff              ; smash the stack

          .if DEMO

            sta BankSwitch0 + Province0MapBank
            jmp DoLocal

          .else

            lda CurrentProvince
            bne +
            sta BankSwitch0 + Province0MapBank
            jmp DoLocal
+
            cmp # 2
            beq +
            sta BankSwitch0 + Province1MapBank
            jmp DoLocal
+
            sta BankSwitch0 + Province2MapBank
            jmp DoLocal

          .fi

;;; Go to the current combat memory bank, and jump to DoCombat.
GoCombat:
          .mvx s, #$ff              ; smash the stack
          sta BankSwitch0 + CombatBank0To127
          jmp DoLocal

GoWarmStart:
          ldy # ServiceWarmStart
          ldx # ColdStartBank
          ;; fall through
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
          ;; fall through after rts

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
;;; 
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
              .if BANK < $08 || BANK > $15
                .include "Overscan.s"
              .fi
            .fi
          .fi

;;; The KnownZeroInEveryBank allows pointer to point to a fixed zero,
;;; which has proven to be useful on occassion.

Zero:
          .byte 0

;;; End of wired memory
WiredEnd:
          .if BankSwitch0 < WiredEnd || WiredEnd < $f000
            .error "Wired ROM ends at ", WiredEnd, " ; must end before ", BankSwitch0, ". Adjust start of wired ROM at top of EndBank.s to ", format("$%x", (BankEndAddress + (BankSwitch0 - WiredEnd)))
          .fi

          .if BankSwitch0 > WiredEnd
            .warn "Wired memory could be moved up, ended at ", *, " but can end as late as ", BankSwitch0, " wasting ", (BankSwitch0 - WiredEnd), ", move BankEndAddress up to ", format("$%x", (BankEndAddress + (BankSwitch0 - WiredEnd)))
          .fi

          .if !DEMO

          ;; magic cookie for Stella
          * = $fff8
          .offs -$f000

          .text "dfdf"

          .fi

          .if DEMO

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

          BankSwitch0 = $ffc0
          BankSwitch1 = $ffc1
          BankSwitch2 = $ffc2
          BankSwitch3 = $ffc3
          BankSwitch4 = $ffc4
          BankSwitch5 = $ffc5
          BankSwitch6 = $ffc6
          BankSwitch7 = $ffc7
          BankSwitch8 = $ffc8
          BankSwitch9 = $ffc9
          BankSwitchA = $ffca
          BankSwitchB = $ffcb
          BankSwitchC = $ffcc
          BankSwitchD = $ffcd
          BankSwitchE = $ffce
          BankSwitchF = $ffcf
          BankSwitch10 = $ffd0
          BankSwitch11 = $ffd1
          BankSwitch12 = $ffd2
          BankSwitch13 = $ffd3
          BankSwitch14 = $ffd4
          BankSwitch15 = $ffd5
          BankSwitch16 = $ffd6
          BankSwitch17 = $ffd7
          BankSwitch18 = $ffd8
          BankSwitch19 = $ffd9
          BankSwitch1A = $ffda
          BankSwitch1B = $ffdb
          BankSwitch1C = $ffdc
          BankSwitch1D = $ffdd
          BankSwitch1E = $ffde
          BankSwitch1F = $ffdf

          .fi

;;; 6507 special vectors
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
