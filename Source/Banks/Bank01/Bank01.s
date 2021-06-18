          BANK = $01

          .include "StartBank.s"

          .include "48Pixels.s"
          .include "VSync.s"
          .include "PlaySpeech.s"
          .include "Prepare48pxMobBlob.s"

DoLocal:  
          rts

          .align $100
          .include "Font.s"
          .include "EndBank.s"
