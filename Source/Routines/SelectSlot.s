;;; Grizzards Source/Routines/SelectSlot.s
;;; Copyright © 2021 Bruce-Robert Pocock
SelectSlot:        .block
          ;;
          ;; Select a save game slot
          ;;

          .KillMusic

          lda #SoundChirp
          sta NextSound

          lda #>Phrase_SelectSlot
          sta CurrentUtterance + 1
          lda #<Phrase_SelectSlot
          sta CurrentUtterance
;;; 
Loop:     
          jsr VSync
          .if TV == NTSC
          .TimeLines KernelLines * 2/3 - 1
          .else
          .TimeLines KernelLines / 2 - 1
          .fi

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
          .ldacolu COLGREEN, 0
          sta COLUBK
          .ldacolu COLGREEN, $f
          sta COLUP0
          sta COLUP1
          .LoadString "SELECT"

StartPicture:

          .SkipLines 16

Slot:
          .FarJSR TextBank, ServiceDecodeAndShowText

          .LoadString " SLOT "
          .FarJSR TextBank, ServiceDecodeAndShowText

          lda #ModeErasing
          cmp GameMode
          bne DoNotDestroy
          jsr EraseSlotSignature
          lda #ModeSelectSlot
          sta GameMode
          jmp ShowVacant

DoNotDestroy:

          ;; See if the slot is in use
          ;; by checking for the signature bytes

          jsr CheckSaveSlot
          ;; carry is SET if the slot is EMPTY
          bcc +
          ldy # 0               ; slot empty
          beq MidScreen         ; always taken
+
          ldy # 1               ; slot busy

MidScreen:
          .WaitForTimer
          .if TV == NTSC
          .SkipLines 2
          .TimeLines KernelLines / 3 - 1
          .else
          .TimeLines KernelLines / 2 - 1
          .fi

          cpy # 0
          bne ShowResume

          lda GameMode
          cmp #ModeSelectSlot
          bne ShowVacant

          .SetPointer BeginText
          jmp FillToSlot

ShowVacant:
          .SetPointer VacantText
          jmp FillToSlot

ShowResume:
          lda GameMode
          cmp #ModeSelectSlot
          bne ShowActive
          .SetPointer ResumeText
          jmp FillToSlot

ShowActive:
          .SetPointer InUseText

FillToSlot:
ShowSaveSlot:
          jsr ShowPointerText

          .SetPointer SlotOneText
          jsr CopyPointerText

          ldx SaveGameSlot
          inx
          txa
          sta StringBuffer + 5
          
ShowSlot:
          .FarJSR TextBank, ServiceDecodeAndShowText

          .WaitForTimer
          jsr Overscan
;;; 
          lda NewSWCHB
          beq SkipSwitches
          .BitBit SWCHBReset
          beq SlotOK

          .BitBit SWCHBSelect
          beq SwitchSelectSlot
SkipSwitches:

          lda GameMode
          cmp #ModeEraseSlot
          beq EliminationMode

          ;; To enter Elimination Mode (ERASE SLOT):
          ;; — both Difficulty Switches to A/Advanced
          lda SWCHB
          and # SWCHBP0Advanced | SWCHBP1Advanced
          cmp # SWCHBP0Advanced | SWCHBP1Advanced
          bne ThisIsNotAStickUp
          ;; — pull Down on joystick
          lda SWCHA
          .BitBit P0StickDown
          bne ThisIsNotAStickUp
          ;; — hold Fire button
          lda INPT4
          .BitBit PRESSED
          bne ThisIsNotAStickUp

          lda #ModeEraseSlot
          sta GameMode
          jmp Loop
;;; 
EliminationMode:
          ;; Release button to exit Elimination Mode
          lda INPT4
          .BitBit PRESSED
          bne ThisIsNotAStickUp

          ;; Push stick Up to erase the selected slot
          lda SWCHA
          .BitBit P0StickUp
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
;;; 
SwitchSelectSlot:
          lda #SoundChirp
          sta NextSound

          inc SaveGameSlot
          lda SaveGameSlot
          cmp #3
          blt GoBack
          lda #0
          sta SaveGameSlot
GoBack:
          jmp Loop
;;; 
SlotOK:
          sta WSYNC
          .WaitScreenTop
          lda #SoundHappy
          sta NextSound

          jsr CheckSaveSlot
          ;; carry is SET if the slot is EMPTY
          bcc LoadGame
          .WaitScreenBottom

          lda #ModeStartGame
          sta GameMode
          .FarJMP MapServicesBank, ServiceStartNewGame

LoadGame:
          jmp LoadSaveSlot

          .bend
