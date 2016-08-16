;------------------------------------------------------------------------------
; 16-bit operations
;------------------------------------------------------------------------------
    MAC PUSH16
    lda {1}
    pha
    lda {1}+1
    pha
    ENDM
    
    MAC POP16
    pla
    sta {1}+1
    pla
    sta {1}
    ENDM

    MAC MOV16
    lda {2}
    sta {1}
    lda {2}+1
    sta {1}+1
    ENDM

    MAC MOV16I
    lda #<{2}
    sta {1}
    lda #>{2}
    sta {1}+1
    ENDM

    MAC ASL16
    asl {1}
    rol {1}+1
    ENDM
    
    MAC LSR16
    lsr {1}+1
    ror {1}
    ENDM

    MAC INC16
    inc {1}
    bne .no_overflow
    inc {1}+1
.no_overflow:
    ENDM

    MAC DEC16
    dec {1}
	lda {1}
	cmp #$FF
    bne .no_overflow
    dec {1}+1
.no_overflow:
    ENDM

    MAC ADD16I
    ; ADD_D dest a b
    ; dest = a + #b
    clc         ;2   2/2
    lda {2}     ;3/4 5/6
    adc #<{3}   ;2   7/8
    sta {1}     ;3/4 10/12
    lda {2}+1   ;3/4 13/16
    adc #>{3}   ;2   15/18
    sta {1}+1   ;3/4 18/22
    ENDM

    MAC ADD16
    ; ADD_D dest a b
    ; dest = a + b
    clc
    lda {2}
    adc {3}
    sta {1}
    lda {2}+1
    adc {3}+1
    sta {1}+1
    ENDM
        
    MAC SUB16
    ; SUB_D dest a b
    ; dest = a - b
    sec
    lda {2}
    sbc {3}
    sta {1}
    lda {2}+1
    sbc {3}+1
    sta {1}+1
    ENDM
    
    MAC SUB16I
    ; SUB_D dest a b
    ; dest = a - b
    sec
    lda {2}
    sbc #<{3}
    sta {1}
    lda {2}+1
    sbc #>{3}
    sta {1}+1
    ENDM

    MAC CMP16
    lda {1}
    cmp {2}
    lda {1}+1
    sbc {2}+1
    bvc .signed
    eor #$80
.signed:
    ENDM

	MAC CMP16I
    lda {1}
    cmp #<{2}
    lda {1}+1
    sbc #>{2}
    bvc .signed
    eor #$80
.signed:
	ENDM
    
    MAC EXTEND ;<16bit result> <8bit input>
    lda #0
    sta {1}+1
    lda {2}
    sta {1}
    bpl .end
    lda #$FF
    sta {1}+1
.end:
    ENDM
    
    MAC NEG16
    lda {2}
    eor #$FF
    sta {1}
    lda {2}+1
    eor #$FF
    sta {1}+1
    INC16 {2}
    ENDM

    MAC ABS16
    lda {2}+1
    bpl .positive
    NEG16 {0}
.positive:
    ENDM
;------------------------------------------------------------------------------
; Long branches
;------------------------------------------------------------------------------
    
	MAC JNE
	beq .not
	jmp {1}
.not:
	ENDM
        
	MAC JEQ
	bne .not
	jmp {1}
.not:
	ENDM

	MAC JCC
	bcs .not
	jmp {1}
.not:
	ENDM
    
	MAC JCS
	bcc .not
	jmp {1}
.not:
	ENDM
    
	MAC JMI
	bpl .not
	jmp {1}
.not:
	ENDM
    
	MAC JPL
	bmi .not
	jmp {1}
.not:
	ENDM

;------------------------------------------------------------------------------
; misc
;------------------------------------------------------------------------------

    MAC MUL_BY_24
    MOV16 {1}, {2}
    ASL16 {1}
    ADD16 {1}, {1}, {2}
    ASL16 {1}
    ASL16 {1}
    ASL16 {1}
    ENDM

    MAC HCF ;halt and catch fire
.loop:
    jmp .loop
    ENDM

    MAC ASR65 ; synthetic asr
    ;round towards zero, not negative infinity
    cmp #$FF
    bne .noTruncate
    lda #0
.noTruncate:
    ;actual shift here
    cmp #$80
    ror
    ENDM

    MAC PHXA ;push A onto software stack in $100:X
    sta $100,x
    dex
    ENDM
    
    MAC SET_PPU_ADDR
    bit PPU_STATUS
    lda #>{1}
    sta PPU_ADDR
    lda #<{1}
    sta PPU_ADDR
    ENDM

    MAC SELECT_BANK
    ldy #{1}
    lda banktable,y
    sta banktable,y
    sty currBank
    ENDM
    
    MAC PUSH_BANK
    lda currBank
    pha
    ENDM
    
    MAC POP_BANK
    pla
    tay
    lda banktable,y
    sta banktable,y
    sty currBank
    ENDM
    
    MAC ENQUEUE_PPU_ADDR
    lda #<{1}
    PHXA
    lda #>{1}
    PHXA
    ENDM
    
    MAC ENQUEUE_ROUTINE
    lda #>[{1}-1]
    PHXA
    lda #<[{1}-1]
    PHXA
    ENDM
