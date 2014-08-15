;------------------------------------------------------------------------------
; NMI (VBLANK) HANDLER
;------------------------------------------------------------------------------
nmi subroutine
    php
    pha
    txa
    pha
    tya
    pha

    lda shr_ppuCtrl
    and %11111011
    sta PPU_CTRL
    bit PPU_STATUS
    lda #$20
    sta PPU_ADDR
    lda #$01
    sta PPU_ADDR
    lda shr_debugReg+1
    REPEAT 4
    lsr
    REPEND
    clc
    adc #HEXFONT_BASE
    sta PPU_DATA
    lda shr_debugReg+1
    and #$0F
    clc
    adc #HEXFONT_BASE
    sta PPU_DATA
    lda shr_debugReg
    REPEAT 4
    lsr
    REPEND
    clc
    adc #HEXFONT_BASE
    sta PPU_DATA
    lda shr_debugReg
    and #$0F
    clc
    adc #HEXFONT_BASE
    sta PPU_DATA
    

.sprite_dma:
    lda shr_doDma
    beq .sprite_dma_end
    lda #0
    sta OAM_ADDR
    lda #>shr_spriteY
    sta OAM_DMA
    dec shr_doDma
.sprite_dma_end:

.pal_copy:
    lda shr_doPalCopy
    beq .pal_copy_end
    jsr nmi_CopyPal
    dec shr_doPalCopy
.pal_copy_end:

.tilecol_copy:
    lda shr_doTileCol
    beq .tilecol_copy_end
    jsr nmi_CopyTileCol
    dec shr_doTileCol
.tilecol_copy_end:
    
; .vram_copy:
    ; lda shr_doVramCopy
    ; beq .reg_update
    ; dec shr_doVramCopy
    ; jsr nmi_LoadBuffer
    
.reg_update:
    lda shr_doRegCopy
    beq .StatusBar
    lda shr_ppuMask
    sta PPU_MASK 
    lda shr_cameraX
    sec
    sbc #8
    sta nmi_scrollX
    lda shr_cameraYMod
    sta nmi_scrollY
    lda shr_nameTable
    asl
    asl
    sta nmi_scrollY+1
    dec shr_doRegCopy

.StatusBar
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

;sync to sprite zero
.wait1: ;wait for it to be cleared from last frame
    bit PPU_STATUS
    bvs .wait1
.wait2: ;wait for it to be set again
    bit PPU_STATUS
    bvc .wait2

    ldx #14
.wait3:
    dex
    bne .wait3

    lda nmi_scrollY+1
    sta PPU_ADDR
    lda nmi_scrollY
    sta PPU_SCROLL
    lda nmi_scrollX
    sta PPU_SCROLL
    lda nmi_scratch
    sta PPU_ADDR
 
.end
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
   rts
;------------------------------------------------------------------------------
nmi_CopyPal subroutine
    bit PPU_STATUS
    lda #$3F
    sta PPU_ADDR
    lda #$01
    sta PPU_ADDR
    ldy #0
    REPEAT 32
    lda (shr_palAddr),y
    sta PPU_DATA
    iny
    REPEND
    rts
