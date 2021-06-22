SeedRandom:
          lda Rand
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
          asl
          ror Rand + 1
          bcc +
          eor #$DB
+
          asl
          ror Rand + 1
          bcc +
          eor #$db
+
          sta Rand
          eor Rand + 1
          rts
