;;; Grizzards Source/Routines/SelectSlot.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

          ;; Select a save game slot
SelectSlot:        .block
          .mva AlarmCountdown, # 120

          .KillMusic
          jsr Prepare48pxMobBlob

          .mva NextSound, #SoundChirp
          .SetUtterance Phrase_SelectSlot

          .mvy SaveSlotChecked, #$ff
          iny                   ; Y = 0
          sty SelectJatibuProgress
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

          .if !DEMO
          
            lda SaveSlotBusy
            bne ReallyErase

            lda SaveSlotErased
            beq ReallyErase

            .SetPointer ResumeText
            gne StartPicture

          .fi

ReallyErase:
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

          .mva GameMode, #ModeSelectSlot
          .mva SaveSlotChecked, #$ff
          gne Loop

DoNotDestroy:
          ;; See if the slot is in use
          ;; by checking for the signature bytes
          lda SaveSlotChecked
          cmp SaveGameSlot
          beq MidScreen

NeedToCheck:
          jsr CheckSaveSlot

Checked:
          .mva SaveSlotChecked, SaveGameSlot
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
          lda SaveSlotErased
          beq ReallyVacant

          .SetPointer ErasedText
          jmp ShowSlotName

ReallyVacant:
          .SetPointer VacantText
          gne ShowSaveSlot

ShowResume:
          lda GameMode
          cmp #ModeSelectSlot
          bne ShowActive

          bit Potions
          bpl +
          .ldacolu COLYELLOW, $e
          sta COLUP0
          sta COLUP1
+
          .SetPointer ResumeText
          jmp ShowSlotName

ShowActive:
          .SetPointer InUseText

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
          beq DoneSwitches

          .BitBit SWCHBReset
          beq SlotOK

          and #SWCHBSelect
          beq SwitchSelectSlot
DoneSwitches:

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
          and #ButtonI
          bne ThisIsNotAStickUp

          .SetUtterance Phrase_EraseSlot

          .mva GameMode, #ModeEraseSlot
          jmp Loop
;;; 
EliminationMode:
          ;; Release button to exit Elimination Mode
          lda INPT4
          and #ButtonI
          bne ThisIsNotAStickUp

          ;; Push stick Up to erase the selected slot
          lda SWCHA
          and #P0StickUp
          beq EraseSlotNow

          gne Loop

EraseSlotNow:
          .if DEMO

            .mva NextSound, #SoundDeleted
            .mva GameMode, #ModeErasing
            jmp Loop
          
          .else

            lda SaveSlotBusy
            bne DoEraseSlot

            lda SaveSlotErased
            bne DoResumeSlot

            .mva NextSound, #SoundBump
            jmp Loop

DoEraseSlot:
            .FarJSR AnimationsBank, ServiceConfirmErase

            jmp Loop

DoResumeSlot:
            jsr Unerase
            jmp Loop
          
          .fi

ThisIsNotAStickUp:
          .mva GameMode, #ModeSelectSlot

          lda AlarmCountdown
          bne StillGotTime

          .WaitScreenBottom
          jmp Attract

StillGotTime:
          lda NewButtons
          beq DoneButtons

          .BitBit ButtonI
          beq SlotOK

DoneButtons:
          jmp Loop
;;; 
SwitchMinusSlot:
          dec SaveGameSlot
          bpl GoBack

          .if ATARIAGESAVE
            .mva SaveGameSlot, # 7
          .else
            .mva SaveGameSlot, # 2
          .fi
          gne GoBack

SwitchSelectSlot:
          inc SaveGameSlot
          lda SaveGameSlot
          .if ATARIAGESAVE
            cmp # 8
          .else
            cmp # 3
          .fi
          blt GoBack

          .mva SaveGameSlot, #0
GoBack:
          .mva NextSound, #SoundChirp

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

;;; audited 2022-02-16 BRPocock
