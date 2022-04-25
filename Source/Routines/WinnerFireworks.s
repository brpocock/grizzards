;;; Grizzards Source/Routines/WinnerFireworks.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
WinnerFireworks:    .block

          .KillMusic
          .mva NextSound, #SoundRoar

          .WaitScreenBottom
          .WaitScreenTop

          ldy # 0
          sty CurrentHP         ; now = Grizzards Count
          sty CurrentGrizzard   ; search each Grizzard, 0 - 29
CheckCaughtLoop:
          .mva Temp, CurrentGrizzard
          .FarJSR SaveKeyBank, ServicePeekGrizzardXP

          bit Temp
          bpl NotCaught

          inc CurrentHP         ; Grizzards Count
NotCaught:
          inc CurrentGrizzard
          lda CurrentGrizzard
          ;; Stop periodically to keep the frame count OK
          and #$04
          beq +
          .WaitScreenBottom
          .WaitScreenTop
+
          cmp # 30
          blt CheckCaughtLoop

          ;; First, save everything, then pull the user's name for the message text
          .FarJSR SaveKeyBank, ServiceSaveToSlot
          .FarJSR SaveKeyBank, ServiceCheckSaveSlot
;;; 
Loop:
          .WaitScreenBottom
          ldx #SFXBank
          jsr FarCall
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

          jmp DoneAgain

NotAgain:
          .SkipLines 16
DoneAgain:

          .SetUpFortyEight BossBearDies
          jsr ShowPicture

          .SetPointer CaughtText
          jsr ShowPointerText

          lda CurrentHP         ; Grizzards Count
          cmp # 30
          beq CaughtEmAll

          .enc "minifont"
          sta Temp

          ldx # 0
BlankFillLoop:
          lda ZeroText, x
          sta StringBuffer, x
          inx
          cpx # 6
          blt BlankFillLoop

          .FarJSR TextBank, ServiceAppendDecimalAndPrint

          jmp CaughtDone

CaughtEmAll:
          .SetPointer EmAllText
          jsr ShowPointerText

CaughtDone:
;;; 
          lda NewSWCHB
          beq DoneSwitches

          and #SWCHBReset
          beq Leave

DoneSwitches:
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

          bit Temp
          bmi SeenGrizzardBefore

          .FarJSR MapServicesBank, ServiceNewGrizzard

SeenGrizzardBefore:
          dec CurrentGrizzard
          bpl ConsiderGrizzard

          ldy # 0               ; XXX necessary?
          sty CurrentGrizzard
          iny                   ; Y = 1
          sty CurrentProvince

WipeProvinceFlags:
          ldx # 8
Wipe8Bytes:
          sta ProvinceFlags - 1, x
          dex
          bne Wipe8Bytes

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
ZeroText:
          .MiniText "    00"
EmAllText:
          .MiniText "EM ALL"

          .bend

;;; Audited 2022-04-23 BRPocock
