;;; Grizzards Source/Routines/GrizzardMetamorphosis.s
;;; Copyright © 2022 Bruce-Robert Pocock

GrizzardMetamorphosis:  .block
          ldx #$ff
          txs

          lda CurrentGrizzard
          sta DeltaY            ; stash here ("before")

          ;; The  actual  metamorphosis  logic  (for  the  demo)  is  mostly
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
          ;; This came back as BUG #352
          .FarJSR SaveKeyBank, ServiceSetCurrentGrizzard

          lda # 3
          sta AlarmCountdown

          ldy # 0
          sty DeltaX            ; we're using this as a screen φ timer
          sty SpeechSegment

          lda #SoundDepot
          sta NextSound
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

          lda DeltaX            ; screen φ
          cmp # 1
          blt DoneDrawing

          lda DeltaY            ; "before" Grizzard
          sta CurrentGrizzard

          jsr DrawGrizzard

          .SkipLines 3
          
          jsr Prepare48pxMobBlob

          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1
          .FarJSR TextBank, ServiceShowGrizzardName

          .SkipLines 5

          lda DeltaX            ; screen φ
          cmp # 2
          blt DoneDrawing

          .ldacolu COLINDIGO, 0
          sta COLUP0
          sta COLUP1

          .SetPointer BecameText
          jsr ShowPointerText

          lda DeltaX            ; screen φ
          cmp # 3
          blt DoneDrawing

          lda NextMap
          sta CurrentGrizzard

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

          lda #>Phrase_Grizzard0
          sta CurrentUtterance + 1
          lda #<Phrase_Grizzard0
          clc
          adc DeltaY            ; "before" Grizzard
          sta CurrentUtterance
          gne SpeechReady

Speech1:
          cmp # 2
          bge Speech2

          lda DeltaX            ; screen φ
          cmp # 2
          blt DoneTalking

          .SetUtterance Phrase_Became
          gne SpeechReady

Speech2:
          cmp # 3
          bge DoneTalking

          lda DeltaX            ; screen φ
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

          inc DeltaX            ; screen φ
          lda DeltaX
          cmp # 4
          blt Loop

Leave:
          lda CurrentMap
          sta NextMap
          .FarJMP TextBank, ServiceCombatVictory
;;; 
BecameText:
          .MiniText "BECAME"

          .bend

;;; Audited 2022-02-15 BRPocock
