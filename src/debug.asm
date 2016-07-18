irq subroutine
    tsx
    inx
    inx
    lda $100,x
    sta shr_debugReg
    inx
    lda $100,x
    sta shr_debugReg+1
    ADD16I shr_debugReg,shr_debugReg,12
    lda #PPU_MASK_SETTING
    sta PPU_MASK
    lda #0
    sta shr_earlyExit
    HCF
