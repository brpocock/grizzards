;;; Grizzards Source/Routines/Random.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
SeedRandom:

          .if BANK == 0

          lda Rand
          bne +
          
          lda INPT1
          eor INPT3
          sta Rand
          lda INPT2
          eor INPT5
          sta Rand + 1
          rts

+
          .else

          lda Rand

          .fi

          eor ClockFrame
          sta Rand
          lda Rand + 1
          ora ClockFrame
          sta Rand + 1
          rts

;;; Random routine copied from Supercat on AtariAge
;;; https://atariage.com/forums/topic/116549-do-emulators-nullify-randomization-routines/?do=findComment&comment=1453512
          
Random:
          lda Rand
          asl a
          ror Rand + 1
          bcc +
          eor #$db
+
          asl a
          ror Rand + 1
          bcc +
          eor #$db
+
          sta Rand
          eor Rand + 1
          rts
