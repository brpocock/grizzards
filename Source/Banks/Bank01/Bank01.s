          BANK = $01

          ;; Map Services Bank

	.include "StartBank.s"

          .include "VSync.s"
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"

DoLocal:
          cpy #ServiceTopOfScreen
          beq TopOfScreenService
          cpy #ServiceBottomOfScreen
	beq BottomOfScreenService
          cpy #ServiceFireworks
          beq WinnerFireworks
          brk

          .include "MapTopService.s"
          .include "MapBottomService.s"
          .include "WinnerFireworks.s"

	.include "EndBank.s"
