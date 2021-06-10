;;; V   V  OOO  I  CCC  EEEEE
;;; V   V O   O I C   C E
;;; V   V O   O I C     EEE
;;;  V V  O   O I C   C E
;;;   V    OOO  I  CCC  EEEEE
;;;
;;;         of the
;;;
;;; EEEEE L     EEEEE M     M EEEEE N   N TTTTT  SSSS
;;; E     L     E     MM   MM E     NN  N   T   S
;;; EEE   L     EEE   M M M M EEE   N N N   T    SSS
;;; E     L     E     M  M  M E     N  NN   T       S
;;; EEEEE LLLLL EEEEE M     M EEEEE N   N   T   SSSS


          BANK = $00

          .weak
          PUBLISHER = false
          .endweak


	  .include "StartBank.s"

	  .include "ColdStart.s"
          .include "Attract.s"
          .include "SelectSlot.s"

          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"
          .include "ShowPicture.s"
          .include "ShowText.s"
          .include "StartNewGame.s"
          .include "VSync.s"
          .include "AtariVox-EEPROM-Driver.s"
          .include "CheckSaveSlot.s"
          .include "LoadSaveSlot.s"
          .include "EraseSlotSignature.s"
          .include "SaveToSlot.s"
          .include "PlaySpeech.s"

SaveAndQuit:
          jsr SaveToSlot
          lda #0
          sta GameMode
          jmp Dispatch

          .include "TitleSpeech.s"

          .align $100
          .include "Title1.s"
          .align $100
          .include "Title2.s"
          .align $100
          .include "Title3.s"
          .align $100
          .if PUBLISHER
            .include "PublisherCredit.s"
          .else
            .include "BRPCredit.s"
          .endif
          .align $100
          .include "Font.s"

          .include "EndBank.s"
