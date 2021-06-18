StartNewGame:          .block

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
          .endif

          lda # ( 76 * ( 192 - 1 ) ) / 64 - 2
          sta TIM64T

          lda StartGameWipeBlock
          cmp #$ff
          beq SignatureTime

          jsr i2cStartWrite
          bcc LetsStart
          jmp EEPROMFail

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
          lda #0
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

          lda # 6
          sta CurrentCombatBank
          sta BlessedCombatBank

          lda # 4
          sta CurrentMapBank
          sta BlessedBank

          lda # 0
          sta CurrentMap
          sta BlessedMap

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
          sta GrizzardAccuracy
          
          lda # 10
          sta MaxHP
          sta CurrentHP

WaitForScreenEnd:
          lda INTIM
          sta WSYNC
          bne WaitForScreenEnd

          jsr Overscan

          lda GameMode
          cmp #ModeStartGame
          beq Loop

          jsr SaveToSlot
          jmp GoMap

Loop:
          jmp StartGameScreenLoop
          .bend
