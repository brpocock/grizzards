;;; Grizzards Source/Banks/Bank0d/Bank0d.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $0d

          .include "StartBank.s"

          .include "Source/Generated/Bank07/SpeakJetIDs.s"
          .include "6BitCompression.s"

          .include "BossBear.s"
          .align $100
          .include "BossBear2.s"
          .align $100
          .include "Grizzard0-0.s"
          .align $100
          .include "Grizzard0-1.s"
          .align $100
          .include "Grizzard1-0.s"
          .align $100
          .include "Grizzard1-1.s"
          .align $100
          .include "Grizzard2-0.s"
          .align $100
          .include "Grizzard2-1.s"

          .align $100
          .include "ShowPicture.s"
          .include "CopyPointerText.s"
          .include "CopyPointerText12.s"
          .include "ShowPointerText.s"
          .include "ShowPointerText12.s"

          .include "BeginNamePrompt.s"

          .include "Prepare48pxMobBlob.s"
          .include "Random.s"

          .include "ShowBossBear.s"

DoLocal:
          cpy #ServiceRevealBear
          beq RevealBear
          cpy #ServiceShowBossBear
          beq ShowBossBear
          cpy #ServiceDrawStarter
          beq DrawStarter
          cpy #ServiceBeginName
          beq BeginNamePrompt
          brk

          .include "DrawStarter.s"

          .include "VSync.s"
          .include "VBlank.s"
          .include "48Pixels.s"


BossText:
          .MiniText " BOSS "
BearText:
          .MiniText " BEAR "
          
          .include "RevealBear.s"

          .include "EndBank.s"
