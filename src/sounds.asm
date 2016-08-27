UpdateSound subroutine
DoMusic subroutine
    lda beatTimer
    beq .tick
    dec beatTimer
    jmp DoMusic_end
.tick:
    ldx #6
.loop:
    lda musicSequence+1,x
    bne .validSequence
    jmp .end
.validSequence:
    
    lda musicStream+1,x
    bne .notStart
    lda musicSequence,x
    sta tmp+2
    lda musicSequence+1,x
    sta tmp+3
    ldy musicIndex,x
    lda (tmp+2),y
    sta musicStream,x
    iny
    lda (tmp+2),y
    sta musicStream+1,x
    iny
    sty musicIndex,x
.notStart:
    
    lda (musicStream,x)
    sta tmp
    lda musicStream,x
    clc
    adc #1
    sta musicStream,x
    lda musicStream+1,x
    adc #0
    sta musicStream+1,x

    lda (musicStream,x)
    sta tmp+1
    lda musicStream,x
    clc
    adc #1
    sta musicStream,x
    lda musicStream+1,x
    adc #0
    sta musicStream+1,x
    
    lda tmp
    cmp #MC____
    beq .note
    bmi .effect
    ;%0xxxxxxx change instrument
    asl
    tay
    lda instruments,y
    sta instrument,x
    lda instruments+1,y
    sta instrument+1,x
    jmp .note
.effect:
    ;#$FE end
    lda musicSequence,x
    sta tmp+2
    lda musicSequence+1,x
    sta tmp+3
    ldy musicIndex,x
    iny
    lda (tmp+2),y
    bne .notEnd
    dey
    lda (tmp+2),y
    tay
    iny
.notEnd:
    lda (tmp+2),y
    sta musicStream+1,x
    dey
    lda (tmp+2),y
    sta musicStream,x
    iny
    iny
    sty musicIndex,x
    
.note:
    lda tmp+1
    cmp #MN____
    beq .end

    lda instrument,x
    sta arg
    lda instrument+1,x
    sta arg+1

    lda tmp+1
    sta arg+2
        
    txa
    pha
    jsr LoadSfx
    pla
    tax
.end:
    dex
    dex
    bmi .loopend
    jmp .loop
.loopend:
    lda tempo
    sta beatTimer
DoMusic_end:

DoSfx subroutine
    ldx #0
.loop:
    lda sfxPatch+1,x ;pointer can't be in zero page, no sound must be set
    beq .stop
    lda (sfxPatch,x) ;byte should always have %xx11xxxx, so sound has ended
    bne .continue
.stop:
    lda #0
    sta sfxPriority,x
    jmp .next
.continue:
    lda (sfxPatch,x)
    sta APU_SQ1_VOL,x
    INC16X sfxPatch
    cpx #12
    bne .notNoise
;noise:
    lda (sfxPatch,x)
    eor #$0F
    sta APU_NOISE_LO
    INC16X sfxPatch
    jmp .next
.notNoise:
    lda (sfxPatch,x)
    clc
    adc sfxNote,x
    tay
    lda periodTableLo,y
    sta APU_SQ1_LO,x
    lda periodTableHi,y
    cmp sfxHi,x
    beq .nohi
    sta sfxHi,x
    sta APU_SQ1_HI,x
.nohi:
    INC16X sfxPatch
.next:
    REPEAT 4
    inx
    REPEND
    cpx #16
    bcc .loop

ClockAPU subroutine
    lda #$C0
    sta APU_FRAME
ClockAPU_end:
    rts

LoadSfx subroutine
    ldy #0
.loop:
    lda (arg),y
    bmi .end
    asl
    asl
    tax
    iny
    
    lda (arg),y
    cmp sfxPriority,x
    bcs .higher
    tya
    clc
    adc #3
    tay
    jmp .loop
.higher
    sta sfxPriority,x
    iny
    
    lda (arg),y
    iny
    sta sfxPatch,x
    
    lda (arg),y
    iny
    sta sfxPatch+1,x

    lda arg+2
    sta sfxNote,x
    
    ;set upper frequency byte
    sty tmp
    tay
    lda periodTableHi,y
    sta sfxHi,x
    sta APU_SQ1_HI,x
    ldy tmp
    jmp .loop
.end:
    rts

;------------------------------------------------------------------------------
; Sound Data
;------------------------------------------------------------------------------
periodTableLo:
  .byte $f1,$7f,$13,$ad,$4d,$f3,$9d,$4c,$00,$b8,$74,$34
  .byte $f8,$bf,$89,$56,$26,$f9,$ce,$a6,$80,$5c,$3a,$1a
  .byte $fb,$df,$c4,$ab,$93,$7c,$67,$52,$3f,$2d,$1c,$0c
  .byte $fd,$ef,$e1,$d5,$c9,$bd,$b3,$a9,$9f,$96,$8e,$86
  .byte $7e,$77,$70,$6a,$64,$5e,$59,$54,$4f,$4b,$46,$42
  .byte $3f,$3b,$38,$34,$31,$2f,$2c,$29,$27,$25,$23,$21
  .byte $1f,$1d,$1b,$1a,$18,$17,$15,$14
periodTableHi:
  .byte $07,$07,$07,$06,$06,$05,$05,$05,$05,$04,$04,$04
  .byte $03,$03,$03,$03,$03,$02,$02,$02,$02,$02,$02,$02
  .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00


nullSong subroutine
    .word 0
    .word 0
    .word 0
    .word 0

testSong subroutine
    .word 0
    .word testChordSequence
    .word testBassSequence
    .word testDrumSequence

testChordSequence
    .word .pat1
    .word 0
.pat1:
    .byte    $04,MN_C3_
    .byte MC____,MN_C3_
    .byte MC____,MN_C3_
    .byte MC____,MN_C3_
    .byte MC____,MN_C3_
    .byte MC____,MN_C3_
    .byte MC____,MN_C3_
    .byte MC____,MN_C3_
    .byte MC____,MN_G3_
    .byte MC____,MN_G3_
    .byte MC____,MN_G3_
    .byte MC____,MN_G3_
    .byte MC____,MN_G3_
    .byte MC____,MN_G3_
    .byte MC____,MN_G3_
    .byte MC_LOP,MN_G3_

testDrumSequence subroutine
    .word .pat2
    .word .pat2
    .word .pat1
    .word .pat1
    .word .pat1
    .word .pat2
    .word 2<<1
.pat1:
    .byte    $00,MN_C1_
    .byte MC____,MN____
    .byte    $03,MN_C1_
    .byte MC____,MN____
    .byte    $01,MN_G3_
    .byte MC____,MN____
    .byte    $03,MN_C1_
    .byte MC_LOP,MN____
.pat2:
    .byte    $01,MN_G3_
    .byte MC____,MN_G3_
    .byte    $00,MN_C1_
    .byte MC____,MN_C1_
    .byte    $03,MN_C1_
    .byte MC____,MN_C1_
    .byte MC____,MN____
    .byte MC_LOP,MN____

testBassSequence subroutine
    .word .pat1
    .word 0
.pat1:
    .byte MC____,MN____
    .byte    $02,MN_C2_
    .byte MC____,MN____
    .byte MC____,MN_C1_
    .byte MC____,MN____
    .byte MC____,MN_C2_
    .byte MC____,MN____
    .byte MC____,MN_C1_
    .byte MC____,MN____
    .byte MC____,MN_G2_
    .byte MC____,MN____
    .byte MC____,MN_G1_
    .byte MC____,MN____
    .byte MC____,MN_G2_
    .byte MC____,MN____
    .byte MC_LOP,MN_G1_
    

instruments:
    .word bassDrum
    .word snareDrum
    .word bass
    .word hihat
    .word testchord


;square patch: 
;.byte duty | vol, relative freq
; .byte 0 ; end
;tri patch:
;.byte TRI_ON, relative freq
;.byte 0 ; to end
;noise patch:
;.byte %0011xxxx ; volume
;.byte %L000FFFF ;L = loop noise, F = absolute frequency
;.byte 0 ; end

testchord subroutine
    .byte SQ2_CH
    .byte 0
    .word .sq
    .byte -1
.sq:
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 4
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 4
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 4
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 4
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 4
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 4
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 4
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 4
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 4
    .byte DUTY_50 | 4, 7
    .byte 0

bass subroutine
    .byte TRI_CH
    .byte 0
    .word .tri
    .byte -1
.tri:
    .byte TRI_ON, 2
    .byte TRI_ON, 1
    .byte TRI_ON, 0
    .byte TRI_ON, 0
    .byte TRI_ON, 0
    .byte TRI_ON, 0
    .byte TRI_ON, 0
    .byte TRI_ON, 0
    .byte TRI_ON, 0
    .byte TRI_ON, 0
    .byte TRI_ON, 0
    .byte TRI_ON, 0
    .byte TRI_ON, 0
    .byte TRI_ON, 0
    .byte TRI_ON, -1
    .byte TRI_ON, -2
    .byte TRI_ON, -3
    .byte TRI_ON, -4
    .byte TRI_OFF, 0
    .byte 0

bassDrum subroutine
    .byte NOISE_CH
    .byte 0
    .word .noise
    .byte TRI_CH
    .byte 0
    .word .tri
    .byte -1
.noise:
    .byte NOISE_VOL | 7, 0
    .byte NOISE_VOL | 7, 0
    .byte NOISE_VOL | 6, 0
    .byte NOISE_VOL | 6, 0
    .byte NOISE_VOL | 5, 0
    .byte NOISE_VOL | 5, 0
    .byte NOISE_VOL | 4, 0
    .byte NOISE_VOL | 4, 0
    .byte NOISE_VOL | 3, 0
    .byte NOISE_VOL | 3, 0
    .byte NOISE_VOL | 2, 0
    .byte NOISE_VOL | 2, 0
    .byte NOISE_VOL | 1, 0
    .byte NOISE_VOL | 1, 0
    .byte NOISE_VOL | 1, 0
    .byte NOISE_VOL | 0, 0
    .byte 0
.tri:
    .byte TRI_ON, 3
    .byte TRI_ON, 2
    .byte TRI_ON, 1
    .byte TRI_OFF, 0
    .byte 0
    
snareDrum subroutine
    .byte NOISE_CH
    .byte 0
    .word .noise
    .byte TRI_CH
    .byte 0
    .word .tri
    .byte -1
.noise:
    .byte NOISE_VOL | 7, 8
    .byte NOISE_VOL | 7, 8
    .byte NOISE_VOL | 6, 8
    .byte NOISE_VOL | 6, 8
    .byte NOISE_VOL | 5, 8
    .byte NOISE_VOL | 5, 8
    .byte NOISE_VOL | 4, 8
    .byte NOISE_VOL | 4, 8
    .byte NOISE_VOL | 3, 8
    .byte NOISE_VOL | 3, 8
    .byte NOISE_VOL | 2, 8
    .byte NOISE_VOL | 2, 8
    .byte NOISE_VOL | 1, 8
    .byte NOISE_VOL | 1, 8
    .byte NOISE_VOL | 1, 8
    .byte NOISE_VOL | 0, 8
    .byte 0
.tri:
    .byte TRI_ON,  3
    .byte TRI_ON,  2
    .byte TRI_ON,  1
    .byte TRI_OFF, 0
    .byte 0

hihat subroutine
    .byte NOISE_CH
    .byte 0
    .word .noise
    .byte -1
.noise:
    .byte NOISE_VOL | 4, NOISE_LOOP | 9
    .byte NOISE_VOL | 7, NOISE_LOOP | 10
    .byte NOISE_VOL | 7, NOISE_LOOP | 10
    .byte NOISE_VOL | 6, NOISE_LOOP | 11
    .byte NOISE_VOL | 6, NOISE_LOOP | 11
    .byte NOISE_VOL | 5, NOISE_LOOP | 12
    .byte NOISE_VOL | 5, NOISE_LOOP | 12
    .byte NOISE_VOL | 4, NOISE_LOOP | 13
    .byte NOISE_VOL | 5, NOISE_LOOP | 13
    .byte NOISE_VOL | 3, NOISE_LOOP | 14
    .byte NOISE_VOL | 4, NOISE_LOOP | 14
    .byte NOISE_VOL | 2, NOISE_LOOP | 13
    .byte NOISE_VOL | 3, NOISE_LOOP | 13
    .byte NOISE_VOL | 1, NOISE_LOOP | 14
    .byte NOISE_VOL | 2, NOISE_LOOP | 14
    .byte NOISE_VOL | 0, NOISE_LOOP | 15
    .byte NOISE_VOL | 1, NOISE_LOOP | 15
    .byte 0

sounds:
    .word sfxJump
    .word sfxShoot
    .word sfxCrystal
    .word sfxLaser
    .word sfxHeavyImpact

sfxHeavyImpact subroutine
    .byte MN_C1_
    .byte NOISE_CH
    .byte 0
    .word .noise
    .byte TRI_CH
    .byte 0
    .word .tri
    .byte -1
.noise:
    .byte NOISE_VOL | 15, 0
    .byte NOISE_VOL | 14, 0
    .byte NOISE_VOL | 13, 0
    .byte NOISE_VOL | 12, 0
    .byte NOISE_VOL | 11, 0
    .byte NOISE_VOL | 10, 0
    .byte NOISE_VOL |  9, 0
    .byte NOISE_VOL |  8, 0
    .byte NOISE_VOL |  7, 0
    .byte NOISE_VOL |  6, 0
    .byte NOISE_VOL |  5, 0
    .byte NOISE_VOL |  4, 0
    .byte NOISE_VOL |  3, 0
    .byte NOISE_VOL |  2, 0
    .byte NOISE_VOL |  1, 0
    .byte NOISE_VOL |  0, 0
    .byte 0
.tri:
    .byte  TRI_ON, 6
    .byte  TRI_ON, 5 
    .byte  TRI_ON, 4
    .byte  TRI_ON, 3
    .byte  TRI_ON, 2
    .byte  TRI_ON, 1
    .byte TRI_OFF, 0
    .byte 0

sfxLaser subroutine
    .byte 0 ;note
    .byte NOISE_CH ;channel
    .byte 3 ;priority
    .word .noise ; patch
    .byte <-1 ;terminator
.noise:
    .byte NOISE_VOL |  1, NOISE_LOOP | 13
    .byte NOISE_VOL |  2, NOISE_LOOP | 13
    .byte NOISE_VOL |  4, NOISE_LOOP | 13
    .byte NOISE_VOL |  8, NOISE_LOOP | 13
    .byte NOISE_VOL | 15, NOISE_LOOP | 13
    .byte NOISE_VOL | 14, NOISE_LOOP | 13
    .byte NOISE_VOL | 13, NOISE_LOOP | 12
    .byte NOISE_VOL | 12, NOISE_LOOP | 11
    .byte NOISE_VOL | 11, NOISE_LOOP | 10
    .byte NOISE_VOL | 10, NOISE_LOOP |  9
    .byte NOISE_VOL |  9, NOISE_LOOP |  8
    .byte NOISE_VOL |  8, NOISE_LOOP |  7
    .byte NOISE_VOL |  7, NOISE_LOOP |  6
    .byte NOISE_VOL |  6, NOISE_LOOP |  5
    .byte NOISE_VOL |  0, NOISE_LOOP |  4
    .byte 0
    
sfxCrystal subroutine
    .byte MN_D5_
    .byte SQ1_CH
    .byte 2
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
    .byte MN_A3S
    .byte SQ1_CH
    .byte 1
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
    .byte MN_F2S
    .byte SQ1_CH
    .byte 1
    .word .sqShoot
    
    .byte NOISE_CH
    .byte 1
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
    .byte NOISE_VOL | 15, 15
    .byte NOISE_VOL | 14, 15
    .byte NOISE_VOL | 13, 15
    .byte NOISE_VOL | 12, 15
    .byte NOISE_VOL | 11, 15
    .byte NOISE_VOL | 10, 15
    .byte NOISE_VOL |  9, 15
    .byte NOISE_VOL |  8, 15
    .byte NOISE_VOL |  7, 15
    .byte NOISE_VOL |  6, 15
    .byte NOISE_VOL |  5, 15
    .byte NOISE_VOL |  4, 15
    .byte NOISE_VOL |  3, 15
    .byte NOISE_VOL |  2, 15
    .byte NOISE_VOL |  1, 15
    .byte NOISE_VOL |  0, 15
    .byte 0
