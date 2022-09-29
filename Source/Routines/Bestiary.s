;;; Grizzards Source/Routines/Bestiary.s
;;; Copyright © 2022 Bruce-Robert Pocock

Bestiary: .block
          .mva EnemyHP, # 1
          .mva AlarmCountdown, # 18
          .mva CombatMajorP, #$80
          .WaitScreenBottom

Loop:
          .WaitScreenTop
          .ldacolu COLGRAY, $c
          stx WSYNC
          sta COLUBK

          .SkipLines KernelLines / 3

          .FarJSR MonsterBank, ServiceDrawBoss

          lda AlarmCountdown
          beq NextPhase

          lda NewSWCHB
          beq CheckFire

          and #SWCHBSelect
          bne LoopMe

CheckFire:
          lda NewButtons
          beq LoopMe

          and #ButtonI
          bne LoopMe

          .mva GameMode, #ModeSelectSlot
          rts
          
LoopMe:
          .WaitScreenBottom
          jmp Loop

NextPhase:
          .if ATARIAGESAVE
            .mva AlarmCountdown, # 30
            .mva GameMode, #ModeAttractHighScore
          .else
            .mva AlarmCountdown, # 8
            .mva GameMode, #ModePublisherPresents
          .fi

          rts
          
          .bend
