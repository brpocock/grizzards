;;; Grizzards Source/Routines/ShowMonsterName.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

ShowMonsterName:    .block
          lda CurrentMonsterPointer
          sta Pointer
          lda CurrentMonsterPointer + 1
          sta Pointer + 1

          ldy # 0
          .UnpackLeft (CurrentMonsterPointer)
          .FarJSR TextBank, ServiceDecodeAndShowText

          ldy # 4
          .UnpackRight (CurrentMonsterPointer)
          .FarJMP TextBank, ServiceDecodeAndShowText ; tail call

          .bend

;;; Audited 2022-02-16 BRPocock
