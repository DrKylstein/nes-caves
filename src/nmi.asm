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
    inc nmi_frame

nmi_SpriteDma subroutine
    lda shr_doDma
    beq nmi_SpriteDma_end
    lda #0
    sta OAM_ADDR
    lda #>shr_spriteY
    sta OAM_DMA
    dec shr_doDma
nmi_SpriteDma_end:

nmi_genericCopy subroutine
    lda #PPU_CTRL_SETTING
    sta PPU_CTRL

    lda shr_sleeping
    beq nmi_genericCopy_end
    tsx
    stx nmi_sp
    ldx shr_copyIndex
    txs
    bit PPU_STATUS
    pla
    sta PPU_ADDR
    pla
    sta PPU_ADDR
END_COPY:
    rts ; jump to update routine
;rts with END_COPY on stack will arrive here
    ldx nmi_sp
    txs
    lda #<shr_copyBufferEnd
    sta shr_copyIndex
nmi_genericCopy_end:

nmi_TileCopy subroutine
    lda shr_doTileCol
    beq nmi_TileCopy_end
    jsr nmi_CopyTileCol
    dec shr_doTileCol
nmi_TileCopy_end:

nmi_OneTileCopy subroutine
    lda shr_doTile
    beq nmi_OneTileCopy_end
    bit PPU_STATUS
    lda shr_tileAddr+1
    sta PPU_ADDR
    lda shr_tileAddr
    sta PPU_ADDR
    ldy shr_tileMeta
    lda metatiles,y
    sta PPU_DATA
    lda metatiles+256,y
    sta PPU_DATA
    ADD16I shr_tileAddr, shr_tileAddr, 32
    lda shr_tileAddr+1
    sta PPU_ADDR
    lda shr_tileAddr
    sta PPU_ADDR
    ldy shr_tileMeta
    lda metatiles+512,y
    sta PPU_DATA
    lda metatiles+768,y
    sta PPU_DATA
    dec shr_doTile
nmi_OneTileCopy_end:
    
nmi_AttrCopy subroutine
    lda shr_doAttrCol
    beq nmi_AttrCopy_end
    jsr nmi_CopyAttrCol
    dec shr_doAttrCol
nmi_AttrCopy_end:

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

nmi_updateReg subroutine
    lda shr_doRegCopy
    beq nmi_updateReg_end
    
    SUB16I nmi_tmp, shr_cameraX, 8
    lda nmi_tmp
    sta nmi_scrollX
    
    lda shr_cameraYMod
    sta nmi_scrollY
    lda shr_nameTable
    sta nmi_nametable
    dec shr_doRegCopy
nmi_updateReg_end:

nmi_DebugCounter subroutine
    lda #PPU_CTRL_SETTING
    sta PPU_CTRL

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

    lda shr_earlyExit
    beq continue$
    jmp nmi_Exit
continue$:


nmi_doStatus subroutine
    lda #PPU_CTRL_SETTING
    sta PPU_CTRL
    bit PPU_STATUS
    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL

    lda nmi_scrollY
    and #%00111000
    asl
    asl
    sta nmi_tmp
    lda nmi_scrollX
    lsr
    lsr
    lsr
    ora nmi_tmp
    sta nmi_tmp

.wait: ;wait for sprite 0 to be cleared from last frame
    bit PPU_STATUS
    bvs .wait
    
;update sound during wait
    ; lda shr_doSfx
    ; beq .check
    ; tay
    ; lda sfx,y
    ; sta nmi_sfxPtr
    ; iny
    ; lda sfx,y
    ; sta nmi_sfxPtr+1
    
    ; ldy #0
    ; lda (nmi_sfxPtr),y
    ; sta nmi_sfxPeriod
    ; INC16 nmi_sfxPtr
    ; lda (nmi_sfxPtr),y
    ; sta nmi_sfxPeriod+1
    ; INC16 nmi_sfxPtr
    ; sty shr_doSfx
; .check:
    ; lda nmi_sfxPeriod+1
    ; bpl .play
    ; lda #0
    ; sta APU_SQ1_VOL
    ; jmp .wait2
; .play:
    ; MOV_D APU_SQ1_LO, nmi_sfxPeriod
    ; lda #%10111111
    ; sta APU_SQ1_VOL
    
    ; ldy #0
    ; lda (nmi_sfxPtr),y
    ; sta nmi_sfxPeriod
    ; INC16 nmi_sfxPtr
    ; lda (nmi_sfxPtr),y
    ; sta nmi_sfxPeriod+1
    ; INC16 nmi_sfxPtr


.wait2: ;wait for sprite 0 to be set again
    bit PPU_STATUS
    bvc .wait2

    lda nmi_nametable
    sta PPU_ADDR
    lda nmi_scrollY
    sta PPU_SCROLL
    lda nmi_scrollX
    sta PPU_SCROLL
    lda nmi_tmp
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
    ADD16I nmi_tmp, nmi_tmp, 8
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
    ADD16I nmi_tmp, nmi_tmp, 8
    REPEND
    rts
;------------------------------------------------------------------------------
nmi_CopyTileCol subroutine
    ;vertical mode
    lda #[PPU_CTRL_SETTING | %00000100]
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

    lda #PPU_CTRL_SETTING
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
;------------------------------------------------------------------------------
nmi_Copy32:
    pla
    sta PPU_DATA
nmi_Copy31:
    pla
    sta PPU_DATA
nmi_Copy30:
    pla
    sta PPU_DATA
nmi_Copy29:
    pla
    sta PPU_DATA
nmi_Copy28:
    pla
    sta PPU_DATA
nmi_Copy27:
    pla
    sta PPU_DATA
nmi_Copy26:
    pla
    sta PPU_DATA
nmi_Copy25:
    pla
    sta PPU_DATA
nmi_Copy24:
    pla
    sta PPU_DATA
nmi_Copy23:
    pla
    sta PPU_DATA
nmi_Copy22:
    pla
    sta PPU_DATA
nmi_Copy21:
    pla
    sta PPU_DATA
nmi_Copy20:
    pla
    sta PPU_DATA
nmi_Copy19:
    pla
    sta PPU_DATA
nmi_Copy18:
    pla
    sta PPU_DATA
nmi_Copy17:
    pla
    sta PPU_DATA
nmi_Copy16:
    pla
    sta PPU_DATA
nmi_Copy15:
    pla
    sta PPU_DATA
nmi_Copy14:
    pla
    sta PPU_DATA
nmi_Copy13:
    pla
    sta PPU_DATA
nmi_Copy12:
    pla
    sta PPU_DATA
nmi_Copy11:
    pla
    sta PPU_DATA
nmi_Copy10:
    pla
    sta PPU_DATA
nmi_Copy9:
    pla
    sta PPU_DATA
nmi_Copy8:
    pla
    sta PPU_DATA
nmi_Copy7:
    pla
    sta PPU_DATA
nmi_Copy6:
    pla
    sta PPU_DATA
nmi_Copy5:
    pla
    sta PPU_DATA
nmi_Copy4:
    pla
    sta PPU_DATA
nmi_Copy3:
    pla
    sta PPU_DATA
nmi_Copy2:
    pla
    sta PPU_DATA
nmi_Copy1:
    pla
    sta PPU_DATA
    
    pla
    sta PPU_ADDR
    pla
    sta PPU_ADDR
    rts