          BANK = $01

          .include "StartBank.s"

          .include "Chat.s"
          .include "48Pixels.s"
          .include "VSync.s"
          .include "PlaySpeech.s"
          .include "Prepare48pxMobBlob.s"

Chatters:
          .byte 14

BeforeChatHook: .block
Return:   
          rts

          .bend

AfterChatHook: .block
          cmp #1
          beq NextChat

          brk

NextChat:
          inc ChatBuddy
          jmp DoChat
          .bend
          

ChatNames:
          .MiniText "INTRO."    ; Intro 1       ... 0
          .MiniText "FERRIS"    ; Intro 2       ... 1
          .MiniText "ROTON "    ; Intro 3       ... 2
          .MiniText "ROTON "    ;               ... 3
          .MiniText "BRIGHT"    ;               ... 4
          .MiniText "PELLON"    ;               ... 5
          .MiniText "CHENAL"    ; No Abraca Dabra ... 6
          .MiniText "CHENAL"    ; Abraca Dabra  ... 7
          .MiniText " SEED "    ;               ... 8
          .MiniText "CHIANA"    ; No Albron     ... 9
          .MiniText "CHIANA"    ; Albron        ... $a
          .MiniText "FERRIS"    ; No Albron     ... $b
          .MiniText "FERRIS"    ; Albron        ... $c

ChatColorFG:
          .colu COLGRAY, $f    ; Intro 1
          .colu COLGOLD, $f    ; Intro 2 (Ferris)
          .colu COLGRAY, $f    ; Intro 3 (Roton)
          .colu COLGRAY, $f    ; Roton
          .colu COLGOLD, $f    ; Bright
          .colu COLGOLD, $f    ; Pellon
          .colu COLGOLD, $f    ; Chenal (no Abraca Dabra)
          .colu COLGOLD, $f    ; Chenal (Abraca Dabra)
          .colu COLGOLD, $f    ; Seed
          .colu COLGOLD, $f    ; Chiana (No Albron)
          .colu COLGOLD, $f    ; Chiana (Albron)
          .colu COLGOLD, $f    ; Ferris (No Albron)
          .colu COLGOLD, $f    ; Ferris (Albron)

ChatColorBG:
          .colu COLGRAY, 0
          .colu COLINDIGO, 0
          .colu COLINDIGO, 0
          .colu COLINDIGO, 0
          .colu COLINDIGO, 0
          .colu COLINDIGO, 0
          .colu COLINDIGO, 0
          .colu COLINDIGO, 0
          .colu COLINDIGO, 0
          .colu COLINDIGO, 0
          .colu COLINDIGO, 0
          .colu COLINDIGO, 0
          .colu COLINDIGO, 0
          .colu COLINDIGO, 0

ChatPortraits:
          .byte $ff
          .byte ChatPortraitMan
          .byte ChatPortraitMan
          .byte ChatPortraitMan
          .byte ChatPortraitMan
          .byte ChatPortraitWoman
          .byte ChatPortraitWoman
          .byte ChatPortraitMan
          .byte ChatPortraitWoman
          .byte ChatPortraitWoman

ChatActions:
          .byte 1               ; Intro 1 (Roton)
          .byte 1               ; Intro 2 (Ferris)
          .byte 0               ; Intro 3 (Roton)
          .byte 0               ; Roton
          .byte 0               ; Bright
          .byte 0               ; Pellon
          .byte 0               ; Chenal (No Abraca Dabra)
          .byte 0               ; Chenal (Abraca Dabra)
          .byte 0               ; Seed
          .byte 0               ; Chiana (no Albron)
          .byte 0               ; Chiana (Albron)
          .byte 0               ; Ferris (No Albron)
          .byte 0               ; Ferris (Albron)

ChatSpeech:
          .include "Bank01Speech.s"

          .align $100
          .include "Font.s"
          .include "EndBank.s"
