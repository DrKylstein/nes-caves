;------------------------------------------------------------------------------
; Sound Data
;------------------------------------------------------------------------------

testDrumSequence:
    .byte $80 | 16+8
    .byte 1,$80 | 8
    .byte 1,$80 | 8
    .byte 0,$80 | 16
    .byte 1,$80 | 8
    .byte 1,$80 | 8
    .byte 0,$80 | 16
    .byte 1,$80 | 8
    .byte 1,$80 | 8
    .byte 0,$80 | 16
    .byte 1,$80 | 8
    .byte 0,$80 | 16
    .byte 0,$80 | 16
    .byte <testDrumSequence-. ;rewind 10 bytes


drumPatches:
    .word bassDrum
    .word hihat


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

bassDrum subroutine
    .byte NOISE_CH
    .byte 0
    .word .noise
    .word 0
    .byte TRI_CH
    .byte 0
    .word .tri
    .word $200
    .byte -1
.noise:
    .byte #$3E, $08
    .byte #$3C, $09
    .byte #$3A, $0a
    .byte #$38, $0b
    .byte #$36, $0c
    .byte #$34, $0d
    .byte #$32, $0e
    .byte #$30, $0F
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
    .word 0
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
    .byte NOISE_CH ;channel
    .byte 3 ;priority
    .word .noise ; patch
    .word 0 ;note
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
    .byte SQ1_CH
    .byte 1
    .word .sq
    .word $060
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
    .byte SQ1_CH
    .byte 2
    .word .sqJump
    .word $00F0
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
    .byte SQ1_CH
    .byte 2
    .word .sqShoot
    .word $0230
    
    .byte NOISE_CH
    .byte 2
    .word .noiseShoot
    .word 0
    
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
