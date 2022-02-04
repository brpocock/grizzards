;;; Grizzards Source/Routines/WinnerFireworks.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
WinnerFireworks:    .block

          lda #SoundRoar
          sta NextSound
          .SetUtterance Phrase_BossBearDefeated

Loop:
          .WaitScreenBottom
          .WaitScreenTop
          .ldacolu COLRED, $8
          sta COLUBK
          .ldacolu COLGOLD, $0
          sta COLUP0
          sta COLUP1

          jsr Prepare48pxMobBlob

          .FarJSR AnimationsBank, ServiceFinalScore

          bit Potions
          bpl NotAgain
          .SetPointer AgainText
          jsr ShowPointerText
NotAgain:
          .SkipLines 30

          .SetUpFortyEight BossBearDies
          jsr ShowPicture

;;; 
          lda NewSWCHB
          beq +
          and #SWCHBReset
          beq Leave
+
          jmp Loop

Leave:
          .WaitScreenBottom
          .WaitScreenTop
NewGamePlus:
          lda #$80 | 25
          sta Potions

          lda # 2
          sta CurrentGrizzard

ConsiderGrizzard:
          .FarJSR SaveKeyBank, ServicePeekGrizzardXP
          bcs SeenGrizzardBefore

          .FarJSR MapServicesBank, ServiceNewGrizzard
          .FarJSR SaveKeyBank, ServiceSaveGrizzard
SeenGrizzardBefore:
          dec CurrentGrizzard
          bpl ConsiderGrizzard

          ldy # 0
          sty CurrentGrizzard
          sty CurrentProvince

          ldx # 8
-
          sta ProvinceFlags - 1, x
          dex
          bne -

          .FarJSR SaveKeyBank, ServiceSaveProvinceData
          inc CurrentProvince
          .FarJSR SaveKeyBank, ServiceSaveProvinceData
          inc CurrentProvince
          .FarJSR SaveKeyBank, ServiceSaveProvinceData

          lda # 0
          sta CurrentMap
          sta CurrentProvince
          sta NextMap

          .FarJSR SaveKeyBank, ServiceSaveToSlot

          jmp GoColdStart

AgainText:
          .MiniText "AGAIN!"
          
          .bend

