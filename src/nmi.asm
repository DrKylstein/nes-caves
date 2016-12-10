;------------------------------------------------------------------------------
; NMI (VBLANK) HANDLER
;------------------------------------------------------------------------------
nmi:
    pha
    txa
    pha

    IFCONST DEBUG_PC
    tsx
    inx
    inx
    inx
    inx
    lda $100,x
    sta shr_debugReg
    inx
    lda $100,x
    sta shr_debugReg+1
    ADD16I shr_debugReg,shr_debugReg,12
    ENDIF
    
    tya
    pha
    inc nmi_frame

nmi_SpriteDma subroutine
    lda shr_sleeping
    beq nmi_SpriteDma_end
    lda #0
    sta OAM_ADDR
    lda #>shr_spriteY
    sta OAM_DMA
nmi_SpriteDma_end:

nmi_genericCopy subroutine
    lda shr_sleeping
    beq nmi_genericCopy_end
    lda #PPU_CTRL_SETTING
    sta PPU_CTRL
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
    JEQ nmi_TileCopy_end
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
    dec shr_doTileCol
nmi_TileCopy_end:
    
nmi_AttrCopy subroutine
    lda shr_doAttrCol
    JEQ nmi_AttrCopy_end
.continue:
    lda shr_tileCol
    lsr
    lsr
    sta nmi_tmp+2
    EXTEND nmi_tmp+2,nmi_tmp+2

;top
    MOV16I nmi_tmp,TOP_ATTR_OFFSET
    ADD16 nmi_tmp,nmi_tmp,nmi_tmp+2

    bit PPU_STATUS
    lda nmi_tmp+1
    sta PPU_ADDR
    lda nmi_tmp
    sta PPU_ADDR
    
    ldy #0
    REPEAT TOP_ATTR_HEIGHT
    lda shr_attrBuffer,y
    iny
    sta PPU_DATA
    ;ADD16I nmi_tmp, nmi_tmp, 8 ;18 cycles
    lda nmi_tmp
    clc
    adc #8
    sta nmi_tmp ;10
    ; REPEAT 7 ;7*4 = 28 cycles
    ; bit PPU_DATA
    ; REPEND
    lda nmi_tmp+1 ;3
    sta PPU_ADDR  ;4 7
    lda nmi_tmp   ;3 10
    sta PPU_ADDR  ;4 14
    REPEND
    
;bottom    
    MOV16I nmi_tmp,BOTTOM_ATTR_OFFSET
    ADD16 nmi_tmp,nmi_tmp,nmi_tmp+2
    
    lda nmi_tmp+1
    sta PPU_ADDR
    lda nmi_tmp
    sta PPU_ADDR
    
    REPEAT BOTTOM_ATTR_HEIGHT
    lda shr_attrBuffer,y
    iny
    sta PPU_DATA
    ;ADD16I nmi_tmp, nmi_tmp, 8 ;18 cycles
    lda nmi_tmp
    clc
    adc #8
    sta nmi_tmp ;10
    ; REPEAT 7 ;7*4 = 28 cycles
    ; bit PPU_DATA
    ; REPEND
    lda nmi_tmp+1 ;3
    sta PPU_ADDR  ;4 7
    lda nmi_tmp   ;3 10
    sta PPU_ADDR  ;4 14
    REPEND
    dec shr_doAttrCol
nmi_AttrCopy_end:

    lda shr_earlyExit
    beq continue$
    jmp nmi_Exit
continue$:

nmi_Clouds subroutine
    lda currLevel
    cmp #MAP_LEVEL
    JNE nmi_Clouds_end
    PUSH_BANK
    SELECT_BANK 0
    ;lda shr_cameraX
    lda nmi_frame;eor #$FF
    REPEAT 4
    asl
    REPEND
    tay
    SET_PPU_ADDR [VRAM_PATTERN_R+[254*16]]
    REPEAT 16
    lda cloudsTiles,y
    iny
    sta PPU_DATA
    REPEND
    tya
    clc
    adc #128-16
    tay
    REPEAT 16
    lda cloudsTiles,y
    iny
    sta PPU_DATA
    REPEND
    POP_BANK
nmi_Clouds_end:

    IFCONST DEBUG
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
    ENDIF

nmi_updateReg subroutine
    lda shr_sleeping
    beq nmi_updateReg_end
    
    SUB16I nmi_tmp, shr_cameraX, 8
    lda nmi_tmp
    sta nmi_scrollX
    
    lda shr_cameraYMod
    sta nmi_scrollY
    lda shr_nameTable
    sta nmi_nametable
nmi_updateReg_end:

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
    sta nmi_splitBits
    lda nmi_scrollX
    lsr
    lsr
    lsr
    ora nmi_splitBits
    sta nmi_splitBits

.wait: ;wait for sprite 0 to be cleared from last frame
    bit PPU_STATUS
    bvs .wait
nmi_doStatus_end:

nmi_DoViewport
.wait2: ;wait for sprite 0 to be set again
    bit PPU_STATUS
    bvc .wait2

    lda nmi_nametable
    sta PPU_ADDR
    lda nmi_scrollY
    sta PPU_SCROLL
    lda nmi_scrollX
    sta PPU_SCROLL
    lda nmi_splitBits
    sta PPU_ADDR
nmi_DoViewport_end:

nmi_Exit:
    lda #0
    sta shr_sleeping
    pla
    tay
    pla
    tax
    pla
    rti
;------------------------------------------------------------------------------
nmi_UpdateScroll subroutine
    pla
    sta PPU_SCROLL
    pla
    sta PPU_SCROLL
    
    pla
    sta PPU_ADDR
    pla
    sta PPU_ADDR
    rts
;------------------------------------------------------------------------------
nmi_UpdateMask subroutine
    pla
    sta PPU_MASK
    pla
    sta shr_earlyExit
    
    pla
    sta PPU_ADDR
    pla
    sta PPU_ADDR
    rts
;------------------------------------------------------------------------------
    .align 256
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
;------------------------------------------------------------------------------
nmi_Fill24:
    pla
    REPEAT 24
    sta PPU_DATA
    REPEND
    pla
    sta PPU_ADDR
    pla
    sta PPU_ADDR
    rts