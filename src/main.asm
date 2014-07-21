;------------------------------------------------------------------------------
; MAIN THREAD
;------------------------------------------------------------------------------
reset subroutine
    sei        ;; ignore IRQs
    cld        ;; disable decimal mode
    ldx #$40
    stx $4017  ;; disable APU frame IRQ
    ldx #$ff
    txs        ;; Set up stack
    inx        ;; now X = 0
    stx PPU_CTRL  ;; disable NMI
    stx PPU_MASK  ;; disable rendering
    stx $4010  ;; disable DMC IRQs
 
    ;; Optional (omitted):
    ;; Set up mapper and jmp to further init code here.
 
    ;; Clear the vblank flag, so we know that we are waiting for the
    ;; start of a vertical blank and not powering on with the
    ;; vblank flag spuriously set
    bit PPU_STATUS
 
    ;; First of two waits for vertical blank to make sure that the
    ;; PPU has stabilized
.vblankwait1: 
    bit PPU_STATUS
    bpl .vblankwait1
 
    ;; We now have about 30,000 cycles to burn before the PPU stabilizes.
    ;; One thing we can do with this time is put RAM in a known state.
    ;; Here we fill it with $00, which matches what (say) a C compiler
    ;; expects for BSS.  Conveniently, X is still 0.
    txa
.clrmem:
    sta $000,x
    sta $100,x
    sta $300,x
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x  ;; Remove this if you're storing reset-persistent data
  
    inx
    bne .clrmem
 
.init_oam:
    lda #$FF
    ldy #0
.oam_loop:
    dey
    sta shr_oamShadow,y
    bne .oam_loop
 
    ;; Other things you can do between vblank waits are set up audio
    ;; or set up other mapper registers.
    lda #$DE
    sta shr_debugReg+1
    lda #$AD
    sta shr_debugReg
    
.vblankwait2:
    bit PPU_STATUS
    bpl .vblankwait2
;end reset subroutine

;load name tables
    ldy #$A0
    bit PPU_STATUS
    lda #$20
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR
.clear_upper
    sta PPU_DATA
    dey
    bne .clear_upper

    ldy #$00
    bit PPU_STATUS
    lda #$20
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR
.load_hud
    lda prgdata_hud,y
    sta PPU_DATA
    iny
    cpy #$80
    bne .load_hud

    bit PPU_STATUS
    lda #$23
    sta PPU_ADDR
    lda #$C0
    sta PPU_ADDR
.load_hud_attr
    lda prgdata_hud,y
    sta PPU_DATA
    iny
    cpy #$88
    bne .load_hud_attr
    
    jsr main_InitialLevelLoad

    ;set sprite 0 for status bar
    lda #22
    sta shr_spriteY
    lda #254
    sta shr_spriteX
    lda #$FE
    sta shr_spriteIndex
    
load_rest subroutine
    lda #%10110000 ;enable nmi
    sta shr_ppuCtrl
    sta PPU_CTRL
    
    lda #32
    sta shr_vramBuffer_length
    lda #$3F
    sta shr_vramBuffer_ppuHigh
    lda #$01
    sta shr_vramBuffer_ppuLow
    lda #%00000000 ;use rom, +1 increment
    sta shr_vramBuffer_flags
    lda #<prgdata_palettes
    sta shr_vramBuffer_romAddr
    lda #>prgdata_palettes
    sta shr_vramBuffer_romAddr+1
    lda #0
    sta shr_vramBuffer_romAddr+2
    inc shr_doVramCopy
    
    ldy #4 ;oam index
    lda #0
    sta shr_spriteFlags,y
    sta shr_spriteFlags+4,y
    lda #48
    sta main_playerX
    tax
    lda #48
    sta main_playerY
    jsr main_SetSpritePos
    lda #0 ;first tile index
    jsr main_SetSpriteTiles

    inc shr_doDma

	lda #96
	sta shr_cameraYMod
    lda #<[PX_MT_HEIGHT*MT_MAP_HEIGHT]
    sta main_camMetaTileX
    lda #>[PX_MT_HEIGHT*MT_MAP_HEIGHT]
    sta main_camMetaTileX+1


    lda #%00011000
    sta shr_ppuMask

    inc main_playerMoved

main_loop subroutine
    jsr read_joy
    sta main_sav
    
.down:
    and #JOY_A_MASK
    BNE_L up
    CMPI_D main_playerY, [[MT_MAP_HEIGHT-2]*PX_MT_HEIGHT]
    BEQ_L up
    
    ;t0 = y in tiles
    MOV_D main_tmp, main_playerY
    REPEAT 4
    LSR_D main_tmp
    REPEND
    INC_D main_tmp; get tile at feet
    
    ;a0 = x in tiles
    ADDI_D main_arg, main_playerX, 8
    REPEAT 4
    LSR_D main_arg
    REPEND
    
    jsr main_MultiplyBy24

    MOV_D shr_debugReg, main_ret

    ;t0 = y + x*24
    ADD_D main_tmp, main_tmp, main_ret
    
    ;lookup tile, get behavior
    ADDI_D main_tmp, main_tmp, prgdata_mainMap
    ldy #0
    lda (main_tmp),y
    tay
    lda prgdata_metatiles+256*4,y
    REPEAT 2
    lsr
    REPEND
    cmp #TB_SOLID
    beq up
    cmp #TB_PLATFORM
    beq up

    INC_D main_playerY
    inc main_playerMoved
up:
    lda main_sav
    and #JOY_A_MASK
    beq .left
    lda main_playerY
    ora main_playerY+1
    beq .left
    DEC_D main_playerY
    inc main_playerMoved
.left:
    lda main_sav
    and #%01000000
    beq .right
    lda main_playerX
    ora main_playerX+1
    beq .right
    DEC_D main_playerX
    inc main_playerMoved
.right:
    lda main_sav
    and #%10000000
    beq .checkMoved
    CMPI_D main_playerX, [[MT_MAP_WIDTH-1]*PX_MT_WIDTH]
    beq .checkMoved
    INC_D main_playerX
    inc main_playerMoved
    
.checkMoved:
    lda main_playerMoved
    BEQ_L no_move

    SUB_D main_sav, main_playerX, shr_cameraX
    lda main_sav
    cmp #[MT_HSCROLL_MARGIN*PX_MT_WIDTH]
    bcs .noLeftScroll
    lda shr_cameraX
    ora shr_cameraX+1
    beq .noLeftScroll
    DEC_D shr_cameraX
    inc main_sav
    lda shr_cameraX
    and #7
    bne .noLeftScroll
    jsr main_LoadTilesOnMoveLeft
.noLeftScroll:
    lda main_sav
    cmp #[[MT_VIEWPORT_WIDTH - MT_HSCROLL_MARGIN]*PX_MT_WIDTH]
    bcc .noRightScroll
    CMPI_D shr_cameraX, [[MT_MAP_WIDTH - MT_VIEWPORT_WIDTH]*PX_MT_WIDTH]
    bcs .noRightScroll
    INC_D shr_cameraX
    dec main_sav
    lda shr_cameraX
    and #7 ; 8-pixel boundaries
    cmp #1
    bne .noRightScroll
    jsr main_LoadTilesOnMoveRight
.noRightScroll
    lda main_sav
    clc
    adc #8 ;saving this for call to SetSpritePos
    tax

    SUB_D main_sav, main_playerY, shr_cameraY
    lda main_sav
    cmp #[MT_VSCROLL_MARGIN*PX_MT_HEIGHT]
    bcs .noUpScroll
    lda shr_cameraY
    ora shr_cameraY+1
    beq .noUpScroll
    DEC_D shr_cameraY
	dec shr_cameraYMod
	lda shr_cameraYMod
	cmp #$FF
	bne .noModUp
	lda #239
	sta shr_cameraYMod
	lda #2
	eor shr_nameTable
	sta shr_nameTable
.noModUp
    inc main_sav
.noUpScroll:
    lda main_sav
    cmp #[[MT_VIEWPORT_HEIGHT - MT_VSCROLL_MARGIN]*PX_MT_HEIGHT]
    bcc .noDownScroll
    CMPI_D shr_cameraY, [[MT_MAP_HEIGHT - MT_VIEWPORT_HEIGHT]*PX_MT_HEIGHT]
    bcs .noDownScroll
    INC_D shr_cameraY
    inc shr_cameraYMod
    lda shr_cameraYMod
    cmp #240
    bne .noModDown
    lda #0
    sta shr_cameraYMod
	lda #2
	eor shr_nameTable
	sta shr_nameTable
.noModDown:
    dec main_sav
.noDownScroll
    lda main_sav
    adc #31
    ldy #4
    jsr main_SetSpritePos

    lda main_playerFrame
    clc
    adc #1
    cmp #3*4
    bne .notLooped
    lda #0
.notLooped
    sta main_playerFrame
    and #%11111100
    jsr main_SetSpriteTiles
    ;jsr main_FlipSprite
    lda #0
    sta main_playerMoved
    inc shr_doDma
    inc shr_doRegCopy
    jsr synchronize
no_move
    jmp main_loop

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
    ADDI_D main_tmp, main_tmp, 1
    LSR_D main_tmp
    ADDI_D main_tmp, main_tmp, 15
    MOV_D main_arg, main_tmp
    jsr main_MultiplyBy24 ;uses only arg 0..1
    ;keeping ret value for later
        
    lda #<prgdata_mainMap
    sta main_arg
    lda #>prgdata_mainMap
    sta main_arg+1
    
    ADD_D main_arg, main_arg, main_ret
    
    lda shr_cameraX
    and #%00001000
    beq .odd
    jsr main_EvenColumn
    jmp .return
.odd:
    jsr main_OddColumn
.return:
    inc shr_doVramCopy
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
    ADDI_D main_tmp, main_tmp, 1
    LSR_D main_tmp
    SUBI_D main_tmp, main_tmp, 1
    MOV_D main_arg, main_tmp
    jsr main_MultiplyBy24 ;uses only arg 0..1
    ;keeping ret value for later
        
    lda #<prgdata_mainMap
    sta main_arg
    lda #>prgdata_mainMap
    sta main_arg+1
    
    ADD_D main_arg, main_arg, main_ret
    
    lda shr_cameraX
    and #%00001000
    beq .odd
    jsr main_EvenColumn
    jmp .return
.odd:
    jsr main_OddColumn
.return:
    inc shr_doVramCopy
    rts
;------------------------------------------------------------------------------


    include main_subs.asm
