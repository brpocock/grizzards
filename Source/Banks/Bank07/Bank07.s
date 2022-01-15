;;; Grizzards Source/Banks/Bank07/Bank07.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
          BANK = $07

          ;;
          ;; Sound and Music services
          ;;

          .include "StartBank.s"

DoLocal:
          .include "PlaySFX.s"
          .if DEMO
          .include "PlayMusic.s"
          .else
DoMusic:  
          ldx # MusicBank
          jsr FarCall
          .fi
          .include "PlaySpeech.s"
          rts

          .include "SoundEffects.s"

          .include "AtariToday.s"

          .include "Victory.s"
          .include "GameOver.s"

          .if DEMO
          .include "SpeakJetIndex.s"
          .include "MovesSpeech.s"
          .include "GrizzardsSpeech.s"
          .include "CombatSpeech.s"
          .include "Monsters6Speech.s"
          .else
          .include "SpeakJetIndexTitleOnly.s"
          .fi
          .include "TitleSpeech.s"

          .include "Theme.s"

          .include "EndBank.s"
