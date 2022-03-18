;;; Grizzards Source/Routines/GrizzardChooser.s
;;; Copyright © 2022 Bruce-Robert Pocock

GrizzardChooser:    .block

          lda #ModeGrizzardChooser
          sta GameMode

          .SetUtterance Phrase_ChooseGrizzard

Loop:
          .WaitScreenBottom
          ldy # 0
          sty GRP0
          sty GRP1
          .WaitScreenTop

          .if SECAM == TV
            lda #COLBLUE
          .else
            .ldacolu COLTURQUOISE, $e
          .fi
          stx WSYNC
          sta COLUBK

          .ldacolu COLGRAY, $2
          sta COLUP0
          sta COLUP1

          jsr Prepare48pxMobBlob

          .SetPointer SelectText
          jsr ShowPointerText

          jsr FindGrizzardName

          jsr ShowPointerText

          .FarJSR StretchBank, ServiceDrawStarter

          lda NewSWCHB
          beq DoneSwitches
          and #SWCHBSelect
          beq DoRight

          lda NewSWCHB
          and #SWCHBReset
          bne DoneSwitches

          .WaitScreenBottom
          jmp GoColdStart

DoneSwitches:       
          lda NewSWCHA
          beq DoneStick

          and #P0StickLeft
          bne DoneLeft

          dec CurrentGrizzard
          .mva NextSound, #SoundChirp
          lda CurrentGrizzard
          bpl DoneLeft

          .mva CurrentGrizzard, # 2
DoneLeft:
          lda NewSWCHA
          and #P0StickRight
          bne DoneRight

DoRight:
          inc CurrentGrizzard
          .mva NextSound, #SoundChirp
          lda CurrentGrizzard
          cmp # 3
          blt DoneRight

          .mva CurrentGrizzard, # 0
DoneRight:
DoneStick:
          lda NewButtons
          beq DoneButtons

          and #ButtonI
          bne DoneButtons

          .mva NextSound, #SoundBlip
          .mva GameMode, #ModeConfirmNewGame

DoneButtons:
          lda GameMode
          cmp #ModeGrizzardChooser
          bne Leave

          jmp Loop

Leave:    
          rts

          .bend
;;; 
FindGrizzardName:   .block
          lda CurrentGrizzard
          beq DirtexName

          cmp # 1
          beq AquaxName

AirexName:
          .SetPointer AirexText
          rts

DirtexName:
          .SetPointer DirtexText
          rts

AquaxName:
          .SetPointer AquaxText
          rts

          .bend

;;; Audited 2022-02-16 BRPocock
