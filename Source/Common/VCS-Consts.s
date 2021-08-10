;;; Atari VCS constants
;;; Copyright © 2006,2007,2017,2020 Bruce-Robert Pocock (brpocock@star-hope.org)
;;;

          BuildPlatform = 2600

          NTSC = "n"[0]
          PAL = "p"[0]
          SECAM = "s"[0]

;;; 
;;; Input pins

          ;; read SWCHA
          P0StickUp = $10
          P0StickDown = $20
          P0StickLeft = $40
          P0StickRight = $80
          P0StickCentered = $f0
          P1StickUp = 1
          P1StickDown = 2
          P1StickLeft = 4
          P1StickRight = 8
          P1StickCentered = $f

          ;; read INPT4 (P0), INPT5 (P1) for stick fire button
          PRESSED = $80

          P0Fire = INPT4
          P1Fire = INPT5

          ;; Paddles: TODO.

          ;; Keypad
          ;; Set SWACNT ← $0f (for P1)
          SWACNTKeypadP0 = $f0
          SWACNTKeypadP1 = $0f
          P0KeypadRow1 = $10
          P0KeypadRow2 = $20
          P0KeypadRow3 = $40
          P0KeypadRow4 = $80
          P1KeypadRow1 = 1
          P1KeypadRow2 = 2
          P1KeypadRow3 = 4
          P1KeypadRow4 = 8
          P0KeypadLeftColumn = INPT0
          P0KeypadMiddleColumn = INPT1
          P0KeypadRightColumn = INPT4
          P1KeypadLeftColumn = INPT2
          P1KeypadMiddleColumn = INPT3
          P1KeypadRightColumn = INPT5

          ;; Console
          SWCHBReset = $01
          SWCHBSelect = $02
          SWCHB7800 = $04 ; this is something we set ourselves
          .if TV != SECAM
            SWCHBColor = $08
          .fi
          SWCHBP0Genesis = $10
          SWCHBP1Genesis = $20
          SWCHBP0Advanced = $40
          SWCHBP1Advanced = $80

;;;
;;; Palettes

          .switch TV
          .case NTSC
          COLGREY = 0
          COLYELLOW = $10
          COLBROWN = $20
          COLORANGE = $30
          COLRED = $40
          COLMAGENTA = $50
          COLPURPLE = $60
          COLINDIGO = $70
          COLBLUE = $80
          COLTURQUOISE = $90
          COLCYAN = $a0
          COLTEAL = $b0
          COLSEAFOAM = $c0
          COLGREEN = $d0
          COLSPRINGGREEN = $e0
          COLGOLD = $f0
          
          .case PAL
          COLGREY = 0
          COLGOLD = $20
          COLSPRINGGREEN = $30
          COLORANGE = $40
          COLGREEN = $50
          COLRED = $60
          COLTEAL = $70
          COLMAGENTA = $80
          COLCYAN = $90
          COLPURPLE = $a0
          COLTURQUOISE = $b0
          COLINDIGO = $c0
          COLBLUE = $d0
          ;; not actually available on PAL:
          COLYELLOW = COLGOLD
          COLSEAFOAM = COLSPRINGGREEN
          COLBROWN = COLORANGE

          .case SECAM
          COLBLACK = 0
          COLBLUE = 2
          COLINDIGO = COLBLUE
          COLRED = 4
          COLBROWN = COLRED
          COLMAGENTA = 6
          COLPURPLE = COLMAGENTA
          COLGREEN = 8
          COLSPRINGGREEN = COLGREEN
          COLSEAFOAM = COLGREEN
          COLCYAN = $a
          COLTURQUOISE = COLCYAN
          COLTEAL = COLCYAN
          COLYELLOW = $c
          COLORANGE = COLYELLOW
          COLGOLD = COLYELLOW
          COLWHITE = $e
          COLGREY = $f          ; effectively white; see #ldacolu macro for use
          .endswitch

          COLGRAY = COLGREY

;;;
;;; Color + Luminance → COLU values
;;;
;;; If  nothing else,  you can  get correct  basic colors  on all  three
;;; models, in particular since SECAM is weird.

colu:     .macro co, lu=$7
          .switch TV

;;; SECAM
          .case SECAM
          .if \co == COLGRAY
	    .if \lu > 7
	      .byte COLWHITE
	    .else
	      .byte COLBLACK
	    .fi
          .else
            .if \lu == 0
              .byte COLBLACK
            .else
              .byte \co
            .fi
          .fi

;;; NTSC, PAL
          .default
          .byte (\co | \lu)
          
          .endswitch            ; TV
          
          .endm
          
ldacolu .macro co, lu=$7
          .switch TV

;;; SECAM
          .case SECAM
          .if \co == COLGRAY
	    .if \lu > 7
	      lda #COLWHITE
	    .else
	      lda #COLBLACK
	    .fi
          .else
            .if \lu == 0
              lda #COLBLACK
            .else
              lda #\co
            .fi
          .fi

;;; NTSC, PAL
          .default
          lda #(\co | \lu)
          
          .endswitch            ; TV
.endm
           
;;;

colors:   .macro co1, co2
          .switch TV

;;; SECAM
          .case SECAM

          .if \co1 == COLGRAY
            .byte (COLWHITE << 4) | COLBLACK
          .else
            .byte (\co1 << 4) | COLBLACK
          .fi

;;; NTSC, PAL
          .default

          .byte \co1 | (\co2 >> 4)

          .endswitch            ; TV
.endm

          
;;; 
          
          CTRLPFREF = $01
          CTRLPFSCORE = $02
          CTRLPFPFP = $04
          CTRLPFBALLSZ1 = $00
          CTRLPFBALLSZ2 = $10
          CTRLPFBALLSZ4 = $20
          CTRLPFBALLSZ8 = $30

          NUSIZMISSILE1 = $00
          NUSIZMISSILE2 = $08
          NUSIZMISSILE4 = $10
          NUSIZMISSILE8 = $18

          NUSIZNorm = $00
          NUSIZ2CopiesClose = $01
          NUSIZ2CopiesMed = $02
          NUSIZ3CopiesClose = $03
          NUSIZ2CopiesWide = $04
          NUSIZDouble = $05
          NUSIZ3CopiesMed = $06
          NUSIZQuad = $07


          ENABLED = $02          ; for ENAM0/1, ENABL, VSYNC, VBLANK

          VBlankLatchINPT45 = $40
          VBlankGroundINPT0123 = $80

          REFLECTED = $08       ; for REFP0

          INSTAT = TIMINT
          INSTATUnderflowSinceRead = $40
          INSTATUnderflowSinceWrite = $80

;;;

          .switch TV
          .case NTSC
          VBlankLines = 40
          KernelLines = 192
          OverscanLines = 30
          FrameDuration = 16686
          FramesPerSecond = 60
          
          .default
          ;;  PAL and SECAM match
          VBlankLines = 48
          KernelLines = 228
          OverscanLines = 36
          FrameDuration = 20055
          FramesPerSecond = 50
          .endswitch

          VBlankWorkLines = VBlankLines - 3

          TotalLines = VBlankLines + KernelLines + OverscanLines

          HBlankCycles = 40
          VisibleLineCycles = 36
