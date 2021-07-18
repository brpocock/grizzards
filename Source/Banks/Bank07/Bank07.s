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
          .include "Monsters5Speech.s"
          .include "Monsters6Speech.s"
          .include "MovesSpeech.s"
          .include "GrizzardsSpeech.s"
          .include "CombatSpeech.s"
          .include "TitleSpeech.s"
          .include "NumbersSpeech.s"
          .include "AtariToday.s"
          ;;.include "Theme.s"
SongTheme:
          .sound 0, 0, 0, 0, 0
          .sound 0, 0, 0, 0, 1
          .fill 400, 0
          .include "Victory.s"
          .include "GameOver.s"

          .include "EndBank.s"
