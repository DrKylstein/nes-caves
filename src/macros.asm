    MAC INC_A
    clc
    adc #1
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

    MAC MOV_D
    lda {1}
    sta {0}
    lda {1}+1
    sta {0}+1
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

	MAC LRB ;long reverse branch, doeas a long branch with inverted logic
	{1} .not
	jmp {2}
.not:
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

    MAC L_PPU_ADDR
    bit PPU_STATUS
    lda {1}+1
    sta PPU_ADDR
    lda {1}
    sta PPU_ADDR
    ENDM

    MAC LI_PPU_ADDR
    bit PPU_STATUS
    lda #>{1}
    sta PPU_ADDR
    lda #<{1}
    sta PPU_ADDR
    ENDM
