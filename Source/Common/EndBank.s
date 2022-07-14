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
            .error format ("Bank $%02x overran ROM space (ending at $%04x, ; must end by $%04x) (Config: %s)", BANK, *, BankEndAddress, ConfigPartNumber)
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
          sta BankSwitch0 + CombatBank0To63
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
          .BankJump Failure, FailureBank
;;; 
;;; The KnownZeroInEveryBank allows pointer to point to a fixed zero,
;;; which has proven to be useful on occassion.

Zero:
          .byte 0

          ;; Useful constants to save time bit-shifting. Used all over.
BitMask:
          .byte $01, $02, $04, $08, $10, $20, $40, $80

          .switch BANK
          .case 3,4,5,SpriteMapperBank
GoSpriteMapper:
            stx BankSwitch0 + SpriteMapperBank
          .endswitch
          .switch BANK
          .case 3,4,5
            jmp GoSpriteMapper
          .case SpriteMapperBank
            jmp SpriteMapper
          .endswitch

ReturnFromSpriteMapperToMap:
          ;; X register has the target ROM bank
          sta BankSwitch0, x
          .if DEMO
            .if 4 == BANK
              jmp Map.SpriteMapperReturn
            .else
              brk
              brk
              brk
            .fi
          .else
            .switch BANK
            .case 3,4,5
              jmp Map.SpriteMapperReturn
            .default
              brk
              brk
              brk
            .endswitch
          .fi

          ;; a tiny little routine that's used all over the place.
          ;; free up from some wasted space here.
          .if BANK != 7
            .include "WaitScreenBottom.s"
          .fi

          .if BANK != 7
            .if !DEMO || BANK != 5
              .if BANK < 8 || BANK >= 13
                .include "Overscan.s"
              .fi
            .fi
          .fi

;;; End of wired memory
WiredEnd:
          .if BankSwitch0 < WiredEnd || WiredEnd < $f000
            .error "Wired ROM ends at ", WiredEnd, " ; must end before ", BankSwitch0, ". Adjust start of wired ROM at top of EndBank.s to ", format("$%x", (BankEndAddress + (BankSwitch0 - WiredEnd)))
          .fi

          .if BankSwitch0 > WiredEnd
            .warn "Wired memory could be moved up, ended at ", *, " but can end as late as ", BankSwitch0, " wasting ", (BankSwitch0 - WiredEnd), ", move BankEndAddress up to ", format("$%x", (BankEndAddress + (BankSwitch0 - WiredEnd)))
          .fi

          .if DEMO

            ;; Bank switch hotspots for F4 style bank switching that we're using for the demo.
            BankSwitch0 = $fff4
            BankSwitch1 = $fff5
            BankSwitch2 = $fff6
            BankSwitch3 = $fff7
            BankSwitch4 = $fff8
            BankSwitch5 = $fff9
            BankSwitch6 = $fffa
            BankSwitch7 = $fffb

          .else

            ;; EF bank switching
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

          .if DEMO

            * = $fff4
            .text "grizbrp", 0

          .else

            * = $ffe0
            .text "grizbrp", 0
            ;; magic cookie for Stella
            nop $1fe0

          .fi

          .if ATARIAGESAVE

            ;; Save-to-cart hotspots
            * = $fff0
            ;;  SCL & SDA write lines, data irrelevant.
            ;;  Using this for Stella's benefit.
            .text "EFFB"
            ;; SDA reads return these values for 0/1 bits
            .byte 0, 1

            ;; for Stella's benefit
            * = $fff8
            .text "EFEF"
          .fi

;;; 6507 special vectors
;;;
          * = RESVEC             ; CPU reset and BRK (IRQ) vectors (no NMI)
          .word GoColdStart

          * = IRQVEC
          .word Break

          .if * != $0000
            .error "Bank ", BANK, " does not end at $ffff, but ", * - 1
          .fi

;;; Audited 2022-02-16 BRPocock

;;;
;;; Grizzards © 2021-2022 Bruce-Robert Pocock.
;;;

;;;
;;;
;;;  FINIS.
;;;
;;;
