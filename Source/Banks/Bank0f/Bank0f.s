;;; Grizzards Source/Banks/Bank0f/Bank0f.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $0f

          .include "StartBank.s"

          .include "Source/Generated/Bank07/SpeakJetIDs.s"

          .include "Font.s"
          .include "FontExtended.s"
          .include "6BitCompression.s"
          .include "DecodeText.s"
          .include "Write12Chars.s"
          .include "Inquire.s"

          .include "AttractStory.s"
          .include "Death.s"
          .include "DrawMonsterGroup.s"
          .include "WinnerFireworks.s"
          .include "CheckForWin.s"
          .include "DrawGrizzard.s"

          .include "MonsterArt.s"
          .include "GrizzardImages.s"
          .include "GrizzardArt.s"
          .include "CombatSpriteTables.s"

          .include "48Pixels.s"
          .include "VSync.s"
          .include "VBlank.s"
          
          .include "Prepare48pxMobBlob.s"
          .include "Random.s"

DoLocal:
          cpy #ServiceWrite12Chars
          beq Write12Chars
          cpy #ServiceAttractStory
          beq AttractStory
          cpy #ServiceDeath
          beq Death
          cpy #ServiceDrawMonsterGroup
          beq DrawMonsterGroup
          cpy #ServiceFireworks
          beq WinnerFireworks
          cpy #ServiceDrawGrizzard
          beq DrawGrizzard
          cpy #ServiceInquire
          beq Inquire
          cpy #ServiceCheckForWin
          beq CheckForWin
          brk

          .include "EndBank.s"
