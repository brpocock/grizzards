;;;
;;;
;;; *** GRIZZARDS ***
;;;
;;;
;;; Copyright © 2021-2022, Bruce-Robert Pocock
;;;

;;; Source/Banks/Bank00/Bank00.s

          BANK = $00

          .include "StartBank.s"
          .include "Source/Generated/Bank07/SpeakJetIDs.s"

;;; Start with page-aligned bitmaps
          .include "Title1.s"

          .if DEMO
            .align $100
            .include "Source/Generated/Bank0d/Grizzard1-0.s"
            .align $100
            .include "Source/Generated/Bank0d/Grizzard1-1.s"
            Title2=Grizzard10
            Title3=Grizzard11
          .fi

          .align $100
          .if PUBLISHER
            .include "AtariAgeLogo.s"
            .align $100
            .include "AtariAgeText.s"
          .else
            .include "BRPCredit.s"
            .align $100
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

          .if !DEMO
            cpy #ServicePeekGrizzardXP
            beq PeekGrizzardXP
          .fi

          cpy #ServiceSaveGrizzard
          beq SaveGrizzard

          cpy #ServiceAttract
          beq Attract.WarmStart

          .if !NOSAVE
            cpy #ServiceLoadGrizzard
            beq LoadGrizzardData

            cpy #ServiceSetCurrentGrizzard
            beq SetCurrentGrizzard
          .fi

          .if !DEMO
            cpy #ServiceSaveProvinceData
            beq SaveProvinceData

            cpy #ServiceLoadProvinceData
            beq LoadProvinceData

            cpy #ServiceChooseGrizzard
            beq GrizzardChooser

            cpy #ServiceConfirmNewGame
            beq ConfirmNewGame
          .fi

          brk

          ;; falls through to
	.include "ColdStart.s"
          ;; falls through to
          .include "DetectConsole.s"
          ;; falls through to
          .include "DetectGenesis.s"
          ;; falls through to
          .include "Attract.s"

          .if NOSAVE

            ;; Dummy out SaveKey routines
SaveToSlot:                     ; NOSAVE
SaveGrizzard:                   ; NOSAVE
            rts
PeekGrizzard:                   ; NOSAVE
            lda Temp
            cmp # 1
            beq +
            clc
            rts
+
            sec
            rts

            .include "BeginOrResume.s"

          .else                 ; Not the NOSAVE build

            .include "SaveToSlot.s"
            .include "PeekGrizzard.s"
            .if !DEMO
              .include "PeekGrizzardXP.s"
            .fi
            .include "SelectSlot.s"
            .include "LoadSaveSlot.s"

            .if ATARIAGESAVE
              .include "AtariAgeSave-EEPROM-Driver.s"
            .else
              .include "AtariVox-EEPROM-Driver.s"
            .fi

            .include "CheckSaveSlot.s"
            .include "LoadGrizzardData.s"
            .include "LoadProvinceData.s"
            .include "SaveProvinceData.s"
            .include "EraseSlotSignature.s"
            .include "SetGrizzardAddress.s"
            .include "SaveGrizzard.s"
            .include "SetCurrentGrizzard.s"

          .fi

          .if DEMO
            .include "DrawStarter.s"
          .else
            .include "GrizzardChooser.s"
            .include "ConfirmNewGame.s"
            .include "Unerase.s"
          .fi

          .include "Random.s"
          .include "48Pixels.s"
          .include "Prepare48pxMobBlob.s"
          .include "VSync.s"
          .include "VBlank.s"

          .include "PreambleAttracts.s"
          .include "AttractCopyright.s"
          .include "Credits.s"
          .include "CopyPointerText.s"
          .include "CopyPointerText12.s"
          .include "ShowPointerText.s"
          .include "ShowPointerText12.s"

          .include "Bank0Strings.s"

          .include "EndBank.s"
