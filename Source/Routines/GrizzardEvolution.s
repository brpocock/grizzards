;;; Grizzards Source/Routines/GrizzardEvolution.s
;;; Copyright © 2022 Bruce-Robert Pocock

GrizzardEvolution:  .block

          lda # 8
          sta AlarmCountdown

          ;; TODO: Phase in bits
          ;; TODO: Add speech
Loop:
          .WaitScreenBottom
          .WaitScreenTop

          stx WSYNC
          .ldacolu COLSPRINGGREEN, $e
          sta COLUBK

          lda CurrentGrizzard
          pha

          .FarJSR AnimationsBank, ServiceDrawGrizzard
          
          jsr Prepare48pxMobBlob
          .ldacolu COLGRAY, 0
          sta COLUP0
          sta COLUP1
          .FarJSR TextBank, ServiceShowGrizzardName

          .SetPointer BecameText
          jsr ShowPointerText

          lda NewMap
          sta CurrentGrizzard

          .FarJSR AnimationsBank, ServiceDrawGrizzard
          jsr Prepare48pxMobBlob
          .FarJSR TextBank, ServiceShowGrizzardName

          pla
          sta CurrentGrizzard

          lda AlarmCountdown
          beq Leave
          
          jmp Loop

Leave:
          rts

BecameText:
          .MiniText "BECAME"

          .bend
