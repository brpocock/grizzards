;;;
;;; Enumerated values used in various places.
;;; 

;;; Game modes are set up as a major (upper nybble) and minor (lower nybble)
;;; mode. The major mode usually indicates which kernel will be used; the
;;; minor modes allow the game mode to track its own sub-states.
          
          ModeColdStart = $00
          
          ModeAttract = $10
          ModeAttractTitle = $11
          ModeAttractCopyright = $12
          ModeAttractStory = $13
          ModeBRPPreamble = $1e
          ModePublisherPresents = $1f
          
          ModeSelectSlot = $20
          ModeEraseSlot = $21
          ModeErasing = $22
          ModeNoAtariVox = $23
          ModeStartGame = $24

          ModeMap = $30

          ModeCombat = $40
          ModeCombatIntro = $41
          ModeCombatPlayer = $42
          ModeCombatEnemy = $43
          ModeDeath = $44
          ModeGrizzardStats = $45

          ModeGrizzardStation = $50


;;; Sounds in the library (index values)
          SoundDrone = 1
          SoundChirp = 2
          SoundDeleted = 3
          SoundHappy = 4
          SoundBump = 5


;;; Status Effects for player or enemies 
          StatusSkipTurn = $01
          StatusSleeping = $02
          StatusFlying = $04
          StatusUndersea = $08
          StatusOnFire = $10
          StatusFrozen = $20

;;; Sprite types
          RandomEncounter = $80 ; likelihood of encounter = lower 7 bits
          SpriteFixed = $40
          SpriteWander = $20
          
;;; Sprite actions
          SpriteDoor = $02
          SpriteGrizzardStation = $04
          SpriteCombat = $40
          SpriteProvinceDoor = $80


          ;; Save game slot address.
          ;; Must be aligned to 64 bytes
          ;; TODO allocate the appropriate number of pages with AtariAge
          ;;
          ;; https://atariage.com/atarivox/atarivox_mem_list.html
          SaveGameSlotPrefix = $1700
          
          ;; Must be exactly 5 bytes for the driver routines to work
          .enc "ascii"
          SaveGameSignature = "griz0"
          .enc "none"


;;; Special Memory Banks

          ColdStartBank = $00
          SaveKeyBank = $00
          FailureBank = $02
          SFXBank = $07
          MapServicesBank = $03
          TextBank = $02

;;; Text bank provides multiple services, selected with .y

          ServiceDecodeAndShowText = $01
          ServiceShowText = $02
          ServiceShowGrizzardName = $03
          ServiceShowGrizzardStats = $04
          ServiceDrawGrizzard = $05
          ServiceShowMove = $06
          ServiceGrizzardStation = $07

;;; Map services bank, same

          ServiceTopOfScreen = $00
          ServiceBottomOfScreen = $01

;;; Also the cold start / save game bank

          ServiceColdStart = $00
          ServiceSaveToSlot = $01
