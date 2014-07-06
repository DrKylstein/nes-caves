    MAC INC_A
    clc
    adc #1
    ENDM

    MAC TEST_TONE
    ;make a tone
    lda #$01  ; square 1
    sta $4015
    lda #$08  ; period low
    sta $4002
    lda #$02  ; period high
    sta $4003
    lda #$bf  ; volume
    sta $4000
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
