
SoundRoutine subroutine
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
; Sound Effects
;------------------------------------------------------------------------------

    SEG.U SOUNDS
    ORG $0000
SFX_JUMP:    ds 2
SFX_SHOOT:   ds 2
SFX_CRYSTAL: ds 2
SFX_LASER:   ds 2
SFX_HAMMER:  ds 2
SFX_AMMO:    
SFX_POINTS:  ds 2
SFX_RTTY:    ds 2
SFX_CHEST:   ds 2
SFX_HURT:    ds 2
SFX_TEXTBOX: ds 2
SFX_SWITCH:  ds 2
SFX_DOOR:    ds 2
SFX_POWER:   ds 2
SFX_DRIP:    ds 2
SFX_FRUIT:   ds 2
    SEG ROM_FILE

    SEG.U PRIORITIES
    ORG $0000
PRI_MUSIC:   ds 1
PRI_BG_LOOP: ds 1
PRI_PLAYER:  ds 1
PRI_ITEM:    ds 1
PRI_ATTACK:  ds 1
PRI_UI:      ds 1
    SEG ROM_FILE


sounds:
    .word sfxJump
    .word sfxShoot
    .word sfxCrystal
    .word sfxLaser
    .word sfxHeavyImpact
    .word sfxAmmo
    .word sfxRTTY
    .word sfxChest
    .word sfxHurt
    .word sfxTextBox
    .word sfxSwitch
    .word sfxDoor
    .word sfxPower
    .word sfxDrip
    .word sfxFruit

sfxDrip subroutine
    .byte MN_C4_
    .byte SQ1_CH
    .byte PRI_BG_LOOP
    .word .sq
    .byte <-1
.sq:
    .byte DUTY_50 | 3,-1
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 15, 1
    .byte DUTY_50 | 15, 2
    .byte DUTY_50 | 0, 0
    .byte 0
.noise:
    .byte NOISE_VOL | 0,15
    .byte NOISE_VOL | 0,15
    .byte NOISE_VOL | 0,15
    .byte NOISE_VOL | 7,15
    .byte NOISE_VOL | 6,15
    .byte NOISE_VOL | 5,15
    .byte NOISE_VOL | 4,15
    .byte NOISE_VOL | 3,15
    .byte NOISE_VOL | 2,15
    .byte NOISE_VOL | 1,15
    .byte NOISE_VOL | 1,15
    .byte NOISE_VOL | 1,15
    .byte NOISE_VOL | 0,15
    .byte 0



sfxAmmo subroutine
    .byte MN_C4S
    .byte SQ1_CH
    .byte PRI_ITEM
    .word .sq
    .byte <-1
.sq:
    .byte DUTY_25 | 15, 0
    .byte DUTY_25 |  0, 0
    .byte DUTY_25 | 15, 0
    .byte DUTY_25 |  0, 0
    .byte DUTY_25 | 15, 0
    .byte DUTY_25 |  0, 0
    .byte DUTY_25 | 15, 0
    .byte DUTY_25 |  0, 0
    .byte DUTY_25 | 15, 0
    .byte DUTY_25 |  0, 0
    .byte DUTY_25 | 15, 0
    .byte DUTY_25 |  0, 0
    .byte DUTY_25 | 15, 0
    .byte DUTY_25 |  0, 0
    .byte DUTY_25 | 15, 0
    .byte DUTY_25 |  0, 0
    .byte DUTY_25 | 15, 0
    .byte DUTY_25 |  0, 0
    .byte DUTY_25 |  0, 0
    
    .byte DUTY_25 | 15, 0
    .byte DUTY_25 |  0, 0
    .byte DUTY_25 |  0, 0

    .byte DUTY_25 | 15, 0
    .byte DUTY_25 |  0, 0
    .byte DUTY_25 |  0, 0
    
    .byte DUTY_25 | 15, 4
    .byte DUTY_25 |  0, 4
    .byte DUTY_25 | 15, 4
    .byte DUTY_25 |  0, 4
    .byte DUTY_25 | 15, 4
    .byte DUTY_25 |  0, 4
    .byte DUTY_25 | 15, 4
    .byte DUTY_25 |  0, 4
    .byte DUTY_25 | 15, 4
    .byte DUTY_25 |  0, 4
    .byte DUTY_25 | 15, 4
    .byte DUTY_25 |  0, 4
    
    
    .byte DUTY_50 | 0, 0
    .byte 0


sfxDoor subroutine
    .byte MN_E3_
    .byte NOISE_CH
    .byte PRI_PLAYER
    .word .noise
    .byte SQ1_CH
    .byte PRI_PLAYER
    .word .sq
    .byte -1
.noise:
    .byte NOISE_VOL | 7, 8
    .byte NOISE_VOL | 6, 8
    .byte NOISE_VOL | 5, 8
    .byte NOISE_VOL | 4, 8
    .byte NOISE_VOL | 3, 8
    .byte NOISE_VOL | 2, 8
    .byte NOISE_VOL | 1, 8
    .byte NOISE_VOL | 1, 8
    .byte NOISE_VOL | 1, 8
    .byte NOISE_VOL | 0, 8
    .byte 0
.sq:
    .byte DUTY_50 |  7,-4
    .byte DUTY_50 |  0, 0
    .byte DUTY_50 |  7,-6
    .byte DUTY_50 |  0, 0

    .byte DUTY_50 | 15,-4
    .byte DUTY_50 |  0,-4
    .byte DUTY_50 |  7,-4
    .byte DUTY_50 |  0,-4
    
    .byte DUTY_50 | 15, 0
    .byte DUTY_50 |  0, 0
    .byte DUTY_50 |  7, 0
    .byte DUTY_50 |  0, 0
    
    
    .byte DUTY_50 | 0, 0
    .byte 0


sfxSwitch subroutine
    .byte MN_E3_
    .byte NOISE_CH
    .byte PRI_PLAYER
    .word .noise
    .byte TRI_CH
    .byte PRI_PLAYER
    .word .tri
    .byte -1
.noise:
    .byte NOISE_VOL | 7, 8
    .byte NOISE_VOL | 6, 8
    .byte NOISE_VOL | 5, 8
    .byte NOISE_VOL | 4, 8
    .byte NOISE_VOL | 3, 8
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


sfxTextBox subroutine
    .byte MN_B3_
    .byte SQ1_CH
    .byte PRI_UI
    .word .sq
    .byte <-1
.sq:
    .byte DUTY_50 |  7,-4
    .byte DUTY_50 |  0, 0
    .byte DUTY_50 |  7,-6
    .byte DUTY_50 |  0, 0

    .byte DUTY_50 | 15,-4
    .byte DUTY_50 |  0,-4
    .byte DUTY_50 |  7,-4
    .byte DUTY_50 |  0,-4
    
    .byte DUTY_50 | 15, 0
    .byte DUTY_50 |  0, 0
    .byte DUTY_50 |  7, 0
    .byte DUTY_50 |  0, 0
    
    
    .byte DUTY_50 | 0, 0
    .byte 0


sfxHurt subroutine
    .byte MN_C3_
    .byte SQ1_CH
    .byte PRI_ATTACK
    .word .sq
    .byte <-1
.sq:
    .byte DUTY_12 | 15, 0
    .byte DUTY_12 |  0, 0
    .byte DUTY_12 | 15, 0
    .byte DUTY_12 |  0, 0
    .byte DUTY_12 |  0, 0
        
    .byte DUTY_12 | 15, 0
    .byte DUTY_12 |  0, 0
    .byte DUTY_12 | 15, 0
    .byte DUTY_12 |  0, 0
    .byte DUTY_12 |  0, 0

    .byte DUTY_12 | 15, 0
    .byte DUTY_12 |  0, 0
    .byte DUTY_12 | 15, 0
    .byte DUTY_12 |  0, 0
    .byte DUTY_12 |  0, 0
    
    .byte DUTY_12 |  0, 0
    .byte DUTY_12 |  0, 0
    
    .byte DUTY_12 | 15, 4
    .byte DUTY_12 |  0, 0
    .byte DUTY_12 | 15, 4
    .byte DUTY_12 |  0, 0

    .byte DUTY_12 |  0, 0
    .byte 0


sfxChest subroutine
    .byte MN_A2_
    .byte SQ1_CH
    .byte PRI_ITEM
    .word .sq
    .byte <-1
.sq:
    .byte DUTY_50 |  0, 0
    .byte DUTY_50 |  1, -1
    .byte DUTY_50 |  2, 2
    .byte DUTY_50 |  3, -3
    .byte DUTY_50 |  4, 4
    .byte DUTY_50 |  5, -5
    .byte DUTY_50 |  6, 6
    .byte DUTY_50 |  7, -7
    .byte DUTY_50 |  8, 8
    .byte DUTY_50 |  9, -9
    .byte DUTY_50 | 10, 10
    .byte DUTY_50 | 11, -11
    .byte DUTY_50 | 12, 12
    .byte DUTY_50 | 13, -13
    .byte DUTY_50 | 14, 14
    .byte DUTY_50 | 15, -15
    .byte DUTY_50 | 15, 16
    .byte DUTY_50 | 15, -17
    .byte DUTY_50 |  0, 17
    .byte 0
    
sfxRTTY subroutine
    .byte MN_C5_
    .byte SQ1_CH
    .byte PRI_BG_LOOP
    .word .sq
    .byte -1
.sq:
    .byte DUTY_12 | 4, 0
    .byte DUTY_25 | 4, 0
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 0, 0
    .byte 0

sfxHeavyImpact subroutine
    .byte MN_C1_
    .byte NOISE_CH
    .byte PRI_ATTACK
    .word .noise
    .byte TRI_CH
    .byte PRI_ATTACK
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
    .byte NOISE_CH
    .byte PRI_ATTACK
    .word .noise
    .byte <-1
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
    .byte PRI_ITEM
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
    
sfxFruit subroutine
    .byte MN_D5_
    .byte SQ1_CH
    .byte PRI_ITEM
    .word .sq
    .byte <-1
.sq:
    .byte DUTY_50 | $8, 0
    .byte DUTY_50 | $F, 0
    .byte DUTY_50 | $F, 0
    .byte DUTY_50 | $F, 0
    .byte DUTY_50 | $D, 0
    .byte DUTY_50 | $B, 0
    .byte DUTY_50 | $9, 0
    .byte DUTY_50 | $7, 0
    .byte DUTY_50 | $5, 0
    .byte DUTY_50 | $3, 0
    .byte DUTY_50 | $2, 0
    .byte DUTY_50 | $1, 0
    .byte DUTY_50 | $0, 0
    .byte 0

sfxJump subroutine
    .byte MN_A3S
    .byte SQ1_CH
    .byte PRI_PLAYER
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
    .byte PRI_PLAYER
    .word .sqShoot
    
    .byte NOISE_CH
    .byte PRI_PLAYER
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

sfxPower subroutine
    .byte MN_C4_
    .byte SQ1_CH
    .byte PRI_ITEM
    .word .sq
    .byte -1
.sq:
    .byte DUTY_50 | $F,2
    .byte DUTY_50 | $F,2
    .byte DUTY_50 | $F,2
    .byte DUTY_50 | $F,2
    .byte DUTY_50 | $F,0
    .byte DUTY_50 | $F,0
    .byte DUTY_50 | $F,0
    .byte DUTY_50 | $F,0
    .byte DUTY_50 | $F,4
    .byte DUTY_50 | $F,4
    .byte DUTY_50 | $F,4
    .byte DUTY_50 | $F,4
    .byte DUTY_50 | $F,2
    .byte DUTY_50 | $F,2
    .byte DUTY_50 | $F,2
    .byte DUTY_50 | $F,2
    .byte DUTY_50 | $8,2
    .byte DUTY_50 | $4,2
    .byte DUTY_50 | $2,2
    .byte DUTY_50 | $0,2
    .byte 0
    
;------------------------------------------------------------------------------
; Notes
;------------------------------------------------------------------------------
    SEG.U NOTES
    ORG 0
MN_A0_  ds 1
MN_A0S  ds 1
MN_B0_  ds 1
MN_C1_  ds 1
MN_C1S  ds 1
MN_D1_  ds 1
MN_D1S  ds 1
MN_E1_  ds 1
MN_F1_  ds 1
MN_F1S  ds 1
MN_G1_  ds 1
MN_G1S  ds 1
MN_A1_  ds 1
MN_A1S  ds 1
MN_B1_  ds 1
MN_C2_  ds 1
MN_C2S  ds 1
MN_D2_  ds 1
MN_D2S  ds 1
MN_E2_  ds 1
MN_F2_  ds 1
MN_F2S  ds 1
MN_G2_  ds 1
MN_G2S  ds 1
MN_A2_  ds 1
MN_A2S  ds 1
MN_B2_  ds 1
MN_C3_  ds 1
MN_C3S  ds 1
MN_D3_  ds 1
MN_D3S  ds 1
MN_E3_  ds 1
MN_F3_  ds 1
MN_F3S  ds 1
MN_G3_  ds 1
MN_G3S  ds 1
MN_A3_  ds 1
MN_A3S  ds 1
MN_B3_  ds 1
MN_C4_  ds 1
MN_C4S  ds 1
MN_D4_  ds 1
MN_D4S  ds 1
MN_E4_  ds 1
MN_F4_  ds 1
MN_F4S  ds 1
MN_G4_  ds 1
MN_G4S  ds 1
MN_A4_  ds 1
MN_A4S  ds 1
MN_B4_  ds 1
MN_C5_  ds 1
MN_C5S  ds 1
MN_D5_  ds 1
MN_D5S  ds 1
MN_E5_  ds 1
MN_F5_  ds 1
MN_F5S  ds 1
MN_G5_  ds 1
MN_G5S  ds 1
MN_A5_  ds 1
MN_A5S  ds 1
MN_B5_  ds 1
MN_C6_  ds 1
MN_C6S  ds 1
MN_D6_  ds 1
MN_D6S  ds 1
MN_E6_  ds 1
MN_F6_  ds 1
MN_F6S  ds 1
MN_G6_  ds 1
MN_G6S  ds 1
MN_A6_  ds 1
MN_A6S  ds 1
MN_B6_  ds 1
MN_C7_  ds 1
MN_C7S  ds 1
MN_D7_  ds 1
MN_D7S  ds 1
MN_E7_  ds 1
MN_F7_  ds 1
MN_F7S  ds 1
MN_G7_  ds 1
MN_G7S  ds 1
    SEG ROM_FILE
    
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
  
;------------------------------------------------------------------------------
; Instruments
;------------------------------------------------------------------------------
  
instruments:
    .word bassDrum
    .word snareDrum
    .word bass
    .word hihat
    .word majorArpeggio
    .word majorPowerChord
    .word minorArpeggio
    .word guitar
    .word guitar2
    SEG.U INSTRUMENTS
    ORG 0
BDRUM:   ds 1
SNARE:   ds 1
BASS:    ds 1
HAT:     ds 1
MJARP:   ds 1
MJPWER:  ds 1
MNARP:   ds 1
GUITAR:  ds 1
GUITAR2:  ds 1
    SEG ROM_FILE

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

guitar subroutine
    .byte SQ1_CH
    .byte PRI_MUSIC
    .word .sq2
    .byte -1
.sq2:
    .byte DUTY_12 |15, 0
    .byte DUTY_12 | 7, 0
    .byte DUTY_12 | 3, 0
    .byte DUTY_12 | 3, 0
    .byte DUTY_25 | 7, 0
    .byte DUTY_25 | 3, 0
    .byte DUTY_25 | 3, 0
    .byte DUTY_50 | 3, 0
    .byte DUTY_25 | 7, 0
    .byte DUTY_25 | 3, 0
    .byte DUTY_25 | 3, 0
    .byte DUTY_50 | 3, 0
    .byte DUTY_50 | 5, 0
    .byte DUTY_50 | 2, 0
    .byte DUTY_50 | 1, 0
    .byte DUTY_50 | 0, 0
    .byte 0
    
guitar2 subroutine
    .byte SQ2_CH
    .byte PRI_MUSIC
    .word .sq2
    .byte -1
.sq2:
    .byte DUTY_12 |15, 0
    .byte DUTY_12 | 7, 0
    .byte DUTY_12 | 3, 0
    .byte DUTY_12 | 3, 0
    .byte DUTY_25 | 7, 0
    .byte DUTY_25 | 3, 0
    .byte DUTY_25 | 3, 0
    .byte DUTY_50 | 3, 0
    .byte DUTY_25 | 7, 0
    .byte DUTY_25 | 3, 0
    .byte DUTY_25 | 3, 0
    .byte DUTY_50 | 3, 0
    .byte DUTY_50 | 5, 0
    .byte DUTY_50 | 2, 0
    .byte DUTY_50 | 1, 0
    .byte DUTY_50 | 0, 0
    .byte 0


majorPowerChord subroutine
    .byte SQ2_CH
    .byte PRI_MUSIC
    .word .sq2
    .byte SQ1_CH
    .byte PRI_MUSIC
    .word .sq1
    .byte -1
.sq2:
    .byte DUTY_12 |15, 0
    .byte DUTY_12 | 7, 0
    .byte DUTY_12 | 3, 0
    .byte DUTY_12 | 3, 0
    .byte DUTY_25 | 7, 0
    .byte DUTY_25 | 3, 0
    .byte DUTY_25 | 3, 0
    .byte DUTY_50 | 3, 0
    .byte DUTY_25 | 7, 0
    .byte DUTY_25 | 3, 0
    .byte DUTY_25 | 3, 0
    .byte DUTY_50 | 3, 0
    .byte DUTY_50 | 5, 0
    .byte DUTY_50 | 2, 0
    .byte DUTY_50 | 1, 0
    .byte DUTY_50 | 0, 0
    .byte 0
.sq1:
    .byte DUTY_50 | 0, 7
    .byte DUTY_50 | 0, 7
    .byte DUTY_12 |15, 7
    .byte DUTY_12 | 7, 7
    .byte DUTY_12 | 3, 7
    .byte DUTY_12 | 3, 7
    .byte DUTY_25 | 7, 7
    .byte DUTY_25 | 3, 7
    .byte DUTY_25 | 3, 7
    .byte DUTY_50 | 3, 7
    .byte DUTY_25 | 7, 7
    .byte DUTY_25 | 3, 7
    .byte DUTY_25 | 3, 7
    .byte DUTY_50 | 3, 7
    .byte DUTY_50 | 5, 7
    .byte DUTY_50 | 2, 7
    .byte DUTY_50 | 1, 7
    .byte DUTY_50 | 0, 7
    .byte 0
    
majorArpeggio subroutine
    .byte SQ2_CH
    .byte PRI_MUSIC
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
    .byte DUTY_50 | 0, 7
    .byte 0
    
minorArpeggio subroutine
    .byte SQ2_CH
    .byte PRI_MUSIC
    .word .sq
    .byte -1
.sq:
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 3
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 3
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 3
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 3
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 3
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 3
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 3
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 3
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 4, 3
    .byte DUTY_50 | 4, 7
    .byte DUTY_50 | 0, 7
    .byte 0

bass subroutine
    .byte TRI_CH
    .byte 0
    .word .tri
    .byte -1
.tri:
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
    .byte NOISE_VOL |11, 15
    .byte NOISE_VOL |10, 15
    .byte NOISE_VOL | 9, 15 
    .byte NOISE_VOL | 8, 15
    .byte NOISE_VOL | 7, 15
    .byte NOISE_VOL | 6, 15 | NOISE_LOOP
    .byte NOISE_VOL | 5, 15
    .byte NOISE_VOL | 4, 15 | NOISE_LOOP
    .byte NOISE_VOL | 3, 15
    .byte NOISE_VOL | 2, 15 | NOISE_LOOP
    .byte NOISE_VOL | 1, 15
    .byte NOISE_VOL | 0, 15 | NOISE_LOOP
    .byte 0

;------------------------------------------------------------------------------
; Music
;------------------------------------------------------------------------------

nullSong subroutine
    .byte 255
    .word 0
    .word 0
    .word 0
    .word 0

testSong subroutine
    .byte 6
    .word testLeadSequence
    .word testChordSequence
    .word testBassSequence
    .word testDrumSequence

testLeadSequence subroutine
    .word .pat0
    .word .pat0
    .word .pat1
    .word .pat1
    .word .pat0
    .word .pat2
    .word .pat2
    .word .pat0
    .word 2<<1
.pat0:
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
.pat1:
    .byte GUITAR,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_A3_
    .byte MC____,MN____
    .byte MC____,MN_E3_
    .byte MC____,MN____
    .byte MC____,MN____
    
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN_E3_
    .byte MC____,MN____
    .byte MC____,MN_A3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    
    .byte MC____,MN_A3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_A3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    
    .byte GUITAR,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_A3_
    .byte MC____,MN____
    .byte MC____,MN_E3_
    .byte MC____,MN____
    .byte MC____,MN____
    
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN_E3_
    .byte MC____,MN____
    .byte MC____,MN_A3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
    
.pat2:
    .byte GUITAR,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN_A3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_E3_
    .byte MC____,MN____
    .byte MC____,MN____
    
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_E3_
    .byte MC____,MN____
    .byte MC____,MN_A3_
    .byte MC____,MN____
    .byte MC____,MN____
    
    .byte MC____,MN_E3_
    .byte MC____,MN_F3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_E3_
    .byte MC____,MN_F3_
    .byte MC____,MN____
    .byte MC____,MN____
    
    .byte MC____,MN_A3_
    .byte MC____,MN_D3_
    .byte MC____,MN____
    .byte MC____,MN_A3_
    .byte MC____,MN_D3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    
    .byte GUITAR,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN_A3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_E3_
    .byte MC____,MN____
    .byte MC____,MN____
    
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_E3_
    .byte MC____,MN____
    .byte MC____,MN_A3_
    .byte MC____,MN____
    .byte MC_LOP,MN____

testChordSequence subroutine
    .word .pat0
    .word .pat0
    .word .pat1
    .word .pat1
    .word .pat0
    .word 2<<1
.pat0:
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
.pat1:
    .byte MJARP ,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_F3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_F3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MNARP ,MN_G3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MJARP ,MN_F3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MNARP ,MN_G3_
    .byte MC____,MN____
    .byte MJARP ,MN_C3_
    .byte MC_LOP,MN____
    
testDrumSequence subroutine
    .word .pat2
    .word .pat2
    .word .pat1
    .word .pat1
    .word .pat1
    .word .pat1
    .word .pat1
    .word .pat1
    .word .pat1
    .word .pat1
    .word .pat1
    .word .pat1
    .word .pat1
    .word .pat1
    .word .pat2
    .word 2<<1
.pat1:
    .byte  BDRUM,MN_C1_
    .byte MC____,MN____
    .byte    HAT,MN_C1_
    .byte MC____,MN____
    .byte  SNARE,MN_G3_
    .byte MC____,MN____
    .byte    HAT,MN_C1_
    .byte MC_LOP,MN____
.pat2:
    .byte  SNARE,MN_G3_
    .byte MC____,MN_G3_
    .byte  BDRUM,MN_C1_
    .byte MC____,MN_C1_
    .byte    HAT,MN_C1_
    .byte MC____,MN_C1_
    .byte MC____,MN____
    .byte MC_LOP,MN____

testBassSequence subroutine
    .word .pat1
    .word 0
.pat1:
    .byte MC____,MN____
    .byte   BASS,MN_C2_
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
    

mellowSong subroutine
    .byte 12
    .word .chordSeq
    .word 0
    .word 0
    .word 0
.chordSeq:
    .word .chordRest
    .word .chord1
    .word .chord1
    .word .chordRest
    .word .chord2
    .word .chord1
    .word 0
.chordRest:
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
.chord1:
    .byte MJPWER,MN_C2_
    .byte MC____,MN____
    .byte MC____,MN_F2_
    .byte MC____,MN____
    .byte MC____,MN_F2_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_C2_
    .byte MC____,MN____
    .byte MC____,MN_F2_
    .byte MC____,MN_F2_
    .byte MC____,MN____
    .byte MC____,MN_C2_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
.chord2:
    .byte MJPWER,MN_C2_
    .byte MC____,MN_C2_
    .byte MC____,MN____
    .byte MC____,MN_F2_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_F2_
    .byte MC____,MN_F2_
    .byte MC____,MN____
    .byte MC____,MN_C2_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____

industrialSong subroutine
    .byte 6
    .word .drumTrack
    .word .bassTrack
    .word 0
    .word 0
.drumTrack:
    .word .drum2
    .word .drum2
    
    .word .drum1
    .word .drum1
    .word .drum1
    .word .drum1
    
    .word .drum2
    .word .drum2
    
    .word .drum1
    .word .drum2
    .word .drum1
    
    .word .drum2
    .word .drum2
    .word .drum2
    .word 2<<1
.drum1:
    .byte BDRUM ,MN_C1_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte SNARE ,MN_G3_
    .byte MC____,MN____
    .byte BDRUM ,MN_G3_
    .byte BDRUM ,MN_G3_
    .byte BDRUM ,MN_G3_
    .byte MC____,MN____
    .byte BDRUM ,MN_G3_
    .byte MC____,MN____
    .byte SNARE ,MN_G3_
    .byte MC____,MN____
    .byte BDRUM ,MN_G3_
    .byte MC____,MN____
    .byte BDRUM ,MN_G3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte SNARE ,MN_G3_
    .byte MC____,MN____
    .byte BDRUM ,MN_G3_
    .byte BDRUM ,MN_G3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte BDRUM ,MN_G3_
    .byte SNARE ,MN_G3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
.drum2:
    .byte SNARE ,MN_G3_
    .byte MC____,MN_G3_
    .byte MC____,MN_G3_
    .byte MC____,MN____
    .byte MC____,MN_G3_
    .byte MC____,MN_G3_
    .byte MC____,MN____
    .byte MC____,MN_G3_
    .byte MC____,MN_G3_
    .byte MC____,MN____
    .byte MC____,MN_G3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
    
.bassTrack:
    .word .bass0
    .word .bass0
    
    .word .bass1
    .word .bass0
    .word .bass1
    .word .bass0
    .word .bass2
    .word .bass0
    .word .bass2
    .word .bass0
    
    .word .bass0
    .word .bass0
    
    .word .bass1
    .word .bass1
    .word .bass2
    .word .bass2
    .word .bass0
    .word .bass0
    .word .bass2
    
    .word .bass0
    .word .bass0
    .word .bass0
    .word 1<<2
.bass0:
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
.bass1:
    .byte GUITAR2,MN_D1S
    .byte MC____,MN____
    .byte MC____,MN_C1_
    .byte MC____,MN_G1S
    .byte MC____,MN____
    .byte MC____,MN_D1S
    .byte MC____,MN____
    .byte MC____,MN_D1S
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_G1S
    .byte MC____,MN____
    .byte MC____,MN_C1_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
.bass2:
    .byte GUITAR2,MN_C1_
    .byte MC____,MN____
    .byte MC____,MN_G1S
    .byte MC____,MN_C1_
    .byte MC____,MN_D1S
    .byte MC____,MN_C1_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_G1S
    .byte MC____,MN_D1S
    .byte MC____,MN____
    .byte MC____,MN_C1_
    .byte MC____,MN_D1S
    .byte MC____,MN____
    .byte MC_LOP,MN____

technoSong subroutine
    .byte 8
    .word .drumTrack
    .word .bassTrack
    .word 0
    .word 0
.drumTrack:
    .word .drum1
    .word 0
.drum1:
    .byte BDRUM ,MN_C1_
    .byte    HAT,MN_C1_
    .byte MC____,MN_C1_
    .byte MC____,MN_C1_
    .byte BDRUM ,MN_C1_
    .byte    HAT,MN_C1_
    .byte MC____,MN_C1_
    .byte MC_LOP,MN_C1_
    
.bassTrack:
    .word .bass0
    .word .bass0
    
    .word .bass1
    .word .bass1
    .word .bass1
    .word .bass1
    
    .word .bass0
    .word .bass0
    .word 1<<2
.bass0:
    .byte GUITAR2,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
.bass1:
    .byte MC____,MN_C3_
    .byte MC____,MN_D3_
    .byte MC____,MN_E3_
    .byte MC____,MN_D3_
    .byte MC____,MN_C3_
    .byte MC____,MN_D3_
    .byte MC____,MN_E3_
    .byte MC____,MN_D3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_G3_
    .byte MC____,MN_C3_
    .byte MC____,MN_D3_
    .byte MC_LOP,MN____

mineSong subroutine
    .byte 12
    .word .leadSeq
    .word .percussionSeq
    .word .bassSeq
    .word 0
    
.leadSeq:
    .word .leadRest
    .word .leadRest
    .word .lead1
    .word .lead1
    .word .lead1
    .word .leadRest
    .word .lead2
    .word .lead2
    .word .lead1
    .word .lead1
    .word 1 << 1
.leadRest:
    .byte GUITAR2,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
.lead1:
    .byte MC____,MN_G3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_G3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_A2S
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_A2S
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
.lead2:
    .byte MC____,MN_A3_
    .byte MC____,MN_D4_
    .byte MC____,MN_A3_
    .byte MC____,MN_D2_
    .byte MC____,MN_G3_
    .byte MC____,MN____
    .byte MC____,MN_G3_
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN_D3_
    .byte MC____,MN____
    .byte MC____,MN_D3S
    .byte MC____,MN____
    .byte MC_LOP,MN____
.percussionSeq:
    .word .percussion1
    .word 0
.percussion1:
    .byte    $03,MN_C1_
    .byte MC____,MN_C1_
    .byte MC____,MN_C1_
    .byte MC____,MN_C1_
    .byte MC____,MN_C1_
    .byte MC____,MN_C1_
    .byte MC____,MN_C1_
    .byte MC_LOP,MN_C1_

.bassSeq:
    .word .bass0
    .word .bass1
    .word .bass1
    .word .bass1
    .word .bass1
    .word .bass2
    .word .bass2
    .word .bass2
    .word .bass1
    .word .bass1
    .word 1 << 1
.bass0:
    .byte BASS  ,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC_LOP,MN____
.bass1:
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_C3_
    .byte MC____,MN_G2_
    .byte MC____,MN____
    .byte MC____,MN____
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN_G2_
    .byte MC____,MN_A2S
    .byte MC____,MN_A2S
    .byte MC____,MN_C3_
    .byte MC_LOP,MN_A2S
.bass2:
    .byte MC____,MN_D3_
    .byte MC____,MN_G3_
    .byte MC____,MN_D3_
    .byte MC____,MN_G2_
    .byte MC____,MN_C3_
    .byte MC____,MN____
    .byte MC____,MN_C3_
    .byte MC____,MN_E2_
    .byte MC____,MN____
    .byte MC____,MN_F2_
    .byte MC____,MN____
    .byte MC____,MN_F2S
    .byte MC____,MN____
    .byte MC____,MN_G2_
    .byte MC____,MN____
    .byte MC_LOP,MN____

;------------------------------------------------------------------------------
