;;; Grizzards Source/Routines/GrizzardMetamorphosis.s
;;; Copyright © 2022 Bruce-Robert Pocock

GrizzardMetamorphosis:  .block
          BeforeGrizzard = DeltaY
          ScreenPhase = DeltaX
          
          .mvx s, #$ff              ; trash the stack

          .mva BeforeGrizzard, CurrentGrizzard

          ;; The  actual  metamorphosis  logic  (for  the  demo)  is  mostly
	;; duplicated in CombatVictoryScreen.s

          ;; Destroy current Grizzard's file
          ;; (also destroys Temp var though)
          ldy # 0
          sty MaxHP
          .FarJSR SaveKeyBank, ServiceSaveGrizzard

          ;; This is a duplicate of logic in NewGrizzard.CatchEm:
          .mva Temp, NextMap
          stx WSYNC
          .FarJSR MapServicesBank, ServiceGrizzardDefaults

          .WaitScreenTop

          ;; We have to also switch the current Grizzard to the new form
          ;; or if they quit, they'll come back with a zombie Grizzard
          ;; with 0 HP still selected as their current companion.
          ;; This came back as Issue #352
          .FarJSR SaveKeyBank, ServiceSetCurrentGrizzard

          .mva AlarmCountdown, # 3

          ldy # 0
          sty ScreenPhase
          sty SpeechSegment

          .mva NextSound, #SoundDepot
;;; 
Loop:
          .WaitScreenBottom
          .WaitScreenTop

          stx WSYNC
          .if SECAM == TV
            lda #COLBLACK
          .else
            .ldacolu COLORANGE, $e
          .fi
          sta COLUBK

          .SkipLines KernelLines / 5

          lda ScreenPhase
          cmp # 1
          blt DoneDrawing

          .mva CurrentGrizzard, BeforeGrizzard

          jsr DrawGrizzard

          .SkipLines 3
          
          jsr Prepare48pxMobBlob

          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1
          .FarJSR TextBank, ServiceShowGrizzardName

          .SkipLines 5

          lda ScreenPhase
          cmp # 2
          blt DoneDrawing

          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1

          .SetPointer BecameText
          jsr ShowPointerText

          lda ScreenPhase
          cmp # 3
          blt DoneDrawing

          .mva CurrentGrizzard, NextMap

          .SkipLines 3
          jsr DrawGrizzard

          .SkipLines 3
          jsr Prepare48pxMobBlob

          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1
          .FarJSR TextBank, ServiceShowGrizzardName

DoneDrawing:
          lda CurrentUtterance
          bne DoneTalking

          lda SpeechSegment
          cmp # 1
          bge Speech1

          .mva CurrentUtterance + 1, #>Phrase_Grizzard0
          lda #<Phrase_Grizzard0
          clc
          adc BeforeGrizzard
          sta CurrentUtterance
          gne SpeechReady

Speech1:
          cmp # 2
          bge Speech2

          lda ScreenPhase
          cmp # 2
          blt DoneTalking

          .SetUtterance Phrase_Became
          gne SpeechReady

Speech2:
          cmp # 3
          bge DoneTalking

          lda ScreenPhase
          cmp # 3
          blt DoneTalking

          .mva CurrentUtterance + 1, #>Phrase_Grizzard0
          lda #<Phrase_Grizzard0
          clc
          adc NextMap
          sta CurrentUtterance
SpeechReady:
          inc SpeechSegment
DoneTalking:
          lda AlarmCountdown
          bne Loop

          .mva AlarmCountdown, # 3

          inc ScreenPhase
          lda ScreenPhase
          cmp # 4
          blt Loop

Leave:
          .mva NextMap, CurrentMap
          .FarJMP TextBank, ServiceCombatVictory
;;; 
BecameText:
          .MiniText "BECAME"

          .bend

;;; Audited 2022-02-16 BRPocock
