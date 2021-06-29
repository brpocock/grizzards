;;; Grizzards Source/Banks/Bank07/Bank07.s
;;; Copyright © 2021 Bruce-Robert Pocock
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
TitleSpeech:
          .include "TitleSpeech.s"

          .include "EndBank.s"
