    MAC HCF
.loop:
    jmp .loop
    ENDM

    MAC PUSH_D
    lda {1}
    pha
    lda {1}+1
    pha
    ENDM
    
    MAC POP_D
    pla
    sta {1}+1
    pla
    sta {1}
    ENDM

    MAC MOV_D
    lda {2}
    sta {1}
    lda {2}+1
    sta {1}+1
    ENDM

    MAC MOVI_D
    lda #<{2}
    sta {1}
    lda #>{2}
    sta {1}+1
    ENDM

    MAC ASL_D
    asl {1}
    rol {1}+1
    ENDM
    
    MAC LSR_D
    lsr {1}+1
    ror {1}
    ENDM

    MAC INC_D
    inc {1}
    bne .no_overflow
    inc {1}+1
.no_overflow:
    ENDM

    MAC DEC_D
    dec {1}
	lda {1}
	cmp #$FF
    bne .no_overflow
    dec {1}+1
.no_overflow:
    ENDM

    MAC ADDI_D
    ; ADD_D dest a b
    ; dest = a + #b
    clc
    lda {2}
    adc #<{3}
    sta {1}
    lda {2}+1
    adc #>{3}
    sta {1}+1
    ENDM

    MAC ADD_D
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
        
    MAC SUB_D
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
    
    MAC SUBI_D
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

    MAC CMP_D
    lda {1}
    cmp {2}
    lda {1}+1
    sbc {2}+1
    ENDM

	MAC CMPI_D
    lda {1}
    cmp #<{2}
    lda {1}+1
    sbc #>{2}
	ENDM
    
	MAC BNE_L
	beq .not
	jmp {1}
.not:
	ENDM
        
	MAC BEQ_L
	bne .not
	jmp {1}
.not:
	ENDM

	MAC BCC_L
	bcs .not
	jmp {1}
.not:
	ENDM
    
	MAC BCS_L
	bcc .not
	jmp {1}
.not:
	ENDM
    
	MAC BMI_L
	bpl .not
	jmp {1}
.not:
	ENDM
    
	MAC BPL_L
	bmi .not
	jmp {1}
.not:
	ENDM

    MAC M_ASR
    cmp #$FF
    bne .noTruncate
    lda #0
.noTruncate:
    cmp #$80
    ror
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
    
    MAC PHXA
    sta $100,x
    dex
    ENDM