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

    ; lda #10
    ; sta main_arg
    ; bit PPU_STATUS
    ; lda #$21
    ; sta PPU_ADDR
    ; lda #$40
    ; sta PPU_ADDR
    ; lda #<prgdata_mainMap
    ; sta main_src
    ; lda #>prgdata_mainMap
    ; sta main_src+1
    
    jsr main_InitialLevelLoad

    ; lda #15
    ; sta main_arg
    ; bit PPU_STATUS
    ; lda #$28
    ; sta PPU_ADDR
    ; lda #$00
    ; sta PPU_ADDR
    ; lda #<[prgdata_mainMap+40*10]
    ; sta main_src
    ; lda #>[prgdata_mainMap+40*10]
    ; sta main_src+1
    ; jsr main_LoadNametable

    ;set sprite 0 for status bar
    lda #22
    sta shr_spriteY
    lda #254
    sta shr_spriteX
    lda #$FE
    sta shr_spriteIndex



    ;load attribute tables
    lda #%00000000
    sta PPU_CTRL
    lda #6
    sta main_arg
    bit PPU_STATUS
    lda #$23
    sta PPU_ADDR
    lda #$D0
    sta PPU_ADDR 
    lda #<[prgdata_mainMap-40]
    sta main_src
    lda #>[prgdata_mainMap-40]
    sta main_src+1
    jsr main_LoadAttributeTable
    
    lda #8
    sta main_arg
    bit PPU_STATUS
    lda #$2B
    sta PPU_ADDR
    lda #$C0
    sta PPU_ADDR
    lda #<[prgdata_mainMap+40*10]
    sta main_src
    lda #>[prgdata_mainMap+40*10]
    sta main_src+1
    jsr main_LoadAttributeTable
    
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

	lda #80
	sta shr_cameraYMod
    lda #<384
    sta main_camMetaTileX
    lda #>384
    sta main_camMetaTileX+1


    lda #%00011000
    sta shr_ppuMask

    inc main_playerMoved

main_loop subroutine
    jsr read_joy
    sta main_scratch
    
.down:
    and #%00100000
    beq .up
    INC_D main_playerY
    inc main_playerMoved
.up:
    lda main_scratch
    and #%00010000
    beq .left
    DEC_D main_playerY
    inc main_playerMoved
.left:
    lda main_scratch
    and #%01000000
    beq .right
    DEC_D main_playerX
    inc main_playerMoved
.right:
    lda main_scratch
    and #%10000000
    beq .checkMoved
    INC_D main_playerX
    inc main_playerMoved
    
.checkMoved:
    lda main_playerMoved
    LRB bne, no_move

    SUB_D main_src, main_playerX, shr_cameraX
    lda main_src
    cmp #64
    bcs .noLeftScroll
    lda shr_cameraX
    ora shr_cameraX+1
    beq .noLeftScroll
    DEC_D shr_cameraX
    inc main_src
.noLeftScroll:
    lda main_src
    cmp #[240-64]
    BCC_L noRightScroll
    CMPI_D shr_cameraX, [640-240]
    BCS_L noRightScroll
    INC_D shr_cameraX
    dec main_src
    lda shr_cameraX
    and #7 ; 8-pixel boundaries
    BNE_L noRightScroll
    
    ;get tile column on screen
    lda shr_cameraX
    sta main_tmp
    lda shr_cameraX+1
    sta main_tmp+1
    REPEAT 3
    lsr main_tmp+1
    ror main_tmp
    REPEND
    lda main_tmp
    and #31
    clc
    adc #31
    and #31
    sta main_arg+2
        
    lda #<prgdata_mainMap
    sta main_arg
    lda #>prgdata_mainMap
    sta main_arg+1
    
    lda shr_cameraX
    and #15
    beq .noMTAdvance
    ADDI_D main_camMetaTileX, main_camMetaTileX, 24
.noMTAdvance:
    
    ADD_D main_arg, main_arg, main_camMetaTileX
    
    lda shr_cameraX
    and #%00001000
    beq .rightOdd
    jsr main_EvenColumn
    jmp .rightDone
.rightOdd:
    jsr main_OddColumn
.rightDone:
    inc shr_doVramCopy
noRightScroll
    lda main_src
    sec
    sbc #8
    tax

    SUB_D main_src, main_playerY, shr_cameraY
    lda main_src
    cmp #48
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
    inc main_src
.noUpScroll:
    lda main_src
    cmp #[[240-32]-48]
    bcc .noDownScroll
    CMPI_D shr_cameraY, [400-[240-32]]
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
    dec main_src
.noDownScroll
    lda main_src
    adc #32
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

    include main_subs.asm
