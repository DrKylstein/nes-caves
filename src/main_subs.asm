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
    jsr main_MultiplyBy24 ;uses only arg 0..1, keeping ret value for later
    ADDI_D main_arg, main_ret, main_levelMap
    
    lda shr_cameraX
    and #$10
    bne .unaligned
    SUBI_D main_arg, main_arg, [1*MT_MAP_HEIGHT]
    jsr main_ColorColumn
    inc shr_doAttrCol
    rts
.unaligned:
    jsr main_ColorWrappedColumn
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
    clc
    adc #7
    and #7
    sta main_arg+2
    
    ;get map index
    MOV_D main_arg, main_tmp
    jsr main_MultiplyBy24 ;uses only arg 0..1
    ADDI_D main_arg, main_ret, main_levelMap
    
    lda shr_cameraX
    and #$10
    bne .unaligned
    ;ADDI_D main_arg, main_arg, [3*MT_MAP_HEIGHT]
    jsr main_ColorColumn
    inc shr_doAttrCol
    rts
.unaligned:
    ADDI_D main_arg, main_arg, [15*MT_MAP_HEIGHT]
    jsr main_ColorWrappedColumn
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
main_GetTile ;arg0..1 = mt_x arg2..3 = mt_y ret0 = value
    jsr main_MultiplyBy24 ;takes arg0, which we no longer care about after this
                          ;returns
    ;t0 = y+ x*24
    ADD_D main_tmp, main_arg+2, main_ret
    
    ;lookup tile, get behavior
    ADDI_D main_tmp, main_tmp, main_levelMap
    ldy #0
    lda (main_tmp),y
    sta main_ret
    rts
;------------------------------------------------------------------------------
main_SetTile ;arg0..1 = mt_x arg2..3 = mt_y, arg4 = value
    jsr main_MultiplyBy24
    ADDI_D main_ret, main_ret, main_levelMap
    ADD_D main_tmp, main_arg+2, main_ret
    lda main_arg+4
    ldy #0
    sta (main_tmp),y ;store updated tile into map
    
    ;update nametables
    lda shr_doTile
    beq .noWait
    jsr synchronize
.noWait:
    lda main_arg+4
    sta shr_tileMeta ;store tile for nametable update
    MOVI_D shr_tileAddr, [$2000+TOP_OFFSET]
    lda main_arg+2
    cmp #9
    bcc .upperTable
    MOVI_D shr_tileAddr, $2800
    SUBI_D main_arg+2, main_arg+2, 9
.upperTable:
    
    REPEAT 6
    ASL_D main_arg+2
    REPEND
    ADD_D shr_tileAddr, shr_tileAddr, main_arg+2
    
    ASL_D main_arg
    lda main_arg
    and #31
    clc
    adc shr_tileAddr
    sta shr_tileAddr
    lda #0
    adc shr_tileAddr+1
    sta shr_tileAddr+1
    
    inc shr_doTile
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
;for revealing aligned columns - subtract 1 for moving viewport right
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
;for revealing unaligned columns - add 15 for moving viewport left
main_ColorWrappedColumn subroutine
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
    
    
    ldy main_tmp
    dey
    sty main_tmp
    
    SUBI_D main_tmp+2, main_arg, [15*MT_MAP_HEIGHT]
    
    lda (main_tmp+2),y
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
    
    lda (main_tmp+2),y
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
    
    ldy main_tmp
    iny
    
    cpx #TOP_ATTR_HEIGHT+BOTTOM_ATTR_HEIGHT
    bne .loop
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
;------------------------------------------------------------------------------
main_AddScore subroutine ; main_arg 3 bytes value to add, A and X trashed
    ldx #0
.loop:
    lda main_arg,x
    clc
    adc shr_score,x
    cmp #100
    bcc .foo
    sbc #100
    inc shr_score+1,x
.foo
    sta shr_score,x
    inx
    cpx #3
    bne .loop
    rts
main_AddScore_end: