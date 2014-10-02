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
 
main_clearOAM subroutine
    lda #$FF
    ldy #0
.loop:
    dey
    sta shr_oamShadow,y
    bne .loop
main_clearOAM_end:
main_clearEntities subroutine
    lda #MAX_ENTITIES
    asl
    tay
    lda #$7F
.loop:
    dey
    sta main_entityX,y
    sta main_entityY,y
    bne .loop
main_clearEntities_end:
 
 
    ;; Other things you can do between vblank waits are set up audio
    ;; or set up other mapper registers.
    
    MOVI_D shr_debugReg, $DEAD
    
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
    
    MOVI_D main_arg, prgdata_level01
    jsr main_LoadLevel
    
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
    
    MOVI_D shr_palAddr, [prgdata_palettes+32]
    inc shr_doPalCopy
    
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

    lda #%00011000
    sta shr_ppuMask

main_loop:
main_CheckInput subroutine
    lda main_ctrl
    sta main_oldCtrl
    jsr read_joy
    sta main_ctrl
    and main_oldCtrl
    eor main_ctrl
    sta main_pressed
    
    MOVI main_playerXVel, 0
.left:
    lda main_ctrl
    and #JOY_LEFT_MASK
    beq .left_end
    lda #<-1
    sta main_playerXVel
    lda main_playerFlags
    ora #%01000000
    sta main_playerFlags
.left_end:
.right:
    lda main_ctrl
    and #JOY_RIGHT_MASK
    beq .right_end
    lda #1
    sta main_playerXVel
    lda main_playerFlags
    and #%10111111
    sta main_playerFlags
.right_end:
.jump:
    lda main_ctrl
    and #JOY_A_MASK
    beq main_CheckInput_end
    bit main_playerFlags
    bmi main_CheckInput_end
    MOVI_D main_playerYVel, -$0270
    lda main_playerFlags
    ora #%10000000
    sta main_playerFlags
main_CheckInput_end:

main_TileInteraction subroutine
    ;a0 = x in tiles
    ADDI_D main_arg, main_playerX, 7
    REPEAT 4
    LSR_D main_arg
    REPEND
    lda main_arg
    sta main_sav+1
    ;a2 = y in tiles
    ADDI_D main_arg+2, main_playerY, 7
    REPEAT 4
    LSR_D main_arg+2
    REPEND
    lda main_arg+2
    sta main_sav+2
    
    jsr main_MultiplyBy24 ;takes arg0, which we no longer care about after this
                          ;returns
    ;t0 = y+ x*24
    ADD_D main_tmp, main_arg+2, main_ret
    
    ;lookup tile, get behavior
    ADDI_D main_tmp, main_tmp, main_levelMap
    ldy #0
    lda (main_tmp),y
    sta main_sav
    tay
    lda prgdata_metatiles+256*4,y
    REPEAT 2
    lsr
    REPEND
    sta main_sav+3
    cmp #TB_CRYSTAL
    bne .not_crystal
    lda #0
    sta main_sav
    jmp .updateTile
.not_crystal:
    lda #JOY_B_MASK
    and main_pressed
    BEQ_L main_TileInteraction_end
    lda main_sav+3
    cmp #TB_LIGHTSON
    bne .not_lighton
    MOVI_D shr_palAddr, prgdata_palettes
    inc shr_doPalCopy
    lda #38
    sta main_sav
    jmp .updateTile
.not_lighton:
    cmp #TB_LIGHTSOFF
    bne .not_lightoff
   MOVI_D shr_palAddr, [prgdata_palettes+32]
    inc shr_doPalCopy
    lda #37
    sta main_sav
    jmp .updateTile
.not_lightoff:
    cmp #TB_ON
    bcc .not_switchon
    ldx main_sav
    dex
    txa
    sta main_sav
    jmp .updateTile
.not_switchon:
    cmp #TB_OFF
    bcc .notswitchoff
    ldx main_sav
    inx
    txa
    sta main_sav
    jmp .updateTile
.notswitchoff:
    MOV_D main_entityX, main_playerX
    MOV_D main_entityY, main_playerY
    jmp main_TileInteraction_end
.updateTile:
    lda main_sav+1
    sta main_arg
    lda main_sav+2
    sta main_arg+2
    lda #0
    sta main_arg+1
    sta main_arg+3
    lda main_sav
    sta main_arg+4
    jsr main_SetTile
main_TileInteraction_end:

main_ApplyGravity subroutine
    CMPI_D main_playerYVel, $0400
    bpl main_ApplyGravity_end
    ADDI_D main_playerYVel, main_playerYVel, 16
main_ApplyGravity_end:


main_CheckLeft subroutine
    ;skip if not moving left (>= 0)
    lda main_playerXVel
    cmp #0
    bpl main_CheckLeft_end

    ;skip if not hit a wall
    ;a0 = x in tiles
    MOV_D main_arg, main_playerX
    REPEAT 4
    LSR_D main_arg
    REPEND
    ;t0 = y in tiles
    ADDI_D main_arg+2, main_playerY, 7
    REPEAT 4
    LSR_D main_arg+2
    REPEND
    
    jsr main_GetTileBehavior
    lda main_ret
    cmp #TB_SOLID
    beq .hit
    cmp #TB_WEAKBLOCK
    beq .hit
    jmp main_CheckLeft_end
.hit:
    MOVI main_playerXVel, 0
main_CheckLeft_end:

main_CheckRight subroutine
    ;skip if not moving right (<= 0)
    lda main_playerXVel
    cmp #0
    bmi main_CheckRight_end
    beq main_CheckRight_end

    ;skip if not hit a wall
    ;a0 = x in tiles
    MOV_D main_arg, main_playerX
    REPEAT 4
    LSR_D main_arg
    REPEND
    INC_D main_arg
    ;t0 = y in tiles
    ADDI_D main_arg+2, main_playerY, 7
    REPEAT 4
    LSR_D main_arg+2
    REPEND
    
    jsr main_GetTileBehavior
    lda main_ret
    cmp #TB_SOLID
    beq .hit
    cmp #TB_WEAKBLOCK
    beq .hit
    jmp main_CheckRight_end
.hit:
    MOVI main_playerXVel, 0
main_CheckRight_end:

main_CheckGround subroutine
    ;skip if not moving down (< 0)
    CMPI_D main_playerYVel, 0
    bmi main_CheckGround_end

    lda main_playerFlags
    ora #%10000000
    sta main_playerFlags

    ;a0 = x in tiles
    ADDI_D main_arg, main_playerX, 8
    REPEAT 4
    LSR_D main_arg
    REPEND
    ;t0 = y in tiles
    MOV_D main_arg+2, main_playerY
    REPEAT 4
    LSR_D main_arg+2
    REPEND
    INC_D main_arg+2; get tile at feet
    
    jsr main_GetTileBehavior
    lda main_ret
    cmp #TB_SOLID
    beq .hit_ground
    cmp #TB_PLATFORM
    beq .hit_ground
    cmp #TB_WEAKBLOCK
    beq .hit_ground
    jmp main_CheckGround_end
    
.hit_ground: ;stop if moving down

    MOVI_D main_playerYVel, 0
    lda #$F0
    and main_playerY
    sta main_playerY
    lda #0
    sta main_playerYFrac
    lda main_playerFlags
    and #%01111111
    sta main_playerFlags
main_CheckGround_end:

main_CheckCieling subroutine

    ;skip if not moving up (>= 0)
    CMPI_D main_playerYVel, 0
    bpl main_CheckCieling_end

    ;hit head on top of screen
    CMPI_D main_playerY, 8
    bcc .hit_cieling
    
    ;a0 = x in tiles
    ADDI_D main_arg, main_playerX, 8
    REPEAT 4
    LSR_D main_arg
    REPEND
    ;t0 = y in tiles
    SUBI_D main_arg+2, main_playerY, 1
    REPEAT 4
    LSR_D main_arg+2
    REPEND
    
    jsr main_GetTileBehavior
    lda main_ret
    cmp #TB_SOLID
    beq  .hit_cieling
    cmp #TB_WEAKBLOCK
    beq  .hit_cieling
    jmp main_CheckCieling_end
    
.hit_cieling:
    MOVI_D main_playerYVel, 0

main_CheckCieling_end:
    
main_ApplyVelocity subroutine
    ;ADD_16_24 main_playerYFrac, main_playerYVel, main_playerYFrac
    MOV_D main_tmp, main_playerYVel
    lda main_playerYVel+1
    bmi .negativeY
    lda #0
    jmp .continueY
.negativeY:
    lda #$FF
.continueY:
    sta main_tmp+2
    
    ADD_24 main_playerYFrac, main_tmp, main_playerYFrac
    
    
    lda main_playerXVel
    sta main_tmp
    bmi .negativeX
    lda #0
    jmp .continueX
.negativeX:
    lda #$FF
.continueX:
    sta main_tmp+1
    
    ADD_D main_playerX, main_tmp, main_playerX
main_ApplyVelocity_end:

main_UpdateCameraX subroutine
.Scroll_Left:
    ;no scrolling because player is not close to screen edge
    SUB_D main_sav, main_playerX, shr_cameraX
    lda main_sav ;player's on-screen x
    cmp #[MT_HSCROLL_MARGIN*PX_MT_WIDTH]
    bcs .Scroll_Left_end
    
    ;no scrolling because screen is at map edge
    lda shr_cameraX
    ora shr_cameraX+1
    beq .Scroll_Left_end
    
    ;scroll left one pixel
    DEC_D shr_cameraX
    inc main_sav
    
    ;no loading tiles if not at tile boundary
    lda shr_cameraX
    and #7
    bne .Scroll_Left_end
    
    jsr main_LoadTilesOnMoveLeft
    
    ;no loading attributes if not at attributes boundary
    lda shr_cameraX
    and #15
    bne .Scroll_Left_end
    
    jsr main_LoadColorsOnMoveLeft
.Scroll_Left_end:

.Scroll_Right:
    ;no scrolling right because player not near screen edge
    lda main_sav ;player's on-screen x
    cmp #[[MT_VIEWPORT_WIDTH - MT_HSCROLL_MARGIN]*PX_MT_WIDTH]
    bcc .Scroll_Right_end
    
    ;no scrolling becuse screen is at map edge
    CMPI_D shr_cameraX, [[MT_MAP_WIDTH - MT_VIEWPORT_WIDTH]*PX_MT_WIDTH]
    bcs .Scroll_Right_end
    
    ;scroll right 1 pixel
    INC_D shr_cameraX
    dec main_sav
    
    ;no loading tiles if not at tile boundary
    lda shr_cameraX
    and #7 ; 8-pixel boundaries
    cmp #1
    bne .Scroll_Right_end
    
    jsr main_LoadTilesOnMoveRight
    
    ;no loading tiles if not at tile boundary
    lda shr_cameraX
    and #15 ; 16-pixel boundaries
    cmp #1
    bne .Scroll_Right_end

    jsr main_LoadColorsOnMoveRight
.Scroll_Right_end:
main_UpdateCameraX_end:

main_UpdateCameraY subroutine
.Scroll_Up:
    ;no scrolling because player not near screen edge
    SUB_D main_sav, main_playerY, shr_cameraY
    lda main_sav ;player's on-screen y
    cmp #[MT_VSCROLL_MARGIN*PX_MT_HEIGHT]
    bcs .Scroll_Up_end
    
    ;no scrolling becuse screen is at map edge
    lda shr_cameraY
    ora shr_cameraY+1
    beq .Scroll_Up_end
    
    ;scroll up one pixel
    DEC_D shr_cameraY
	dec shr_cameraYMod
    ;handle nametable boundary
	lda shr_cameraYMod
	cmp #$FF
	bne .noModUp
	lda #239
	sta shr_cameraYMod
	lda #2
	eor shr_nameTable
	sta shr_nameTable
.noModUp:
    inc main_sav
.Scroll_Up_end:
    
.Scroll_Down:
    ;no scrolling because player not near screen edge
    lda main_sav ;player's on-screen y
    cmp #[[MT_VIEWPORT_HEIGHT - MT_VSCROLL_MARGIN]*PX_MT_HEIGHT]
    bcc .Scroll_Down_end
    
    ;no scrolling becuse screen is at map edge
    CMPI_D shr_cameraY, [[MT_MAP_HEIGHT - MT_VIEWPORT_HEIGHT]*PX_MT_HEIGHT]
    bcs .Scroll_Down_end
    
    ;scroll down one pixel
    INC_D shr_cameraY
    inc shr_cameraYMod
    ;handle nametable boundary
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
.Scroll_Down_end:
main_UpdateCameraY_end:

main_UpdatePlayerSprite subroutine
    ;update position
    SUB_D main_sav, main_playerX, shr_cameraX
    lda main_sav
    clc
    adc #8
    tax
    SUB_D main_sav, main_playerY, shr_cameraY
    lda main_sav
    adc #30
    ldy #4
    jsr main_SetSpritePos

    ;update tiles
    lda main_playerFrame
    clc
    adc main_playerXVel
    and #%00011111
    sta main_playerFrame

.jump_anim:
    bit main_playerFlags
    bpl .walk_anim
    lda #8
    sta main_playerFrame
    jmp .do_anim

.walk_anim:
    lda #0
    cmp main_playerXVel
    bne .do_anim
    sta main_playerFrame

.do_anim:
    lda main_playerFlags
    and #%01000000
    ldy #4
    sta shr_spriteFlags,y
    sta shr_spriteFlags+4,y
    bit main_playerFlags
    bvs .left
.right:
    lda main_playerFrame
    and #%11111100
    sta shr_spriteIndex,y
    clc
    adc #2
    sta shr_spriteIndex+4,y
    jmp main_UpdatePlayerSprite_end
.left:
    lda main_playerFrame
    and #%11111100
    sta shr_spriteIndex+4,y
    clc
    adc #2
    sta shr_spriteIndex,y
main_UpdatePlayerSprite_end:

main_updateEntities subroutine
    ldy #MAX_ENTITIES
.loop:
    dey
    tya
    asl
    tay
    lda main_entityX,y
    sta main_tmp
    lda main_entityX+1,y
    sta main_tmp+1
    CMPI_D main_tmp, $7F7F
    beq .inactive
    INC_D main_tmp
    lda main_tmp
    sta main_entityX,y
    lda main_tmp+1
    sta main_entityX+1,y
.inactive:
    tya
    lsr
    tay
    bne .loop
main_updateEntities_end:

main_UpdateEntitySprites subroutine
    ldy #[shr_entitySprites-shr_oamShadow]
    ldx #0
.loop:
    tya

    lda #0
    sta shr_spriteFlags,y
    sta shr_spriteFlags+OAM_SIZE,y

    lda #64
    sta shr_spriteIndex,y
    clc
    adc #2
    sta shr_spriteIndex+OAM_SIZE,y

    txa
    asl
    tax

    sec
    lda main_entityX,x
    sbc shr_cameraX
    sta main_tmp
    lda main_entityX+1,x
    sbc shr_cameraX+1
    sta main_tmp+1
    DEC_D main_tmp
    
    lda #$FF
    sta shr_spriteX,y
    sta shr_spriteX+OAM_SIZE,y
    sta shr_spriteY,y
    sta shr_spriteY+OAM_SIZE,y
    
    CMPI_D main_tmp, $FF
    bcs .out_of_range
    lda main_tmp
    sta shr_spriteX,y

    ADDI_D main_tmp, main_tmp, 8
    
    CMPI_D main_tmp, $FF
    bcs .out_of_range
    lda main_tmp
    sta shr_spriteX+OAM_SIZE,y
    
    sec
    lda main_entityY,x
    sbc shr_cameraY
    sta main_tmp
    lda main_entityY+1,x
    sbc shr_cameraY+1
    sta main_tmp+1
    ADDI_D main_tmp, main_tmp, 29
    CMPI_D main_tmp, 240
    bcs .out_of_range
    CMPI_D main_tmp, 3*8
    bcc .out_of_range
    lda main_tmp
    sta shr_spriteY,y
    sta shr_spriteY+OAM_SIZE,y
    
.out_of_range:

    
    txa
    lsr
    tax
    
    inx
    tya
    clc
    adc #8
    tay
    cpy #MAX_ENTITIES*2
    bcs main_UpdateEntitySprites_end
    jmp .loop
main_UpdateEntitySprites_end

    inc shr_doDma
    inc shr_doRegCopy
    jsr synchronize
    jmp main_loop

    include main_subs.asm
