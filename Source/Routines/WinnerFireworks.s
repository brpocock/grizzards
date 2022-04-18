;;; Grizzards Source/Routines/WinnerFireworks.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
WinnerFireworks:    .block

          .KillMusic
          .mva NextSound, #SoundRoar

          .WaitScreenBottom

          ldy # 0
          sty CurrentHP         ; now = Grizzards Count
          sty CurrentGrizzard   ; search each Grizzard, 0 - 29
CheckCaughtLoop:
          .FarJSR SaveKeyBank, ServicePeekGrizzardXP
          bcc +
          inc CurrentHP         ; Grizzards Count
+
          inc CurrentGrizzard
          lda CurrentGrizzard
          cmp # 30
          blt CheckCaughtLoop

          .WaitScreenTop
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
          jmp +
NotAgain:
          .SkipLines 16
+

          .SetPointer CaughtText
          jsr ShowPointerText

          lda CurrentHP         ; Grizzards Count
          cmp # 30
          beq CaughtEmAll

          .enc "minifont"
          sta Temp
          lda #" "
          ldx # 6
-
          sta StringBuffer - 1, x
          dex
          bne -
          .FarJSR TextBank, ServiceAppendDecimalAndPrint

          jmp +
CaughtEmAll:
          .SetPointer EmAllText
          jsr ShowPointerText

          .SetUpFortyEight BossBearDies
          jsr ShowPicture
;;; 
          lda NewSWCHB
          beq +
          and #SWCHBReset
          beq Leave
+
          jmp Loop
;;; 
Leave:
          .WaitScreenBottom
          .WaitScreenTop
NewGamePlus:
          .mva Potions, #$80 | 25
          .mva CurrentGrizzard, # 2

ConsiderGrizzard:
          .FarJSR SaveKeyBank, ServicePeekGrizzardXP

          bcs SeenGrizzardBefore

          .FarJSR MapServicesBank, ServiceNewGrizzard

          .FarJSR SaveKeyBank, ServiceSaveGrizzard

SeenGrizzardBefore:
          dec CurrentGrizzard
          bpl ConsiderGrizzard

          ldy # 0               ; XXX necessary?
          sty CurrentGrizzard
          iny                   ; Y = 1
          sty CurrentProvince

WipeProvinceFlags:
          ldx # 8
-
          sta ProvinceFlags - 1, x
          dex
          bne -

          ;; Save Province 1 as zeroes
          .FarJSR SaveKeyBank, ServiceSaveProvinceData

          ;; Save Province 2 as zeroes
          inc CurrentProvince
          .FarJSR SaveKeyBank, ServiceSaveProvinceData

          ldy # 0               ; XXX necessary?
          sty CurrentMap
          sty CurrentProvince
          sty NextMap

          ;; Save global data, also save province 0 as zeroes
          .FarJSR SaveKeyBank, ServiceSaveToSlot

          jmp GoWarmStart
;;; 
AgainText:
          .MiniText "AGAIN!"
CaughtText:
          .MiniText "CAUGHT"
EmAllText:
          .MiniText "EM ALL"

          .bend

;;; Audited 2022-04-18 BRPocock
