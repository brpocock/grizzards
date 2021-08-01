;;; Grizzards Source/Banks/Bank08/SignpostIndex.s
;;; Copyright © 2021 Bruce-Robert Pocock

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
Return:
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
          rtrs
          
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
