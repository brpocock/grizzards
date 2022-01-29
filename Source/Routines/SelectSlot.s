;;; Grizzards Source/Routines/SelectSlot.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

SelectSlot:        .block
          ;;
          ;; Select a save game slot
          ;;

          lda # 120
          sta AlarmCountdown

          .KillMusic
          jsr Prepare48pxMobBlob

          lda #SoundChirp
          sta NextSound

          lda #>Phrase_SelectSlot
          sta CurrentUtterance + 1
          lda #<Phrase_SelectSlot
          sta CurrentUtterance

          ldx # 0
          stx SelectJatibuProgress
          dex
          stx SaveSlotChecked

;;; 
Loop:
          .WaitScreenBottom
          .WaitScreenTop

          lda GameMode
          cmp #ModeSelectSlot
          beq NoErase

Erase:
          .ldacolu COLGOLD, $0
          sta COLUBK
          .ldacolu COLRED, $8
          sta COLUP0
          sta COLUP1
          .SetPointer EraseText
          gne StartPicture

NoErase:
          .ldacolu COLGREEN, 0
          sta COLUBK
          .ldacolu COLGREEN, $f
          sta COLUP0
          sta COLUP1
          .SetPointer SelectText

StartPicture:
          .SkipLines 16

Slot:
          jsr ShowPointerText

          .SetPointer SlotText
          jsr ShowPointerText

          lda #ModeErasing
          cmp GameMode
          bne DoNotDestroy
DestroyNow:
          jsr EraseSlotSignature
          lda #ModeSelectSlot
          sta GameMode
          gne MidScreen

DoNotDestroy:
          ;; See if the slot is in use
          ;; by checking for the signature bytes
          lda SaveSlotChecked
          cmp SaveGameSlot
          beq MidScreen

NeedToCheck:
          jsr CheckSaveSlot
Checked:
          lda SaveGameSlot
          sta SaveSlotChecked
          jmp Loop

MidScreen:
          .SkipLines KernelLines / 4
          ldy SaveSlotBusy
          bne ShowResume

          lda GameMode
          cmp #ModeSelectSlot
          bne ShowVacant

          .SetPointer BeginText
          gne ShowSaveSlot

ShowVacant:
          .SetPointer VacantText
          gne ShowSaveSlot

ShowResume:
          lda GameMode
          cmp #ModeSelectSlot
          bne ShowActive
          .SetPointer ResumeText
ShowSlotName:
          jsr ShowPointerText
          ldx # 6
-
          lda NameEntryBuffer - 1, x
          sta StringBuffer - 1, x
          dex
          bne -

          .FarJSR TextBank, ServiceDecodeAndShowText
          jmp ShowSlotNumbered

ShowActive:
          .SetPointer InUseText
          jmp ShowSlotName

ShowSaveSlot:
          jsr ShowPointerText

ShowSlotNumbered:
          .SetPointer SlotOneText
          jsr CopyPointerText

          ldx SaveGameSlot
          inx
          stx StringBuffer + 5

ShowSlot:
          .FarJSR TextBank, ServiceDecodeAndShowText

;;; 
          lda NewSWCHB
          beq SkipSwitches
          .BitBit SWCHBReset
          beq SlotOK

          and #SWCHBSelect
          beq SwitchSelectSlot
SkipSwitches:

          .FarJSR 1, $fe
          cpy # 0
          beq StickDone
          lda NewSWCHA
          beq StickDone
          .BitBit P0StickLeft
          beq SwitchMinusSlot
          and #P0StickRight
          beq SwitchSelectSlot

StickDone:

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
          and #P0StickDown
          bne ThisIsNotAStickUp
          ;; — hold Fire button
          lda INPT4
          and #PRESSED
          bne ThisIsNotAStickUp

          lda #>Phrase_EraseSlot
          sta CurrentUtterance + 1
          lda #<Phrase_EraseSlot
          sta CurrentUtterance

          lda #ModeEraseSlot
          sta GameMode
          jmp Loop
;;; 
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

          lda #ModeErasing
          sta GameMode
          jmp Loop

ThisIsNotAStickUp:
          lda #ModeSelectSlot
          sta GameMode

          lda AlarmCountdown
          bne StillGotTime

          .WaitScreenBottom
          jmp Attract

StillGotTime:

          lda NewButtons
          beq SkipButton
          .BitBit PRESSED
          beq SlotOK
SkipButton:

          jmp Loop
;;; 
SwitchMinusSlot:
          dec SaveGameSlot
          bpl GoBack
          lda # 2
          sta SaveGameSlot
          gne GoBack

SwitchSelectSlot:
          inc SaveGameSlot
          lda SaveGameSlot
          .if ATARIAGESAVE
          cmp # 4
          .else
          cmp # 3
          .fi
          blt GoBack
          lda #0
          sta SaveGameSlot
GoBack:
          lda #SoundChirp
          sta NextSound

          jmp Loop
;;; 
SlotOK:
          .WaitScreenBottom
          .WaitScreenTopMinus 2, 0

          lda SaveSlotBusy
          beq GoNewGame

FinishScreenAndProceed:
          ldy # 1
          gne LoadSaveSlot      ; located immediately after this in memory
                                ; (so, reachable by branch)

GoNewGame:
          .WaitScreenBottom
          .if TV != NTSC
          stx WSYNC
          .fi
          .FarJMP MapServicesBank, ServiceNewGame

;;;

          .bend
