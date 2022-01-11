;;; Grizzards Source/Banks/Bank17/Bank17.s
;;; Copyright © 2021-2022, Bruce-Robert Pocock

          BANK = $17

          ;; Combat for encounters $40 … $7f

          .include "StartBank.s"
          .include "Prepare48pxMobBlob.s"
          .include "6BitCompression.s"
          .include "Source/Generated/Bank07/SpeakJetIDs.s"

          MonsterPhrase = Phrase_Monster7_0

DoVBlankWork:
          .include "CombatVBlank.s"
DoLocal:
          .include "CombatSetup.s"
          ;; falls through to:
          .FarJSR TextBank, ServiceCombatIntro
          ;; on return, falls through to:
          .include "CombatMainScreen.s"

          .include "GrizzardStatsScreen.s"
          .include "CombatAnnouncementScreen.s"
          .include "ExecuteCombatMove.s"
          .include "FindHighBit.s"
          .include "CopyPointerText.s"
          .include "ShowMonsterName.s"

          .include "VSync.s"
          .include "VBlank.s"
          
          .include "Random.s"
          .include "48Pixels.s"
          .include "MoveEffects.s"

          .include "Combat17.s"
          .include "Monsters17.s"
          .include "MonsterMoves17.s"
          

          .include "EndBank.s"
