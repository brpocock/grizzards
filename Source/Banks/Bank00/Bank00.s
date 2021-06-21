;;;
;;; 
;;; *** GRIZZARDS ***
;;; 
;;;
;;; Copyright © 2021, Bruce-Robert Pocock
;;; 

          BANK = $00

          .weak
          PUBLISHER = false
          .endweak

	.include "StartBank.s"

DoLocal:
          cpy #ServiceColdStart
          beq ColdStart
          cpy #ServiceSaveToSlot
          beq SaveToSlot
          brk

	.include "ColdStart.s"
          .include "SaveToSlot.s"

          .include "Attract.s"
          .include "SelectSlot.s"
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"
          .include "ShowPicture.s"
          .include "StartNewGame.s"
          .include "VSync.s"
          .include "AtariVox-EEPROM-Driver.s"
          .include "CheckSaveSlot.s"
          .include "LoadSaveSlot.s"
          .include "EraseSlotSignature.s"
          .include "PlaySpeech.s"

SaveAndQuit:
          jsr SaveToSlot
          lda #0
          sta GameMode
          jmp ColdStart

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

          .include "EndBank.s"
