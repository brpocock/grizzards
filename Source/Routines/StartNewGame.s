;;; Grizzards Source/Routines/StartNewGame.s
;;; Copyright © 2021 Bruce-Robert Pocock
StartNewGame:          .block
          .WaitScreenTop

          lda #ModeStartGame
          sta GameMode

          ldx #$ff              ; destroy stack. We are here to stay.
          txs

InitGameVars:
          ;; Set up actual game vars for a new game
          lda #ModeMap
          sta GameMode

          lda # 0
          sta CurrentProvince
          sta CurrentMap
          sta Score
          sta Score + 1
          sta Score + 2
          sta ClockFrame
          sta ClockSeconds
          sta ClockMinutes
          sta ClockFourHours

          lda # 80              ; Player start position
          sta BlessedX
          sta PlayerX
          lda # 25
          sta BlessedY
          sta PlayerY

          lda # STARTER         ; STARTER Grizzard
          sta CurrentGrizzard
          lda # 1
          sta GrizzardAttack
          sta GrizzardDefense
          sta GrizzardDefense + 1 ; unused for now

          lda #$0f              ; learn 4 moves to start TODO
          sta MovesKnown

          lda # 10
          sta MaxHP
          sta CurrentHP

          lda #0
          sta StartGameWipeBlock

          .WaitScreenBottom

Loop:
          .WaitScreenTopMinus 2, 2

          lda StartGameWipeBlock
          cmp #$ff
          beq Leave

          jsr i2cStartWrite
          bcc LetsStart
          jsr i2cStopWrite
          lda #ModeNoAtariVox
          sta GameMode
          brk

LetsStart:
          lda SaveGameSlot
          clc
          adc #>SaveGameSlotPrefix
          jsr i2cTxByte
          clc
          ;; if this is non-zero other things will bomb
          .if ($ff & SaveGameSlotPrefix) != 0
          .error "SaveGameSlotPrefix should be page-aligned, got ", SaveGameSlotPrefix
          .fi
          lda #<SaveGameSlotPrefix
          adc StartGameWipeBlock
          jsr i2cTxByte

          ldx #SaveWritesPerScreen
WipeBlock:
          lda # 0
          jsr i2cTxByte
          dex
          bne WipeBlock

          jsr i2cStopWrite

          lda StartGameWipeBlock
          clc
          adc #SaveWritesPerScreen
          bcs DoneWiping
          sta StartGameWipeBlock

          jmp WaitForScreenEnd

DoneWiping:
          lda #$ff
          sta StartGameWipeBlock

WaitForScreenEnd:
          .WaitScreenBottom

          lda GameMode
          cmp #ModeStartGame
          bne Loop
Leave:
          .FarJSR SaveKeyBank, ServiceSaveToSlot
          jmp GoMap

          .bend
