SelectSlot:        .block
          ;;
          ;; Select a save game slot
          ;;

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
          .SetUpTextConstant "ERASE "
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
          .SetUpTextConstant "SELECT"

StartPicture:

          ldx #16
FillTop:
          sta WSYNC
          dex
          bne FillTop

          jsr Prepare48pxMobBlob

Slot:
          ldx #ServiceDecodeAndShowText
          ldy #TextBank
          jsr FarCall

          .SetUpTextConstant " SLOT "
          ldx #ServiceDecodeAndShowText
          ldy #TextBank
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

          .SetUpTextConstant "BEGIN "
          jmp FillToSlot

ShowClear:
          .SetUpTextConstant "VACANT"
          jmp FillToSlot

ShowResume:
          lda GameMode
          cmp #ModeSelectSlot
          bne ShowActive
          .SetUpTextConstant "RESUME"
          jmp FillToSlot

ShowActive:
          .SetUpTextConstant "IN USE"

FillToSlot:
          sta WSYNC
          lda INTIM
          bne FillToSlot

ShowSaveSlot:
          ldx #ServiceDecodeAndShowText
          ldy #TextBank
          jsr FarCall

          .SetUpTextConstant "SLOT 1"

          ;; Ensure a new scanline whichever branch is taken
          .Sleep 15

          ldx SaveGameSlot
          inx
          txa
          sta StringBuffer + 5
          
ShowSlot:
          ldx #ServiceDecodeAndShowText
          ldy #TextBank
          jsr FarCall

          ldx #25
FillBottom:
          dex
          sta WSYNC
          bne FillBottom

          .if KernelLines > 192
          ldx #KernelLines - 192
FillScreen:
          sta WSYNC
          dex
          bne FillScreen
          .fi

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
          jmp SelectSlot

EliminationMode:
          ;; Release button to exit Elimination Mode
          lda INPT4
          and #PRESSED
          bne ThisIsNotAStickUp

          ;; Push stick Up to erase the selected slot
          lda SWCHA
          and #P0StickUp
          beq EraseSlotNow
          jmp SelectSlot

EraseSlotNow:
          lda #SoundDeleted
          sta NextSound

          lda #ModeErasing
          sta GameMode
          jmp SelectSlot

ThisIsNotAStickUp:
          lda #ModeSelectSlot
          sta GameMode

          jmp SelectSlot

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
          jmp SelectSlot

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
