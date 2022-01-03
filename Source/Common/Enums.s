;;; Grizzards Source/Common/Enums.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock
;;;
;;; Enumerated values used in various places.
;;; 

;;; 
;;; Game modes are set up as a major (upper nybble) and minor (lower nybble)
;;; mode. The major mode usually indicates which kernel will be used; the
;;; minor modes allow the game mode to track its own sub-states.
          
          ModeColdStart = $00

          ModeAttract = $10
          ModeAttractTitle = $11
          ModeAttractCopyright = $12
          ModeAttractStory = $13
          ModeCreditSecret = $14
          ModeBRPPreamble = $1e
          ModePublisherPresents = $1f

          ModeSelectSlot = $20
          ModeEraseSlot = $21
          ModeErasing = $22
          ModeNoAtariVox = $23
          ModeStartGame = $24

          ModeMap = $30
          ModeMapNewRoom = $31
          ModeMapNewRoomDoor = $32

          ModeCombat = $40
          ModeCombatAnnouncement = $41
          ModeCombatOutcome = $43
          ModeDeath = $44
          ModeCombatNextTurn = $45
          ModeLearntMove = $46
          ModeLevelUp = $47

          ModeGrizzardDepot = $50

          ModeNewGrizzard = $60

          ModeGrizzardStats = $70

          ModeSignpost = $80
          ModeSignpostDone = $81
          ModeSignpostSetFlag = $82
          ModeSignpostClearFlag = $83
          ModeSignpostWarp = $84
          ModeSignpostSet0And63 = $85 ; when Peter is found.
          ModeTrainLastMove = $86
;;; 
;;; Sounds in the library (index values)
          SoundDrone = 1
          SoundChirp = 2
          SoundDeleted = 3
          SoundHappy = 4
          SoundBump = 5
          SoundHit = SoundBump
          SoundMiss = SoundDeleted
          SoundError = 6
          SoundSweepUp = 7
          SoundAtariToday = 8
          SoundVictory = 9
          SoundGameOver = 10
          SoundFootstep = 11
;;; 
;;; Status Effects for player or enemies 
          StatusSleep = $01
          StatusAttackDown = $04
          StatusDefendDown = $08
          StatusMuddle = $10
          StatusAttackUp = $40
          StatusDefendUp = $80
;;; 
          MoveEffectsToEnemy = $1f
          MoveEffectsToSelf = $e0
;;; 
          LevelUpAttack = $01
          LevelUpDefend = $02
          LevelUpMaxHP = $04
;;; 
;;; Sprite types
          RandomEncounter = $80
          SpriteFixed = $40
          SpriteWander = $20

          SpriteMoveNone = $00
          SpriteMoveIdle = $01
          SpriteRandomEncounter = $02
          SpriteMoveLeft = $10
          SpriteMoveRight = $20
          SpriteMoveUp = $40
          SpriteMoveDown = $80
;;; 
;;; Sprite actions
          SpriteCombat = $00
          SpriteGrizzardDepot = $01
          SpriteGrizzard = $02
          SpriteDoor = $03
          SpriteSign = $04
          SpritePerson = $05
          SpriteMajorCombat = $06
          SpriteCombatPuff = $07
          SpriteProvinceDoor = $07
;;; 
          ;; Save game slot address.
          ;; Must be page-aligned
          ;; Uses the subsequent 12 64-byte blocks
          .if DEMO
          SaveGameSlotPrefix = $3000
          .else
          ;; https://atariage.com/atarivox/atarivox_mem_list.html
          SaveGameSlotPrefix = $1100
          .fi
          
          ;; Must be exactly 5 bytes for the driver routines to work
          .enc "ascii"
          SaveGameSignature = "griz0"
          .enc "none"
;;; 
;;; Special Memory Banks

          ColdStartBank = $00
          SaveKeyBank = $00
          MapServicesBank = $01
          .if DEMO
          AnimationsBank = $03
          .else
          AnimationsBank = $0f
          .fi
          TextBank = $02
          FailureBank = $01
          Province0MapBank = $04
          .if !DEMO
          Province1MapBank = $03
          Province2MapBank = $05
          .fi
          CombatBank0To127 = $06
          CombatBank128To255 = $06
          SFXBank = $07
          .if DEMO
          SignpostBank = $05
          SignpostBankCount = 1
          .else
          SignpostBank = $08
          SignpostBankCount = 7
          .fi

          .if !DEMO
          FinaleBank = $0f
          .fi
;;; 
;;; Text bank provides multiple services, selected with .y

          ServiceAppendDecimalAndPrint = $0e
          ServiceCombatOutcome = $14
          ServiceDecodeAndShowText = $01
          ServiceFetchGrizzardMove = $13
          ServiceLearntMove = $18
          ServiceLevelUp = $1a
          ServiceNewGame = $0f
          ServiceShowGrizzardName = $03
          ServiceShowGrizzardStats = $04
          ServiceShowMove = $06
          ServiceShowMoveDecoded = $17
          ServiceShowText = $02
          ServiceCombatIntro = $1b
          ServiceCombatVictory = $1c

;;; Map services bank, same

          ServiceBottomOfScreen = $09
          ServiceGrizzardDepot = $07
          ServiceGrizzardStatsScreen = $19
          ServiceNewGrizzard = $0c
          ServiceTopOfScreen = $08
          ServiceValidateMap = $1d

;;; Animations services

          ServiceDrawGrizzard = $05
          ServiceAttractStory = $15
          ServiceDeath = $0d
          ServiceDrawMonsterGroup = $0b
          ServiceFireworks = $0a

;;; Also the cold start / save game bank

          ServiceColdStart = $00
          ServicePeekGrizzard = $12
          ServiceSaveGrizzard = $11
          ServiceSaveToSlot = $10
          ServiceAttract = $1e
          ServiceSaveProvinceData = $20
          ServiceLoadProvinceData = $21
          ServiceLoadGrizzard = $22
;;; 
;;; Maximum number of Grizzards allowed
;;; The save/load routines should handle up to 36

          NumGrizzards = 30
;;; 
;;; Screen boundaries for popping to the next screen

          ScreenLeftEdge = $30
          ScreenRightEdge = $c8
          ScreenTopEdge = 8
          ScreenBottomEdge = 75
;;; 
;;; Localization

          LangEng = $0e
          LangSpa = $05
          LangFra = $0f
;;; 
;;; Indices into the monster table
          MonsterNameIndex = 0
          MonsterArtIndex = 9
          MonsterColorIndex = 10
          MonsterAttackIndex = 11
          MonsterDefendIndex = 12
          MonsterHPIndex = 13
          MonsterPointsIndex = 14 ; two bytes, low byte, high byte order

;;; 
;;; MapFlags values
          MapFlagRandomSpawn = $04
          MapFlagFacing = $08   ; matches REFP0 REFLECTED bit
          MapFlagSprite0Moved = $10
          MapFlagSprite1Moved = $20
          MapFlagSprite2Moved = $40
          MapFlagSprite3Moved = $80
;;; 
;;; Monster art types
          Monster_Bunny = 0
          Monster_Rodent = 1
          Monster_Sheep = 2
          Monster_Turtle = 3
          Monster_Fox = 4
          Monster_Cat = 5
          Monster_Dog = 6
          Monster_Bear = 7
          Monster_Mouse = 8
          Monster_Firefox = 9
          Monster_TwoLegs = 10
          Monster_Mutant = 11
          Monster_WillOWisp = 12
          Monster_Butterfly = 13
          Monster_SlimeSmall = 14
          Monster_Serpent = 15
          Monster_Bird = 16
          Monster_Crab = 17
          Monster_Raptor = 18
          Monster_Human = 19
          Monster_Bat = 20
          Monster_Eagle = 21
          Monster_Dragon = 22
          Monster_SlimeBig = 23
          Monster_Cyclops = 24
