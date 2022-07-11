;;; Grizzards Source/Routines/ChangeProvince.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

ChangeProvince:
;;; Duplicated in Signpost.s and ChangeProvince.s with variations
          .mvx s, #$ff              ; smash the stack
          .WaitForTimer         ; finish up VBlank cycle
          ldx # 0
          stx VBLANK
          ;; WaitScreenTop without VSync/VBlank
          .if TV == NTSC
            .TimeLines KernelLines - 2
          .else
            lda #$fe
            sta TIM64T
          .fi
          .WaitScreenBottom
          .FarJSR SaveKeyBank, ServiceSaveProvinceData

          .WaitScreenTop
          ldx SpriteFlicker
          lda SpriteAction, x
          and #$f0
          lsr a
          lsr a
          lsr a
          lsr a
          sta CurrentProvince
          lda SpriteParam, x
          sta NextMap
          .mvy GameMode, #ModeMapNewRoomDoor ; XXX why Y?
          .FarJSR SaveKeyBank, ServiceLoadProvinceData

          .WaitScreenBottom
          jmp GoMap
