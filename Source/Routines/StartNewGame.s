;;; Grizzards Source/Routines/StartNewGame.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

StartNewGame:          .block
          .if NOSAVE
            .WaitScreenBottom
          .fi
          .WaitScreenTopMinus 1, -1

          .mva GameMode, #ModeStartGame ; XXX unused?

          .mvx s, #$ff              ; destroy stack. We are here to stay.

          inx                   ; X = 0
          stx NameEntryBuffer
EnterName:
          .FarJSR StretchBank, ServiceBeginName

          .if DEMO

            lda # 1               ; Aquax
            sta CurrentGrizzard

          .else

            .FarJSR SaveKeyBank, ServiceChooseGrizzard

            .FarJSR SaveKeyBank, ServiceConfirmNewGame

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
          sta PlayerX
          lda # 25
          sta BlessedY
          sta PlayerY

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

          ldy # 0               ; XXX necessary?
          sty StartGameWipeBlock

          .WaitScreenBottom
          .if TV != NTSC
            stx WSYNC
          .fi

          .if NOSAVE

            .mva CurrentGrizzard, # 1               ; Aquax
            .mva ProvinceFlags + 4, #$ff

          .else

WipeGrizzards:
          .WaitScreenTop

          jsr StartAddress

          lda #$40
          jsr i2cTxByte

          ldx # 12 * 5
          jsr WipeSome

          jsr ChangeAddress

          lda #$80
          jsr i2cTxByte

          ldx # 12 * 5
          jsr WipeSome

          jsr ChangeAddress

          lda #$c0
          jsr i2cTxByte

          ldx # 7 * 5
          jsr WipeSome

DoneWipingGrizzards:

          .FarJSR SaveKeyBank, ServiceSaveToSlot

SaveName:
          .if NTSC == TV
            .SkipLines 2
          .else
            .SkipLines 1
          .fi
          .WaitScreenTop

          .if ATARIAGESAVE
            lda SaveGameSlot
          .fi
          jsr i2cStartWrite
          .if !ATARIAGESAVE
            lda SaveGameSlot
            clc
            adc #>SaveGameSlotPrefix
            jsr i2cTxByte
          .fi
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
WipeSome:
          lda # 0
          jsr i2cTxByte
          dex
          bne WipeSome
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
          
          .bend
