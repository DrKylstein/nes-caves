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
    ENDIF
    
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

    lda shr_earlyExit
    beq continue$
    jmp nmi_Exit
continue$:

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

nmi_loadSfx subroutine
    MOV16 nmi_tmp,shr_sfxPtr
    lda nmi_tmp+1
    beq nmi_loadSfx_end
    ldy #0
.loop:
    lda (nmi_tmp),y
    bmi .end
    asl
    asl
    tax
    iny
    REPEAT 2
    lda (nmi_tmp),y
    sta nmi_sfxBase,x
    iny
    inx
    REPEND

    REPEAT 2
    lda (nmi_tmp),y
    sta nmi_sfxBase,x
    sta APU_SQ1_VOL,x
    iny
    inx
    REPEND
    jmp .loop
.end:
    lda #0
    sta shr_sfxPtr+1
nmi_loadSfx_end:

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

nmi_DoSq1 subroutine
;update sound during wait

    ldy #0
    lda nmi_sq1Patch+1 ;pointer can't be in zero page, no sound must be set
    beq .ended
    lda (nmi_sq1Patch),y
    beq .ended ;byte should always have %xx11xxxx, so sound has ended
    sta APU_SQ1_VOL
    iny
    lda nmi_sq1Freq
    sec
    sbc (nmi_sq1Patch),y
    sta APU_SQ1_LO
.noTrigger
    ADD16I nmi_sq1Patch, nmi_sq1Patch, 2
.ended:
nmi_DoSq1_end:

nmi_DoTri subroutine
;update sound during wait

    ldy #0
    lda nmi_triPatch+1 ;pointer can't be in zero page, no sound must be set
    beq .ended
    lda (nmi_triPatch),y
    sta nmi_tmp
    iny
    lda (nmi_triPatch),y
    sta nmi_tmp+1
    
    CMP16I nmi_tmp, TRI_END
    beq .ended
        
    SUB16 APU_TRI_LO,nmi_triFreq,nmi_tmp
    
    lda #$C0
    sta APU_TRI_LINEAR

    
    ADD16I nmi_triPatch, nmi_triPatch, 2
    jmp nmi_DoTri_end
.ended:
    lda #$80
    sta APU_TRI_LINEAR
    
nmi_DoTri_end:


nmi_DoNoise subroutine
;update sound during wait

    ldy #0
    lda nmi_noisePatch+1 ;pointer can't be in zero page, no sound must be set
    beq .ended
    lda (nmi_noisePatch),y
    beq .ended ;byte should always have %xx11xxxx, so sound has ended
    sta APU_NOISE_VOL
    iny
    lda (nmi_noisePatch),y
    eor #$0F
    sta APU_NOISE_LO
.noTrigger
    ADD16I nmi_noisePatch, nmi_noisePatch, 2
.ended:
nmi_DoNoise_end:

nmi_ClockAPU subroutine
    lda #$C0
    sta APU_FRAME
nmi_ClockAPU_end:
    

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
    