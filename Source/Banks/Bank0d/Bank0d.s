;;; Grizzards Source/Banks/Bank0d/Bank0d.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $0d

          .include "StartBank.s"

          .include "Source/Generated/Bank07/SpeakJetIDs.s"
          .include "6BitCompression.s"

          .include "Font.s"
          .include "FontExtended.s"

          .include "DecodeText.s"

          .include "CopyPointerText.s"

ShowPointerText:
          jsr CopyPointerText
          .FarJMP TextBank, ServiceDecodeAndShowText ; tail call

          .include "BeginNamePrompt.s"

          .include "Prepare48pxMobBlob.s"
          .include "Random.s"

DoLocal:
          cpy #ServiceDrawStarter
          beq DrawStarter
          cpy #ServiceBeginName
          beq BeginNamePrompt
          cpy #ServiceUnerase
          cpy #ServiceConfirmErase
          cpy #ServiceDrawBoss
          brk

          .include "DrawStarter.s"
          .include "ShowPicture.s"
          .include "VSync.s"
          .include "VBlank.s"
          .include "48Pixels.s"

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


          .include "EndBank.s"
