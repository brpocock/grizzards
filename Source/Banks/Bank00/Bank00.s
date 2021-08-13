;;;
;;;
;;; *** GRIZZARDS ***
;;;
;;;
;;; Copyright © 2021, Bruce-Robert Pocock
;;;

          BANK = $00

          .include "StartBank.s"
          .include "Source/Generated/Bank07/SpeakJetIDs.s"

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
            .include "AtariAgeLogo.s"
            .align $100, 0
            .include "AtariAgeText.s"
          .else
            .include "BRPCredit.s"
            .align $100, 0
            .fill 66, 0            ; leave space for publisher name
          .fi

          .include "ShowPicture.s"

DoLocal:
          cpy #ServiceColdStart
          beq ColdStart
          cpy #ServiceSaveToSlot
          beq SaveToSlot
          cpy #ServicePeekGrizzard
          beq PeekGrizzard
          cpy #ServiceSaveGrizzard
          beq SaveGrizzard
          cpy #ServiceAttract
          beq Attract.WarmStart
          brk

	.include "ColdStart.s"
          ;; falls through to
          .include "DetectConsole.s"
          ;; falls through to
          .include "DetectGenesis.s"
          ;; falls through to
          .include "Attract.s"

          .if NOSAVE

          ;; Dummy out SaveKey routines
SaveToSlot:
SaveGrizzard:
          rts
PeekGrizzard:
          lda Temp
          cmp # 1
          beq +
          clc
          rts
+
          sec
          rts

          .include "BeginOrResume.s"

          .else
          
          .include "SaveToSlot.s"
          .include "PeekGrizzard.s"
          .include "SelectSlot.s"
          .include "LoadSaveSlot.s"
          .include "AtariVox-EEPROM-Driver.s"
          .include "CheckSaveSlot.s"
          .include "LoadGrizzardData.s"
          .include "LoadProvinceData.s"
          .include "SaveProvinceData.s"
          .include "EraseSlotSignature.s"
          .include "SetGrizzardAddress.s"
          .include "SaveGrizzard.s"

          .fi

          .include "Random.s"
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"
          .include "VSync.s"
          .include "VBlank.s"
          .include "Overscan.s"
          .include "PreambleAttracts.s"
          .include "AttractCopyright.s"
          .include "Credits.s"
          .include "CopyPointerText.s"
          .include "Bank0Strings.s"
          .include "WaitScreenBottom.s"

ShowPointerText:
          jsr CopyPointerText
          ;; fall through
ShowText:
          .FarJMP TextBank, ServiceDecodeAndShowText
Quit:
          ldy #ServiceColdStart
          jmp ColdStart

          .include "EndBank.s"
