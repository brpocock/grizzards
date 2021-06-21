	  BANK = $03

          ;; Map Services Bank

	  .include "StartBank.s"

          .include "VSync.s"
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"

DoLocal:
          cpy #ServiceTopOfScreen
          beq TopOfScreenService
          jmp BottomOfScreenService


          .include "MapTopService.s"
          .include "MapBottomService.s"

ProvinceBanks:
          .byte $04             ; first province = bank 4
          .byte $01             ; second province = bank 1

	  .include "EndBank.s"
