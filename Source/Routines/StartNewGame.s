;;; Grizzards Source/Routines/StartNewGame.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

StartNewGame:          .block
          .if NOSAVE
            .WaitScreenBottom
          .fi
          .WaitScreenTopMinus 1, -1

          .mvx s, #$ff              ; destroy stack. We are here to stay.

          ;; Need to set NameEntryBuffer+0 ← $ff to indicate that
          ;; we're starting a new name entry.
          stx NameEntryBuffer
EnterName:
          .FarJSR StretchBank, ServiceBeginName

          .if DEMO

            lda # 1               ; Aquax
            sta CurrentGrizzard

          .else

            .FarJSR SaveKeyBank, ServiceChooseGrizzard

            lda GameMode
            cmp #ModeEnterName
            beq EnterName

          .fi

InitGameVars:
          ;; Set up actual game vars for a new game
          .mva GameMode, #ModeMap

          ldy # 0

          ;; Wipe CurrentMap, Clock*, and Score
          ldx # 8
-
          sty CurrentMap - 1, x
          dex
          bne -

          sty CurrentProvince
          sty NextMap
          .if DEMO
            sty Potions
          .fi

          lda # 80              ; Player start position
          sta BlessedX
          lda # 25
          sta BlessedY

          lda # 1
          sta GrizzardAttack
          sta GrizzardDefense

          sty GrizzardXP

          lda #$03
          sta MovesKnown

          ldx # 7
          lda # 0
-
          sta ProvinceFlags - 1, x
          dex
          bne -

          .mva ProvinceFlags + 7, #$ff

          lda # 10
          sta MaxHP
          sta CurrentHP

          .WaitScreenBottom
          .if TV != NTSC
            stx WSYNC
          .fi

          .if NOSAVE

            .mva CurrentGrizzard, # 1        ; Aquax
            .mva ProvinceFlags + 4, #$ff

          .else

WipeGrizzards:
          .WaitScreenTop

          jsr StartAddress

          lda #$40
          ldx # 12 * 5
          jsr WipeSome

          jsr ChangeAddress

          lda #$80
          ldx # 12 * 5
          jsr WipeSome

          jsr ChangeAddress

          lda #$c0
          ldx # 7 * 5
          jsr WipeSome

          jsr i2cStopWrite
          jsr i2cWaitForAck

DoneWipingGrizzards:
          .FarJSR SaveKeyBank, ServiceSaveToSlot

          lda Potions
          beq SaveName

          .mva CurrentGrizzard, # 2
GetAllStarters:
          .FarJSR SaveKeyBank, ServiceSaveGrizzard
          dec CurrentGrizzard
          bpl GetAllStarters

          inc CurrentGrizzard

SaveName:
          .if NTSC == TV
            .SkipLines 2
          .else
            .SkipLines 1
          .fi
          .WaitScreenTop

          jsr StartAddress
          clc
          lda #<SaveGameSlotPrefix
          adc #$1a
          jsr i2cTxByte

          ldx # 0
-
          lda NameEntryBuffer, x
          jsr i2cTxByte

          inx
          cpx # 6
          bne -

          jsr i2cStopWrite

          .WaitScreenBottom

          .fi       ; end of not-NOSAVE

          jmp GoMap
;;; 
          .if !NOSAVE

WipeSome:
          jsr i2cTxByte
Wiping:
          lda # 0
          jsr i2cTxByte
          dex
          bne Wiping
          rts
;;; 
ChangeAddress:
          jsr i2cStopWrite
          jsr i2cWaitForAck
          ;; f all through
StartAddress:
          .if ATARIAGESAVE
            lda SaveGameSlot
            jmp i2cStartWrite   ; tail call
          .else
            jsr i2cStartWrite
            lda #>SaveGameSlotPrefix
            clc
            adc SaveGameSlot
            jmp i2cTxByte       ; tail call
          .fi

          .fi                   ; end of !NOSAVE
          .bend
