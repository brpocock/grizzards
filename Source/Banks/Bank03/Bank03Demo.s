;;; Grizzards Source/Banks/Bank03/Bank03Demo.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          .include "Source/Generated/Bank07/SpeakJetIDs.s"

          .include "Font.s"
          .include "FontExtended.s"
          .include "CombatSpriteTables.s"
          .include "6BitCompression.s"
          .include "DecodeText.s"
          .include "Write12Chars.s"
          .align $40            ; XXX alignment
          .include "Prepare48pxMobBlob.s"
          .fill $20            ; XXX alignment
          .include "DrawMonsterGroup.s"

          .include "Inquire.s"

          .include "AttractStory.s"
          .include "Death.s"
          .include "DrawGrizzard.s"

          .include "48Pixels.s"
          .include "VSync.s"
          .include "VBlank.s"

          .include "CombatVBlank.s"
          
          .include "Random.s"

          .align $80            ; XXX alignment
          .include "BeginNamePrompt.s"
          
          .include "DemoDrawBoss.s"

          .include "CopyPointerText.s"
          .include "ShowPointerText.s"

DoLocal:
          cpy #ServiceCombatVBlank
          beq CombatVBlank

          cpy #ServiceWrite12Chars
          beq Write12Chars

          cpy #ServiceAttractStory
          beq AttractStory

          cpy #ServiceDeath
          beq Death

          cpy #ServiceDrawMonsterGroup
          beq DrawMonsterGroup

          cpy #ServiceDrawGrizzard
          beq DrawGrizzard

          cpy #ServiceInquire
          beq Inquire

          cpy #ServiceBeginName
          beq BeginNamePrompt

          cpy #ServiceDrawBoss
          beq DemoDrawBoss

          brk

          .include "MonsterArt.s"
          .include "GrizzardImages.s"
          .include "GrizzardArt.s"

