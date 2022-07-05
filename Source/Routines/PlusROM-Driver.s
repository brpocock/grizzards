;;; Grizzards Source/Routines/AtariVox-EEPROM-Driver.s
;;;
;;; PlusROM Driver
;;;
;;; Copyright © 2022 Bruce-Robert Pocock

SaveGameSignatureString:
          .text SaveGameSignature

          PlusSendBuffer = $1ff0
          PlusSendReady = $1ff1
          PlusRead = $1ff2
          PlusReadLength = $1ff3

          .enc "Unicode"
          PlusCommandCheckSlot = "C"
          PlusCommandLoadGrizzardData = "l"
          PlusCommandOK = "O"
          PlusCommandPeekGrizzard = "P"
          PlusCommandPeekGrizzardXP = "X"
          PlusCommandSaveGrizzard = "s"
          PlusCommandSaveProvinceData = "P"
          PlusCommandSaveToSlot = "S"
          PlusCommandSetCurrentGrizzard = "G"
          .enc "none"

          SaveWritesPerScreen = $20

;;; 

CheckForPlus:
          ldx PlusReadLength
          dex
          beq NoPlusROM

          rts

NoPlusROM:
          .mva Score + 1, #$17
          .mva Score + 2, #$ed
          .mva Score + 0, #$fe
          .mva GameMode, #ModeNoAtariVox
          jmp Failure.DoneWithStack          
          
WaitForPlus:
          ;; Wait for a reply from PlusROM with a blank screen.
          ;; Let's be orange, nobody else is using orange.
          ldy # 0
          .StyAllGraphics

WaitForPlusLoop:
          .WaitScreenBottom
          .WaitScreenTop

          .ldacolu COLORANGE, $f
          sta COLUBK

          lda PlusReadLength
          beq WaitForPlusLoop

Return:
          rts

PlusDone:
          lda PlusReadLength
          beq Return

          lda PlusRead
          jmp PlusDone
          
PlusCommandError:
          .mva Score + 1, PlusRead
          .mva Score + 2, PlusRead
          .mva Score + 0, #$ff
          .mva GameMode, #ModeNoAtariVox
          jmp Failure.DoneWithStack

CheckSaveSlot:
          ;; Check SaveGameSlot for a save game
          ;; Returns values of Potions (crown bit $80),
          ;; player name in NameEntryBuffer,
          ;; and sets SaveSlotBusy and SaveSlotErased to
          ;; either $00 for false or non-zero for true

          lda #PlusCommandCheckSlot
          sta PlusSendBuffer

          lda SaveGameSlot
          sta PlusSendReady

          jsr WaitForPlus

          lda PlusRead
          cmp #PlusCommandOK
          bne PlusCommandError

          lda PlusRead
          sta Potions

          ldx # 0
-
          lda PlusRead
          sta NameEntryBuffer, x
          inx
          cpx # 6
          blt -

          lda PlusRead
          sta SaveSlotBusy

          lda PlusRead
          sta SaveSlotErased

          jmp PlusDone

SaveToSlot:
          .WaitScreenBottom
          .WaitScreenTop

          lda #PlusCommandSaveToSlot
          sta PlusSendBuffer

          lda SaveGameSlot
          sta PlusSendBuffer

          ldx # 0
WriteSignatureLoop:
          lda SaveGameSignatureString, x
          sta PlusSendBuffer
          inx
          cpx # 5
          bne WriteSignatureLoop

          ldx # 0
WriteGlobalLoop:
          lda GlobalGameData, x
          sta PlusSendBuffer
          inx
          cpx # GlobalGameDataLength
          bne WriteGlobalLoop

          lda #$fe
          sta PlusSendReady

          jsr SaveProvinceData

          ;; Fall through to SaveGrizzard

SaveGrizzard:
          lda #PlusCommandSaveGrizzard
          sta PlusSendBuffer
          
          lda SaveGameSlot
          sta PlusSendBuffer

          lda CurrentGrizzard
          sta PlusSendBuffer

          ldx # 0
-
          lda MaxHP, x
          sta PlusSendBuffer
          inx
          cpx # 5
          bne -

          lda # 0
          sta PlusSendReady

          .WaitScreenBottomTail

PeekGrizzard:
          lda #PlusCommandPeekGrizzard
PeekGrizzardCommon:
          sta PlusSendBuffer

          lda SaveGameSlot
          sta PlusSendBuffer

          lda Temp
          sta PlusSendReady

          jsr WaitForPlus

          lda PlusRead
          cmp # PlusCommandOK
          bne PlusCommandError

          lda PlusRead
          beq NoGrizzard

GotGrizzard:
          .mva Temp, #$80
          sec
          rts

NoGrizzard:
          .mva Temp, # 0
          clc
          rts

PeekGrizzardXP:
          lda #PlusCommandPeekGrizzardXP
          jmp PeekGrizzardCommon

LoadGrizzardData:
          lda #PlusCommandLoadGrizzardData
          sta PlusSendBuffer

          lda SaveGameSlot
          sta PlusSendBuffer

          lda CurrentGrizzard
          sta PlusSendReady

          jsr WaitForPlus

          ldx # 0
-
          lda PlusRead

          sta MaxHP, x
          inx
          cpx # 5
          blt -
          
          .mva CurrentHP, MaxHP
          .mva DebounceSWCHB, SWCHB

          .mva PlayerX, BlessedX
          .mva PlayerY, BlessedY

          rts

SetCurrentGrizzard:
          lda #PlusCommandSetCurrentGrizzard
          sta PlusSendBuffer

          lda SaveGameSlot
          sta PlusSendBuffer

          lda CurrentGrizzard
          sta PlusSendReady

          jmp WaitForPlus

SaveProvinceData:
          lda #PlusCommandSaveProvinceData
          sta PlusSendBuffer

          lda SaveGameSlotPrefix

LoadProvinceData:
          ;; TODO
          brk

EraseSlotSignature:
          ;; TODO
          brk

Unerase:
          ;; TODO
          brk

LoadSaveSlot:
          ;; TODO
          brk

StartNewGame:
          ;; TODO
          brk
