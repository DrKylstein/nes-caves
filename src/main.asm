;------------------------------------------------------------------------------
; MAIN THREAD
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
;Initial Boot
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
 
 
init_apu subroutine
    lda #$0F
    sta $4015
    ldy #0
.loop:  
    lda .regs,y
    sta $4000,y
    iny
    cpy #$18
    bne .loop
    MOVI_D nmi_sfxPtr, prgdata_nullSound
    jmp init_apu_end
.regs:
    .byte $30,$08,$00,$00
    .byte $30,$08,$00,$00
    .byte $80,$00,$00,$00
    .byte $30,$00,$00,$00
    .byte $00,$00,$00,$00
    .byte $00,$0F,$00,$40
init_apu_end:

main_clearOAM subroutine
    lda #$FF
    ldy #0
.loop:
    dey
    sta shr_oamShadow,y
    bne .loop
main_clearOAM_end:
main_clearEntities subroutine
    ldy #MAX_ENTITIES
    lda #$7F
.loop:
    dey
    sta main_entityXLo,y
    sta main_entityXHi,y
    sta main_entityYLo,y
    sta main_entityYHi,y
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
    
    ;set sprite 0 for status bar
    lda #22
    sta shr_spriteY
    lda #206
    sta shr_spriteX
    lda #$FE
    sta shr_spriteIndex
    
    MOVI_D shr_palAddr, prgdata_palettes
    lda #SPRITE_PAL
    sta shr_palDest
    inc shr_doPalCopy
    inc shr_earlyExit
    lda #%10110000 ;enable nmi
    sta PPU_CTRL
    jsr synchronize
    lda #0
    sta PPU_CTRL
    dec shr_earlyExit
;------------------------------------------------------------------------------
;New Game
;------------------------------------------------------------------------------
    lda #5
    sta shr_ammo
    
    MOVI_D main_arg, prgdata_mainMap
;------------------------------------------------------------------------------
;Start of Level
;------------------------------------------------------------------------------
main_EnterLevel:
main_DisableDisplay subroutine
    lda #%00000000 ;disable nmi
    sta shr_ppuCtrl
    sta PPU_CTRL
    sta shr_ppuMask
    sta PPU_MASK
main_DisableDisplay_end:

main_ResetStats subroutine
    lda #3
    sta shr_hp
    lda #MAX_ENTITIES
    sta main_currPlatform
    lda #0
    sta main_paused
main_ResetStats_end:

    ADDI_D shr_palAddr, main_arg, PAL_OFFSET
    lda #BG_PAL
    sta shr_palDest
    inc shr_doPalCopy


main_LoadLevel subroutine
    MOV_D main_tmp+2, main_arg
    MOVI_D main_tmp, main_levelMap
    ldy #0
    ldx #4
.loop:
    lda (main_tmp+2),y
    sta (main_tmp),y
    iny
    bne .loop
    ADDI_D main_tmp+2, main_tmp+2, 256
    ADDI_D main_tmp, main_tmp, 256
    dex
    bne .loop
    
    ADDI_D main_tmp+2, main_arg, 960
    MOVI_D main_tmp, main_entityBlock
    ldy #0
.copyEntities:
    lda (main_tmp+2),y
    sta (main_tmp),y
    iny
    cpy #[main_entityBlockEnd-main_entityBlock]
    bne .copyEntities
        
    ADDI_D main_tmp+2, main_arg, 1040
    ldy #0
    ldx #1
    lda #0
    sta main_playerYFrac
.loadCoords:
    lda (main_tmp+2),y
    sta main_playerYFrac,x
    inx
    iny
    cpy #20
    bne .loadCoords
main_LoadLevel_end:

main_InitNametables subroutine
    MOV_D main_arg, shr_cameraX
    REPEAT 4
    LSR_D main_arg
    REPEND
    jsr main_MultiplyBy24
    MOVI_D main_sav, main_levelMap
    ADD_D main_sav, main_sav, main_ret
    ldy #0
    MOV_D main_sav+2, shr_cameraX
    REPEAT 3
    LSR_D main_sav+2
    REPEND
        
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
    clc
    adc main_sav+2
    and #$1F
    sta main_arg+2
    tya
    pha
    jsr main_EvenColumn
    jsr nmi_CopyTileCol     ;terribly unsafe
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
    adc main_sav+2
    and #$1F
    sta main_arg+2
    tya
    pha
    jsr main_OddColumn
    jsr nmi_CopyTileCol     ;ditto
    pla
    tay
    
    iny
    ADDI_D main_sav, main_sav, 23
    cpy #16
    bne .loop
main_InitNametables_end:

main_InitAttributes subroutine
    ldy #0
    MOVI_D main_arg, main_levelMap
.loop:
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
    bne .loop
main_InitAttributes_end:

main_ReenableDisplay subroutine
    lda #%10110000 ;enable nmi
    sta shr_ppuCtrl
    sta PPU_CTRL
    lda #%00011000
    sta shr_ppuMask
main_ReenableDisplay_end:

;------------------------------------------------------------------------------
;Every Frame
;------------------------------------------------------------------------------
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
.start:
    lda main_pressed
    and #JOY_START_MASK
    beq .foo
    lda #1
    eor main_paused
    sta main_paused
.foo    
    lda main_paused
    beq .left
    lda main_pressed
    and #JOY_SELECT_MASK
    beq main_CheckInput
    jmp main_doExit
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
    MOVI_D main_playerYVel, JUMP_VELOCITY
    lda main_playerFlags
    ora #%10000000
    sta main_playerFlags
    MOVI_D shr_sfxPtr, prgdata_jumpSound
    inc shr_doSfx
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
    cmp #TB_POINTS
    bcc .ammo
    cmp #TB_POINTS+8
    bcs .ammo
    sec
    sbc #TB_POINTS
    asl
    asl
    tax
    lda prgdata_points+1,x
    sta main_arg+2
    lda prgdata_points+2,x
    sta main_arg+1
    lda prgdata_points+3,x
    sta main_arg
    cpx #0
    bne .notCrystal
    dec main_crystalsLeft
.notCrystal:
    jsr main_AddScore
    MOVI_D shr_sfxPtr, prgdata_crystalSound
    inc shr_doSfx
    
    lda #0
    sta main_sav
    jmp .updateTile
.ammo:
    cmp #TB_AMMO
    bne .exit
    MOVI_D shr_sfxPtr, prgdata_crystalSound
    inc shr_doSfx
    lda shr_ammo
    clc
    adc #5
    sta shr_ammo
    lda #0
    sta main_sav
    jmp .updateTile
.exit:
    cmp #TB_EXIT
    bne .not_exit
    lda main_crystalsLeft
    bne .not_exit
main_doExit:
    MOVI_D main_arg, prgdata_mainMap
    MOV_D main_playerX, main_mapPX
    MOV_D main_playerY, main_mapPY
    MOV_D shr_cameraX, main_mapCamX
    MOV_D shr_cameraY, main_mapCamY
    lda main_mapCamYMod
    sta shr_cameraYMod
    CMPI_D shr_cameraY, 240
    lda #0
    bcc .nt0
    lda #8
.nt0:
    sta shr_nameTable
    jmp main_EnterLevel
.not_exit:
    cmp #TB_MAPDOOR+16
    bcc .maybe_door
    jmp .not_door
.maybe_door:
    cmp #TB_MAPDOOR-1
    bcs .still_maybe_door
    jmp .not_door
.still_maybe_door:
    sec
    sbc #TB_MAPDOOR
    sta main_currLevel
    asl
    tay
    lda prgdata_levelTable,y
    sta main_arg
    lda prgdata_levelTable+1,y
    sta main_arg+1
    MOV_D main_mapPX, main_playerX
    MOV_D main_mapPY, main_playerY
    MOV_D main_mapCamX, shr_cameraX
    MOV_D main_mapCamY, shr_cameraY
    lda shr_cameraYMod
    sta main_mapCamYMod
    jmp main_EnterLevel
.not_door:
    lda #JOY_B_MASK
    and main_pressed
    BEQ_L main_TileInteraction_end
    lda main_sav+3
    
    cmp #TB_LOCK+3
    bcs .switch
    cmp #TB_LOCK
    bcc .switch
    
    sec
    sbc #TB_LOCK
    tay
    lda main_doorsLo,y
    sta main_tmp
    lda main_doorsHi,y
    sta main_tmp+1
    ADDI_D main_tmp, main_tmp, main_levelMap
    MOV_D shr_debugReg, main_tmp
    ldy #0
    lda #0
    sta (main_tmp),y
    iny
    sta (main_tmp),y
    
    ldy main_sav
    iny
    tya
    sta main_sav
    jmp .updateTile
.switch:
    cmp #TB_ON
    bcc .not_switchon
    sec
    sbc #TB_ON
    tax
    ldy main_switchable,x
    lda #0
    sta main_entityXVel,y
    ldx main_sav
    dex
    txa
    sta main_sav
    jmp .updateTile
.not_switchon:
    cmp #TB_OFF
    bcc .shoot
    sec
    sbc #TB_OFF
    tax
    ldy main_switchable,x
    lda #1
    sta main_entityXVel,y
    ldx main_sav
    inx
    txa
    sta main_sav
    jmp .updateTile
.shoot:
    lda main_entityXHi
    cmp #$7F
    bne main_TileInteraction_end
    ;lda shr_ammo
    ;beq main_TileInteraction_end
    ;dec shr_ammo
    lda main_playerX
    sta main_entityXLo
    lda main_playerX+1
    sta main_entityXHi
    lda main_playerY
    sta main_entityYLo
    lda main_playerY+1
    and #ENT_YPOS
    ;ora #ENT_ISPROJECTILE
    sta main_entityYHi
    
    MOVI_D shr_sfxPtr, prgdata_crystalSound
    inc shr_doSfx
    
    bit main_playerFlags
    bvs .shootLeft
.shootRight:
    lda #2
    sta main_entityXVel
    clc
    lda #8
    adc main_entityXLo
    sta main_entityXLo
    lda #0
    adc main_entityXHi
    sta main_entityXHi
    
    jmp main_TileInteraction_end
.shootLeft:
    lda #<-2
    sta main_entityXVel
    sec
    lda main_entityXLo
    sbc #8
    sta main_entityXLo
    lda main_entityXHi
    sbc #0
    sta main_entityXHi
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
    ADDI_D main_playerYVel, main_playerYVel, GRAVITY
main_ApplyGravity_end:


main_CheckLeft subroutine
    ;skip if not moving left (>= 0)
    lda main_playerXVel
    cmp #0
    bpl main_CheckLeft_end

    CMPI_D main_playerX, 1
    bcc .hit
    
    ;main_arg = x in tiles
    MOV_D main_arg, main_playerX
    REPEAT 4
    LSR_D main_arg
    REPEND
    ;main_arg+2 = y in tiles
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

    CMPI_D main_playerX, [MT_MAP_WIDTH*PX_MT_WIDTH - 16]
    bcs .hit

    ;main_arg = x in tiles
    MOV_D main_arg, main_playerX
    REPEAT 4
    LSR_D main_arg
    REPEND
    INC_D main_arg
    ;main_arg+2 = y in tiles
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
    cmp #TB_EXIT
    bne main_CheckRight_end
    lda main_crystalsLeft
    beq main_CheckRight_end
.hit:
    MOVI main_playerXVel, 0
main_CheckRight_end:

main_CheckGround subroutine
    ;skip if not moving down (< 0)
    CMPI_D main_playerYVel, 0
    BMI_L main_CheckGround_end

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
    beq .hitGroundTile
    cmp #TB_PLATFORM
    beq .hitGroundTile
    cmp #TB_WEAKBLOCK
    beq .hitGroundTile
    
    jmp .checkSpriteHit
.hitGroundTile:
    lda #$F0
    and main_playerY
    sta main_playerY
    jmp .hit_ground

.checkSpriteHit:
    ldy #MAX_ENTITIES
    sty main_currPlatform
.loop:
    dey
    BMI_L main_CheckGround_end
    
    lda main_entityYHi,y
    lsr
    tax
    lda prgdata_entityFlags,x
    and #ENT_ISPLATFORM
    beq .loop
    
    lda main_entityXLo,y
    sta main_tmp
    lda main_entityXHi,y
    sta main_tmp+1
    
    ADDI_D main_tmp+2, main_playerX, 4
    SUBI_D main_tmp, main_tmp, 8
    CMP_D main_tmp, main_tmp+2
    bpl .loop
    
    SUBI_D main_tmp+2, main_playerX, 4
    ADDI_D main_tmp, main_tmp, 16
    CMP_D main_tmp, main_tmp+2
    bmi .loop
    
    lda main_entityYLo,y
    sta main_tmp
    lda main_entityYHi,y
    and #ENT_YPOS
    sta main_tmp+1
    
    SUBI_D main_tmp+2, main_playerY, 16
    CMP_D main_tmp, main_tmp+2
    bmi .longLoop

    SUBI_D main_tmp, main_tmp, 17
    CMP_D main_tmp, main_playerY
    bpl .longLoop
    
    jmp .hitSprite
.longLoop:
    jmp .loop
.hitSprite:
    
    ADDI_D main_playerY, main_tmp, 1
    sty main_currPlatform
.hit_ground: ;stop if moving down
    MOVI_D main_playerYVel, 0
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
    
main_CheckHurt subroutine
    lda main_mercyTime
    beq .findEnemy
    dec main_mercyTime
    jmp main_CheckHurt_end
.findEnemy:
    ldy #MAX_ENTITIES
.loop:
    dey
    BMI_L main_CheckHurt_end
    
    lda main_entityYHi,y
    lsr
    tax
    lda prgdata_entityFlags,x
    and #ENT_ISDEADLY
    beq .loop
    
    lda main_entityXLo,y
    sta main_tmp
    lda main_entityXHi,y
    sta main_tmp+1
    
    ADDI_D main_tmp+2, main_playerX, 4
    SUBI_D main_tmp, main_tmp, 8
    CMP_D main_tmp, main_tmp+2
    bpl .loop
    
    SUBI_D main_tmp+2, main_playerX, 4
    ADDI_D main_tmp, main_tmp, 16
    CMP_D main_tmp, main_tmp+2
    bmi .loop
    
    lda main_entityYLo,y
    sta main_tmp
    lda main_entityYHi,y
    and #ENT_YPOS
    sta main_tmp+1
    
    SUBI_D main_tmp+2, main_playerY, 16
    CMP_D main_tmp, main_tmp+2
    bmi .longLoop

    SUBI_D main_tmp, main_tmp, 17
    CMP_D main_tmp, main_playerY
    bpl .longLoop
    
    lda shr_hp
    bne .hurt
    lda main_currLevel
    asl
    tay
    lda prgdata_levelTable,y
    sta main_arg
    lda prgdata_levelTable+1,y
    sta main_arg+1
    jmp main_EnterLevel
.hurt:
    dec shr_hp
    lda #120
    sta main_mercyTime
    jmp main_CheckHurt_end
.longLoop:
    jmp .loop
main_CheckHurt_end:

main_ApplyVelocity subroutine
    MOV_D main_tmp, main_playerYVel
    ldy main_currPlatform
    cpy #MAX_ENTITIES
    beq .noLift
    
    lda main_entityYHi,y
    lsr
    tax
    lda prgdata_entityFlags,x
    sta main_sav
    
    lda main_sav
    and #ENT_ISVERTICAL
    beq .noLift
    lda main_entityXVel,y
    clc
    adc main_tmp+1
    ;sta main_tmp+1
.noLift:    
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
    ldy main_currPlatform
    cpy #MAX_ENTITIES
    beq .noTrolley
    lda main_sav
    and #ENT_ISVERTICAL
    bne .noTrolley
    lda main_tmp
    adc main_entityXVel,y
    sta main_tmp
.noTrolley:
    lda main_tmp
    cmp #0
    bmi .negativeX
    lda #0
    jmp .continueX
.negativeX:
    lda #$FF
.continueX:
    sta main_tmp+1
    
    ADD_D main_playerX, main_playerX, main_tmp
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
    CMPI_D shr_cameraX, [[MT_MAP_WIDTH - MT_VIEWPORT_WIDTH]*PX_MT_WIDTH - 8]
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
    SUB_D main_sav, main_playerY, shr_cameraY
    ;no scrolling because player not near screen edge
    lda main_sav ;player's on-screen y
    cmp #[MT_VSCROLL_MARGIN*PX_MT_HEIGHT]
    bcs .Scroll_Up_end
    
    ;no scrolling becuse screen is at map edge
    lda shr_cameraY
    ora shr_cameraY+1
    beq .Scroll_Up_end
    
    lda #[MT_VSCROLL_MARGIN*PX_MT_HEIGHT]
    sec
    sbc main_sav
    sta main_tmp
    lda #0
    sta main_tmp+1
    SUB_D shr_cameraY, shr_cameraY, main_tmp
    
    ;handle nametable boundary
    lda shr_cameraYMod
    cmp main_tmp
    bcs .noModUp
    clc
    adc #240
    sta shr_cameraYMod
	lda #8
	eor shr_nameTable
	sta shr_nameTable
.noModUp:

	lda shr_cameraYMod
    sec
	sbc main_tmp
    sta shr_cameraYMod
.Scroll_Up_end:
    
.Scroll_Down:
    ;no scrolling because player not near screen edge
    SUB_D main_sav, main_playerY, shr_cameraY
    lda main_sav
    cmp #[[MT_VIEWPORT_HEIGHT - MT_VSCROLL_MARGIN]*PX_MT_HEIGHT]
    bcc .Scroll_Down_end
    
    ;no scrolling becuse screen is at map edge
    CMPI_D shr_cameraY, [[MT_MAP_HEIGHT - MT_VIEWPORT_HEIGHT]*PX_MT_HEIGHT]
    bcs .Scroll_Down_end
    
    ;scroll down one pixel
    lda main_sav ;player's on-screen y
    sec
    sbc #[[MT_VIEWPORT_HEIGHT - MT_VSCROLL_MARGIN]*PX_MT_HEIGHT]
    sta main_tmp
    lda #0
    sta main_tmp+1
    ADD_D shr_cameraY, shr_cameraY, main_tmp
    lda shr_cameraYMod
    clc
    adc main_tmp
    sta shr_cameraYMod
    
    ;handle nametable boundary
    cmp #240
    bcc .Scroll_Down_end
    sec
    sbc #240
    sta shr_cameraYMod
	lda #8
	eor shr_nameTable
	sta shr_nameTable
.Scroll_Down_end:
main_UpdateCameraY_end:

main_UpdatePlayerSprite subroutine
    lda main_mercyTime
    beq .visible
    lda shr_frame
    and #1
    beq .visible
    lda #$FF
    sta shr_spriteY+OAM_SIZE
    sta shr_spriteY+OAM_SIZE+OAM_SIZE
    jmp main_UpdatePlayerSprite_end
.visible:
    ;update position
    SUB_D main_sav, main_playerX, shr_cameraX
    lda main_sav
    clc
    adc #8
    tax
    SUB_D main_sav, main_playerY, shr_cameraY
    lda main_sav
    clc
    adc #31
    ldy #OAM_SIZE
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
    sta shr_spriteFlags+OAM_SIZE
    sta shr_spriteFlags+OAM_SIZE+OAM_SIZE
    bit main_playerFlags
    bvs .left
.right:
    lda main_playerFrame
    and #%11111100
    sta shr_spriteIndex+OAM_SIZE
    clc
    adc #2
    sta shr_spriteIndex+OAM_SIZE+OAM_SIZE
    jmp main_UpdatePlayerSprite_end
.left:
    lda main_playerFrame
    and #%11111100
    sta shr_spriteIndex+OAM_SIZE+OAM_SIZE
    clc
    adc #2
    sta shr_spriteIndex+OAM_SIZE
main_UpdatePlayerSprite_end:

main_updateEntities subroutine
    ldy #[MAX_ENTITIES-1]
.loop:
    lda main_entityXHi,y
    cmp #$7F
    bne .active
    jmp .inactive
.active:   
    ;calculate map tile
    lda main_entityXLo,y
    sta main_arg
    lda main_entityXHi,y
    sta main_arg+1
    lda main_entityXVel,y
    bmi .shift
    lda main_entityYHi,y
    and #ENT_YPOS
    bne .shift
    ADDI_D main_arg, main_arg, 15
.shift:
    REPEAT 4
    LSR_D main_arg
    REPEND
    lda main_arg
    sta main_sav+1
    lda main_entityYLo,y
    sta main_arg+2
    lda main_entityYHi,y
    and #ENT_YPOS
    sta main_arg+3
    
    lda main_entityYHi,y
    lsr
    tax
    lda prgdata_entityFlags,x
    sta main_sav+4
    
    ;lda main_sav
    and #ENT_ISVERTICAL
    beq .shiftY
    lda main_sav+4
    and #ENT_ISPLATFORM
    beq .notPlatform
    lda main_entityXVel,y
    bpl .notPlatform
    SUBI_D main_arg+2, main_arg+2, 15
    
.notPlatform
    lda main_entityXVel,y
    bmi .shiftY
    ADDI_D main_arg+2, main_arg+2, 15
.shiftY:
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
    tya
    pha
    ldy #0
    lda (main_tmp),y
    sta main_sav
    tay
    lda prgdata_metatiles+256*4,y
    REPEAT 2
    lsr
    REPEND
    sta main_sav+3
    pla
    tay
    
    ;react to map tile
    lda main_sav+4
    and #ENT_ISPROJECTILE
    beq .checkObstacle
    
.checkImpact:
    lda main_sav+3
    cmp #TB_SOLID
    beq .die
    cmp #TB_WEAKBLOCK
    bne .checkOffScreen
    lda main_sav+1
    sta main_arg
    lda main_sav+2
    sta main_arg+2
    lda #0
    sta main_arg+1
    sta main_arg+3
    lda #0
    sta main_arg+4
    tya
    pha
    jsr main_SetTile
    pla
    tay
    jmp .die
.checkOffScreen:
    sec
    lda main_entityXLo,y
    sbc shr_cameraX
    sta main_tmp
    lda main_entityXHi,y
    sbc shr_cameraX+1
    sta main_tmp+1
    CMPI_D main_tmp, #$FF
    bcs .die
    CMPI_D main_tmp, #$0
    bcs .updateVel
.die:
    lda #$7F
    sta main_entityXHi,y
    jmp .inactive


.checkObstacle:
    lda main_sav+3
    cmp #TB_SOLID
    beq .reverse
    cmp #TB_WEAKBLOCK
    bne .updateVel
.reverse:
    sec
    lda #0
    sbc main_entityXVel,y
    sta main_entityXVel,y
    
.updateVel:
    lda main_entityXHi,y
    sta main_tmp+1
    lda main_entityXLo,y
    sta main_tmp
    lda main_sav+4
    and #ENT_ISVERTICAL
    beq .horizontal
    
    lda main_entityYHi,y
    and #ENT_YPOS
    sta main_tmp+1
    lda main_entityYLo,y
    sta main_tmp
.horizontal:

    lda main_entityXVel,y
    sta main_tmp+2
    bmi .negative
    lda #0
    sta main_tmp+3
    jmp .continue
.negative:
    lda #$FF
    sta main_tmp+3
.continue:
    ADD_D main_tmp, main_tmp, main_tmp+2
    lda main_sav+4
    and #ENT_ISVERTICAL
    bne .vertical
    lda main_tmp
    sta main_entityXLo,y
    lda main_tmp+1
    sta main_entityXHi,y
    jmp .inactive
.vertical:
    lda main_tmp
    sta main_entityYLo,y
    lda main_entityYHi,y
    and #ENT_FLAGS
    ora main_tmp+1 ; just assuming that calculated y will never be out of bounds
    sta main_entityYHi,y
.inactive:
    dey
    bmi main_updateEntities_end
    jmp .loop
main_updateEntities_end:

main_UpdateEntitySprites subroutine
    ldy #[shr_entitySprites-shr_oamShadow]
    ldx #[MAX_ENTITIES-1]
.loop:
    lda main_entityYHi,x
    stx main_tmp
    lsr
    tax
    lda prgdata_entityFlags,x
    ldx main_tmp
    sta main_tmp
    
    and #ENT_COLOR
    lsr
    sta shr_spriteFlags,y
    sta shr_spriteFlags+OAM_SIZE,y

    lda main_tmp
    and #ENT_ISFACING
    beq .noFacing
    lda main_entityXVel,x
    bpl .noFacing
    lda main_tmp
    and #ENT_ISVERTICAL
    bne .vflip
    lda #$40
    ora shr_spriteFlags,y
    sta shr_spriteFlags,y
    sta shr_spriteFlags+OAM_SIZE,y
    jmp .noFacing
.vflip:
    lda #$80
    ora shr_spriteFlags,y
    sta shr_spriteFlags,y
    sta shr_spriteFlags+OAM_SIZE,y
    
.noFacing:
    lda main_entityYHi,x
    stx main_tmp
    lsr
    tax
    lda prgdata_entityTiles,x
    ldx main_tmp
    sta main_tmp
    lda shr_frame
    asl
    and #12
    clc
    adc main_tmp
    sta shr_spriteIndex,y
    clc
    adc #2
    sta shr_spriteIndex+OAM_SIZE,y


    sec
    lda main_entityXLo,x
    sbc shr_cameraX
    sta main_tmp
    lda main_entityXHi,x
    sbc shr_cameraX+1
    sta main_tmp+1
    
    lda #$FF
    sta shr_spriteX,y
    sta shr_spriteX+OAM_SIZE,y
    sta shr_spriteY,y
    sta shr_spriteY+OAM_SIZE,y
    
    ;move origin to center
    ADDI_D main_tmp, main_tmp, 8

    
    CMPI_D main_tmp, $FF
    bcs .out_of_range
    lda main_tmp
    sta shr_spriteX,y

    ;move to pos of next sprite half
    clc
    lda main_tmp
    adc #8
    sta main_tmp;ADDI_D main_tmp, main_tmp, 8
    
    CMPI_D main_tmp, $FF
    bcs .out_of_range
    lda main_tmp
    sta shr_spriteX+OAM_SIZE,y
    
    sec
    lda main_entityYLo,x
    sbc shr_cameraY
    sta main_tmp
    lda main_entityYHi,x
    and #$1 ;remove flags
    sbc shr_cameraY+1
    sta main_tmp+1
    ADDI_D main_tmp, main_tmp, 31
    CMPI_D main_tmp, 240
    bcs .out_of_range
    CMPI_D main_tmp, 3*8
    bcc .out_of_range
    lda main_tmp
    sta shr_spriteY,y
    sta shr_spriteY+OAM_SIZE,y
        
.out_of_range:

    tya
    clc
    adc #[OAM_SIZE*2]
    tay
    dex
    bmi main_UpdateEntitySprites_end
    jmp .loop
main_UpdateEntitySprites_end

    inc shr_doDma
    inc shr_doRegCopy
    jsr synchronize
    jmp main_loop

    include main_subs.asm
