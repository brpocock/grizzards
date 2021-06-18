          BANK = $07

          ;;
          ;; Sound and Music services
          ;;
          ;; (not speech)
          ;; 

          .include "StartBank.s"

DoLocal:
          .include "PlaySFX.s"

          .include "SoundEffects.s"
          
          .include "EndBank.s"
