;;; Grizzards Source/Routines/GrizzardEvolution.s
;;; Copyright © 2022 Bruce-Robert Pocock

GrizzardEvolution:  .block

          lda # 3
          sta AlarmCountdown

          lda # 0
          sta DeltaX
          sta SpeechSegment

Loop:
          .WaitScreenBottom
          .WaitScreenTop

          stx WSYNC
          .ldacolu COLSPRINGGREEN, $e
          sta COLUBK

          .SkipLines KernelLines / 5

          lda CurrentGrizzard
          pha

          lda DeltaX
          cmp # 1
          blt DoneDrawing

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
          pla
          sta CurrentGrizzard

          lda AlarmCountdown
          bne Loop

          inc DeltaX
          lda DeltaX
          cmp # 4
          blt Loop

Leave:
          
          rts

BecameText:
          .MiniText "BECAME"

          .bend
