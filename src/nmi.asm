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

.sprite_dma:
    lda shr_doDma
    beq .vram_copy
    lda #0
    sta OAM_ADDR
    lda #>shr_spriteY
    sta OAM_DMA
    dec shr_doDma
    
.vram_copy:
    lda shr_doVramCopy
    beq .reg_update
    dec shr_doVramCopy
    ldy #0
.while_requests:
    lda shr_vramBuffer,y
    beq .reg_update
    iny
    sta nmi_len
    bit PPU_STATUS
    lda shr_vramBuffer,y
    sta PPU_ADDR
    iny
    sta PPU_ADDR
    iny
    lda shr_vramBuffer,y
    beq .from_ram
.from_rom:
    iny
    lda shr_vramBuffer,y
    sta nmi_src
    iny
    lda shr_vramBuffer,y
    sta nmi_src+1
    iny
    tya ;preserve y in x
    tax ;-
    ldy #0
.foreach_rombyte:
    lda (nmi_src),y
    sta PPU_DATA
    iny
    cpy nmi_len
    bne .foreach_rombyte
;end foreach_rombyte
    txa
    tay
    jmp .while_requests
.from_ram:
    iny
    ldx #0
.foreach_rambyte
    lda shr_vramBuffer,y
    iny
    sta PPU_DATA
    inx
    cpx nmi_len
    bne .foreach_rambyte
;end foreach_rambyte
    jmp .while_requests

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
