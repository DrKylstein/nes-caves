;------------------------------------------------------------------------------
; NMI (VBLANK) HANDLER
;------------------------------------------------------------------------------
nmi:
    php
    pha
    txa
    pha
    tya
    pha
    inc shr_frame

nmi_SpriteDma subroutine
    lda shr_doDma
    beq nmi_SpriteDma_end
    lda #0
    sta OAM_ADDR
    lda #>shr_spriteY
    sta OAM_DMA
    dec shr_doDma
nmi_SpriteDma_end:

nmi_PalCopy subroutine
    lda shr_doPalCopy
    beq nmi_PalCopy_end
    bit PPU_STATUS
    lda #$3F
    sta PPU_ADDR
    lda shr_palDest
    sta PPU_ADDR
    ldy #16
.loop:
    lda (shr_palAddr),y
    sta PPU_DATA
    dey
    bne .loop
    sty shr_doPalCopy
nmi_PalCopy_end:

nmi_TileCopy subroutine
    lda shr_doTileCol
    beq nmi_TileCopy_end
    jsr nmi_CopyTileCol
    dec shr_doTileCol
nmi_TileCopy_end:
    
nmi_AttrCopy subroutine
    lda shr_doAttrCol
    beq nmi_AttrCopy_end
    jsr nmi_CopyAttrCol
    dec shr_doAttrCol
nmi_AttrCopy_end:

    lda shr_earlyExit
    beq nmi_FlashBg
    jmp nmi_Exit

nmi_FlashBg subroutine
    lda shr_flashBg
    beq nmi_FlashBg_end
    bit PPU_STATUS
    lda #$3F
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR
    lda #$0A
    sta PPU_DATA
    dec shr_flashBg
nmi_FlashBg_end:

    lda shr_ppuCtrl
    and %11111011
    sta PPU_CTRL
nmi_DebugCounter subroutine
    bit PPU_STATUS
    lda #$20
    sta PPU_ADDR
    lda #$5A
    sta PPU_ADDR
    lda shr_debugReg+1
    REPEAT 4
    lsr
    REPEND
    sta PPU_DATA
    lda shr_debugReg+1
    and #$0F
    sta PPU_DATA
    lda shr_debugReg
    REPEAT 4
    lsr
    REPEND
    sta PPU_DATA
    lda shr_debugReg
    and #$0F
    sta PPU_DATA
nmi_DebugCounter_end:
nmi_UpdateAmmo subroutine
    bit PPU_STATUS
    lda #$20
    sta PPU_ADDR
    lda #$71
    sta PPU_ADDR
    lda shr_ammo
    jsr nmi_CentToDec
    sty PPU_DATA
    sta PPU_DATA
nmi_UpdateAmmo_end:
nmi_UpdateScore subroutine
    bit PPU_STATUS
    lda #$20
    sta PPU_ADDR
    lda #$65
    sta PPU_ADDR
    ldx #3
.loop:
    lda shr_score-1,x
    jsr nmi_CentToDec
    sty PPU_DATA
    sta PPU_DATA
    dex
    bne .loop
nmi_UpdateScore_end:

nmi_UpdateHearts subroutine
    lda #$20
    sta PPU_ADDR
    lda #$76
    sta PPU_ADDR
    lda #$10
    ldy #3
.clear_hearts:
    sta PPU_DATA
    dey
    bne .clear_hearts

    lda #$20
    sta PPU_ADDR
    lda #$76
    sta PPU_ADDR
    lda #$11
    ldy shr_hp
    beq nmi_UpdateHearts_end
.fill_hearts:
    sta PPU_DATA
    dey
    bne .fill_hearts
nmi_UpdateHearts_end:

nmi_updateReg subroutine
    lda shr_doRegCopy
    beq nmi_updateReg_end
    lda shr_ppuMask
    sta PPU_MASK 
    
    SUBI_D nmi_scratch, shr_cameraX, 8
    lda nmi_scratch
    sta nmi_scrollX
    
    lda shr_cameraYMod
    sta nmi_scrollY
    lda shr_nameTable
    sta nmi_nametable
    dec shr_doRegCopy
nmi_updateReg_end:

nmi_doStatus subroutine
    lda shr_ppuCtrl
    and #$FE
    sta PPU_CTRL
    bit PPU_STATUS
    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL

    lda nmi_scrollY
    and #%00111000
    asl
    asl
    sta nmi_scratch
    lda nmi_scrollX
    lsr
    lsr
    lsr
    ora nmi_scratch
    sta nmi_scratch

.wait: ;wait for sprite 0 to be cleared from last frame
    bit PPU_STATUS
    bvs .wait
    
;update sound during wait
    lda shr_doSfx
    beq .check
    dec shr_doSfx
    MOV_D nmi_sfxPtr, shr_sfxPtr
    lda #0
    sta APU_SQ1_HI
.check:
    ldy #0
    lda (nmi_sfxPtr),y
    bne .play
    lda #0
    sta APU_SQ1_VOL
    jmp .wait2
.play:
    sta APU_SQ1_LO
    INC_D nmi_sfxPtr
    
    lda shr_frame
    and #1
    beq .vibrate
    lda #%10111111
    sta APU_SQ1_VOL
    jmp .wait2
.vibrate:
    lda #%10110000
    sta APU_SQ1_VOL

.wait2: ;wait for sprite 0 to be set again
    bit PPU_STATUS
    bvc .wait2

    lda nmi_nametable
    sta PPU_ADDR
    lda nmi_scrollY
    sta PPU_SCROLL
    lda nmi_scrollX
    sta PPU_SCROLL
    lda nmi_scratch
    sta PPU_ADDR
nmi_doStatus_end:

nmi_Exit:
    lda #0
    sta shr_sleeping
    pla
    tay
    pla
    tax
    pla
    plp
    rti
   
;------------------------------------------------------------------------------
nmi_CopyAttrCol subroutine
    lda shr_tileCol
    lsr
    lsr
    sta nmi_tmp+2

;top
    lda #<TOP_ATTR_OFFSET
    sta nmi_tmp
    lda #>TOP_ATTR_OFFSET
    sta nmi_tmp+1
    clc
    lda nmi_tmp
    adc nmi_tmp+2
    sta nmi_tmp
    lda nmi_tmp+1
    adc #0
    sta nmi_tmp+1

    ldy #0
    bit PPU_STATUS
    
    REPEAT TOP_ATTR_HEIGHT
    lda nmi_tmp+1
    sta PPU_ADDR
    lda nmi_tmp
    sta PPU_ADDR
    lda shr_attrBuffer,y
    sta PPU_DATA
    iny
    ADDI_D nmi_tmp, nmi_tmp, 8
    REPEND
    
;bottom    
    lda #<BOTTOM_ATTR_OFFSET
    sta nmi_tmp
    lda #>BOTTOM_ATTR_OFFSET
    sta nmi_tmp+1
    clc
    lda nmi_tmp
    adc nmi_tmp+2
    sta nmi_tmp
    lda nmi_tmp+1
    adc #0
    sta nmi_tmp+1
    
    REPEAT BOTTOM_ATTR_HEIGHT
    lda nmi_tmp+1
    sta PPU_ADDR
    lda nmi_tmp
    sta PPU_ADDR
    lda shr_attrBuffer,y
    sta PPU_DATA
    iny
    ADDI_D nmi_tmp, nmi_tmp, 8
    REPEND
    rts
;------------------------------------------------------------------------------
nmi_CopyTileCol subroutine
    ;vertical mode
    lda #%00000100
    ora shr_ppuCtrl
    sta PPU_CTRL

;top nametable
    bit PPU_STATUS
    lda #>[$2000+TOP_OFFSET]
    sta PPU_ADDR
    lda shr_tileCol
    clc
    adc #<[$2000+TOP_OFFSET]
    sta PPU_ADDR
    ldy #0
    REPEAT TOP_HEIGHT
    lda shr_tileBuffer,y
    sta PPU_DATA
    iny
    REPEND
    
    ;bottom nametable
    lda #$28
    sta PPU_ADDR
    lda shr_tileCol
    sta PPU_ADDR
    REPEAT BOTTOM_HEIGHT
    lda shr_tileBuffer,y
    sta PPU_DATA
    iny
    REPEND

    lda #%11111011
    and shr_ppuCtrl
    sta PPU_CTRL
   rts
;------------------------------------------------------------------------------
nmi_CentToDec subroutine ;input in A, output ones to A, tens to Y
    ldy #0
.loop:
    cmp #10
    bcc .end
    sbc #10
    iny
    jmp .loop
.end:
    rts
nmi_CentToDec_end:

