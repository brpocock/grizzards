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
          PlusCommandOK = "O"
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
          .ldacolu COLORANGE, $f
          sta COLUBK

          ldy # 0
          .StyAllGraphics

WaitForPlusLoop:
          .WaitScreenBottom
          .WaitScreenTop

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
          ;; TODO
          brk

PeekGrizzard:
          ;; TODO
          brk

PeekGrizzardXP:
          ;; TODO
          brk

SaveGrizzard:
          ;; TODO
          brk

LoadGrizzardData:
          ;; TODO
          brk

SetCurrentGrizzard:
          ;; TODO
          brk

SaveProvinceData:
          ;; TODO
          brk

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
