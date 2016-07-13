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
    beq nmi_TileCopy_end
    jsr nmi_CopyTileCol
    dec shr_doTileCol
nmi_TileCopy_end:
    
nmi_AttrCopy subroutine
    lda shr_doAttrCol
    bne .continue
    jmp nmi_AttrCopy_end
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
    REPEAT 7
    bit PPU_DATA
    REPEND
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
    ADD16I nmi_tmp, nmi_tmp, 8
    REPEAT 7
    bit PPU_DATA
    REPEND
    REPEND
    dec shr_doAttrCol
nmi_AttrCopy_end:

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

nmi_DoPercussion subroutine
    lda shr_percussionStream+1
    beq nmi_DoPercussion_end
    ldy #0    
    lda nmi_percussionTimer
    beq .loop
    dec nmi_percussionTimer
    jmp nmi_DoPercussion_end
    
.loop:
    lda (shr_percussionStream),y
    bmi .command
    asl
    tax
    lda drumPatches,x
    sta shr_sfxPtr
    lda drumPatches+1,x
    sta shr_sfxPtr+1
    INC16 shr_percussionStream
    jmp .loop
.command:
    and #$40
    bne .branch
    lda (shr_percussionStream),y
    and #$1F
    sta nmi_percussionTimer
    INC16 shr_percussionStream
    jmp nmi_DoPercussion_end
.branch:
    lda (shr_percussionStream),y
    clc
    adc shr_percussionStream
    sta shr_percussionStream
    lda shr_percussionStream+1
    adc #$FF
    sta shr_percussionStream+1
    MOV16 shr_debugReg,shr_percussionStream
    jmp .loop
nmi_DoPercussion_end:
        


nmi_loadSfx subroutine
    MOV16 nmi_tmp,shr_sfxPtr
    lda nmi_tmp+1
    beq nmi_loadSfx_end
    ldy #0
.loop:
    lda (nmi_tmp),y
    bmi .end
    tax
    iny
    
    lda (nmi_tmp),y
    cmp nmi_sfxPriority,x
    bcs .higher
    tya
    clc
    adc #5
    tay
    jmp .loop
.higher
    sta nmi_sfxPriority,x
    iny
    txa
    asl
    tax
    
    lda (nmi_tmp),y
    iny
    sta nmi_sfxPatch,x
    
    lda (nmi_tmp),y
    iny
    sta nmi_sfxPatch+1,x

    lda (nmi_tmp),y
    iny
    sta nmi_sfxFreq,x
    
    lda (nmi_tmp),y
    iny
    sta nmi_sfxFreq+1,x
    ;set upper frequency byte for square qwaves
    sta nmi_tmp+2
    txa
    asl
    tax
    lda nmi_tmp+2
    sta APU_SQ1_HI,x
    
    jmp .loop
.end:
    lda #0
    sta shr_sfxPtr+1
nmi_loadSfx_end:

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
    lda #0
    sta nmi_sq1Priority
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
    lda #0
    sta nmi_triPriority

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
    ADD16I nmi_noisePatch, nmi_noisePatch, 2
.ended:
    lda #0
    sta nmi_noisePriority
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
nmi_Copy8Stride8
    pla
    sta PPU_DATA
    REPEAT 7
    bit PPU_DATA
    REPEND
nmi_Copy7Stride8
    pla
    sta PPU_DATA
    REPEAT 7
    bit PPU_DATA
    REPEND
nmi_Copy6Stride8
    pla
    sta PPU_DATA
    REPEAT 7
    bit PPU_DATA
    REPEND
nmi_Copy5Stride8
    REPEAT 5
    pla
    sta PPU_DATA
    REPEAT 7
    bit PPU_DATA
    REPEND
    REPEND
    
    pla
    sta PPU_ADDR
    pla
    sta PPU_ADDR
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
    