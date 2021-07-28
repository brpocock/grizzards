;;; Grizzards Source/Banks/Bank07/Bank07.s
;;; Copyright © 2021 Bruce-Robert Pocock
          BANK = $07

          ;;
          ;; Sound and Music services
          ;;

          .include "StartBank.s"

DoLocal:
          .include "PlaySFX.s"
          .include "PlayMusic.s"
          .include "PlaySpeech.s"
          rts

          .include "SoundEffects.s"

          .include "SpeakJetIndex.s"
          ;; Speech index uses a wildcard on this directory
          ;; All files must be included or the index will break
          .include "Monsters6Speech.s"
          .include "MovesSpeech.s"
          .include "GrizzardsSpeech.s"
          .include "CombatSpeech.s"
          .include "TitleSpeech.s"
          .include "AtariToday.s"
          .include "Theme.s"
          .include "Victory.s"
          .include "GameOver.s"

          .fill 26, "sfx"

          .include "EndBank.s"
