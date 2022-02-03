;;; Grizzards Source/Routines/NewGrizzard.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

NewGrizzard:        .block
          .WaitScreenTop

          ;; Call with new Grizzard in Temp
          lda Temp
          pha

          .KillMusic

          .FarJSR SaveKeyBank, ServicePeekGrizzard
          ;; carry is set if the Grizzard is found
          bcc CatchEm
          ;; If so, nothin!g doing, return
          pla        ; discard stashed ID
          lda CurrentMap
          sta NextMap
          jsr WaitScreenBottomSub

          rts

CatchEm:
          ;; New Grizzard found, save current Grizzard …
          .FarJSR SaveKeyBank, ServiceSaveGrizzard
          stx WSYNC
          .if NTSC == TV
          stx WSYNC
          .fi
          ;; … and set up this one with default levels
          pla
          sta Temp
          jsr Defaults

          stx WSYNC
          .if NTSC == TV
          stx WSYNC
          .fi
          .WaitScreenTop
          lda #SoundHappy
          sta NextSound

          lda #>Phrase_Grizzard0
          sta CurrentUtterance + 1
          lda #<Phrase_Grizzard0
          clc
          adc CurrentGrizzard
          sta CurrentUtterance

          lda # 7
          sta AlarmCountdown
Loop:
          .WaitScreenBottom
          .WaitScreenTop
          .ldacolu COLGRAY, $0
          sta COLUBK
          .ldacolu COLSPRINGGREEN, $e
          sta COLUP0
          sta COLUP1

          jsr Prepare48pxMobBlob

          .SkipLines KernelLines / 3

          .SetPointer CaughtText
          jsr ShowPointerText

          .FarJSR TextBank, ServiceShowGrizzardName
          .FarJSR AnimationsBank, ServiceDrawGrizzard

          lda AlarmCountdown
          beq +
          jmp Loop
+
          .WaitScreenBottom
          lda CurrentMap
          sta NextMap
          jmp GoMap

CaughtText:
          .MiniText "CAUGHT"

Defaults:
          .WaitScreenTop
          lda Temp
          sta CurrentGrizzard

          asl a
          asl a
          clc
          adc CurrentGrizzard  ; × 5
          tay
          ;; max 150, .y can hold it OK

          lda GrizzardStartingStats, y
          .if NOSAVE
          cmp MaxHP
          blt +
          .fi
          sta MaxHP
+
          .if NOSAVE
          lda MaxHP
          .fi
          sta CurrentHP
          iny
          lda GrizzardStartingStats, y
          .if NOSAVE
          cmp GrizzardAttack
          blt +
          .fi
          sta GrizzardAttack
+
          iny
          lda GrizzardStartingStats, y
          .if NOSAVE
          cmp GrizzardDefense
          blt +
          .fi
          sta GrizzardDefense
+
          iny
          .if !NOSAVE
          lda # 0               ; XP always starts at zero
          sta GrizzardXP
          .fi
          iny
          lda GrizzardStartingStats, y
          sta MovesKnown

          ;; Now, save this guy for good measure
          .FarJSR SaveKeyBank, ServiceSaveGrizzard

          rts
          
          .bend
