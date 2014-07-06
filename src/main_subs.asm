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
; main_src contains address of row in level, 
; PPUADDR already set to destination,
; main_arg is number of rows
; modifies A, Y, main_scratchBuffer, main_scratch
main_LoadAttributeTable subroutine
    ldy #0
.outer_loop:
    tya
    pha
    
    ldx #0 ; indexes attribute bytes
.buffer_loop:
    ;x = 0..8 (attribute bytes across) -> y = 0..16 (metatiles across)
    ;we store 2 metatiles across of info each loop
    txa
    asl
    tay

    ;save metatile index
    pha
    
    ;do top left
    lda (main_src),y
    tay
    lda prgdata_metatiles+1024,y
    and #%00000011 ;upper bits reserved for flags
    sta main_scratch
    
    ;recover metatile index, move right 1, save again
    pla
    tay
    iny
    tya
    pha
    
    ;do top right
    lda (main_src),y
    tay
    lda prgdata_metatiles+1024,y
    and #%00000011
    REPEAT 2
    asl
    REPEND
    ora main_scratch
    sta main_scratch
    
    ;recover metatile index move down 1 and left 1, save again
    pla
    clc
    adc #MAP_WIDTH-1
    tay
    pha
    
    ;do bottom left
    lda (main_src),y
    tay
    lda prgdata_metatiles+1024,y
    and #%00000011
    REPEAT 4
    asl
    REPEND
    ora main_scratch
    sta main_scratch
    
    ;recover metatile index, move right 1 (last item, don't need to save)
    pla
    tay
    iny
    
    ;do bottom right
    lda (main_src),y
    tay
    lda prgdata_metatiles+1024,y
    and #%00000011
    REPEAT 6
    asl
    REPEND
    ora main_scratch
    ;store final result
    sta main_scratchBuffer,x
    
    ;last attribute byte?
    inx
    cpx #8
    bne .buffer_loop
;end .buffer_loop    
    ;move cached data to ppu
    ldy #0
.copy_loop:
    lda main_scratchBuffer,y
    sta PPU_DATA
    iny
    cpy #8
    bne .copy_loop
;end .copy_loop

    pla
    tay
    lda main_src
    clc
    adc #MAP_WIDTH*2
    sta main_src
    lda main_src+1
    adc #0
    sta main_src+1
    
    iny
    cpy main_arg
    bne .outer_loop
;end .outer_loop
    rts
;------------------------------------------------------------------------------
; main_src contains address of row in level, 
; PPUADDR already set to destination,
; main_arg is number of rows
; modifies A, Y, main_scratchBuffer, main_scratch
main_LoadNametable subroutine
    ldy #0
.outer_loop:
    tya
    pha
    
    ldy #$00
.buffer_loop
    tya
    asl
    tax
    
    ;save y
    tya
    sta main_scratch
    
    ;get metatile index from level map
    lda (main_src),y
    tay
    
    ;get each corner of the metatile
    lda prgdata_metatiles,y
    sta main_scratchBuffer,x
    
    lda prgdata_metatiles+256,y
    sta main_scratchBuffer+1,x
    
    lda prgdata_metatiles+512,y
    sta main_scratchBuffer+32,x
    
    lda prgdata_metatiles+768,y
    sta main_scratchBuffer+33,x  
    
    ;restore y
    lda main_scratch
    tay
    
    iny
    cpy #16
    bne .buffer_loop
;end .buffer_loop
    ldy #0
.load_loop
    lda main_scratchBuffer,y
    sta PPU_DATA
    iny
    cpy #16*2*2
    bne .load_loop
;end .load_loop
    pla
    tay
    
    lda main_src
    clc
    adc #MAP_WIDTH
    sta main_src
    lda main_src+1
    adc #0
    sta main_src+1
    
    iny
    cpy main_arg
    bne .outer_loop

    rts
;------------------------------------------------------------------------------
main_PrepColumn subroutine
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
