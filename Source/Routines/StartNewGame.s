;;; Grizzards Source/Routines/StartNewGame.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
StartNewGame:          .block
          .if NOSAVE
            .WaitScreenBottom
          .fi
          .WaitScreenTopMinus 1, -1

          .mva GameMode, #ModeStartGame ; XXX unused?

          ldx #$ff              ; destroy stack. We are here to stay.
          txs

InitGameVars:
          ;; Set up actual game vars for a new game
          .mva GameMode, #ModeMap

          ldy # 0
          sty CurrentProvince
          sty NextMap
          sty CurrentMap
          .if DEMO
            sty Potions
          .fi
          sty Score
          sty Score + 1
          sty Score + 2
          sty ClockFrame
          sty ClockSeconds
          sty ClockMinutes
          sty ClockFourHours

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

          ldy # 0               ; XXX necessary?
          sty NameEntryBuffer
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

          .bend
