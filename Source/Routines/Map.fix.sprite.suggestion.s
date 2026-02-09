; Enemy             ;    CYCLE 15
    VKERNEL1 ENH
    lda #31         ; 2     enemy height
    dcp enDY        ; 5
    bcs .DrawE0     ; 2/3
    lda #0          ; 2
    .byte $2C       ; 4-5   BIT compare hack to skip 2 byte op
.DrawE0:
    lda (enSpr),y   ; 5
          tax             ; 2

          ;; from @mzxrules
