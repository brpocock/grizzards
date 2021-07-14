;;; Grizzards Source/Routines/StartNewGame.s
;;; Copyright © 2021 Bruce-Robert Pocock
StartNewGame:          .block

          ldx #$ff              ; destroy stack. We are here to stay.
          txs
          
          lda #0
          sta StartGameWipeBlock

StartGameScreenLoop:
          jsr VSync
          jsr VBlank

          .if KernelLines > 192
          ldx # KernelLines - 192
SkipForPAL:
          stx WSYNC
          dex
          bne SkipForPAL
          .fi

          lda # ( 76 * ( 192 - 1 ) ) / 64 - 2
          sta TIM64T

          lda StartGameWipeBlock
          cmp #$ff
          beq SignatureTime

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
          jmp WaitForScreenEnd

SignatureTime:
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

          lda # 1
          sta CurrentGrizzard   ; giving them a free Grizzard for now, TODO
          sta GrizzardAttack
          sta GrizzardDefense
          sta GrizzardDefense + 1 ; unused for now

          lda #$0f              ; learn 4 moves to start TODO
          sta MovesKnown

          lda # 10
          sta MaxHP
          sta CurrentHP

WaitForScreenEnd:
          lda INSTAT
          bne WaitForScreenEnd

          jsr Overscan

          lda GameMode
          cmp #ModeStartGame
          beq Loop

          jmp GoMap

Loop:
          jmp StartGameScreenLoop
          .bend
