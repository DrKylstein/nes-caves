;------------------------------------------------------------------------------
main_GetTileBehavior ;arg0..1 = mt_x arg2..3 = mt_y ret0 = value
    jsr main_MultiplyBy24 ;takes arg0, which we no longer care about after this
                          ;returns
    ;t0 = y+ x*24
    ADD_D main_tmp, main_arg+2, main_ret
    
    ;lookup tile, get behavior
    ADDI_D main_tmp, main_tmp, prgdata_mainMap
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
    lda #<prgdata_mainMap
    sta main_sav
    lda #>prgdata_mainMap
    sta main_sav+1
    ldy #0
.loop:
    ;args to buffer column    
    lda main_sav
    sta main_arg
    lda main_sav+1
    sta main_arg+1
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
    
    ;terribly unsafe, by code duplication is worse
    jsr nmi_CopyTileCol
    
    pla
    tay
    
    lda main_sav
    sta main_arg
    lda main_sav+1
    sta main_arg+1
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
    
    ;ditto (irony!)
    jsr nmi_CopyTileCol
    
    pla
    tay
    
    iny
    ADDI_D main_sav, main_sav, 23
    cpy #16
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
