;;; Grizzards Source/Routines/AttractStory.s
;;; Copyright © 2021 Bruce-Robert Pocock

AttractStory:       .block

          lda AttractHasSpoken
          cmp #<Phrase_Story
          beq Loop
          
          lda #>Phrase_Story
          sta CurrentUtterance + 1
          lda #<Phrase_Story
          sta CurrentUtterance
          sta AttractHasSpoken
;;; 
Loop:
          .WaitScreenTop

          .ldacolu COLBLUE, $8
          sta COLUBK

          .ldacolu COLBROWN, 0
          sta COLUP0
          sta COLUP1

          .LoadString "STORY "
          .FarJSR TextBank, ServiceDecodeAndShowText

          .LoadString "-TODO-"
          .FarJSR TextBank, ServiceDecodeAndShowText

          .LoadString "COMING"
          .FarJSR TextBank, ServiceDecodeAndShowText

          .LoadString "AUGUST"
          .FarJSR TextBank, ServiceDecodeAndShowText

;;; 

          lda ClockSeconds
          cmp AlarmSeconds
          bne StillStory

          lda # 30
          jsr SetNextAlarm
          lda #ModeAttractTitle
          sta GameMode
          rts

StillStory:
          .WaitScreenBottom

          lda NewSWCHB
          beq LoopMe
          and #SWCHBSelect
          bne LoopMe
          lda #ModeSelectSlot
          sta GameMode
          rts

LoopMe:
          jmp Loop

          ;; TODO flesh out this mode

          .rept $200
          nop
          .next
          
          .bend
