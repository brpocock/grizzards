          BANK = $07

          ;;
          ;; Sound and Music services
          ;;

          .include "StartBank.s"

DoLocal:

          .include "PlaySFX.s"
          .include "PlaySpeech.s"

          .include "SoundEffects.s"

MovesSpeech:        
          .include "MovesSpeech.s"
GrizzardsSpeech:    
          .include "GrizzardsSpeech.s"
CombatSpeech:
          .include "CombatSpeech.s"

          .include "EndBank.s"
