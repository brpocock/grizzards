;;; Grizzards Source/Banks/Bank0e/Bank0e.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $0e

          .include "StartBank.s"
          .include "SpeakJetIDs.s"
          .include "SpeakJetIndex.s"

DoLocal:
          cpy #ServiceGrizzardEvolution
          beq GrizzardEvolution
          cpy #ServiceDeath
          beq Death
          cpy #ServiceDrawBoss
          beq DrawBoss
          brk

          .include "VSync.s"
          .include "VBlank.s"
          .include "Random.s"
          .include "48Pixels.s"
          .include "ShowPicture.s"
          .include "Prepare48pxMobBlob.s"
          .include "GrizzardEvolution.s"

          .include "FinalSpeech.s"

          .include "Death.s"

          .include "DrawBoss.s"

          .include "PlaySpeech.s"

          .include "CopyPointerText.s"

          .include "GrizzardsSpeech.s"

ShowPointerText:
          jsr CopyPointerText
          ;; fall through
ShowText:
          .FarJMP TextBank, ServiceDecodeAndShowText

          .include "BossArt.s"
          .include "BossArt2.s"

          .align $100
          .include "BossBearDies.s"

          .include "EndBank.s"
