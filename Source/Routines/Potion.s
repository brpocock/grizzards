;;; Grizzards Source/Routines/Potion.s
;;; Copyright © 2022 Bruce-Robert Pocock

Potion:   .block

          lda # 1
          sta DeltaX

          lda #ModePotion
          sta GameMode
          
          .SetUtterance Phrase_Potion
          .KillMusic
          geq FirstLoop

Loop:
          .WaitScreenBottom
FirstLoop:
          .WaitScreenTop

          jsr Prepare48pxMobBlob

          .ldacolu COLBLUE, $8
          stx WSYNC
          sta COLUBK

          .ldacolu COLYELLOW, $e
          sta COLUP0
          sta COLUP1

          .SetPointer PotionText
          jsr ShowPointerText

          .SetPointer CountText
          jsr ShowPointerText

          .SetPointer ZeroText
          lda Potions
          jsr AppendDecimalAndPrint

          .SkipLines KernelLines / 3

          .ldacolu COLBLUE, $8
          ldx DeltaX
          bne +
          .ldacolu COLMAGENTA, $4
+
          stx WSYNC
          sta COLUBK

          .SetPointer UseText
          jsr ShowPointerText
          .SkipLines 2

          .ldacolu COLINDIGO, $4
          ldx DeltaX
          bne +
          .ldacolu COLBLUE, $8
+
          stx WSYNC
          sta COLUBK

          .SetPointer DontText
          jsr ShowPointerText
          .SkipLines 2

          .ldacolu COLBLUE, $8
          stx WSYNC
          sta COLUBK

DoneSwitches:       
          lda NewSWCHA
          beq DoneStick
          and #P0StickUp
          bne DoneUp

          lda Potions
          beq DoneUp

          lda # 0
          sta DeltaX
          lda #SoundChirp
          sta NextSound
DoneUp:
          lda NewSWCHA
          and #P0StickDown
          bne DoneDown

          lda # 1
          sta DeltaX
          lda #SoundChirp
          sta NextSound
DoneDown:
DoneStick:
          lda NewButtons
          beq DoneButton
          and #PRESSED
          bne DoneButton

          ldx DeltaX
          beq UsePotion
          
          lda #ModeMap
          sta GameMode
          gne Leave

DoneButton:

          jmp Loop
;;; 

UsePotion:
          lda MaxHP
          sta CurrentHP
          dec Potions

          lda #SoundHappy
          sta NextSound
Leave:
          .WaitScreenBottom
          jmp GoMap
;;; 

PotionText:
          .MiniText "POTION"
CountText:
          .MiniText "COUNT "
ZeroText:
          .MiniText "    00"
UseText:
          .MiniText " USE  "
DontText:
          .MiniText "DO NOT"
          .bend
