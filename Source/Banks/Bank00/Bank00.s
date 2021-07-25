;;;
;;;
;;; *** GRIZZARDS ***
;;;
;;;
;;; Copyright © 2021, Bruce-Robert Pocock
;;;

          BANK = $00

          .include "StartBank.s"
          .include "SpeakJetIDs.s"

;;; Start with page-aligned bitmaps
          .include "Title1.s"
          .align $100, 0

          .switch STARTER
          .case 0
          .include "Grizzard0-0.s"
          .align $100, 0
          .include "Grizzard0-1.s"
          Title2=Grizzard00
          Title3=Grizzard01

          .case 1
          .include "Grizzard1-0.s"
          .align $100, 0
          .include "Grizzard1-1.s"
          Title2=Grizzard10
          Title3=Grizzard11

          .case 2
          .include "Grizzard2-0.s"
          .align $100, 0
          .include "Grizzard2-1.s"
          Title2=Grizzard20
          Title3=Grizzard21

          .default
          .error "STARTER ∈ (0 1 2), not ", STARTER
          .endswitch

          .align $100, 0
          .if PUBLISHER
            .include "PublisherCredit.s"
            .include "PublisherName.s"
          .else
            .include "BRPCredit.s"
            .fill 66, 0            ; leave space for publisher name
          .fi

          .include "ShowPicture.s"

DoLocal:
          cpy #ServiceColdStart
          beq ColdStart
          cpy #ServiceSaveToSlot
          beq SaveToSlot
          brk

	.include "ColdStart.s"
          ;; falls through to
          .include "DetectConsole.s"
          ;; falls through to
          .include "Attract.s"

          .include "SaveToSlot.s"

          .include "Random.s"
          .include "SelectSlot.s"
          .include "LoadSaveSlot.s"
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"
          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "AtariVox-EEPROM-Driver.s"
          .include "CheckSaveSlot.s"
          .include "LoadGrizzardData.s"
          .include "LoadProvinceData.s"
          .include "SaveProvinceData.s"
          .include "EraseSlotSignature.s"
          .include "SetGrizzardAddress.s"
          .include "SaveGrizzard.s"
          .include "PreambleAttracts.s"
          .include "AttractCopyright.s"
          .include "Credits.s"
          .include "CopyPointerText.s"
          .include "SetNextAlarm.s"
          .include "Bank0Strings.s"

ShowPointerText:
          jsr CopyPointerText
          ;; fall through
ShowText:
          .FarJMP TextBank, ServiceDecodeAndShowText
Quit:
          ldy #ServiceColdStart
          jmp ColdStart

          .include "EndBank.s"
