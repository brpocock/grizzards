;;; Grizzards Source/Banks/Bank08/SignpostIndex.s
;;; Copyright © 2021-2022 Bruce-Robert Pocock

GetSignpostIndex:      .block
          ldx SignpostIndex

          cpx # 3
          beq CheckTunnelBlocked
          cpx # 6
          beq CheckTunnelVisited
          cpx # 7
          beq CheckTunnelVisited
          cpx # 13
          beq CheckShipInPort
          cpx # 21
          beq CheckFoundPendant
          cpx # 104
          beq CheckPotions
Return:
          rts

CheckPotions:
          lda Potions
          and #$7f
          cmp # 5
          blt Return

          ldx # 105
          rts

CheckFoundPendant:
          lda ProvinceFlags + 3 ; flag 28 = found pendant in mine
          and # %00010000
          beq Return
          ;; have you returned it yet?
          lda ProvinceFlags + 7
          and # %10000000
          bne ReturnPendantNow
          ldx # 24              ; already have key
          rts

ReturnPendantNow:
          ldx # 23              ; return pendant
          rts

CheckTunnelBlocked:
          lda ProvinceFlags + 2
          and # %00000110   ; Do they have both artifacts?
          cmp # %00000110
          bne Return
          ldx # 4               ; tunnel open
          rts

CheckTunnelVisited:
          lda ProvinceFlags + 2
          and # $01
          bne VisitedTunnel   ; did they visit the tunnel?
          ldx # 5               ; no, can't have artifact
          rts

VisitedTunnel:
          lda ProvinceFlags + 2
          cpx # 6
          beq Artifact1
          and # $02
          beq Return            ; get artifact
TookArtifact:
          ldx # 8
          rts

Artifact1Scared:
          ldx # 15
          rts
          
Artifact1:
          and # $04
          bne TookArtifact
          lda ProvinceFlags + 2
          and #$30
          cmp #$30
          bne Artifact1Scared
          ;; fall through

CheckShipInPort:
          lda ProvinceFlags
          and #$01
          beq Return
          ldx # 19
          rts

          .bend
