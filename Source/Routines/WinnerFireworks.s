;;; Grizzards Source/Routines/WinnerFireworks.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
WinnerFireworks:    .block

          .KillMusic
          .mva NextSound, #SoundRoar

          .WaitScreenBottom
          .WaitScreenTop

          .mvy NewButtons, # 0
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
          lda CurrentGrizzard
          cmp # 30
          blt CheckCaughtLoop

          ;; First, save everything, then pull the user's name for the message text
          ;; SaveToSlot starts _and ends_ with WaitScreenBottom calls.
          .FarJSR SaveKeyBank, ServiceSaveToSlot
          .switch TV
          .case NTSC
            stx WSYNC
            stx WSYNC
          .endswitch
          .WaitScreenTopMinus 1, 1
          .FarJSR SaveKeyBank, ServiceCheckSaveSlot
          .WaitScreenBottom
          .WaitScreenTopMinus 1, 1
;;; 
Loop:
          ldx #SFXBank
          jsr FarCall
          .WaitScreenBottom
          .switch TV
          .case PAL,SECAM
            .SkipLines 2
            stx TIM64T          ; strobe the clock an extra time …
          ;; If we don't do this, every 31 frames it just does not work. See
          ;; #503 and notes on 2022-07-14 (Vol III page "You Won PAL Timings")
          .endswitch
          .WaitScreenTopMinus 1, 0
          stx WSYNC
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

          sta Temp

          ldx # 5
BlankFillLoop:
          lda ZeroText, x
          sta StringBuffer, x
          dex
          bpl BlankFillLoop

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
          lda NewButtons
          beq DoneButtons

          and #ButtonI
          bne DoneButtons

GoShowCredits:
          .WaitScreenBottom
          .mvx SignpostIndex, # 108    ; Credits1
          jmp Signpost

DoneButtons:
          jmp Loop
;;; 
Leave:
          .WaitScreenBottom
          .WaitScreenTop
;;; 
NewGamePlus:
          .mva Potions, #$80 | 25
;;; 
AddAllStarters:
          .mva CurrentGrizzard, # 2

ConsiderGrizzard:
          .mva Temp, CurrentGrizzard
          .FarJSR SaveKeyBank, ServicePeekGrizzardXP

          bit Temp
          bmi SeenGrizzardBefore

          .mva Temp, CurrentGrizzard
          .WaitScreenBottom
          ;; Defaults does WaitScreenTop and SaveGrizzard and WaitScreenBottom
          .FarJSR MapServicesBank, ServiceGrizzardDefaults
          .WaitScreenTop

SeenGrizzardBefore:
          dec CurrentGrizzard
          bpl ConsiderGrizzard
;;; 
SelectAvailableGrizzard:
          .mva CurrentGrizzard, # 0

GrizzardCheckup:
          .mva Temp, CurrentGrizzard
          .FarJSR SaveKeyBank, ServicePeekGrizzard

          bit Temp
          bmi ValidGrizzardToBeCurrent

          inc CurrentGrizzard
          gne GrizzardCheckup

ValidGrizzardToBeCurrent:
          .FarJSR SaveKeyBank, ServiceLoadGrizzard
;;; 
ResetProvinceFlags:
          ldy # 0               ; XXX necessary?
          sty CurrentMap
          sty NextMap
          tya

          iny                   ; Y = 1
          sty CurrentProvince

WipeProvinceFlags:
          ldx # 8
Wipe8Bytes:
          sta ProvinceFlags - 1, x
          dex
          bne Wipe8Bytes

          .WaitScreenBottom

          ;; Save Province 1 as zeroes
          .FarJSR SaveKeyBank, ServiceSaveProvinceData

          ;; Save Province 2 as zeroes
          inc CurrentProvince
          .FarJSR SaveKeyBank, ServiceSaveProvinceData

          .mvy CurrentProvince, # 0
          ;; Save global data, also save province 0 as zeroes
          .FarJSR SaveKeyBank, ServiceSaveToSlot

          stx WSYNC
          stx WSYNC

          .mvx SignpostIndex, # 29 ; NewGamePlusGo
          jmp Signpost
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
