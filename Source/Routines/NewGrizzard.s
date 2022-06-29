;;; Grizzards Source/Routines/NewGrizzard.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

NewGrizzard:        .block
          ;; Call with new Grizzard in Temp
          lda Temp
          pha

          .WaitScreenTop

          .KillMusic

          pla
          pha
          .FarJSR SaveKeyBank, ServicePeekGrizzard
          bit Temp
          bpl CatchEm

          ;; Already caught, nothing doing, return
          pla        ; discard stashed ID
          .mva NextMap, CurrentMap
          jmp WaitScreenBottomSub ; tail call

CatchEm:
          ;; New Grizzard wasn't already found, save current Grizzard …
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
          .mva NextSound, #SoundHappy

          .mva CurrentUtterance + 1, #>Phrase_Grizzard0
          lda #<Phrase_Grizzard0
          clc
          adc CurrentGrizzard
          sta CurrentUtterance

          .mva AlarmCountdown, # 7
;;;
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
          lda GameMode
          cmp #ModeWinnerFireworks
          bne BackToMap

          rts

BackToMap:
          .mva NextMap, CurrentMap
          jmp GoMap
;;; 
CaughtText:
          .MiniText "CAUGHT"
;;; 
Defaults:
          .WaitScreenTop
          .mva CurrentGrizzard, Temp

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
          .mva GrizzardXP, # 0               ; XP always starts at zero
          iny
          lda GrizzardStartingStats, y
          sta MovesKnown

          ;; Now, save this guy for good measure
          .FarJMP SaveKeyBank, ServiceSaveGrizzard ; tail call
          
          .bend

;;; Audited 2022-02-16 BRPocock
