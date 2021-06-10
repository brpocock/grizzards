	  BANK = $03

          ;; Map Services Bank

	  .include "StartBank.s"

          .include "VSync.s"
          .include "Prepare48pxMobBlob.s"
          .include "48Pixels.s"
          .align $100
          .include "Font.s"
          .include "ShowText.s"

DoLocal:
          cpy #0
          beq TopOfScreenService
          jmp BottomOfScreenService


          .include "MapTopService.s"
          .include "MapBottomService.s"

ProvinceBanks:
          .byte $04             ; Only one province in demo

	  .include "EndBank.s"
