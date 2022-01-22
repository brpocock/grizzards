;;; Grizzards Source/Routines/GrizzardEvolution.s
;;; Copyright © 2022 Bruce-Robert Pocock

GrizzardEvolution:  .block
          ldx #$ff
          stx s

          lda CurrentGrizzard
          sta DeltaY

          ;; The  actual  evolution  logic  (for  the  demo)  is  mostly
	;; duplicated in CombatVictoryScreen.s

          ;; Destroy current Grizzard's file
          ;; (also destroys Temp var though)
          ldy # 0
          sty MaxHP
          .FarJSR SaveKeyBank, ServiceSaveGrizzard

          ;; This is a duplicate of logic in NewGrizzard.CatchEm:
          lda NextMap
          sta Temp
          stx WSYNC
          .FarJSR MapServicesBank, ServiceGrizzardDefaults

          .WaitScreenTop

          ;; We have to also switch the current Grizzard to the new form
          ;; or if they quit, they'll come back with a zombie Grizzard
          ;; with 0 HP still selected as their current companion.
          .FarJSR SaveKeyBank, ServiceSetCurrentGrizzard

          lda # 3
          sta AlarmCountdown

          lda # 0
          sta DeltaX
          sta SpeechSegment

          lda #SoundDepot
          sta NextSound

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

          lda DeltaX
          cmp # 1
          blt DoneDrawing

          lda DeltaY
          sta CurrentGrizzard

          .FarJSR AnimationsBank, ServiceDrawGrizzard
          .SkipLines 3
          
          jsr Prepare48pxMobBlob
          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1
          .FarJSR TextBank, ServiceShowGrizzardName
          .SkipLines 5

          lda DeltaX
          cmp # 2
          blt DoneDrawing

          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1

          .SetPointer BecameText
          jsr ShowPointerText

          lda DeltaX
          cmp # 3
          blt DoneDrawing

          lda NextMap
          sta CurrentGrizzard

          .SkipLines 3
          .FarJSR AnimationsBank, ServiceDrawGrizzard
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

          lda #>Phrase_Grizzard0
          sta CurrentUtterance + 1
          lda #<Phrase_Grizzard0
          clc
          adc DeltaY
          sta CurrentUtterance

          gne SpeechReady

Speech1:
          cmp # 2
          bge Speech2
          lda DeltaX
          cmp # 2
          blt DoneTalking

          .SetUtterance Phrase_Became
          gne SpeechReady

Speech2:
          cmp # 3
          bge DoneTalking
          lda DeltaX
          cmp # 3
          blt DoneTalking

          lda #>Phrase_Grizzard0
          sta CurrentUtterance + 1
          lda #<Phrase_Grizzard0
          clc
          adc NextMap
          sta CurrentUtterance

SpeechReady:
          inc SpeechSegment

DoneTalking:
          lda AlarmCountdown
          bne Loop

          lda # 3
          sta AlarmCountdown

          inc DeltaX
          lda DeltaX
          cmp # 4
          blt Loop

Leave:
          lda CurrentMap
          sta NextMap
          .FarJMP TextBank, ServiceCombatVictory

BecameText:
          .MiniText "BECAME"

          .bend
