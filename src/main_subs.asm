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
    sta main_scratch
    lda shr_spriteIndex+4,y
    sta shr_spriteIndex,y
    lda main_scratch
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
    jsr main_LoadBuffer
    lda #0
    sta shr_vramBuffer
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
    jsr main_LoadBuffer
    lda #0
    sta shr_vramBuffer
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
TOP_HEIGHT = 18
BOTTOM_HEIGHT = 30
TOP_OFFSET = $180
main_EvenColumn subroutine
    lda #%10000100 ;use ram, use +32 increment
    sta shr_vramBuffer_flags    
    sta shr_vramBuffer_flags+TOP_HEIGHT+4  
    lda #0 
    sta shr_vramBuffer+TOP_HEIGHT+4+BOTTOM_HEIGHT+4
    
    lda #TOP_HEIGHT
    sta shr_vramBuffer_length
    lda #>[$2000+TOP_OFFSET]
    sta shr_vramBuffer_ppuHigh    
    lda main_arg+2
    clc
    adc #<[$2000+TOP_OFFSET]
    sta shr_vramBuffer_ppuLow
    
    lda #BOTTOM_HEIGHT
    sta shr_vramBuffer_length+TOP_HEIGHT+4
    lda #$28
    sta shr_vramBuffer_ppuHigh+TOP_HEIGHT+4
    lda main_arg+2
    sta shr_vramBuffer_ppuLow+TOP_HEIGHT+4
    
    ldy #0
    ldx #0
.first_loop
    sty main_tmp
    lda (main_arg),y
    tay
    lda prgdata_metatiles,y
    sta shr_vramBuffer_data,x
    inx
    lda prgdata_metatiles+512,y
    sta shr_vramBuffer_data,x
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
    sta shr_vramBuffer_data+TOP_HEIGHT+4,x
    inx
    lda prgdata_metatiles+512,y
    sta shr_vramBuffer_data+TOP_HEIGHT+4,x
    inx
    ldy main_tmp
    iny
    cpx #BOTTOM_HEIGHT
    bne .third_loop
    rts
;------------------------------------------------------------------------------
;arg 0..1 -> rom address
;arg 2 -> nametable column
; 20 top 30 bottom, x2 right and left
main_OddColumn subroutine
    lda #%10000100 ;use ram, use +32 increment
    sta shr_vramBuffer_flags    
    sta shr_vramBuffer_flags+TOP_HEIGHT+4  
    lda #0 
    sta shr_vramBuffer+TOP_HEIGHT+4+BOTTOM_HEIGHT+4
    
    lda #TOP_HEIGHT
    sta shr_vramBuffer_length
    lda #>[$2000+TOP_OFFSET]
    sta shr_vramBuffer_ppuHigh    
    lda main_arg+2
    clc
    adc #<[$2000+TOP_OFFSET]
    sta shr_vramBuffer_ppuLow
    
    lda #BOTTOM_HEIGHT
    sta shr_vramBuffer_length+TOP_HEIGHT+4
    lda #$28
    sta shr_vramBuffer_ppuHigh+TOP_HEIGHT+4
    lda main_arg+2
    sta shr_vramBuffer_ppuLow+TOP_HEIGHT+4
    
    ldy #0
    ldx #0
.second_loop
    sty main_tmp
    lda (main_arg),y
    tay
    lda prgdata_metatiles+256,y
    sta shr_vramBuffer_data,x
    inx
    lda prgdata_metatiles+768,y
    sta shr_vramBuffer_data,x
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
    sta shr_vramBuffer_data+TOP_HEIGHT+4,x
    inx
    lda prgdata_metatiles+768,y
    sta shr_vramBuffer_data+TOP_HEIGHT+4,x
    inx
    ldy main_tmp
    iny
    cpx #BOTTOM_HEIGHT
    bne .fourth_loop 
    rts
;------------------------------------------------------------------------------
;equivalent to nmi routine    
main_LoadBuffer subroutine
    lda main_sav
    pha
    ldy #0
.while_requests:
    lda shr_vramBuffer,y
    beq .return
    ;length
    sta main_sav
    ;increment
    iny
    lda shr_vramBuffer,y
    sta main_tmp
    and #%00000100
    ora shr_ppuCtrl
    sta PPU_CTRL
    ;ppu address
    bit PPU_STATUS
    REPEAT 2
    iny
    lda shr_vramBuffer,y
    sta PPU_ADDR
    REPEND
    ;flags
    lda main_tmp
    bmi .from_ram
.from_rom:
    iny
    lda shr_vramBuffer,y
    sta main_src
    iny
    lda shr_vramBuffer,y
    sta main_src+1
    iny
    tya ;preserve y in x
    tax ;-
    ldy #0
.foreach_rombyte:
    lda (main_src),y
    sta PPU_DATA
    iny
    cpy main_sav
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
    sta PPU_DATA
    iny
    inx
    cpx main_sav
    bne .foreach_rambyte
;end foreach_rambyte
    jmp .while_requests
.return
    pla
    sta main_sav
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
