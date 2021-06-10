DoChat: .block

SetUpChat:
          ;; Find out if there's some other speech we should be giving,
          ;; maybe because of some game flag or something.
          ldx ChatBuddy
          jsr BeforeChatHook
          stx ChatBuddy

          ;; Start at the very beginning
          ;; (a very good place to start)
          lda #<ChatSpeech
          sta CurrentUtterance
          lda #>ChatSpeech
          sta CurrentUtterance + 1
          ;; Start counting here. Are we at zero? Then we're done
          ldx ChatBuddy
          beq FoundUtterance
          ;; .y has to stay zero throughout this process
          ldy #0

          ;; Search for the utterance .x
FindUtterance:
          ;; Advance to the next byte
          lda CurrentUtterance
          clc
          adc #1
          bcc +
          inc CurrentUtterance + 1
+
          sta CurrentUtterance
          ;; Check for #$ff by inverting and checking for zero
          lda (CurrentUtterance),y
          eor #$ff
          ;; Not #$ff? Keep scanning until we find it
          bne FindUtterance
          ;; It's #$ff, so decrement .x and keep looking
          dex
          bne FindUtterance

FoundUtterance:
          ;; Increment past the $ff and stash in both
          ;; CurrentUtterance and ChatBegan points
          lda CurrentUtterance
          clc
          adc #1
          bcc +
          inc CurrentUtterance + 1
+
          sta CurrentUtterance
          sta ChatBegan
          lda CurrentUtterance + 1
          sta ChatBegan + 1

          ldx ChatBuddy
          lda ChatPortraits, x
          sta ChatBuddyFace
          lda ChatColorFG, x
          sta ChatFG
          lda ChatColorBG, x
          sta ChatBG
          lda ChatActions, x
          sta AfterChatAction

          lda ChatBuddy
          clc
          rol a
          rol a
          adc ChatBuddy
          adc ChatBuddy
          tax
          lda ChatNames + 0, x
          sta StringBuffer + 0
          lda ChatNames + 1, x
          sta StringBuffer + 1
          lda ChatNames + 2, x
          sta StringBuffer + 2
          lda ChatNames + 3, x
          sta StringBuffer + 3
          lda ChatNames + 4, x
          sta StringBuffer + 4
          lda ChatNames + 5, x
          sta StringBuffer + 5

Loop:
          lda ChatBuddyFace
          eor #$ff
          beq SkipFace
          ldx #FacesBank
          jsr FarCall
          jmp PrintName

SkipFace:
          jsr Prepare48pxMobBlob
          ldx #41
SkipFaceLoop:
          stx WSYNC
          dex
          bne SkipFaceLoop

PrintName:
          lda #( 76 * (KernelLines - 89) ) / 64 - 3
          sta TIM64T

          jsr PlaySpeech

FillScreen:
          sta WSYNC
          lda INTIM
          bne FillScreen

          sta WSYNC
          sta WSYNC
          sta WSYNC

          lda INPT4
          and #$80
          cmp DebounceFire
          beq NoNeedToRepeatYourself
          lda INPT4
          and #$80
          sta DebounceFire
          beq Fire

          lda SWCHA
          and #P0StickUp
          bne NoNeedToRepeatYourself

          lda ChatBegan
          sta CurrentUtterance
          lda ChatBegan + 1
          sta CurrentUtterance + 1

NoNeedToRepeatYourself:

          lda SWCHB
          cmp DebounceSWCHB
          beq SkipSwitches
          sta DebounceSWCHB
          and #SWCHBReset
          bne SkipSwitches

          lda #ModeAttract
          sta GameMode

SkipSwitches:

          jsr Overscan
          lda GameMode
          cmp #ModeChat
          bne Return
          jmp Loop

Fire:
          lda AfterChatAction
          bne AfterChatExtension
AfterChatMap:
          lda #ModeMap
          sta GameMode
Return:
          jmp Dispatch

AfterChatExtension:
          jmp AfterChatHook

          .bend
