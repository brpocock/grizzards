;;; Grizzards Source/Routines/Potion.s
;;; Copyright © 2022 Bruce-Robert Pocock

Potion:   .block

          .mva DeltaX, # 1
          .mva GameMode, #ModePotion
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
          and #$7f
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
          and #$7f
          beq DoneUp

          .mva DeltaX, # 0
          .mva NextSound, #SoundChirp
DoneUp:
          lda NewSWCHA
          and #P0StickDown
          bne DoneDown

          .mva DeltaX, # 1
          .mva NextSound, #SoundChirp
DoneDown:
DoneStick:
          lda NewButtons
          beq DoneButton

          and #ButtonI
          bne DoneButton

          ldx DeltaX
          beq UsePotion

          .mva GameMode, #ModeMap
          gne Leave

DoneButton:

          jmp Loop
;;; 
UsePotion:
          .mva CurrentHP, MaxHP
          lda Potions
          bpl NotCrowned

          and #$7f
          sec
          sbc # 1
          ora #$80
          sta Potions
          gne +
NotCrowned:
          dec Potions
+
          .mva NextSound, #SoundHappy

          .mva AlarmCountdown, # 5

UsedLoop:
          .WaitScreenBottom
          .WaitScreenTop

          jsr Prepare48pxMobBlob

          .ldacolu COLBLUE, $8
          stx WSYNC
          sta COLUBK
          .ldacolu COLYELLOW, $e
          sta COLUP0
          sta COLUP1

          .SkipLines KernelLines / 3

          .SetPointer UsedText
          jsr ShowPointerText

          .SetPointer PotionText
          jsr ShowPointerText

          lda AlarmCountdown
          bne UsedLoop

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
UsedText:
          .MiniText " USED "

          .bend

;;; Audited 2022-02-16 BRPocock
