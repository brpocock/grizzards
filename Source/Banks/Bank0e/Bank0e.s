;;; Grizzards Source/Banks/Bank0e/Bank0e.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $0e

          .include "StartBank.s"
          .include "SpeakJetIndex.s"

          .include "RevealBear.s"

DoLocal:
          cpy #ServiceRevealBear
          beq RevealBear
          cpy #ServiceFireworks
          beq WinnerFireworks
          cpy #ServiceShowBossBear
          beq ShowBossBear
          brk

          .include "VSync.s"
          .include "VBlank.s"
          .include "Random.s"
          .include "48Pixels.s"
          .include "ShowPicture.s"
          .include "Prepare48pxMobBlob.s"

          .include "FinalText.s"
          .include "BossBear.s"
          .include "ShowBossBear.s"
          .include "BossBearDies.s"
          .include "Fireworks.s"
          .include "WinnerFireworks.s"

          .include "PlaySpeech.s"

          .include "CopyPointerText.s"
          .include "CopyPointerText12.s"

ShowPointerText:
          jsr CopyPointerText
          ;; fall through
ShowText:
          .FarJMP TextBank, ServiceDecodeAndShowText

ShowPointerText12:
          jsr CopyPointerText12
          ;; fall through
ShowText12:
          .FarJMP AnimationsBank, ServiceWrite12Chars

BossText:
          .MiniText " BOSS "
BearText:
          .MiniText " BEAR "
          
          .include "EndBank.s"
