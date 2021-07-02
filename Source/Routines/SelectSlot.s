;;; Grizzards Source/Routines/SelectSlot.s
;;; Copyright © 2021 Bruce-Robert Pocock
SelectSlot:        .block
          ;;
          ;; Select a save game slot
          ;;

          lda #>Phrase_SelectSlot
          sta CurrentUtterance + 1
          lda #<Phrase_SelectSlot
          sta CurrentUtterance
          
Loop:     
          jsr VSync
          jsr VBlank

          lda GameMode
          cmp #ModeSelectSlot
          beq NoErase

          .ldacolu COLRED, $8
          sta COLUP0
          sta COLUP1
          .ldacolu COLGOLD, $0
          sta COLUBK
          .LoadString "ERASE "
          jmp StartPicture

NoErase:
          .if TV == SECAM
          .ldacolu COLYELLOW
          .else
          .ldacolu COLGREEN, 0
          .fi
          sta COLUBK
          .ldacolu COLGREEN
          sta COLUP0
          sta COLUP1
          .LoadString "SELECT"

StartPicture:

          ldx #16
FillTop:
          sta WSYNC
          dex
          bne FillTop

Slot:
          ldy #ServiceDecodeAndShowText
          ldx #TextBank
          jsr FarCall

          .LoadString " SLOT "
          ldy #ServiceDecodeAndShowText
          ldx #TextBank
          jsr FarCall

          lda # ( (76 * 75) / 64 )
          sta TIM64T

          lda #ModeErasing
          cmp GameMode
          bne DoNotDestroy
          jsr EraseSlotSignature
          lda #ModeSelectSlot
          sta GameMode
          jmp ShowClear

DoNotDestroy:

          ;; See if the slot is in use
          ;; by checking for the signature bytes

          jsr CheckSaveSlot
          ;; carry is SET if the slot is EMPTY
          bcc ShowResume

          lda GameMode
          cmp #ModeSelectSlot
          bne ShowClear

          .LoadString "BEGIN "
          jmp FillToSlot

ShowClear:
          .LoadString "VACANT"
          jmp FillToSlot

ShowResume:
          lda GameMode
          cmp #ModeSelectSlot
          bne ShowActive
          .LoadString "RESUME"
          jmp FillToSlot

ShowActive:
          .LoadString "IN USE"

FillToSlot:
          sta WSYNC
          lda INTIM
          bne FillToSlot

ShowSaveSlot:
          ldy #ServiceDecodeAndShowText
          ldx #TextBank
          jsr FarCall

          .LoadString "SLOT 1"

          ;; Ensure a new scanline whichever branch is taken
          .Sleep 15

          ldx SaveGameSlot
          inx
          txa
          sta StringBuffer + 5
          
ShowSlot:
          ldy #ServiceDecodeAndShowText
          ldx #TextBank
          jsr FarCall

          ldx #KernelLines - 172
FillScreen:
          sta WSYNC
          dex
          bne FillScreen

          jsr Overscan

          lda SWCHB
          cmp DebounceSWCHB
          beq SkipSwitches
          sta DebounceSWCHB
          and #SWCHBReset
          beq SlotOK

          lda DebounceSWCHB
          and #SWCHBSelect
          beq SwitchSelectSlot
SkipSwitches:

          lda GameMode
          cmp #ModeEraseSlot
          beq EliminationMode

          ;; To enter Elimination Mode (ERASE SLOT):
          ;; — both Difficulty Switches to A/Advanced
          lda DebounceSWCHB
          and # SWCHBP0Advanced | SWCHBP1Advanced
          cmp # SWCHBP0Advanced | SWCHBP1Advanced
          bne ThisIsNotAStickUp
          ;; — pull Down on joystick
          lda SWCHA
          and #P0StickDown
          bne ThisIsNotAStickUp
          ;; — hold Fire button
          lda INPT4
          and #PRESSED
          bne ThisIsNotAStickUp

          lda #ModeEraseSlot
          sta GameMode
          jmp Loop

EliminationMode:
          ;; Release button to exit Elimination Mode
          lda INPT4
          and #PRESSED
          bne ThisIsNotAStickUp

          ;; Push stick Up to erase the selected slot
          lda SWCHA
          and #P0StickUp
          beq EraseSlotNow
          jmp Loop

EraseSlotNow:
          lda #SoundDeleted
          sta NextSound

          lda #>Phrase_EraseSlot
          sta CurrentUtterance + 1
          lda #<Phrase_EraseSlot
          sta CurrentUtterance

          lda #ModeErasing
          sta GameMode
          jmp Loop

ThisIsNotAStickUp:
          lda #ModeSelectSlot
          sta GameMode

          jmp Loop

SwitchSelectSlot:
          lda #SoundChirp
          sta NextSound

          inc SaveGameSlot
          lda SaveGameSlot
          cmp #3
          bmi GoBack
          lda #0
          sta SaveGameSlot
GoBack:
          jmp Loop

SlotOK:

          lda #SoundHappy
          sta NextSound

          jsr CheckSaveSlot
          ;; carry is SET if the slot is EMPTY
          bcc LoadGame

          lda #ModeStartGame
          sta GameMode
          jmp StartNewGame

LoadGame:
          jmp LoadSaveSlot

          .bend
