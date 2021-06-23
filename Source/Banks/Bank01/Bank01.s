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
          cpy #ServiceDrawMonsterGroup
          beq DrawMonsterGroup
          brk

          .include "MapTopService.s"
          .include "MapBottomService.s"
          .include "DrawMonsterGroup.s"
          .include "WinnerFireworks.s"
          .include "MonsterArt.s"
          .include "CombatSpriteTables.s"

	.include "EndBank.s"
