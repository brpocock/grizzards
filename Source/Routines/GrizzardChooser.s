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
          lda CurrentGrizzard
          bpl DoneLeft
          lda # 2
          sta CurrentGrizzard
          lda #SoundBlip
          sta NextSound
DoneLeft:
          lda NewSWCHA
          and #P0StickRight
          bne DoneRight
DoRight:
          inc CurrentGrizzard
          lda CurrentGrizzard
          cmp # 3
          blt DoneRight
          lda # 0
          sta CurrentGrizzard
          lda #SoundBlip
          sta NextSound
DoneRight:
DoneStick:
          lda NewButtons
          beq DoneButtons
          and #PRESSED
          bne DoneButtons

          lda #ModeConfirmNewGame
          sta GameMode

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
