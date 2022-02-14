;;; Grizzards Source/Banks/Bank0e/Bank0e.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $0e

          .include "StartBank.s"

          .include "Source/Generated/Bank07/SpeakJetIDs.s"
          .include "48Pixels.s"

          .include "DrawBoss.s"
          .include "DrawMonsterGroup.s"

DoLocal:
          cpy #ServiceDrawBoss
          beq DrawBoss
          cpy #ServiceGetMonsterColors
          beq GetMonsterColors
          cpy #ServiceDrawMonsterGroup
          beq DrawMonsterGroup
          cpy #ServicePotion
          beq Potion
          brk

          .include "VSync.s"
          .include "VBlank.s"
          .include "Prepare48pxMobBlob.s"
          .include "AppendDecimalAndPrint.s"

          .include "Potion.s"

          .include "CopyPointerText.s"

ShowPointerText:
          jsr CopyPointerText
          ;; fall through
ShowText:
          .FarJMP TextBank, ServiceDecodeAndShowText

          .include "GetMonsterColors.s"

          .align $20           ; XXX alignment
          .include "CombatSpriteTables.s"
          .include "MonsterColors.s"
          .include "BossArt.s"
          .include "BossArt2.s"
          .include "MonsterArt.s"
          .include "MonsterArt2.s"

          .include "EndBank.s"

          
