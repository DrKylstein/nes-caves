;------------------------------------------------------------------------------
; MAIN THREAD
;------------------------------------------------------------------------------

;lasers should only fire if player is within y range and is onscreen

;door updates
;individual enemy hit boxes?
;enemy points table

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
 
    ;; Other things you can do between vblank waits are set up audio
    ;; or set up other mapper registers.
    
    MOVI_D shr_debugReg, $BEEF
    
.vblankwait2:
    bit PPU_STATUS
    bpl .vblankwait2
;end reset subroutine

    lda #0
    sta PPU_CTRL
    lda #0
    sta PPU_MASK

main_LoadTitlePatterns subroutine
    lda #<bank0_titleTiles
    sta main_tmp
    lda #>bank0_titleTiles
    sta main_tmp+1
    ldy #0
    lda banktable,y
    sta banktable,y
    bit PPU_STATUS
    lda #$10
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR
    ldx #16
.loop:
    lda (main_tmp),y
    sta PPU_DATA
    iny
    bne .loop
    inc main_tmp+1
    dex
    bne .loop
main_LoadTitlePatterns_end:
main_LoadTitleNames subroutine
    lda #<prgdata_titleNames
    sta main_tmp
    lda #>prgdata_titleNames
    sta main_tmp+1
    bit PPU_STATUS
    lda #$20
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR
    ldx #4
.loop:
    lda (main_tmp),y
    sta PPU_DATA
    iny
    bne .loop
    inc main_tmp+1
    dex
    bne .loop
main_LoadTitleNames_end:

main_LoadTitlePalette subroutine
    ldy #16
    bit PPU_STATUS
    lda #$3F
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR
.loop:
    lda prgdata_titlePalette,y
    sta PPU_DATA
    dey
    bpl .loop
main_LoadTitlePalette_end:

main_DoTitleScreen subroutine
    lda #0
    bit PPU_STATUS
    sta PPU_SCROLL
    sta PPU_SCROLL

    lda #%0011000
    sta PPU_CTRL
    lda #%00011110
    sta PPU_MASK
    
.waitForPress:
    jsr read_joy
    cmp #0
    beq .waitForPress
    
    lda #0
    sta PPU_CTRL
    lda #0
    sta PPU_MASK
main_DoTitleScreen_end:

main_LoadPatterns subroutine
    lda #<bank0_defaultTiles
    sta main_tmp
    lda #>bank0_defaultTiles
    sta main_tmp+1
    ldy #0
    lda banktable,y
    sta banktable,y
    bit PPU_STATUS
    sty PPU_ADDR
    sty PPU_ADDR
    ldx #32
.loop:
    lda (main_tmp),y
    sta PPU_DATA
    iny
    bne .loop
    inc main_tmp+1
    dex
    bne .loop
main_LoadPatterns_end:

main_initNametables subroutine
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
main_InitSprites subroutine
    ldy #0
.loop:
    lda #15
    sta shr_spriteY,y
    lda #206
    sta shr_spriteX,y
    lda #$FE
    sta shr_spriteIndex,y
    lda #%00100000
    sta shr_spriteFlags,y
    REPEAT OAM_SIZE
    iny
    REPEND
    cpy #8*OAM_SIZE
    bne .loop

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
    ;lda #MAP_LEVEL
    ;sta main_currLevel
    
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
    lda #4
    sta main_switches
    lda #3
    sta shr_hp
    lda #MAX_ENTITIES
    sta main_currPlatform
    lda #0
    sta main_paused
    sta shr_powerTime
    sta shr_powerTime+1
    sta main_bonusCount
    lda main_playerFlags
    and #~PLY_HASKEY
    sta main_playerFlags
    lda #CATERPILLAR_ID+1
    sta main_caterpillarNext
main_ResetStats_end:

    ADDI_D shr_palAddr, main_arg, [main_levelDataEnd-main_levelMap+main_entityBlockEnd-main_entityBlock]
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
    
    ADDI_D main_tmp+2, main_arg, [main_levelDataEnd-main_levelMap]
    MOVI_D main_tmp, main_entityBlock
    ldy #0
.copyEntities:
    lda (main_tmp+2),y
    sta (main_tmp),y
    iny
    cpy #[main_entityBlockEnd-main_entityBlock]
    bne .copyEntities
main_LoadLevel_end:

main_InitEntities subroutine
    ldy #0
.loop:
    lda main_entityYHi,y
    lsr
    tax
    lda prgdata_entitySpeeds,x
    sta main_entityXVel,y
    iny
    cpy #MAX_ENTITIES
    bne .loop
main_InitEntities_end:

main_LoadMapState subroutine
    lda main_currLevel
    bpl main_LoadMapState_end
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
main_LoadMapState_end:

main_InitNametables subroutine
    MOV_D main_arg, shr_cameraX
    REPEAT 4
    LSR_D main_arg
    REPEND
    jsr main_MultiplyBy24
    ADDI_D main_sav, main_ret, main_levelMap
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
    MOV_D main_arg, shr_cameraX
    REPEAT 4
    LSR_D main_arg
    REPEND
    jsr main_MultiplyBy24
    ADDI_D main_arg, main_ret, main_levelMap
    lda shr_cameraX
    REPEAT 5
    lsr
    REPEND
    sta main_sav+3
    ldy #0
.loop:
    tya
    clc
    adc main_sav+3
    and #7
    asl
    asl
    sta shr_tileCol
    sty main_sav+2
    jsr main_ColorColumn
    jsr nmi_CopyAttrCol
    ldy main_sav+2
    lda main_arg
    clc
    adc #MT_MAP_HEIGHT*2
    sta main_arg
    lda main_arg+1
    adc #0
    sta main_arg+1
    iny
    cpy #8
    bne .loop
main_InitAttributes_end:

    jsr main_LoadTilesOnMoveLeft

main_ReenableDisplay subroutine
    lda #%10110000 ;enable nmi
    sta shr_ppuCtrl
    sta PPU_CTRL
    lda #%00011000
    sta shr_ppuMask
    inc shr_doRegCopy
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
    ora #PLY_ISFLIPPED
    sta main_playerFlags
.left_end:
.right:
    lda main_ctrl
    and #JOY_RIGHT_MASK
    beq .right_end
    lda #1
    sta main_playerXVel
    lda main_playerFlags
    and #~PLY_ISFLIPPED
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
    and #PLY_ISUPSIDEDOWN
    beq .notUpsideDown
    MOVI_D main_playerYVel, -JUMP_VELOCITY
.notUpsideDown:
    lda main_playerFlags
    ora #PLY_ISJUMPING
    sta main_playerFlags
    lda #SFX_JUMP
    sta shr_doSfx
main_CheckInput_end:

main_TileInteraction subroutine
    lda main_playerFlags
    and #~PLY_ISBEHIND
    sta main_playerFlags

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
    lsr
    lsr
    sta main_sav+3
    asl
    tay
    lda main_TileCollision,y
    sta main_tmp
    lda main_TileCollision+1,y
    sta main_tmp+1
    jmp (main_tmp)
    
main_TileCollision:
    .word main_TC_Nop;main_TC_Empty
    .word main_TC_Nop;main_TC_Solid
    .word main_TC_Nop;main_TC_Platform
    .word main_TC_Exit
    .word main_TC_Nop;main_TC_Hazard
    .word main_TC_Nop;main_TC_Death
    .word main_TC_Nop;main_TC_LightsOn
    .word main_TC_Nop;main_TC_LightsOff
    .word main_TC_Nop;main_TC_WeakBlock
    .word main_TC_Ammo
    .word main_TC_Nop;main_TC_Strength
    .word main_TC_Powershot
    .word main_TC_Gravity
    .word main_TC_Key
    .word main_TC_Nop;main_TC_Stop
    .word main_TC_Chest
    .word main_TC_Points ;crystal
    .word main_TC_Points ;egg
    .word main_TC_Points ;800
    .word main_TC_Points ;1000
    .word main_TC_Points ;5000
    .word main_TC_Points ;bonus
    .word main_TC_Nop
    .word main_TC_Nop
    .word main_TC_Nop
    .word main_TC_Nop
    .word main_TC_Nop
    .word main_TC_Lock
    .word main_TC_Lock
    .word main_TC_Lock
    .word main_TC_Nop
    .word main_TC_Nop
    .word main_TC_Nop ;air
    .word main_TC_Foreground
    .word main_TC_Nop
    .word main_TC_Nop
    .word main_TC_Nop
    .word main_TC_Nop
    .word main_TC_Nop
    .word main_TC_Nop
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Entrance
    .word main_TC_Off
    .word main_TC_Off
    .word main_TC_Off
    .word main_TC_Off
    .word main_TC_On
    .word main_TC_On
    .word main_TC_On
    .word main_TC_On
    
main_TC_Points:
    lda main_sav+3
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
    bne .notCrystal
    inc shr_flashBg
.notCrystal:
    cpx #5<<2
    bne .notBonus
    lda #8
    clc
    adc main_bonusCount
    sta main_bonusCount
    cmp #5<<3
    bcc .notBonus
    ldx #6<<2
    lda prgdata_points+1,x
    sta main_arg+2
    lda prgdata_points+2,x
    sta main_arg+1
    lda prgdata_points+3,x
    sta main_arg
.notBonus:
    jsr main_AddScore
    lda #SFX_CRYSTAL
    sta shr_doSfx
    
    lda #0
    sta main_sav
    jmp main_TC_UpdateTile
main_TC_Points_end:

main_TC_Key:
    lda #SFX_CRYSTAL
    sta shr_doSfx
    lda main_playerFlags
    ora #PLY_HASKEY
    sta main_playerFlags
    lda #0
    sta main_sav
    jmp main_TC_UpdateTile
main_TC_Key_end:

main_TC_Chest:
    lda #PLY_HASKEY
    bit main_playerFlags
    BEQ_L main_TC_Return
    lda #SFX_CRYSTAL
    sta shr_doSfx
    
    lda #2
    sta main_arg+1
    lda #0
    sta main_arg
    sta main_arg+2
    jsr main_AddScore
    
    inc main_sav
    jmp main_TC_UpdateTile
main_TC_Chest_end:

main_TC_Ammo:
    lda #SFX_CRYSTAL
    sta shr_doSfx
    lda shr_ammo
    clc
    adc #5
    sta shr_ammo
    lda #0
    sta main_sav
    jmp main_TC_UpdateTile
main_TC_Ammo_end:

main_TC_Powershot:
    lda #SFX_CRYSTAL
    sta shr_doSfx
    lda #10
    sta shr_powerTime+1
    lda #60
    sta shr_powerTime
    lda #~PLY_ISUPSIDEDOWN
    and main_playerFlags
    sta main_playerFlags
    lda #0
    sta main_sav
    jmp main_TC_UpdateTile
main_TC_Powershot_end:

main_TC_Gravity:
    lda #SFX_CRYSTAL
    sta shr_doSfx
    lda #10
    sta shr_powerTime+1
    lda #60
    sta shr_powerTime
    lda #PLY_ISUPSIDEDOWN
    ora main_playerFlags
    sta main_playerFlags
    lda #0
    sta main_sav
    jmp main_TC_UpdateTile
main_TC_Gravity_end:

main_TC_Foreground:
    lda main_playerFlags
    ora #PLY_ISBEHIND
    sta main_playerFlags
    jmp main_TC_Return
main_TC_Foreground_end:

main_TC_Exit:
    lda main_crystalsLeft
    BNE_L main_TC_Return
    ldy main_currLevel
    cpy #16
    bcs .upperLevels
    lda prgdata_bits,y
    ora main_cleared
    sta main_cleared
    jmp main_doExit
.upperLevels:
    tya
    sec
    sbc #8
    lda prgdata_bits,y
    ora main_cleared+1
    sta main_cleared+1
main_doExit:
    lda #MAP_LEVEL
    sta main_currLevel
    MOVI_D main_arg, prgdata_mainMap
    jmp main_EnterLevel
main_TC_Exit_end:

main_TC_Entrance:
    lda main_sav+3
    sec
    sbc #TB_MAPDOOR
    cmp #16
    bcs .enterUpperLevel
    tay
    lda prgdata_bits,y
    and main_cleared
    beq .uncleared
    lda main_sav+3
    jmp main_TC_Return
.enterUpperLevel:
    sec
    sbc #8
    tay
    lda prgdata_bits,y
    and main_cleared+1
    beq .uncleared
    lda main_sav+3
    jmp main_TC_Return
.uncleared:
    lda main_sav+3
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
main_TC_Entrance_end:
    
main_TC_Lock:
    lda #JOY_B_MASK
    and main_pressed
    BEQ_L main_TC_Return
    
    lda main_sav+3
    sec
    sbc #TB_LOCK
    tay
    lda main_doorsLo,y
    sta main_tmp
    lda main_doorsHi,y
    sta main_tmp+1
    ADDI_D main_tmp, main_tmp, main_levelMap
    ldy #0
    lda #0
    sta (main_tmp),y
    iny
    sta (main_tmp),y
    inc main_sav
    jmp main_TC_UpdateTile
main_TC_Lock_end:

main_TC_On:
    lda #JOY_B_MASK
    and main_pressed
    BEQ_L main_TC_Return
    lda main_sav+3
    sec
    sbc #TB_ON
    tay
    lda prgdata_bits,y
    eor main_switches
    sta main_switches
    dec main_sav
    jmp main_TC_UpdateTile
main_TC_On_end:

main_TC_Off:
    lda #JOY_B_MASK
    and main_pressed
    BEQ_L main_TC_Return
    lda main_sav+3
    sec
    sbc #TB_OFF
    tay
    lda prgdata_bits,y
    eor main_switches
    sta main_switches
    inc main_sav
    jmp main_TC_UpdateTile
main_TC_Off_end:

    
main_TC_Return:
main_TC_Nop:
    lda #JOY_B_MASK
    and main_pressed
    BEQ_L main_TileInteraction_end
    bit main_entityXHi
    BPL_L main_TileInteraction_end
    lda shr_ammo
    BEQ_L main_TileInteraction_end
    dec shr_ammo
    lda main_playerX
    sta main_entityXLo
    lda main_playerX+1
    and #ENT_X_POS
    sta main_entityXHi
    lda main_playerY
    sta main_entityYLo
    lda main_playerY+1
    and #ENT_Y_POS
    sta main_entityYHi
    lda shr_powerTime+1
    beq .notPowerShot
    lda #PLY_ISUPSIDEDOWN
    and main_playerFlags
    bne .notPowerShot
    lda #POWERSHOT_ID<<1
    ora main_entityYHi
    sta main_entityYHi
.notPowerShot
    lda #SFX_ROCKET
    sta shr_doSfx
    
    bit main_playerFlags
    bvs .shootLeft
.shootRight:
    lda #3
    sta main_entityXVel
    clc
    lda #8
    adc main_entityXLo
    sta main_entityXLo
    lda #0
    adc main_entityXHi
    and #ENT_X_POS
    sta main_entityXHi
    
    jmp main_TileInteraction_end
.shootLeft:
    lda #<-3
    sta main_entityXVel
    lda main_entityXLo
    sec
    sbc #8
    sta main_entityXLo
    lda main_entityXHi
    sbc #0
    and #ENT_X_POS
    sta main_entityXHi
    jmp main_TileInteraction_end
    
main_TC_UpdateTile:
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
    lda main_playerFlags
    and #PLY_ISUPSIDEDOWN
    bne .reverseGravity
    CMPI_D main_playerYVel, $0400
    bpl main_ApplyGravity_end
    ADDI_D main_playerYVel, main_playerYVel, GRAVITY
    jmp main_ApplyGravity_end
.reverseGravity:
    CMPI_D main_playerYVel, -$0400
    bmi main_ApplyGravity_end
    SUBI_D main_playerYVel, main_playerYVel, GRAVITY
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
    and #PLY_ISUPSIDEDOWN
    bne .upsideDown
    lda main_playerFlags
    ora #PLY_ISJUMPING
    sta main_playerFlags
.upsideDown:

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
    bne .notPlatform
    lda main_playerY
    and #$F
    cmp #8
    bcc .hitGroundTile
    jmp .checkSpriteHit
.notPlatform:
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
    and #ENT_F_ISPLATFORM
    beq .loop
    
    lda main_entityXLo,y
    sta main_tmp
    lda main_entityXHi,y
    and #ENT_X_POS
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
    and #ENT_Y_POS
    sta main_tmp+1
    
    SUBI_D main_tmp, main_tmp, 15
    CMP_D main_tmp, main_playerY
    bmi .longLoop

    SUBI_D main_tmp, main_tmp, 2
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
    and #PLY_ISUPSIDEDOWN
    bne main_CheckGround_end
    lda main_playerFlags
    and #~PLY_ISJUMPING
    sta main_playerFlags
main_CheckGround_end:

main_CheckCieling subroutine

    ;skip if not moving up (>= 0)
    CMPI_D main_playerYVel, 0
    BPL_L main_CheckCieling_end

    lda main_playerFlags
    and #PLY_ISUPSIDEDOWN
    beq .notUpsideDown
    lda main_playerFlags
    ora #PLY_ISJUMPING
    sta main_playerFlags
.notUpsideDown:


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
    lda #0
    sta main_playerYFrac
    lda main_playerFlags
    and #PLY_ISUPSIDEDOWN
    beq main_CheckCieling_end
    lda main_playerFlags
    and #~PLY_ISJUMPING
    sta main_playerFlags
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
    
    lda main_entityXHi,y
    bmi .loop
        
    lda main_entityYHi,y
    lsr
    tax
    lda prgdata_entityFlags,x
    and #ENT_F_ISDEADLY
    beq .loop
    
    lda main_entityXHi,y
    and #ENT_X_COUNT
    beq .notHidden
    lda prgdata_entityFlags,x
    and #ENT_F_ISPROJECTILE
    beq .notHidden
    jmp .loop
.notHidden:

    
    lda main_entityXLo,y
    sta main_tmp
    lda main_entityXHi,y
    and #ENT_X_POS
    sta main_tmp+1
    
    ADDI_D main_tmp+2, main_playerX, 4
    SUBI_D main_tmp, main_tmp, 7
    CMP_D main_tmp, main_tmp+2
    bpl .loop
    
    SUBI_D main_tmp+2, main_playerX, 4
    ADDI_D main_tmp, main_tmp, 16
    CMP_D main_tmp, main_tmp+2
    bmi .loop
    
    lda main_entityYLo,y
    sta main_tmp
    lda main_entityYHi,y
    and #ENT_Y_POS
    sta main_tmp+1
    
    SUBI_D main_tmp+2, main_playerY, 15
    CMP_D main_tmp, main_tmp+2
    bmi .longLoop

    SUBI_D main_tmp, main_tmp, 15
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
    lda #60
    sta main_mercyTime
    jmp main_CheckHurt_end
.longLoop:
    jmp .loop
main_CheckHurt_end:

main_UpdatePower subroutine
    lda shr_powerTime+1
    beq main_UpdatePower_end
    dec shr_powerTime
    bne main_UpdatePower_end
    lda #60
    sta shr_powerTime
    dec shr_powerTime+1
    bne main_UpdatePower_end
    lda #~PLY_ISUPSIDEDOWN
    and main_playerFlags
    sta main_playerFlags
main_UpdatePower_end:

main_updateEntities subroutine
    ldy #[MAX_ENTITIES-1]
.loop:
    lda main_entityXHi,y
    bpl .active
    jmp .inactive
.active:   
    lda main_entityYHi,y
    lsr
    tax
    
    cpx #CATERPILLAR_ID
    bcc .noSkipHTest
    cpx #CATERPILLAR_ID+4
    bcs .noSkipHTest
    jmp .vtest
.noSkipHTest:
    
    
    lda prgdata_entityFlags,x
    and #ENT_F_ISPLATFORM
    bne .persistent
    lda main_entityXLo,y
    sec
    sbc shr_cameraX
    sta main_tmp
    lda main_entityXHi,y
    and #ENT_X_POS
    sbc shr_cameraX+1
    sta main_tmp+1
    CMPI_D main_tmp, [MT_VIEWPORT_WIDTH*PX_MT_WIDTH + PX_MT_WIDTH]
    bpl .offScreen
    CMPI_D main_tmp, -PX_MT_WIDTH
    bmi .offScreen
.vtest:
    lda main_entityYLo,y
    sec
    sbc shr_cameraY
    sta main_tmp
    lda main_entityYHi,y
    and #ENT_Y_POS
    sbc shr_cameraY+1
    sta main_tmp+1
    CMPI_D main_tmp, [MT_VIEWPORT_HEIGHT*PX_MT_HEIGHT + PX_MT_HEIGHT]
    bpl .offScreen
    CMPI_D main_tmp, -PX_MT_HEIGHT
    bmi .offScreen
    jmp .persistent
.offScreen:
    lda prgdata_entityFlags,x
    and #ENT_F_ISPROJECTILE
    beq .normal
    jmp .die
.normal:
    jmp .inactive
.persistent:

    cpx #ROCK_ID
    bne .notRock
    lda main_entityYLo,y
    sta main_tmp
    lda main_entityYHi,y
    and #ENT_Y_POS
    sta main_tmp+1
    lda main_tmp
    cmp main_playerY
    bne .notRock
    lda main_tmp+1
    cmp main_playerY+1
    bne .notRock
    lda main_entityXVel,y
    bne .notRock
    lda #2
    sta main_entityXVel,y
.notRock:


    lda prgdata_entityFlags2,x
    and #ENT_F2_ISGROUNDED
    bne .checkfloor
    jmp .hitwall
.checkfloor:
    ;calculate map tile
    lda main_entityXLo,y
    sta main_arg
    lda main_entityXHi,y
    and #ENT_X_POS
    sta main_arg+1
    
    lda main_entityXVel,y
    bmi .shift2
    ADDI_D main_arg, main_arg, 15
.shift2:
    REPEAT 4
    LSR_D main_arg
    REPEND
    jsr main_MultiplyBy24
    lda main_entityYLo,y
    sta main_tmp
    lda main_entityYHi,y
    and #ENT_Y_POS
    sta main_tmp+1
    ADDI_D main_tmp, main_tmp, 16
    REPEAT 4
    LSR_D main_tmp
    REPEND
    ADD_D main_tmp, main_tmp, main_ret
    ADDI_D main_tmp, main_tmp, main_levelMap
    sty main_tmp+2
    ldy #0
    lda (main_tmp),y
    tay
    lda prgdata_metatiles+256*4,y
    ldy main_tmp+2
    lsr
    lsr
    cmp #TB_SOLID
    beq .hitwall
    cmp #TB_PLATFORM
    beq .hitwall
    jmp .reverse


.hitwall:
    ;calculate map tile
    lda main_entityXLo,y
    sta main_arg
    lda main_entityXHi,y
    and #ENT_X_POS
    sta main_arg+1
    lda main_entityXVel,y
    bmi .shift
    ADDI_D main_arg, main_arg, 15
.shift:
    REPEAT 4
    LSR_D main_arg
    REPEND
    lda main_arg
    sta main_sav+1
    jsr main_MultiplyBy24
    
    lda main_entityYLo,y
    sta main_tmp
    lda main_entityYHi,y
    and #ENT_Y_POS
    sta main_tmp+1
    
    lda prgdata_entityFlags,x
    and #ENT_F_ISVERTICAL
    beq .shiftY
    lda prgdata_entityFlags,x
    and #ENT_F_ISPLATFORM
    beq .notPlatform
    lda main_entityXVel,y
    bpl .notPlatform
    SUBI_D main_tmp, main_tmp, 15
    
.notPlatform:
    lda main_entityXVel,y
    bmi .shiftY
    ADDI_D main_tmp, main_tmp, 15
.shiftY:
    REPEAT 4
    LSR_D main_tmp
    REPEND
    ADD_D main_tmp, main_tmp, main_ret
    ADDI_D main_tmp, main_tmp, main_levelMap
    sty main_tmp+2
    ldy #0
    lda (main_tmp),y
    sta main_sav
    tay
    lda prgdata_metatiles+256*4,y
    ldy main_tmp+2
    lsr
    lsr
    sta main_sav+3
    
    ;react to map tile
    lda prgdata_entityFlags,x
    and #ENT_F_ISPROJECTILE
    bne .checkImpact
    jmp .checkObstacle
    
.checkImpact:
    lda main_sav+3
    cmp #TB_SOLID
    beq .die
    cpy #0
    bne .notEgg
    cmp #TB_WEAKBLOCK
    bne .notWeakBlock
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
.longCheckDone
    jmp .tileCheckDone
.notWeakBlock:
    cmp #TB_EGG
    bne .notEgg
    lda main_sav+1
    sta main_arg
    lda main_sav+2
    sta main_arg+2
    lda #0
    sta main_arg+1
    sta main_arg+3
    lda main_bonusCount
    and #7
    clc
    adc #BONUS_TILES
    sta main_arg+4
    inc main_bonusCount
    tya
    pha
    jsr main_SetTile
    pla
    tay
    jmp .die
.notEgg:
    cmp #TB_PLATFORM
    bne .longCheckDone
    lda prgdata_entityFlags,x
    and #ENT_F_ISVERTICAL
    beq .longCheckDone
    lda main_entityXVel,y
    bmi .longCheckDone
.die:
    cpy #0
    beq .playerShot
    lda main_entityXLo-1,y
    sta main_entityXLo,y
    lda main_entityYLo-1,y
    sta main_entityYLo,y
    
    lda main_entityXHi,y
    and #~ENT_X_POS
    sta main_entityXHi,y
    lda main_entityXHi-1,y
    and #ENT_X_POS
    ora main_entityXHi,y
    sta main_entityXHi,y
    
    lda main_entityYHi,y
    and #~ENT_Y_POS
    sta main_entityYHi,y
    lda main_entityYHi-1,y
    and #ENT_Y_POS
    ora main_entityYHi,y
    sta main_entityYHi,y
    
    lda main_entityXHi,y
    and #~ENT_X_COUNT
    ora prgdata_entityCounts,x
    sta main_entityXHi,y
.noPause:

    jmp .inactive
.playerShot:
    lda #$80
    sta main_entityXHi,y
    jmp .inactive


.checkObstacle:    
    lda main_sav+3
    cmp #TB_SOLID
    beq .reverse
    cmp #TB_WEAKBLOCK
    beq .reverse
    jmp .tileCheckDone
    ; cpx #SLIME_ID
    ; beq .random
    ; cpx #SLIME_ID+1
    ; bne .tileCheckDone
; .random:
    ; lda main_frame
    ; and #63
    ; bne .tileCheckDone
.reverse:
    lda main_frame
    and #2
    bne .noSwitch
    cpx #SLIME_ID
    beq .goVertical
    cpx #SLIME_ID+1
    beq .goHorizontal
    jmp .noSwitch
.goVertical:
    lda main_entityYHi,y
    clc
    adc #%10
    sta main_entityYHi,y
    jmp .noSwitch
.goHorizontal:
    lda main_entityYHi,y
    sec
    sbc #%10
    sta main_entityYHi,y
.noSwitch:
    lda #0
    cpx #HAMMER_ID
    bne .notHammer
    lda #5
.notHammer:
    sec
    sbc main_entityXVel,y
    sta main_entityXVel,y
    lda main_entityXHi,y
    and #~ENT_X_COUNT
    ora prgdata_entityCounts,x
    sta main_entityXHi,y

.tileCheckDone:
    cpy #0
    beq .longimmortal

    lda main_entityXLo
    sta main_tmp
    lda main_entityXHi
    bmi .longimmortal
    and #ENT_X_POS
    sta main_tmp+1
    lda main_entityXLo,y
    sta main_tmp+2
    lda main_entityXHi,y
    and #ENT_X_POS
    sta main_tmp+3
    SUBI_D main_tmp, main_tmp, 8
    ADDI_D main_tmp+2, main_tmp+2, 8
    CMP_D main_tmp, main_tmp+2
    bcs .longimmortal
    ADDI_D main_tmp, main_tmp, 16
    SUBI_D main_tmp+2, main_tmp+2, 16
    CMP_D main_tmp, main_tmp+2
    bcc .longimmortal
    
    jmp .spam
.longimmortal:
    jmp .immortal
.spam:

    lda main_entityYLo
    sta main_tmp
    lda main_entityYHi
    and #ENT_Y_POS
    sta main_tmp+1
    lda main_entityYLo,y
    sta main_tmp+2
    lda main_entityYHi,y
    and #ENT_Y_POS
    sta main_tmp+3
    SUBI_D main_tmp, main_tmp, 16
    ;ADDI_D main_tmp+2, main_tmp+2, 8
    CMP_D main_tmp, main_tmp+2
    bcs .longimmortal
    ADDI_D main_tmp, main_tmp, 16
    SUBI_D main_tmp+2, main_tmp+2, 16
    CMP_D main_tmp, main_tmp+2
    bcc .longimmortal
    
    ;destroy bullet
    lda prgdata_entityFlags2,x
    and #ENT_F2_ISHITTABLE
    beq .longimmortal
    lda #$80
    sta main_entityXHi
    
    lda prgdata_entityFlags,x
    and #ENT_F_ISMORTAL
    beq .longimmortal
    
    lda main_entityYHi
    lsr
    cmp #POWERSHOT_ID
    beq .reallyDead

    lda prgdata_entityFlags2,x
    and #ENT_F2_NEEDPOWERSHOT
    bne .immortal

    lda prgdata_entityHPs,x
    sta main_tmp
    lda main_entityXHi,y
    and #~ENT_X_HP
    sta main_tmp+1
    lda main_entityXHi,y
    and #ENT_X_HP
    lsr
    lsr
    clc
    adc #1
    cmp main_tmp
    bcc .notDead
.reallyDead:
    lda #$80
    sta main_entityXHi,y
    lda #10
    sta main_arg
    lda #0
    sta main_arg+1
    sta main_arg+2
    stx main_sav
    jsr main_AddScore
    ldx main_sav
    cpx #CATERPILLAR_ID
    beq .caterpillar
    jmp .inactive
.caterpillar:  
    lda main_caterpillarNext
    cmp #CATERPILLAR_ID+4
    bcc .segmentsleft 
    jmp .inactive
.segmentsleft:
    sty main_tmp
    ldy #0
.caterpillarLoop:
    lda main_entityYHi,y
    lsr
    cmp main_caterpillarNext
    bne .nodice
    lda main_entityYHi,y
    and #~ENT_Y_INDEX
    ora #CATERPILLAR_ID<<1
    sta main_entityYHi,y
    inc main_caterpillarNext
    jmp .inactive
.nodice:
    iny
    cpy #MAX_ENTITIES
    bne .caterpillarLoop
    ldy main_tmp
    jmp .inactive
.notDead:
    asl
    asl
    and #ENT_X_HP
    ora main_tmp+1
    sta main_entityXHi,y
.immortal:
.updateVel:
    lda prgdata_entityFlags2,x
    and #ENT_F2_SWITCHID
    beq .notSwitchable
    stx main_tmp
    tax
    lda prgdata_bits-1,x
    ldx main_tmp
    and main_switches
    bne .notSwitchable
    lda main_entityXHi,y
    ora #$10
    sta main_entityXHi,y
.notSwitchable:
    lda main_entityXHi,y
    REPEAT 4
    lsr
    REPEND
    beq .notPaused
    sec
    sbc #1
    REPEAT 4
    asl
    REPEND
    sta main_tmp
    lda main_frame
    and #31
    beq .updateCount
    jmp .inactive
.updateCount:
    lda main_entityXHi,y
    and #~ENT_X_COUNT
    ora main_tmp
    sta main_entityXHi,y
    jmp .inactive
.notPaused:
    lda main_entityXLo,y
    sta main_tmp
    lda main_entityXHi,y
    and #ENT_X_POS
    sta main_tmp+1
    lda prgdata_entityFlags,x
    and #ENT_F_ISVERTICAL
    beq .horizontal
    
    lda main_entityYLo,y
    sta main_tmp
    lda main_entityYHi,y
    and #ENT_Y_POS
    sta main_tmp+1
.horizontal:
    lda main_entityXVel,y
    and #1
    bne .extra
    lda main_entityXVel,y
    jmp .noExtra
.extra:
    lda main_frame
    and #1
    bne .leapFrame
    lda main_entityXVel,y
    jmp .noExtra
.leapFrame:
    lda main_entityXVel,y
    bmi .negativeLeap
    clc
    adc #1
    jmp .noExtra
.negativeLeap:
    sec
    sbc #1
.noExtra:
    cmp #<-1
    bne .noRotateError
    lda #0
.noRotateError:
    cmp #80
    ror
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
    lda prgdata_entityFlags,x
    and #ENT_F_ISVERTICAL
    bne .vertical
    lda main_tmp
    sta main_entityXLo,y
    lda main_entityXHi,y
    and #~ENT_X_POS
    ora main_tmp+1
    sta main_entityXHi,y
    cpy main_currPlatform
    bne .inactive
    ADD_D main_playerX, main_playerX, main_tmp+2
    jmp .inactive
.vertical:
    lda main_tmp
    sta main_entityYLo,y
    lda main_entityYHi,y
    and #~ENT_Y_POS
    ora main_tmp+1 ; just assuming that calculated y will never be out of bounds
    sta main_entityYHi,y
    cpy main_currPlatform
    bne .inactive
    ADD_D main_playerY, main_playerY, main_tmp+2
.inactive:
    dey
    bmi main_updateEntities_end
    jmp .loop
main_updateEntities_end:


main_ApplyVelocity subroutine
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
    bne .noTiles
    jsr main_LoadTilesOnMoveLeft
.noTiles:
    
    ;no loading attributes if not at attributes boundary
    lda shr_cameraX
    and #15
    cmp #15
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
    ;update position
    SUB_D main_sav, main_playerX, shr_cameraX
    lda main_sav
    clc
    adc #8
    sta shr_playerSprites+SPR_X
    clc
    adc #8
    sta shr_playerSprites+OAM_SIZE+SPR_X
    
    SUB_D main_sav, main_playerY, shr_cameraY
    lda main_sav
    clc
    adc #31
    sta shr_playerSprites+SPR_Y
    sta shr_playerSprites+OAM_SIZE+SPR_Y

    ;update tiles
    lda main_playerFrame
    clc
    adc main_playerXVel
    and #%00011111
    sta main_playerFrame

    lda main_playerFrame
    lsr
    lsr
    tax

    bit main_playerFlags
    bpl .walk_anim
    ldx #9
    jmp .do_anim

.walk_anim:
    lda #0
    cmp main_playerXVel
    bne .do_anim
    ldx #8

.do_anim:
    lda main_playerFlags
    and #PLY_ISFLIPPED
    sta shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+OAM_SIZE+SPR_FLAGS
    bit main_playerFlags
    bvs .left
.right:
    lda prgdata_playerWalk,x
    sta shr_playerSprites+SPR_INDEX
    clc
    adc #2
    sta shr_playerSprites+OAM_SIZE+SPR_INDEX
    jmp .animEnd
.left:
    lda prgdata_playerWalk,x
    sta shr_playerSprites+OAM_SIZE+SPR_INDEX
    clc
    adc #2
    sta shr_playerSprites+SPR_INDEX
.animEnd:

    lda main_mercyTime
    beq .notFlashing
    lda #$01
    ora shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+OAM_SIZE+SPR_FLAGS
.notFlashing:

    lda main_playerFlags
    and #PLY_ISBEHIND
    beq .notBehind
    lda #$20
    ora shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+OAM_SIZE+SPR_FLAGS
.notBehind:
    
    lda main_playerFlags
    and #PLY_ISUPSIDEDOWN
    beq .notUpsideDown
    lda #$80
    ora shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+OAM_SIZE+SPR_FLAGS
.notUpsideDown:

main_UpdatePlayerSprite_end:

main_UpdateEntitySprites subroutine
    lda main_frame
    and #1
    sta main_sav
    ldy #[shr_entitySprites-shr_oamShadow]
    ldx #[MAX_ENTITIES-1]
    lda main_sav
    beq .loop
    ldx #0
.loop:
    lda main_entityYHi,x
    stx main_tmp
    lsr
    tax
    lda prgdata_entityTiles,x
    sta main_sav+2
    lda prgdata_entityFlags2,x
    sta main_sav+1
    lda prgdata_entityFlags,x
    ldx main_tmp
    sta main_sav+3
    
    and #ENT_F_COLOR
    lsr
    sta shr_spriteFlags,y
    sta shr_spriteFlags+OAM_SIZE,y

    lda main_sav+1
    and #ENT_F2_NOANIM
    bne .notmoving
    lda main_entityXHi,x
    and #ENT_X_COUNT
    bne .notmoving
    lda main_entityXVel,x
    bne .moving
    lda main_sav+3
    and #ENT_F_ISFACING
    beq .moving
.notmoving:
    lda main_sav+2
    sta shr_spriteIndex,y
    clc
    adc #2
    sta shr_spriteIndex+OAM_SIZE,y
    jmp .facing
.moving:
    lda main_sav+1
    and #ENT_F2_SHORTANIM
    beq .longanim
    lda main_frame
    and #12
    cmp #12
    bne .longanim
    lda #4
    jmp .anim
.longanim:
    lda main_frame
    and #12
.anim:
    clc
    adc main_sav+2
    sta shr_spriteIndex,y
    clc
    adc #2
    sta shr_spriteIndex+OAM_SIZE,y

.facing:
    lda main_sav+1
    and #ENT_F2_ISXFLIPPED
    bne .xflip
    lda main_sav+3
    and #ENT_F_ISFACING
    beq .noFacing
    lda main_entityXVel,x
    bpl .noFacing
    lda main_sav+3
    and #ENT_F_ISVERTICAL
    bne .vflip
.xflip:
    lda #$40
    ora shr_spriteFlags,y
    sta shr_spriteFlags,y
    sta shr_spriteFlags+OAM_SIZE,y
    lda shr_spriteIndex+OAM_SIZE,y
    sta main_tmp
    lda shr_spriteIndex,y
    sta shr_spriteIndex+OAM_SIZE,y
    lda main_tmp
    sta shr_spriteIndex,y
    jmp .noFacing
.vflip:
    lda #$80
    ora shr_spriteFlags,y
    sta shr_spriteFlags,y
    sta shr_spriteFlags+OAM_SIZE,y
    
.noFacing:
    
    lda #$FF
    sta shr_spriteX,y
    sta shr_spriteX+OAM_SIZE,y
    sta shr_spriteY,y
    sta shr_spriteY+OAM_SIZE,y
    
    lda main_sav+3
    and #ENT_F_ISPROJECTILE
    beq .notHidden
    lda main_entityXHi,x
    and #ENT_X_COUNT
    beq .notHidden
    jmp .out_of_range
.notHidden:

    lda main_entityXLo,x
    sec
    sbc shr_cameraX
    sta main_tmp
    lda main_entityXHi,x
    and #ENT_X_POS
    sbc shr_cameraX+1
    sta main_tmp+1
    
    ;move origin to center
    ADDI_D main_tmp, main_tmp, 8

    lda main_entityXHi,x
    bpl .foo
    jmp .out_of_range
.foo:
    
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
    CMPI_D main_tmp, 2*8
    bcc .out_of_range
    lda main_entityYHi,x
    lsr
    cmp #ROCK_ID
    bne .notRock
    lda main_entityXVel,x
    bne .notRock
    lda #4
    adc main_tmp
    sta main_tmp
    lda shr_spriteFlags,y
    ora #$20
    sta shr_spriteFlags,y
    lda shr_spriteFlags+OAM_SIZE,y
    ora #$20
    sta shr_spriteFlags+OAM_SIZE,y
.notRock:
    lda main_tmp
    sta shr_spriteY,y
    sta shr_spriteY+OAM_SIZE,y
        

        
.out_of_range:
    tya
    clc
    adc #[OAM_SIZE*2]
    beq main_UpdateEntitySprites_end
    tay
    lda main_sav
    bne .bar
    dex
    bmi main_UpdateEntitySprites_end
    jmp .loop
.bar:
    inx
    cpx #MAX_ENTITIES
    beq main_UpdateEntitySprites_end
    jmp .loop
main_UpdateEntitySprites_end

    inc main_frame
    inc shr_doDma
    inc shr_doRegCopy
    jsr synchronize
    jmp main_loop

    include main_subs.asm
