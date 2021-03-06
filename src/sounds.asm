
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
    
    lda musicPatternPtr+1,x
    bne .notStart
    lda musicSequence,x
    sta tmp+2
    lda musicSequence+1,x
    sta tmp+3
    ldy musicSequenceIndex,x
    lda (tmp+2),y
    sta musicPatternPtr,x
    iny
    lda (tmp+2),y
    sta musicPatternPtr+1,x
    iny
    sty musicSequenceIndex,x
.notStart:
    
    lda (musicPatternPtr,x)
    bpl .note ;%0xxxxxxx note on
    asl
    bmi .effect ;%11xxxxxx effect
    ;%10xxxxxx change instrument
    tay
    lda instruments,y
    sta instrument,x
    lda instruments+1,y
    sta instrument+1,x
    jmp .commandEnd
.effect:
    ;%11111111 end
    lda musicSequence,x
    sta tmp+2
    lda musicSequence+1,x
    sta tmp+3
    ldy musicSequenceIndex,x
    iny
    lda (tmp+2),y
    bne .notLoop
    dey
    lda (tmp+2),y
    tay
    iny
.notLoop:
    lda (tmp+2),y
    sta musicPatternPtr+1,x
    dey
    lda (tmp+2),y
    sta musicPatternPtr,x
    iny
    iny
    sty musicSequenceIndex,x
    jmp .notStart
.commandEnd:
    lda musicPatternPtr,x
    clc
    adc #1
    sta musicPatternPtr,x
    lda musicPatternPtr+1,x
    adc #0
    sta musicPatternPtr+1,x

.note:
    lda (musicPatternPtr,x)
    cmp #REST
    beq .end
    sta arg+2
    lda instrument,x
    sta arg
    lda instrument+1,x
    sta arg+1
    txa
    pha
    jsr LoadSfx
    pla
    tax
.end:
    lda musicPatternPtr,x
    clc
    adc #1
    sta musicPatternPtr,x
    lda musicPatternPtr+1,x
    adc #0
    sta musicPatternPtr+1,x

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
    .byte NOTE_C4
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
    .byte NOTE_C4S
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
    .byte NOTE_E3
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
    .byte NOTE_E3
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
    .byte NOTE_B3
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
    .byte NOTE_C3
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
    .byte NOTE_A2
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
    .byte NOTE_C5
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
    .byte NOTE_C1
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
    .byte NOTE_D5
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
    .byte NOTE_D5
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
    .byte NOTE_A3S
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
    .byte NOTE_F2S
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
    .byte NOTE_C4
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
NOTE_A0:   ds 1
NOTE_A0S:
NOTE_B0F:  ds 1
NOTE_B0:   ds 1

NOTE_C1:   ds 1
NOTE_C1S:
NOTE_D1F:  ds 1
NOTE_D1:   ds 1
NOTE_D1S:
NOTE_E1F:  ds 1
NOTE_E1:   ds 1
NOTE_F1:   ds 1
NOTE_F1S:
NOTE_G1F:  ds 1
NOTE_G1:   ds 1
NOTE_G1S:
NOTE_A1F:  ds 1
NOTE_A1:   ds 1
NOTE_A1S:
NOTE_B1F:  ds 1
NOTE_B1:   ds 1

NOTE_C2:   ds 1
NOTE_C2S:
NOTE_D2F:  ds 1
NOTE_D2:   ds 1
NOTE_D2S:
NOTE_E2F:  ds 1
NOTE_E2:   ds 1
NOTE_F2:   ds 1
NOTE_F2S:
NOTE_G2F:  ds 1
NOTE_G2:   ds 1
NOTE_G2S:
NOTE_A2F:  ds 1
NOTE_A2:   ds 1
NOTE_A2S:
NOTE_B2F:  ds 1
NOTE_B2:   ds 1

NOTE_C3:   ds 1
NOTE_C3S:
NOTE_D3F:  ds 1
NOTE_D3:   ds 1
NOTE_D3S:
NOTE_E3F:  ds 1
NOTE_E3:   ds 1
NOTE_F3:   ds 1
NOTE_F3S:
NOTE_G3F:  ds 1
NOTE_G3:   ds 1
NOTE_G3S:
NOTE_A3F:  ds 1
NOTE_A3:   ds 1
NOTE_A3S:
NOTE_B3F:  ds 1
NOTE_B3:   ds 1

NOTE_C4:   ds 1
NOTE_C4S:
NOTE_D4F:  ds 1
NOTE_D4:   ds 1
NOTE_D4S:
NOTE_E4F:  ds 1
NOTE_E4:   ds 1
NOTE_F4:   ds 1
NOTE_F4S:
NOTE_G4F:  ds 1
NOTE_G4:   ds 1
NOTE_G4S:
NOTE_A4F:  ds 1
NOTE_A4:   ds 1
NOTE_A4S:
NOTE_B4F:  ds 1
NOTE_B4:   ds 1

NOTE_C5:   ds 1
NOTE_C5S:
NOTE_D5F:  ds 1
NOTE_D5:   ds 1
NOTE_D5S:
NOTE_E5F:  ds 1
NOTE_E5:   ds 1
NOTE_F5:   ds 1
NOTE_F5S:
NOTE_G5F:  ds 1
NOTE_G5:   ds 1
NOTE_G5S:
NOTE_A5F:  ds 1
NOTE_A5:   ds 1
NOTE_A5S:
NOTE_B5F:  ds 1
NOTE_B5:   ds 1

NOTE_C6:   ds 1
NOTE_C6S:
NOTE_D6F:  ds 1
NOTE_D6:   ds 1
NOTE_D6S:
NOTE_E6F:  ds 1
NOTE_E6:   ds 1
NOTE_F6:   ds 1
NOTE_F6S:
NOTE_G6F:  ds 1
NOTE_G6:   ds 1
NOTE_G6S:
NOTE_A6F:  ds 1
NOTE_A6:   ds 1
NOTE_A6S:
NOTE_B6F:  ds 1
NOTE_B6:   ds 1

NOTE_C7:   ds 1
NOTE_C7S:
NOTE_D7F:  ds 1
NOTE_D7:   ds 1
NOTE_D7S:
NOTE_E7F:  ds 1
NOTE_E7:   ds 1
    SEG ROM_FILE

REST = 127
    
periodTableLo:
  .byte $f1,$7f,$13
  .byte $ad,$4d,$f3,$9d,$4c,$00,$b8,$74,$34,$f8,$bf,$89
  .byte $56,$26,$f9,$ce,$a6,$80,$5c,$3a,$1a,$fb,$df,$c4
  .byte $ab,$93,$7c,$67,$52,$3f,$2d,$1c,$0c,$fd,$ef,$e1
  .byte $d5,$c9,$bd,$b3,$a9,$9f,$96,$8e,$86,$7e,$77,$70
  .byte $6a,$64,$5e,$59,$54,$4f,$4b,$46,$42,$3f,$3b,$38
  .byte $34,$31,$2f,$2c,$29,$27,$25,$23,$21,$1f,$1d,$1b
  .byte $1a,$18,$17,$15,$14
periodTableHi:
  .byte $07,$07,$07
  .byte $06,$06,$05,$05,$05,$05,$04,$04,$04,$03,$03,$03
  .byte $03,$03,$02,$02,$02,$02,$02,$02,$02,$01,$01,$01
  .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $00,$00,$00,$00,$00
  

END_PATTERN = $FF

;------------------------------------------------------------------------------
; Instruments
;------------------------------------------------------------------------------
  
instruments:
    .word voice_kick
    .word voice_snare
    .word voice_bass
    .word voice_hat
    .word voice_majorArpeggio
    .word voice_powerChord
    .word voice_minorArpeggio
    .word voice_guitar
    .word voice_guitar2
    SEG.U INSTRUMENTS
    ORG $80
VOICE_KICK:   ds 1
VOICE_SNARE:   ds 1
VOICE_BASS:    ds 1
VOICE_HAT:     ds 1
VOICE_MAJOR_ARP:   ds 1
VOICE_MAJOR_PCHORD:  ds 1
VOICE_MINOR_ARP:   ds 1
                ds 1
VOICE_GUITAR:  ;ds 1
VOICE_GUITAR2:  ds 1
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

voice_guitar subroutine
    .byte SQ1_CH
    .byte PRI_MUSIC
    .word .sq2
    .byte -1
.sq2:
    .byte DUTY_12 |15, 0
    .byte DUTY_12 |10, 0
    .byte DUTY_12 | 5, 0
    .byte DUTY_12 | 5, 0
    .byte DUTY_25 |10, 0
    .byte DUTY_25 | 5, 0
    .byte DUTY_25 | 5, 0
    .byte DUTY_50 | 5, 0
    .byte DUTY_25 |10, 0
    .byte DUTY_25 | 5, 0
    .byte DUTY_25 | 5, 0
    .byte DUTY_50 | 5, 0
    .byte DUTY_50 | 9, 0
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 2, 0
    .byte DUTY_50 | 0, 0
    .byte 0
    
voice_guitar2 subroutine
    .byte SQ2_CH
    .byte PRI_MUSIC
    .word .sq2
    .byte -1
.sq2:
    .byte DUTY_12 |15, 0
    .byte DUTY_12 |10, 0
    .byte DUTY_12 | 5, 0
    .byte DUTY_12 | 5, 0
    .byte DUTY_25 |10, 0
    .byte DUTY_25 | 5, 0
    .byte DUTY_25 | 5, 0
    .byte DUTY_50 | 5, 0
    .byte DUTY_25 |10, 0
    .byte DUTY_25 | 5, 0
    .byte DUTY_25 | 5, 0
    .byte DUTY_50 | 5, 0
    .byte DUTY_50 | 9, 0
    .byte DUTY_50 | 4, 0
    .byte DUTY_50 | 2, 0
    .byte DUTY_50 | 0, 0
    .byte 0


voice_powerChord subroutine
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
    
voice_majorArpeggio subroutine
    .byte SQ2_CH
    .byte PRI_MUSIC
    .word .sq
    .byte -1
.sq:
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 4
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 4
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 4
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 4
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 4
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 4
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 4
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 4
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 4
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 0, 7
    .byte 0
    
voice_minorArpeggio subroutine
    .byte SQ2_CH
    .byte PRI_MUSIC
    .word .sq
    .byte -1
.sq:
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 3
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 3
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 3
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 3
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 3
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 3
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 3
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 3
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 7, 0
    .byte DUTY_50 | 7, 3
    .byte DUTY_50 | 7, 7
    .byte DUTY_50 | 0, 7
    .byte 0

voice_bass subroutine
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

voice_kick subroutine
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
    
voice_snare subroutine
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

voice_hat subroutine
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

song_null subroutine
    .byte 255
    .word 0
    .word 0
    .word 0
    .word 0

    include song-party.asm
    include song-mine.asm
    include song-industrial.asm
    include song-blues.asm
    
;------------------------------------------------------------------------------
