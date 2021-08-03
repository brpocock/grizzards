;;; Grizzards Source/Routines/SelectSlot.s
;;; Copyright © 2021 Bruce-Robert Pocock
SelectSlot:        .block
          ;;
          ;; Select a save game slot
          ;;

          jsr VSync

          .KillMusic

          lda #SoundChirp
          sta NextSound

          lda #>Phrase_SelectSlot
          sta CurrentUtterance + 1
          lda #<Phrase_SelectSlot
          sta CurrentUtterance

          .if TV == NTSC
          .TimeLines KernelLines * 2/3 - 2
          .else
          .TimeLines KernelLines / 2 - 2
          .fi

          jmp LoopFirst
;;; 
Loop:     
          jsr VSync
          .if TV == NTSC
          .TimeLines KernelLines * 2/3 - 1
          .else
          .TimeLines KernelLines / 2 - 1
          .fi
LoopFirst:

          lda GameMode
          cmp #ModeSelectSlot
          beq NoErase

          .ldacolu COLRED, $8
          sta COLUP0
          sta COLUP1
          .ldacolu COLGOLD, $0
          sta COLUBK
          .SetPointer EraseText
          bne StartPicture      ; always taken

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
          jsr EraseSlotSignature
          lda #ModeSelectSlot
          sta GameMode
          bne MidScreen        ; always taken

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
          bne ShowSaveSlot      ; always taken

ShowVacant:
          .SetPointer VacantText
          bne ShowSaveSlot      ; always taken

ShowResume:
          lda GameMode
          cmp #ModeSelectSlot
          bne ShowActive
          .SetPointer ResumeText
          bne ShowSaveSlot

ShowActive:
          .SetPointer InUseText

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

          lda NewSWCHA
          beq SkipStick
          .BitBit P0StickLeft
          beq SwitchMinusSlot
          .BitBit P0StickRight
          beq SwitchSelectSlot
SkipStick:

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

          lda #ModeErasing
          sta GameMode
          jmp Loop

ThisIsNotAStickUp:
          lda #ModeSelectSlot
          sta GameMode

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
          bne GoBack            ; always taken

SwitchSelectSlot:
          inc SaveGameSlot
          lda SaveGameSlot
          cmp # 3
          blt GoBack
          lda #0
          sta SaveGameSlot
GoBack:
          lda #SoundChirp
          sta NextSound

          jmp Loop
;;; 
SlotOK:
          sta WSYNC
          .WaitScreenTop
          lda #SoundHappy
          sta NextSound

          jsr CheckSaveSlot
          ;; carry is SET if the slot is EMPTY
          bcc +
          ldy # 0               ; slot empty
          beq FinishScreenAndProceed ; always taken
+
          ldy # 1               ; slot busy

FinishScreenAndProceed:
          sty Temp
          .WaitScreenBottom
          ldy Temp
          bne LoadSaveSlot      ; located immediately after this in memory
                                ; (so, reachable by branch)

          lda #ModeStartGame
          sta GameMode
          .FarJMP MapServicesBank, ServiceNewGame

          .bend
