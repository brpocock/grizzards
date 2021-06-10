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

          ModeChat = $50

;;; Portraits available for chat heads.
          ChatPortraitMan = 0
          ChatPortraitWoman = 1
          ChatPortraitChild = 2
          ;; there can be 6 portraits in bank 5

;;; Sounds in the library (index values)
          SoundDrone = 1
          SoundChirp = 2
          SoundDeleted = 3
          SoundHappy = 4
          SoundBump = 5

;;; AfterChat actions
          AfterChatSetFlag = 1
          AfterChatClearFlag = 2
          AfterChatHeal = 3
          AfterChatMoreChat = 4

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
          SpriteChat = $01
          SpriteDoor = $02
          SpriteCombat = $40
          SpriteProvinceDoor = $80


          ;; Save game slot address.
          ;; Must be aligned to 64 bytes
          ;; TODO allocate the appropriate number of pages with AtariAge
          ;;
          ;; https://atariage.com/atarivox/atarivox_mem_list.html
          SaveGameSlotPrefix = $1600
          
          ;; Must be exactly 5 bytes for the driver routines to work
          .enc "ascii"
          SaveGameSignature = "griz0"
          .enc "none"


;;; Special Memory Banks

          ColdStartBank = $00
          FacesBank = $05
          FailureBank = $05
          SFXBank = $07
          MapServicesBank = $03
