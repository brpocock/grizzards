;;; Grizzards Source/Routines/UserInput.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

UserInput:          .block

CheckButton:
          lda NewButtons
          beq CheckSwitches

          and #PRESSED
          bne CheckSwitches

          .if !DEMO
            .mva GameMode, #ModePotion
          .fi 

CheckSwitches:
          lda NewSWCHB
          beq NoSelect

          .BitBit SWCHBReset
          bne NoReset

          .WaitForTimer
          ldy # 0
          sty VBLANK
          .if TV == NTSC
            .TimeLines KernelLines - 1
          .else
            dey                 ; Y ← $ff
            sty TIM64T
          .fi

          .FarJMP SaveKeyBank, ServiceAttract

NoReset:
          and #SWCHBSelect
          bne NoSelect

          .mva GameMode, #ModeGrizzardStats
NoSelect:
          .if TV == SECAM

            lda DebounceSWCHB
            and #SWCHBP1Advanced        ; SECAM pause
            sta Pause

          .else

            lda DebounceSWCHB
            .BitBit SWCHBColor
            bne NoPause

            and #SWCHB7800
            beq +
            lda Pause
            eor #$ff
+
            sta Pause
            jmp SkipSwitches

NoPause:
            ldy # 0             ; XXX necessary?
            sty Pause

          .fi
SkipSwitches:
;;; 

HandleStick:
          ldy # 0               ; XXX necessary?
          sty DeltaX
          sty DeltaY

          lda Pause
          beq +
          rts
+
          lda DebounceSWCHA
          .BitBit P0StickUp
          bne DoneStickUp

          ldx #-1
          stx DeltaY

DoneStickUp:
          .BitBit P0StickDown
          bne DoneStickDown

          ldx # 1
          stx DeltaY

DoneStickDown:
          .BitBit P0StickLeft
          bne DoneStickLeft

          tay
          lda MapFlags
          and # ~MapFlagFacing
          sta MapFlags

          ldx #-1
          stx DeltaX

          tya
DoneStickLeft:
          .BitBit P0StickRight
          bne DoneStickRight

          lda MapFlags
          ora #MapFlagFacing
          sta MapFlags

          ldx #1
          stx DeltaX

DoneStickRight:
ApplyStick:
;;; 
FractionalMovement: .macro deltaVar, fractionVar, positionVar, pxPerSecond
          .block
          lda \fractionVar
          ldx \deltaVar
          beq DoneMovement
          bpl MovePlus
MoveMinus:
          sec
          sbc #ceil(\pxPerSecond * $80)
          sta \fractionVar
          bcs DoneMovement
          adc #$80
          sta \fractionVar
          dec \positionVar
          jmp DoneMovement

MovePlus:
          clc
          adc #ceil(\pxPerSecond * $80)
          sta \fractionVar
          bcc DoneMovement
          sbc #$80
          sta \fractionVar
          inc \positionVar
DoneMovement:
          .bend
          .endm
;;; 
          MovementDivisor = 0.85
          ;; Make MovementDivisor  relatively the same in  both directions
	;; so diagonal movement forms a 45° line
          MovementSpeedX = ((40.0 / MovementDivisor) / FramesPerSecond)
          .FractionalMovement DeltaX, PlayerXFraction, PlayerX, MovementSpeedX
          MovementSpeedY = ((30.0 / MovementDivisor) / FramesPerSecond)
          .FractionalMovement DeltaY, PlayerYFraction, PlayerY, MovementSpeedY

          rts
          .bend
