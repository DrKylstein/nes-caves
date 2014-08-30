;------------------------------------------------------------------------------
main_LoadLevel subroutine
    MOVI_D main_tmp, main_levelMap
    ldy #0
    ldx #0
.loop:
    lda (main_arg),y
    sta (main_tmp),y
    iny
    bne .loop
    inc main_arg+1
    inc main_tmp+1
    inx
    cpx #4
    bne .loop
    rts
;------------------------------------------------------------------------------
main_LoadTilesOnMoveRight subroutine
    ;get tile column on screen
    MOV_D main_tmp, shr_cameraX
    REPEAT 3
    LSR_D main_tmp
    REPEND
    lda main_tmp
    and #31
    clc
    adc #31
    and #31
    sta main_arg+2
    
    ;get map index
    ADDI_D main_tmp, main_tmp, 1
    LSR_D main_tmp
    ADDI_D main_tmp, main_tmp, 15
    MOV_D main_arg, main_tmp
    jsr main_MultiplyBy24 ;uses only arg 0..1
    ;keeping ret value for later
        
    MOVI_D main_arg, main_levelMap
    
    ADD_D main_arg, main_arg, main_ret
    
    lda shr_cameraX
    and #%00001000
    beq .odd
    jsr main_EvenColumn
    jmp .return
.odd:
    jsr main_OddColumn
.return:
    inc shr_doTileCol
    rts
;------------------------------------------------------------------------------
main_LoadTilesOnMoveLeft subroutine
    ;get tile column on screen
    MOV_D main_tmp, shr_cameraX
    REPEAT 3
    LSR_D main_tmp
    REPEND
    lda main_tmp
    and #31
    clc
    adc #31
    and #31
    sta main_arg+2
    
    ;get map index
    ADDI_D main_tmp, main_tmp, 1
    LSR_D main_tmp
    SUBI_D main_tmp, main_tmp, 1
    MOV_D main_arg, main_tmp
    jsr main_MultiplyBy24 ;uses only arg 0..1
    ;keeping ret value for later
        
    MOVI_D main_arg, main_levelMap
    
    ADD_D main_arg, main_arg, main_ret
    
    lda shr_cameraX
    and #%00001000
    beq .odd
    jsr main_EvenColumn
    jmp .return
.odd:
    jsr main_OddColumn
.return:
    inc shr_doTileCol
    rts
;------------------------------------------------------------------------------
main_LoadColorsOnMoveRight subroutine
    ;get tile column on screen
    MOV_D main_tmp, shr_cameraX
    REPEAT 4
    LSR_D main_tmp
    REPEND
    ADDI_D main_tmp, main_tmp, 15
    
    ;get index to attribute table
    lda main_tmp
    lsr
    and #7
    clc
    adc #7
    and #7
    sta main_arg+2
    
    ;get map index
    MOV_D main_arg, main_tmp
    DEC_D main_arg
    jsr main_MultiplyBy24 ;uses only arg 0..1, keeping ret value for later

    MOVI_D main_arg, main_levelMap
    ADD_D main_arg, main_arg, main_ret
    
    jsr main_ColorColumn
.return:
    inc shr_doAttrCol
    rts
;------------------------------------------------------------------------------
main_LoadColorsOnMoveLeft subroutine
    ;get tile column on screen
    MOV_D main_tmp, shr_cameraX
    REPEAT 4
    LSR_D main_tmp
    REPEND
    
    ;get index to attribute table
    lda main_tmp
    lsr
    and #7
    clc
    adc #7
    and #7
    sta main_arg+2
    
    ;get map index
    MOV_D main_arg, main_tmp
    DEC_D main_arg
    jsr main_MultiplyBy24 ;uses only arg 0..1
    ;keeping ret value for later

    MOVI_D main_arg, main_levelMap
    ADD_D main_arg, main_arg, main_ret
    
    jsr main_ColorColumn
.return:
    inc shr_doAttrCol
    rts
;------------------------------------------------------------------------------
main_GetTileBehavior ;arg0..1 = mt_x arg2..3 = mt_y ret0 = value
    jsr main_MultiplyBy24 ;takes arg0, which we no longer care about after this
                          ;returns
    ;t0 = y+ x*24
    ADD_D main_tmp, main_arg+2, main_ret
    
    ;lookup tile, get behavior
    ADDI_D main_tmp, main_tmp, main_levelMap
    ldy #0
    lda (main_tmp),y
    tay
    lda prgdata_metatiles+256*4,y
    REPEAT 2
    lsr
    REPEND
    sta main_ret
    rts
;------------------------------------------------------------------------------
main_SetTileOnMatch ;arg0..1 = mt_x arg2..3 = mt_y, arg4 = test, arg5 = value
    PUSH_D main_sav
    PUSH_D main_sav+2
    jsr main_MultiplyBy24 ;takes arg0, which we no longer care about after this
                          ;returns
    ;t0 = y+ x*24
    ADD_D main_tmp, main_arg+2, main_ret
    
    ;lookup tile, get behavior
    ADDI_D main_tmp, main_tmp, main_levelMap
    ldy #0
    lda (main_tmp),y
    tay
    lda prgdata_metatiles+256*4,y
    REPEAT 2
    lsr
    REPEND
    cmp main_arg+4
    bne .no_match
    
    MOVI shr_debugReg, 1
    lda main_arg+5
    ldy #0
    sta (main_tmp),y
    
    jsr main_MultiplyBy24
    ADDI_D main_sav, main_ret, main_levelMap
    
    MOV_D main_tmp, main_playerX
    REPEAT 3
    LSR_D main_tmp
    REPEND
    lda main_tmp
    and #31
    clc
    adc #33
    and #30
    sta main_sav+2
    
    MOV_D main_arg, main_sav
    MOV main_arg+2, main_sav+2
    jsr main_EvenColumn
    inc shr_doTileCol
    jsr synchronize
    
    MOV_D main_arg, main_sav
    MOV main_arg+2, main_sav+2
    inc main_arg+2
    jsr main_OddColumn
    inc shr_doTileCol
    jsr synchronize
.no_match:
    POP_D main_sav+2
    POP_D main_sav
    rts
;------------------------------------------------------------------------------
main_MultiplyBy24: ;arg0..arg1 is factor, ret0..ret1 is result
    MOV_D main_ret, main_arg ; 1
    ASL_D main_ret
    ADD_D main_ret, main_ret, main_arg ;1
    ASL_D main_ret ;0
    ASL_D main_ret ;0
    ASL_D main_ret ;0
    rts
;------------------------------------------------------------------------------
synchronize subroutine
    lda #1
    sta shr_sleeping
.loop
    lda shr_sleeping
    bne .loop
rts
;------------------------------------------------------------------------------
main_SetSpriteTiles subroutine ;Y = oam index*4, A = first tile
    sta shr_spriteIndex,y
    clc
    adc #2
    sta shr_spriteIndex+4,y
    rts
;------------------------------------------------------------------------------
main_SetSpritePos subroutine ;Y = oam index*4, X = xpos, A = ypos
    sta shr_spriteY,y
    sta shr_spriteY+4,y
    txa
    sta shr_spriteX,y
    clc
    adc #8
    sta shr_spriteX+4,y
    rts
;------------------------------------------------------------------------------
main_FlipSprite subroutine ;Y = oam index*4,
    lda shr_spriteIndex,y
    sta main_tmp
    lda shr_spriteIndex+4,y
    sta shr_spriteIndex,y
    lda main_tmp
    sta shr_spriteIndex+4,y
    lda shr_spriteFlags,y
    eor #%01000000
    sta shr_spriteFlags,y
    lda shr_spriteFlags+4,y
    eor #%01000000
    sta shr_spriteFlags+4,y
    rts
;------------------------------------------------------------------------------
main_InitialLevelLoad subroutine
    MOVI_D main_sav, main_levelMap
    ldy #0
.loop:
    ;args to buffer column    
    MOV_D main_arg, main_sav
    tya
    clc
    adc main_arg
    sta main_arg
    lda #0
    adc main_arg+1
    sta main_arg+1
    tya
    asl
    sta main_arg+2
    tya
    pha
    jsr main_EvenColumn
    jsr nmi_CopyTileCol     ;terribly unsafe, by code duplication is worse
    pla
    tay
    
    MOV_D main_arg, main_sav
    tya
    clc
    adc main_arg
    sta main_arg
    lda #0
    adc main_arg+1
    sta main_arg+1
    tya
    asl
    sec
    adc #0
    sta main_arg+2
    tya
    pha
    jsr main_OddColumn
    jsr nmi_CopyTileCol     ;ditto (irony!)
    pla
    tay
    
    iny
    ADDI_D main_sav, main_sav, 23
    cpy #16
    bne .loop
    
    ldy #0
    MOVI_D main_arg, main_levelMap
.attr_loop:
    tya
    asl
    asl
    sta shr_tileCol
    tya
    pha
    jsr main_ColorColumn
    jsr nmi_CopyAttrCol
    pla
    tay
    clc
    lda main_arg
    adc #MT_MAP_HEIGHT*2
    sta main_arg
    lda main_arg+1
    adc #0
    sta main_arg+1
    iny
    cpy #8
    bne .attr_loop
    rts
;------------------------------------------------------------------------------
;arg 0..1 -> rom address
;arg 2 -> nametable column
main_EvenColumn subroutine    
    ldy #0
    ldx #0
.first_loop
    sty main_tmp
    lda (main_arg),y
    tay
    lda prgdata_metatiles,y
    sta shr_tileBuffer,x
    inx
    lda prgdata_metatiles+512,y
    sta shr_tileBuffer,x
    inx
    ldy main_tmp
    iny
    cpx #TOP_HEIGHT
    bne .first_loop
    
    ADDI_D main_arg, main_arg, TOP_HEIGHT/2
    
    ldy #0
    ldx #0
.third_loop
    sty main_tmp
    lda (main_arg),y
    tay
    lda prgdata_metatiles,y
    sta shr_tileBuffer+TOP_HEIGHT,x
    inx
    lda prgdata_metatiles+512,y
    sta shr_tileBuffer+TOP_HEIGHT,x
    inx
    ldy main_tmp
    iny
    cpx #BOTTOM_HEIGHT
    bne .third_loop
    
    lda main_arg+2
    sta shr_tileCol
    rts
;------------------------------------------------------------------------------
;arg 0..1 -> rom address
;arg 2 -> nametable column
; 20 top 30 bottom, x2 right and left
main_OddColumn subroutine    
    ldy #0
    ldx #0
.second_loop
    sty main_tmp
    lda (main_arg),y
    tay
    lda prgdata_metatiles+256,y
    sta shr_tileBuffer,x
    inx
    lda prgdata_metatiles+768,y
    sta shr_tileBuffer,x
    inx
    ldy main_tmp
    iny
    cpx #TOP_HEIGHT
    bne .second_loop  
    
    ADDI_D main_arg, main_arg, TOP_HEIGHT/2
    
    ldy #0
    ldx #0
.fourth_loop
    sty main_tmp
    lda (main_arg),y
    tay
    lda prgdata_metatiles+256,y
    sta shr_tileBuffer+TOP_HEIGHT,x
    inx
    lda prgdata_metatiles+768,y
    sta shr_tileBuffer+TOP_HEIGHT,x
    inx
    ldy main_tmp
    iny
    cpx #BOTTOM_HEIGHT
    bne .fourth_loop 
    lda main_arg+2
    sta shr_tileCol
    
    rts
;------------------------------------------------------------------------------
main_ColorColumn subroutine
    ldy #0
    ldx #0
.loop:
    cpx #TOP_ATTR_HEIGHT
    bne .no_partial
    dey
.no_partial:
    sty main_tmp
    
    lda (main_arg),y
    tay
    lda prgdata_metatiles+256*4,y
    and #%00000011
    sta main_tmp+1
    
    
    ldy main_tmp
    iny
    sty main_tmp
    
    lda (main_arg),y
    tay
    lda prgdata_metatiles+256*4,y
    and #%00000011
    REPEAT 4
    asl
    REPEND
    ora main_tmp+1
    sta main_tmp+1
    
    
    lda main_tmp
    clc
    adc #MT_MAP_HEIGHT-1
    tay
    sty main_tmp
    
    lda (main_arg),y
    tay
    lda prgdata_metatiles+256*4,y
    and #%00000011
    REPEAT 2
    asl
    REPEND
    ora main_tmp+1
    sta main_tmp+1
    
    
    ldy main_tmp
    iny
    sty main_tmp
    
    lda (main_arg),y
    tay
    lda prgdata_metatiles+256*4,y
    and #%00000011
    REPEAT 6
    asl
    REPEND
    ora main_tmp+1
    
    ;lda #%10101010
    sta shr_attrBuffer,x
    inx
    
    lda main_tmp
    sec
    sbc #MT_MAP_HEIGHT-1
    tay
    
    cpx #TOP_ATTR_HEIGHT+BOTTOM_ATTR_HEIGHT
    bne .loop
    rts
;------------------------------------------------------------------------------
;arg 0..1 -> rom address
;arg 2 -> nametable column
main_EvenColorColumn subroutine
    rts
;------------------------------------------------------------------------------
;arg 0..1 -> rom address
;arg 2 -> nametable column
; 20 top 30 bottom, x2 right and left
main_OddColorColumn subroutine
    rts
;------------------------------------------------------------------------------
; Reads controller
; Out: A=buttons pressed, where bit 0 is A button
read_joy subroutine
   ;; Strobe controller
   lda #1
   sta $4016
   lda #0
   sta $4016
    
   ;; Read all 8 buttons
   ldx #8
.loop:
   pha
    
   ;; Read next button state and mask off low 2 bits.
   ;; Compare with $01, which will set carry flag if
   ;; either or both bits are set.
   lda $4016
   and #$03
   cmp #$01
    
   ;; Now, rotate the carry flag into the top of A,
   ;; land shift all the other buttons to the right
   pla
   ror
    
   dex
   bne .loop
    
   rts
