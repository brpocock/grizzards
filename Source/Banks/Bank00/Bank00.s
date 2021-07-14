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
          .include "SpeakJetIDs.s"

          .text "griz", 0       ; Magic cookie to identify file on Linux®
DoLocal:
          cpy #ServiceColdStart
          beq ColdStart
          cpy #ServiceSaveToSlot
          beq SaveToSlot
          brk

	.include "ColdStart.s"
          .include "SaveToSlot.s"

          .include "Random.s"
          .include "Attract.s"
          .include "SelectSlot.s"
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"
          .include "ShowPicture.s"
          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "AtariVox-EEPROM-Driver.s"
          .include "CheckSaveSlot.s"
          .include "LoadSaveSlot.s"
          .include "LoadGrizzardData.s"
          .include "LoadProvinceData.s"
          .include "SaveProvinceData.s"
          .include "EraseSlotSignature.s"
          .include "SetGrizzardAddress.s"
          .include "SaveGrizzard.s"
          .include "PreambleAttracts.s"
          .include "AttractCopyright.s"
          .include "Credits.s"
          .include "SetNextAlarm.s"

Quit:
          ldy #ServiceColdStart
          jmp ColdStart

          .align $100
          .include "Title1.s"
          .align $100, 0
          .include "Title2.s"
          .align $100, 0
          .include "Title3.s"
          .align $100, 0
          .if PUBLISHER
            .include "PublisherCredit.s"
            .include "PublisherName.s"
          .else
            .include "BRPCredit.s"
            .fill 66, 0            ; leave space for publisher name
          .fi

          .include "EndBank.s"
