          BANK = $07

          ;;
          ;; Sound and Music services
          ;;
          ;; (not speech)
          ;; 

          .include "StartBank.s"

DoLocal:
          .include "PlaySFX.s"
          jmp FarReturn

          .include "SoundEffects.s"
          
          .include "EndBank.s"
