;;; Grizzards Source/Routines/BeginOrResume.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

BeginOrResume:        .block
          .KillMusic

          lda #SoundChirp
          sta NextSound

          .WaitScreenBottom
;;; 
Loop:     
          .WaitScreenTop

          .ldacolu COLGREEN, $0
          sta COLUBK
          .ldacolu COLGREEN, $e
          sta COLUP0
          sta COLUP1
          
          .SkipLines KernelLines * 2/5

          lda SaveGameSlot
          beq ShowBegin

          lda ProvinceFlags + 4
          beq ShowBegin

          .SetPointer ResumeText
          jmp ShowBeginOrResume

ShowBegin:
          .SetPointer BeginText
ShowBeginOrResume:  
          jsr ShowPointerText
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
          beq SwitchSelectSlot

          .BitBit P0StickRight
          beq SwitchSelectSlot

SkipStick:
          lda NewButtons
          beq SkipButton

          .BitBit ButtonI
          beq SlotOK

SkipButton:
          .WaitScreenBottom
          jmp Loop
;;; 
SwitchSelectSlot:
          lda SaveGameSlot
          eor #$ff
          sta SaveGameSlot
GoBack:
          .mva NextSound, #SoundChirp

          .WaitScreenBottom
          jmp Loop
;;; 
SlotOK:
          .WaitScreenBottom
          .WaitScreenTop
          .mva NextSound, #SoundHappy

          lda SaveGameSlot
          beq BeginAnew

          lda ProvinceFlags + 4
          beq BeginAnew

          lda MaxHP
          sta CurrentHP

          ldy # 0               ; XXX necessary?
          sty CurrentProvince
          sty NextMap
          sty CurrentMap

          lda # 80              ; Player start position
          sta BlessedX
          sta PlayerX
          lda # 25
          sta BlessedY
          sta PlayerY

          .WaitScreenBottom
          jmp GoMap

BeginAnew:
          .mva GameMode, #ModeStartGame
          .mva SaveGameSlot, #$ff
          .FarJMP MapServicesBank, ServiceNewGame

          .bend

;;; Audited 2022-02-16 BRPocock
