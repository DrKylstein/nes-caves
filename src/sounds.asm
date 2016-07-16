;------------------------------------------------------------------------------
; Sound Data
;------------------------------------------------------------------------------

testDrumSequence:   
    .byte $00,$20
    .byte $FF,$FF
    .byte $01,$20
    .byte $FF,$FF

    .byte $00,$20
    .byte $FF,$FF
    .byte $01,$20
    .byte <[[testDrumSequence-.]>>1],$FF

testBassSequence:
    .byte $FF,$FF
    .byte $02,$10
    .byte $FF,$FF
    .byte $02,$20
    
    .byte $FF,$FF
    .byte $FF,$14
    .byte $FF,$FF
    .byte $FF,$24
    
    .byte $FF,$FF
    .byte $FF,$16
    .byte $FF,$FF
    .byte $FF,$26
    
    .byte $FF,$FF
    .byte $FF,$12
    .byte $FF,$FF
    .byte <[[testBassSequence-.]>>1],$22

instruments:
    .word bassDrum
    .word hihat
    .word bass


periodTableLo:
  .byte $f1,$7f,$13,$ad,$4d,$f3,$9d,$4c,$00,$b8,$74,$34,0,0,0,0
  .byte $f8,$bf,$89,$56,$26,$f9,$ce,$a6,$80,$5c,$3a,$1a,0,0,0,0
  .byte $fb,$df,$c4,$ab,$93,$7c,$67,$52,$3f,$2d,$1c,$0c,0,0,0,0
  .byte $fd,$ef,$e1,$d5,$c9,$bd,$b3,$a9,$9f,$96,$8e,$86,0,0,0,0
  .byte $7e,$77,$70,$6a,$64,$5e,$59,$54,$4f,$4b,$46,$42,0,0,0,0
  .byte $3f,$3b,$38,$34,$31,$2f,$2c,$29,$27,$25,$23,$21,0,0,0,0
  .byte $1f,$1d,$1b,$1a,$18,$17,$15,$14
periodTableHi:
  .byte $07,$07,$07,$06,$06,$05,$05,$05,$05,$04,$04,$04,0,0,0,0
  .byte $03,$03,$03,$03,$03,$02,$02,$02,$02,$02,$02,$02,0,0,0,0
  .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,0,0,0,0
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,0,0,0,0
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,0,0,0,0
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,0,0,0,0
  .byte $00,$00,$00,$00,$00,$00,$00,$00

;square patch: 
;.byte duty | vol, relative freq
; .byte 0 ; end
;tri patch:
;.word relative freq
;.word TRI_END ; to end
;noise patch:
;.byte %0011xxxx ; volume
;.byte %L000FFFF ;L = loop noise, F = absolute frequency
;.byte 0 ; end

bass subroutine
    .byte TRI_CH
    .byte 0
    .word .tri
    .byte -1
.tri:
    .word 0
    .word -128
    .word 0
    .word 64
    .word 0
    .word -32
    .word 0
    .word 16
    .word 0
    .word -8
    .word 0
    .word 4
    .word 0
    .word -2
    .word 0
    .word 0
    .word 0
    .word 0
    .word TRI_END

bassDrum subroutine
    .byte NOISE_CH
    .byte 0
    .word .noise
    .byte TRI_CH
    .byte 0
    .word .tri
    .byte -1
.noise:
    .byte #$3E, $00
    .byte #$3C, $01
    .byte #$3A, $02
    .byte #$38, $03
    .byte #$36, $04
    .byte #$34, $05
    .byte #$32, $06
    .byte #$30, $07
    .byte 0
.tri:
    .word 0
    .word 4
    .word 8
    .word 16
    .word TRI_END

hihat subroutine
    .byte NOISE_CH
    .byte 0
    .word .noise
    .byte -1
.noise:
    .byte #$3E, $84
    .byte #$3C, $85
    .byte #$3A, $86
    .byte #$38, $87
    .byte #$36, $88
    .byte #$34, $89
    .byte #$32, $8a
    .byte #$30, $8b
    .byte 0


sfxLaser subroutine
    .word 0 ;note
    .byte NOISE_CH ;channel
    .byte 3 ;priority
    .word .noise ; patch
    .byte <-1 ;terminator
.noise:
    .byte $31, $8D
    .byte $32, $8D
    .byte $34, $8D
    .byte $38, $8D
    .byte $3F, $8D
    .byte $3E, $8D
    .byte $3D, $8C
    .byte $3C, $8B
    .byte $3B, $8A
    .byte $3A, $89
    .byte $39, $88
    .byte $38, $87
    .byte $37, $86
    .byte $36, $85
    .byte $30, $84
    .byte 0
    
sfxCrystal subroutine
    .word $060
    .byte SQ1_CH
    .byte 1
    .word .sq
    .byte <-1
.sq:
    .byte DUTY_50 | $8, 0
    .byte DUTY_50 | $F, 0
    .byte DUTY_50 | $F, 0
    .byte DUTY_50 | $F, 0
    .byte DUTY_50 | $F, 8
    .byte DUTY_50 | $F, 8
    .byte DUTY_50 | $F, 8
    .byte DUTY_50 | $F, 8
    .byte DUTY_50 | $F, 8
    .byte DUTY_50 | $F, 8
    .byte DUTY_50 | $D, 8
    .byte DUTY_50 | $B, 8
    .byte DUTY_50 | $9, 8
    .byte DUTY_50 | $7, 8
    .byte DUTY_50 | $5, 8
    .byte DUTY_50 | $3, 8
    .byte DUTY_50 | $2, 8
    .byte DUTY_50 | $1, 8
    .byte DUTY_50 | $0, 8
    .byte 0

sfxJump subroutine
    .word $00F0
    .byte SQ1_CH
    .byte 2
    .word .sqJump
    .byte <-2
    
.sqJump:
    .byte DUTY_25 | $F, 0
    .byte DUTY_25 | $2, 1
    .byte DUTY_25 | $E, 1
    .byte DUTY_25 | $2, 2
    .byte DUTY_25 | $D, 2
    .byte DUTY_25 | $2, 3
    .byte DUTY_25 | $C, 3
    .byte DUTY_25 | $2, 4
    .byte DUTY_25 | $B, 4
    .byte DUTY_25 | $2, 5
    .byte DUTY_25 | $A, 5
    .byte DUTY_25 | $2, 6
    .byte DUTY_25 | $9, 6
    .byte DUTY_25 | $2, 7
    .byte DUTY_25 | $8, 7
    .byte DUTY_25 | $2, 8
    .byte DUTY_25 | $7, 8
    .byte DUTY_25 | $2, 9
    .byte DUTY_25 | $6, 9
    .byte DUTY_25 | $2,10
    .byte DUTY_25 | $5,10
    .byte DUTY_25 | $2,11
    .byte DUTY_25 | $4,11
    .byte DUTY_25 | $2,12
    .byte DUTY_25 | $3,12
    .byte DUTY_25 | $2,13
    .byte DUTY_25 | $2,13
    .byte DUTY_25 | $2,14
    .byte DUTY_25 | $1,14
    .byte DUTY_25 | $0,15
    .byte 0
    
sfxShoot subroutine
    .word $0230
    .byte SQ1_CH
    .byte 2
    .word .sqShoot
    
    .byte NOISE_CH
    .byte 2
    .word .noiseShoot
    
    .byte <-1
.sqShoot:
    .byte DUTY_25 | $F, 0
    .byte DUTY_25 | $2, 1
    .byte DUTY_25 | $E, 1
    .byte DUTY_25 | $2, 2
    .byte DUTY_25 | $D, 2
    .byte DUTY_25 | $2, 3
    .byte DUTY_25 | $C, 3
    .byte DUTY_25 | $2, 4
    .byte DUTY_25 | $B, 4
    .byte DUTY_25 | $2, 5
    .byte DUTY_25 | $A, 5
    .byte DUTY_25 | $2, 6
    .byte DUTY_25 | $9, 6
    .byte DUTY_25 | $2, 7
    .byte DUTY_25 | $8, 7
    .byte DUTY_25 | $2, 8
    .byte DUTY_25 | $7, 8
    .byte DUTY_25 | $2, 9
    .byte DUTY_25 | $6, 9
    .byte DUTY_25 | $2,10
    .byte DUTY_25 | $5,10
    .byte DUTY_25 | $2,11
    .byte DUTY_25 | $4,11
    .byte DUTY_25 | $2,12
    .byte DUTY_25 | $3,12
    .byte DUTY_25 | $2,13
    .byte DUTY_25 | $2,13
    .byte DUTY_25 | $2,14
    .byte DUTY_25 | $1,14
    .byte DUTY_25 | $0,15
    .byte 0
.noiseShoot:
    .byte $3F, $0F
    .byte $3E, $0F
    .byte $3D, $0F
    .byte $3C, $0F
    .byte $3B, $0F
    .byte $3A, $0F
    .byte $39, $0F
    .byte $38, $0F
    .byte $37, $0F
    .byte $36, $0F
    .byte $35, $0F
    .byte $34, $0F
    .byte $33, $0F
    .byte $32, $0F
    .byte $31, $0F
    .byte $30, $0F
    .byte 0
