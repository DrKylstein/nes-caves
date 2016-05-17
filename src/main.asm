;------------------------------------------------------------------------------
; MAIN THREAD
;------------------------------------------------------------------------------

;opened doors need to be updated if in nametable
;enemy points table
;large enemies - triceratops, t-rex, stalk-eye
;explosions
;corner collisions with solids
;edge collisions with special tiles
;better hidden block collision
;flame traps
;rolling enemy
;strength mushrooms
;infinite ammo w/ powershot
;sound effects
;air generator death
;fix intermittent color corruption
;reset in-level score on death or quit
;transitions
;unique level tiles?
;death animation

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
    MOVI_D nmi_sfxPtr, nullSound
    jmp init_apu_end
.regs:
    .byte $30,$08,$00,$00
    .byte $30,$08,$00,$00
    .byte $80,$00,$00,$00
    .byte $30,$00,$00,$00
    .byte $00,$00,$00,$00
    .byte $00,$0F,$00,$40
init_apu_end:

clearOAM subroutine
    lda #$FF
    ldy #0
.loop:
    dey
    sta shr_oamShadow,y
    bne .loop
clearOAM_end: 
 
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

LoadTitlePatterns subroutine
    lda #<bank0_titleTiles
    sta tmp
    lda #>bank0_titleTiles
    sta tmp+1
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
    lda (tmp),y
    sta PPU_DATA
    iny
    bne .loop
    inc tmp+1
    dex
    bne .loop
LoadTitlePatterns_end:
LoadTitleNames subroutine
    lda #<titleNames
    sta tmp
    lda #>titleNames
    sta tmp+1
    bit PPU_STATUS
    lda #$20
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR
    ldx #4
.loop:
    lda (tmp),y
    sta PPU_DATA
    iny
    bne .loop
    inc tmp+1
    dex
    bne .loop
LoadTitleNames_end:

LoadTitlePalette subroutine
    ldy #16
    bit PPU_STATUS
    lda #$3F
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR
.loop:
    lda titlePalette,y
    sta PPU_DATA
    dey
    bpl .loop
LoadTitlePalette_end:

DoTitleScreen subroutine
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
DoTitleScreen_end:

LoadPatterns subroutine
    lda #<bank0_defaultTiles
    sta tmp
    lda #>bank0_defaultTiles
    sta tmp+1
    ldy #0
    lda banktable,y
    sta banktable,y
    bit PPU_STATUS
    sty PPU_ADDR
    sty PPU_ADDR
    ldx #32
.loop:
    lda (tmp),y
    sta PPU_DATA
    iny
    bne .loop
    inc tmp+1
    dex
    bne .loop
LoadPatterns_end:

InitNametables subroutine
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
    lda hud,y
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
    lda hud,y
    sta PPU_DATA
    iny
    cpy #$88
    bne .load_hud_attr
    
    ;set sprite 0 for status bar
InitSprites subroutine
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

    MOVI_D shr_palAddr, palettes
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
    ;sta currLevel
    
    MOVI_D arg, mainMap
;------------------------------------------------------------------------------
;Start of Level
;------------------------------------------------------------------------------
EnterLevel:
DisableDisplay subroutine
    lda #%00000000 ;disable nmi
    sta shr_ppuCtrl
    sta PPU_CTRL
    sta shr_ppuMask
    sta PPU_MASK
DisableDisplay_end:

ResetStats subroutine
    lda #4
    sta switches
    lda #3
    sta shr_hp
    lda #MAX_ENTITIES
    sta currPlatform
    lda #0
    sta paused
    sta shr_powerTime
    sta shr_powerTime+1
    sta bonusCount
    lda playerFlags
    and #~PLY_HASKEY
    sta playerFlags
    lda #CATERPILLAR_ID+1
    sta caterpillarNext
ResetStats_end:

    ADDI_D shr_palAddr, arg, [levelDataEnd-levelMap+entityBlockEnd-entityBlock]
    lda #BG_PAL
    sta shr_palDest
    inc shr_doPalCopy


LoadLevel subroutine
    MOV_D tmp+2, arg
    MOVI_D tmp, levelMap
    ldy #0
    ldx #4
.loop:
    lda (tmp+2),y
    sta (tmp),y
    iny
    bne .loop
    ADDI_D tmp+2, tmp+2, 256
    ADDI_D tmp, tmp, 256
    dex
    bne .loop
    
    ADDI_D tmp+2, arg, [levelDataEnd-levelMap]
    MOVI_D tmp, entityBlock
    ldy #0
.copyEntities:
    lda (tmp+2),y
    sta (tmp),y
    iny
    cpy #[entityBlockEnd-entityBlock]
    bne .copyEntities
LoadLevel_end:

InitEntities subroutine
    ldy #0
.loop:
    lda entityYHi,y
    lsr
    tax
    lda entitySpeeds,x
    sta entityVelocity,y
    lda entityAnims,x
    sta entityAnim,y
    lda #0
    sta entityCount,y
    iny
    cpy #MAX_ENTITIES
    bne .loop
InitEntities_end:

LoadMapState subroutine
    lda currLevel
    bpl LoadMapState_end
    MOV_D playerX, mapPX
    MOV_D playerY, mapPY
    MOV_D shr_cameraX, mapCamX
    MOV_D shr_cameraY, mapCamY
    lda mapCamYMod
    sta shr_cameraYMod
    CMPI_D shr_cameraY, 240
    lda #0
    bcc .nt0
    lda #8
.nt0:
    sta shr_nameTable
LoadMapState_end:

LoadNametables subroutine
    MOV_D arg, shr_cameraX
    REPEAT 4
    LSR_D arg
    REPEND
    jsr MultiplyBy24
    ADDI_D sav, ret, levelMap
    ldy #0
    MOV_D sav+2, shr_cameraX
    REPEAT 3
    LSR_D sav+2
    REPEND
        
.loop:
    ;args to buffer column    
    MOV_D arg, sav
    tya
    clc
    adc arg
    sta arg
    lda #0
    adc arg+1
    sta arg+1
    tya
    asl
    clc
    adc sav+2
    and #$1F
    sta arg+2
    tya
    pha
    jsr EvenColumn
    jsr nmi_CopyTileCol     ;terribly unsafe
    pla
    tay
    
    MOV_D arg, sav
    tya
    clc
    adc arg
    sta arg
    lda #0
    adc arg+1
    sta arg+1
    tya
    asl
    sec
    adc #0
    adc sav+2
    and #$1F
    sta arg+2
    tya
    pha
    jsr OddColumn
    jsr nmi_CopyTileCol     ;ditto
    pla
    tay
    
    iny
    ADDI_D sav, sav, 23
    cpy #16
    bne .loop
LoadNametables_end:

InitAttributes subroutine
    MOV_D arg, shr_cameraX
    REPEAT 4
    LSR_D arg
    REPEND
    jsr MultiplyBy24
    ADDI_D arg, ret, levelMap
    lda shr_cameraX
    REPEAT 5
    lsr
    REPEND
    sta sav+3
    ldy #0
.loop:
    tya
    clc
    adc sav+3
    and #7
    asl
    asl
    sta shr_tileCol
    sty sav+2
    jsr ColorColumn
    jsr nmi_CopyAttrCol
    ldy sav+2
    lda arg
    clc
    adc #MT_MAP_HEIGHT*2
    sta arg
    lda arg+1
    adc #0
    sta arg+1
    iny
    cpy #8
    bne .loop
InitAttributes_end:

    jsr LoadTilesOnMoveLeft

ReenableDisplay subroutine
    lda #%10110000 ;enable nmi
    sta shr_ppuCtrl
    sta PPU_CTRL
    lda #%00011000
    sta shr_ppuMask
    inc shr_doRegCopy
ReenableDisplay_end:

;------------------------------------------------------------------------------
;Every Frame
;------------------------------------------------------------------------------
MainLoop:
CheckInput subroutine
    lda ctrl
    sta oldCtrl
    jsr read_joy
    sta ctrl
    and oldCtrl
    eor ctrl
    sta pressed
    
    lda #0
    sta playerXVel
.start:
    lda pressed
    and #JOY_START_MASK
    beq .foo
    lda #1
    eor paused
    sta paused
.foo    
    lda paused
    beq .left
    lda pressed
    and #JOY_SELECT_MASK
    beq CheckInput
    jmp doExit
.left:
    lda ctrl
    and #JOY_LEFT_MASK
    beq .left_end
    lda #<-1
    sta playerXVel
    lda playerFlags
    ora #PLY_ISFLIPPED
    sta playerFlags
.left_end:
.right:
    lda ctrl
    and #JOY_RIGHT_MASK
    beq .right_end
    lda #1
    sta playerXVel
    lda playerFlags
    and #~PLY_ISFLIPPED
    sta playerFlags
.right_end:
    lda pressed
    and #JOY_SELECT_MASK
    beq .jump
    lda #0
    sta crystalsLeft
.jump:
    lda ctrl
    and #JOY_A_MASK
    beq CheckInput_end
    bit playerFlags
    bmi CheckInput_end
    MOVI_D playerYVel, JUMP_VELOCITY
    lda playerFlags
    and #PLY_ISUPSIDEDOWN
    beq .notUpsideDown
    MOVI_D playerYVel, -JUMP_VELOCITY
.notUpsideDown:
    lda playerFlags
    ora #PLY_ISJUMPING
    sta playerFlags
    lda #SFX_JUMP
    sta shr_doSfx
CheckInput_end:

TileInteraction subroutine
    lda playerFlags
    and #~PLY_ISBEHIND
    sta playerFlags

    ;a0 = x in tiles
    ADDI_D arg, playerX, 7
    REPEAT 4
    LSR_D arg
    REPEND
    lda arg
    sta sav+1
    ;a2 = y in tiles
    ADDI_D arg+2, playerY, 7
    REPEAT 4
    LSR_D arg+2
    REPEND
    lda arg+2
    sta sav+2
    
    jsr MultiplyBy24 ;takes arg0, which we no longer care about after this
                          ;returns
    ;t0 = y+ x*24
    ADD_D tmp, arg+2, ret
    
    ;lookup tile, get behavior
    ADDI_D tmp, tmp, levelMap
    ldy #0
    lda (tmp),y
    sta sav
    tay
    lda metatiles+256*4,y
    lsr
    lsr
    sta sav+3
    asl
    tay
    lda TileCollision,y
    sta tmp
    lda TileCollision+1,y
    sta tmp+1
    jmp (tmp)
    
TileCollision:
    .word TC_Nop;TC_Empty
    .word TC_Nop;TC_Solid
    .word TC_Nop;TC_Platform
    .word TC_Exit
    .word TC_Harmful
    .word TC_Deadly
    .word TC_Nop;TC_LightsOn
    .word TC_Nop;TC_LightsOff
    .word TC_Nop;TC_WeakBlock
    .word TC_Ammo
    .word TC_Nop;TC_Strength
    .word TC_Powershot
    .word TC_Gravity
    .word TC_Key
    .word TC_Nop;TC_Stop
    .word TC_Chest
    .word TC_Points ;crystal
    .word TC_Points ;egg
    .word TC_Points ;800
    .word TC_Points ;1000
    .word TC_Points ;5000
    .word TC_Points ;bonus
    .word TC_Nop
    .word TC_Nop
    .word TC_Hidden
    .word TC_Nop
    .word TC_Nop
    .word TC_Lock
    .word TC_Lock
    .word TC_Lock
    .word TC_Nop
    .word TC_Nop
    .word TC_Nop ;air
    .word TC_Foreground
    .word TC_Nop
    .word TC_Nop
    .word TC_Nop
    .word TC_Nop
    .word TC_Nop
    .word TC_Nop
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Entrance
    .word TC_Off
    .word TC_Off
    .word TC_Off
    .word TC_Off
    .word TC_On
    .word TC_On
    .word TC_On
    .word TC_On
    
TC_Harmful:
    jsr DamagePlayer
    jmp TC_Nop
    
TC_Deadly:
    jsr KillPlayer
    lda #0
    sta sav
    jmp TC_UpdateTile
    
TC_Points:
    lda sav+3
    sec
    sbc #TB_POINTS
    asl
    asl
    tax
    lda points+1,x
    sta arg+2
    lda points+2,x
    sta arg+1
    lda points+3,x
    sta arg
    cpx #0
    bne .notCrystal
    dec crystalsLeft
    bne .notCrystal
    inc shr_flashBg
.notCrystal:
    cpx #5<<2
    bne .notBonus
    lda #8
    clc
    adc bonusCount
    sta bonusCount
    cmp #5<<3
    bcc .notBonus
    ldx #6<<2
    lda points+1,x
    sta arg+2
    lda points+2,x
    sta arg+1
    lda points+3,x
    sta arg
.notBonus:
    jsr AddScore
    lda #SFX_CRYSTAL
    sta shr_doSfx
    
    lda #0
    sta sav
    jmp TC_UpdateTile
TC_Points_end:

TC_Key:
    lda #SFX_CRYSTAL
    sta shr_doSfx
    lda playerFlags
    ora #PLY_HASKEY
    sta playerFlags
    lda #0
    sta sav
    jmp TC_UpdateTile
TC_Key_end:

TC_Chest:
    lda #PLY_HASKEY
    bit playerFlags
    BEQ_L TC_Return
    lda #SFX_CRYSTAL
    sta shr_doSfx
    
    lda #2
    sta arg+1
    lda #0
    sta arg
    sta arg+2
    jsr AddScore
    
    inc sav
    jmp TC_UpdateTile
TC_Chest_end:

TC_Ammo:
    lda #SFX_CRYSTAL
    sta shr_doSfx
    lda shr_ammo
    clc
    adc #5
    sta shr_ammo
    lda #0
    sta sav
    jmp TC_UpdateTile
TC_Ammo_end:

TC_Powershot:
    lda #SFX_CRYSTAL
    sta shr_doSfx
    lda #10
    sta shr_powerTime+1
    lda #60
    sta shr_powerTime
    lda #~PLY_ISUPSIDEDOWN
    and playerFlags
    sta playerFlags
    lda #0
    sta sav
    jmp TC_UpdateTile
TC_Powershot_end:

TC_Gravity:
    lda #SFX_CRYSTAL
    sta shr_doSfx
    lda #10
    sta shr_powerTime+1
    lda #60
    sta shr_powerTime
    lda #PLY_ISUPSIDEDOWN
    ora playerFlags
    sta playerFlags
    lda #0
    sta sav
    jmp TC_UpdateTile
TC_Gravity_end:

TC_Foreground:
    lda playerFlags
    ora #PLY_ISBEHIND
    sta playerFlags
    jmp TC_Return
TC_Foreground_end:

TC_Exit:
    lda crystalsLeft
    BNE_L TC_Return
    ldy currLevel
    cpy #16
    bcs .upperLevels
    lda bits+1,y
    ora cleared
    sta cleared
    jmp doExit
.upperLevels:
    tya
    sec
    sbc #8
    lda bits+1,y
    ora cleared+1
    sta cleared+1
doExit:
    lda #MAP_LEVEL
    sta currLevel
    MOVI_D arg, mainMap
    jmp EnterLevel
TC_Exit_end:

TC_Entrance:
    lda sav+3
    sec
    sbc #TB_MAPDOOR
    cmp #16
    bcs .enterUpperLevel
    tay
    lda bits+1,y
    and cleared
    beq .uncleared
    lda sav+3
    jmp TC_Return
.enterUpperLevel:
    sec
    sbc #8
    tay
    lda bits+1,y
    and cleared+1
    beq .uncleared
    lda sav+3
    jmp TC_Return
.uncleared:
    lda sav+3
    sec
    sbc #TB_MAPDOOR
    sta currLevel
    asl
    tay
    lda levelTable,y
    sta arg
    lda levelTable+1,y
    sta arg+1
    MOV_D mapPX, playerX
    MOV_D mapPY, playerY
    MOV_D mapCamX, shr_cameraX
    lda mapCamX
    and #$E0
    sta mapCamX
    MOV_D mapCamY, shr_cameraY
    lda shr_cameraYMod
    sta mapCamYMod
    jmp EnterLevel
TC_Entrance_end:
    
TC_Hidden:
    lda #HIDDEN_TILE
    sta sav
    jmp TC_UpdateTile
TC_Hidden_end:
    
TC_Lock:
    lda #JOY_B_MASK
    and pressed
    BEQ_L TC_Return
    
    lda sav+3
    sec
    sbc #TB_LOCK
    tay
    lda doorsLo,y
    sta tmp
    lda doorsHi,y
    sta tmp+1
    ADDI_D tmp, tmp, levelMap
    ldy #0
    lda #0
    sta (tmp),y
    iny
    sta (tmp),y
    inc sav
    jmp TC_UpdateTile
TC_Lock_end:

TC_On:
    lda #JOY_B_MASK
    and pressed
    BEQ_L TC_Return
    lda sav+3
    sec
    sbc #TB_ON
    tay
    lda bits+1,y
    eor switches
    sta switches
    dec sav
    jmp TC_UpdateTile
TC_On_end:

TC_Off:
    lda #JOY_B_MASK
    and pressed
    BEQ_L TC_Return
    lda sav+3
    sec
    sbc #TB_OFF
    tay
    lda bits+1,y
    eor switches
    sta switches
    inc sav
    jmp TC_UpdateTile
TC_Off_end:

    
TC_Return:
TC_Nop:
    lda #JOY_B_MASK
    and pressed
    BEQ_L TileInteraction_end
    bit entityXHi
    BPL_L TileInteraction_end
    lda shr_ammo
    BEQ_L TileInteraction_end
    dec shr_ammo
    lda playerX
    sta entityXLo
    lda playerX+1
    and #ENT_X_POS
    sta entityXHi
    lda playerY
    sta entityYLo
    lda playerY+1
    and #ENT_Y_POS
    sta entityYHi
    lda #ANIM_SMALL_LONG
    sta entityAnim
    lda #0
    sta entityCount
    lda shr_powerTime+1
    beq .notPowerShot
    lda #PLY_ISUPSIDEDOWN
    and playerFlags
    bne .notPowerShot
    lda #POWERSHOT_ID<<1
    ora entityYHi
    sta entityYHi
    lda #ANIM_SMALL_OSCILLATE
    sta entityAnim
.notPowerShot
    lda #SFX_ROCKET
    sta shr_doSfx
    
    bit playerFlags
    bvs .shootLeft
.shootRight:
    lda #2
    sta entityVelocity
    clc
    lda #8
    adc entityXLo
    sta entityXLo
    lda #0
    adc entityXHi
    and #ENT_X_POS
    sta entityXHi
    
    jmp TileInteraction_end
.shootLeft:
    lda #<-2
    sta entityVelocity
    lda entityXLo
    sec
    sbc #8
    sta entityXLo
    lda entityXHi
    sbc #0
    and #ENT_X_POS
    sta entityXHi
    inc entityAnim
    jmp TileInteraction_end
    
TC_UpdateTile:
    lda sav+1
    sta arg
    lda sav+2
    sta arg+2
    lda #0
    sta arg+1
    sta arg+3
    lda sav
    sta arg+4
    jsr SetTile
TileInteraction_end:

ApplyGravity subroutine
    lda playerFlags
    and #PLY_ISUPSIDEDOWN
    bne .reverseGravity
    CMPI_D playerYVel, $0400
    bpl ApplyGravity_end
    ADDI_D playerYVel, playerYVel, GRAVITY
    jmp ApplyGravity_end
.reverseGravity:
    CMPI_D playerYVel, -$0400
    bmi ApplyGravity_end
    SUBI_D playerYVel, playerYVel, GRAVITY
ApplyGravity_end:


CheckLeft subroutine
    ;skip if not moving left (>= 0)
    lda playerXVel
    cmp #0
    bpl CheckLeft_end

    CMPI_D playerX, 1
    bcc .hit
    
    ;arg = x in tiles
    MOV_D arg, playerX
    REPEAT 4
    LSR_D arg
    REPEND
    ;arg+2 = y in tiles
    ADDI_D arg+2, playerY, 7
    REPEAT 4
    LSR_D arg+2
    REPEND
    
    jsr GetTileBehavior
    lda ret
    cmp #TB_SOLID
    beq .hit
    cmp #TB_WEAKBLOCK
    beq .hit
    jmp CheckLeft_end
.hit:
    lda #0
    sta playerXVel
CheckLeft_end:

CheckRight subroutine
    ;skip if not moving right (<= 0)
    lda playerXVel
    cmp #0
    bmi CheckRight_end
    beq CheckRight_end

    CMPI_D playerX, [MT_MAP_WIDTH*PX_MT_WIDTH - 16]
    bcs .hit

    ;arg = x in tiles
    MOV_D arg, playerX
    REPEAT 4
    LSR_D arg
    REPEND
    INC_D arg
    ;arg+2 = y in tiles
    ADDI_D arg+2, playerY, 7
    REPEAT 4
    LSR_D arg+2
    REPEND
    
    jsr GetTileBehavior
    lda ret
    cmp #TB_SOLID
    beq .hit
    cmp #TB_WEAKBLOCK
    beq .hit
    cmp #TB_EXIT
    bne CheckRight_end
    lda crystalsLeft
    beq CheckRight_end
.hit:
    lda #0
    sta playerXVel
CheckRight_end:

CheckGround subroutine
    ;skip if not moving down (< 0)
    CMPI_D playerYVel, 0
    BMI_L CheckGround_end

    lda playerFlags
    and #PLY_ISUPSIDEDOWN
    bne .upsideDown
    lda playerFlags
    ora #PLY_ISJUMPING
    sta playerFlags
.upsideDown:

    ;a0 = x in tiles
    ADDI_D arg, playerX, 8
    REPEAT 4
    LSR_D arg
    REPEND
    ;t0 = y in tiles
    MOV_D arg+2, playerY
    REPEAT 4
    LSR_D arg+2
    REPEND
    INC_D arg+2; get tile at feet
    
    jsr GetTileBehavior
    lda ret
    cmp #TB_SOLID
    beq .hitGroundTile
    cmp #TB_PLATFORM
    bne .notPlatform
    lda playerY
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
    and playerY
    sta playerY
    jmp .hit_ground

.checkSpriteHit:
    ldy #MAX_ENTITIES
    sty currPlatform
.loop:
    dey
    BMI_L CheckGround_end
    
    lda entityYHi,y
    lsr
    tax
    lda entityFlags,x
    and #ENT_F_ISPLATFORM
    beq .loop
    
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sta tmp+1
    
    ADDI_D tmp+2, playerX, 4
    SUBI_D tmp, tmp, 8
    CMP_D tmp, tmp+2
    bpl .loop
    
    SUBI_D tmp+2, playerX, 4
    ADDI_D tmp, tmp, 16
    CMP_D tmp, tmp+2
    bmi .loop
    
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    
    SUBI_D tmp, tmp, 15
    CMP_D tmp, playerY
    bmi .longLoop

    SUBI_D tmp, tmp, 2
    CMP_D tmp, playerY
    bpl .longLoop
    
    jmp .hitSprite
.longLoop:
    jmp .loop
.hitSprite:
    
    ADDI_D playerY, tmp, 1
    sty currPlatform
.hit_ground: ;stop if moving down
    lda #0
    sta playerYVel
    sta playerYFrac
    lda playerFlags
    and #PLY_ISUPSIDEDOWN
    bne CheckGround_end
    lda playerFlags
    and #~PLY_ISJUMPING
    sta playerFlags
CheckGround_end:

CheckCieling subroutine

    ;skip if not moving up (>= 0)
    CMPI_D playerYVel, 0
    BPL_L CheckCieling_end

    lda playerFlags
    and #PLY_ISUPSIDEDOWN
    beq .notUpsideDown
    lda playerFlags
    ora #PLY_ISJUMPING
    sta playerFlags
.notUpsideDown:


    ;hit head on top of screen
    CMPI_D playerY, 8
    bcc .hit_cieling
    
    ;a0 = x in tiles
    ADDI_D arg, playerX, 8
    REPEAT 4
    LSR_D arg
    REPEND
    ;t0 = y in tiles
    SUBI_D arg+2, playerY, 1
    REPEAT 4
    LSR_D arg+2
    REPEND
    
    jsr GetTileBehavior
    lda ret
    cmp #TB_SOLID
    beq  .hit_cieling
    cmp #TB_WEAKBLOCK
    beq  .hit_cieling
    jmp CheckCieling_end
    
.hit_cieling:
    MOVI_D playerYVel, 0
    lda #0
    sta playerYFrac
    lda playerFlags
    and #PLY_ISUPSIDEDOWN
    beq CheckCieling_end
    lda playerFlags
    and #~PLY_ISJUMPING
    sta playerFlags
CheckCieling_end:
    
CheckHurt subroutine
    lda mercyTime
    beq .findEnemy
    dec mercyTime
    jmp CheckHurt_end
.findEnemy:
    ldy #MAX_ENTITIES
.loop:
    dey
    BMI_L CheckHurt_end
    
    lda entityXHi,y
    bmi .loop
        
    lda entityYHi,y
    lsr
    tax
    lda entityFlags,x
    and #ENT_F_ISDEADLY
    beq .loop
    
    lda entityXHi,y
    and #ENT_X_COUNT
    beq .notHidden
    lda entityFlags,x
    and #ENT_F_ISPROJECTILE
    beq .notHidden
    jmp .loop
.notHidden:

    
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sta tmp+1
    
    ADDI_D tmp+2, playerX, 4
    SUBI_D tmp, tmp, 7
    CMP_D tmp, tmp+2
    bpl .loop
    
    SUBI_D tmp+2, playerX, 4
    ADDI_D tmp, tmp, 16
    CMP_D tmp, tmp+2
    bmi .loop
    
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    
    SUBI_D tmp+2, playerY, 15
    CMP_D tmp, tmp+2
    bmi .longLoop

    SUBI_D tmp, tmp, 15
    CMP_D tmp, playerY
    bpl .longLoop
    
    jsr DamagePlayer
    lda entityFlags,x
    and #ENT_F_ISPROJECTILE
    beq CheckHurt_end
    lda #$80
    sta entityXHi,y
    
    jmp CheckHurt_end
.longLoop:
    jmp .loop
CheckHurt_end:

UpdatePower subroutine
    lda shr_powerTime+1
    beq UpdatePower_end
    dec shr_powerTime
    bne UpdatePower_end
    lda #60
    sta shr_powerTime
    dec shr_powerTime+1
    bne UpdatePower_end
    lda #~PLY_ISUPSIDEDOWN
    and playerFlags
    sta playerFlags
UpdatePower_end:

updateEntities subroutine
    ldy #[MAX_ENTITIES-1]
.loop:
    lda entityXHi,y
    bpl .active
    jmp ER_Return
.active:   
    lda entityYHi,y
    and #ENT_Y_INDEX
    lsr
    tax

;check offscreen
    cpx #CATERPILLAR_ID
    bcc .noSkipHTest
    cpx #CATERPILLAR_ID+4
    bcs .noSkipHTest
    jmp .vtest
.noSkipHTest:
    lda entityFlags,x
    and #ENT_F_ISPLATFORM
    bne .persistent
    lda entityXLo,y
    sec
    sbc shr_cameraX
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sbc shr_cameraX+1
    sta tmp+1
    CMPI_D tmp, [MT_VIEWPORT_WIDTH*PX_MT_WIDTH + PX_MT_WIDTH]
    bpl .offScreen
    CMPI_D tmp, -PX_MT_WIDTH
    bmi .offScreen
.vtest:
    lda entityYLo,y
    sec
    sbc shr_cameraY
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sbc shr_cameraY+1
    sta tmp+1
    CMPI_D tmp, [MT_VIEWPORT_HEIGHT*PX_MT_HEIGHT + PX_MT_HEIGHT]
    bpl .offScreen
    CMPI_D tmp, -PX_MT_HEIGHT
    bmi .offScreen
    jmp .persistent
.offScreen:
    lda entityFlags,x
    and #ENT_F_ISPROJECTILE
    beq .normal
    lda #$80
    sta entityXHi,y
.normal:
    jmp ER_Return
.persistent:
    txa
    asl
    tax
    lda entityRoutine,x
    sta tmp
    lda entityRoutine+1,x
    sta tmp+1
    txa
    lsr
    tax
    jmp (tmp)
ER_Return:
    dey
    BMI_L updateEntities_end
    jmp .loop
    
entityRoutine:
    .word ER_Bullet
    .word ER_VerticalPlatform
    .word ER_HorizontalPlatform
    .word ER_Spider
    .word ER_Bat
    .word ER_PowerShot
    .word ER_Mimrock
    .word ER_Cart
    .word ER_CaterpillarHead
    .word ER_CaterpillarFront
    .word ER_CaterpillarBack
    .word ER_CaterpillarTail
    .word ER_SlimeHorizontal
    .word ER_SlimeVertical
    .word ER_Hammer
    .word ER_Faucet
    .word ER_Water
    .word ER_VerticalPlatformIdle
    .word ER_HorizontalPlatformIdle
    .word ER_RightCannon
    .word ER_RightLaser
    .word ER_LeftCannon
    .word ER_LeftLaser
    .word ER_Rex
    
IsNearPlayerY subroutine
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    ADDI_D tmp+2,playerY,8
    REPEAT 4
    LSR_D tmp
    LSR_D tmp+2
    REPEND
    lda tmp
    cmp tmp+2
    rts

ApplyXVel subroutine
    lda entityVelocity,y
    M_ASR
    sta tmp
    EXTEND tmp, tmp
    lda frame
    and #1
    beq .noExtra
    lda entityVelocity,y
    bpl .positive
    DEC_D tmp
    jmp .noExtra
.positive:
    INC_D tmp
.noExtra:
    clc
    lda entityXLo,y
    adc tmp
    sta entityXLo,y
    lda entityXHi,y
    adc tmp+1
    and #ENT_X_POS
    sta tmp
    lda entityXHi,y
    and #~ENT_X_POS
    ora tmp
    sta entityXHi,y
    rts
    
HitWall subroutine
    ;calculate map tile
    lda entityXLo,y
    sta arg
    lda entityXHi,y
    and #ENT_X_POS
    sta arg+1
    lda entityVelocity,y
    bmi .shift
    ADDI_D arg, arg, 15
.shift:
    REPEAT 4
    LSR_D arg
    REPEND
    lda arg
    sta ret+2 ;metatile x
    jsr MultiplyBy24
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    REPEAT 4
    LSR_D tmp
    REPEND
    lda tmp
    sta ret+3 ;metatile y
    ADD_D tmp, tmp, ret
    ADDI_D tmp, tmp, levelMap
    sty tmp+2
    ldy #0
    lda (tmp),y
    sta ret+1 ; metatile index
    tay
    lda metatiles+256*4,y
    ldy tmp+2
    lsr
    lsr
    sta ret ; behavior
    rts

    
ER_Mimrock subroutine
    jsr IsNearPlayerY
    bne hiding$
    lda entityVelocity,y
    bne hiding$
    lda #2
    sta entityVelocity,y
hiding$:
    jmp ER_Default

ER_RightCannon subroutine
ER_LeftCannon subroutine
    lda #SWITCH_TURRETS
    bit switches
    beq return$
    jsr IsNearPlayerY
    bne return$
    lda entityXHi+1,y
    bpl return$
    lda entityCount,y
    clc
    adc #1
    sta entityCount,y
    cmp #$10
    bne return$
    lda #0
    sta entityCount,y
    lda entityXHi,y
    sta entityXHi+1,y
    lda entityXLo,y
    sta entityXLo+1,y
    lda entityYHi,y
    and #~ENT_Y_INDEX
    ora #40
    sta entityYHi+1,y
    lda entityYLo,y
    sta entityYLo+1,y
return$:
    jmp ER_Return
    
    

ER_Bullet subroutine
    jsr HitWall
    lda ret
    cmp #TB_SOLID
    beq .die
    cmp #TB_WEAKBLOCK
    bne .notWeakBlock
    lda ret+2
    sta arg
    lda ret+3
    sta arg+2
    lda #0
    sta arg+1
    sta arg+3
    sta arg+4
    sty sav
    jsr SetTile
    ldy sav
    jmp .die
.notWeakBlock:
    cmp #TB_EGG
    bne .notEgg
    lda ret+2
    sta arg
    lda ret+3
    sta arg+2
    lda #0
    sta arg+1
    sta arg+3
    lda bonusCount
    and #7
    clc
    adc #BONUS_TILES
    sta arg+4
    inc bonusCount
    sty sav
    jsr SetTile
    ldy sav
.die:
    lda #$80
    sta entityXHi,y
    jmp ER_Return
.notEgg:

    jsr ApplyXVel
    lda entityCount,y
    clc
    adc #1
    sta entityCount,y
    cmp #$28
    bne done$
    
    lda entityVelocity,y
    bmi negative$
    clc
    adc #3
    sta entityVelocity,y
    jmp ER_Return
negative$:
    sec
    sbc #3
    sta entityVelocity,y
done$:
    jmp ER_Return

ER_VerticalPlatform:
ER_HorizontalPlatform:
ER_Spider:
ER_Bat:
ER_PowerShot:
ER_Cart:
ER_CaterpillarHead:
ER_CaterpillarFront:
ER_CaterpillarBack:
ER_CaterpillarTail:
ER_SlimeHorizontal:
ER_SlimeVertical:
ER_Hammer:
ER_Faucet:
ER_Water:
ER_VerticalPlatformIdle:
ER_HorizontalPlatformIdle:
ER_RightLaser:
ER_LeftLaser:
ER_Rex:
    jmp ER_Default

    
ER_Default subroutine

    lda entityFlags2,x
    and #ENT_F2_ISGROUNDED
    bne .checkfloor
    jmp .hitwall
.checkfloor:
    ;calculate map tile
    lda entityXLo,y
    sta arg
    lda entityXHi,y
    and #ENT_X_POS
    sta arg+1
    
    lda entityVelocity,y
    bmi .shift2
    ADDI_D arg, arg, 15
.shift2:
    REPEAT 4
    LSR_D arg
    REPEND
    jsr MultiplyBy24
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    ADDI_D tmp, tmp, 16
    REPEAT 4
    LSR_D tmp
    REPEND
    ADD_D tmp, tmp, ret
    ADDI_D tmp, tmp, levelMap
    sty tmp+2
    ldy #0
    lda (tmp),y
    tay
    lda metatiles+256*4,y
    ldy tmp+2
    lsr
    lsr
    cmp #TB_SOLID
    beq .hitwall
    cmp #TB_PLATFORM
    beq .hitwall
    jmp .reverse


.hitwall:
    ;calculate map tile
    lda entityXLo,y
    sta arg
    lda entityXHi,y
    and #ENT_X_POS
    sta arg+1
    lda entityVelocity,y
    bmi .shift
    ADDI_D arg, arg, 15
.shift:
    REPEAT 4
    LSR_D arg
    REPEND
    lda arg
    sta sav+1
    jsr MultiplyBy24
    
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    
    lda entityFlags,x
    and #ENT_F_ISVERTICAL
    beq .shiftY
    lda entityFlags,x
    and #ENT_F_ISPLATFORM
    beq .notPlatform
    lda entityVelocity,y
    bpl .notPlatform
    SUBI_D tmp, tmp, 15
    
.notPlatform:
    lda entityVelocity,y
    bmi .shiftY
    ADDI_D tmp, tmp, 15
.shiftY:
    REPEAT 4
    LSR_D tmp
    REPEND
    ADD_D tmp, tmp, ret
    ADDI_D tmp, tmp, levelMap
    sty tmp+2
    ldy #0
    lda (tmp),y
    sta sav
    tay
    lda metatiles+256*4,y
    ldy tmp+2
    lsr
    lsr
    sta sav+3
    
    ;react to map tile
    lda entityFlags,x
    and #ENT_F_ISPROJECTILE
    bne .checkImpact
    jmp .checkObstacle
    
.checkImpact:
    lda sav+3
    cmp #TB_SOLID
    beq .die
    cpy #0
    bne .notEgg
    cmp #TB_WEAKBLOCK
    bne .notWeakBlock
    lda sav+1
    sta arg
    lda sav+2
    sta arg+2
    lda #0
    sta arg+1
    sta arg+3
    lda #0
    sta arg+4
    tya
    pha
    jsr SetTile
    pla
    tay
    jmp .die
.longCheckDone
    jmp .tileCheckDone
.notWeakBlock:
    cmp #TB_EGG
    bne .notEgg
    lda sav+1
    sta arg
    lda sav+2
    sta arg+2
    lda #0
    sta arg+1
    sta arg+3
    lda bonusCount
    and #7
    clc
    adc #BONUS_TILES
    sta arg+4
    inc bonusCount
    tya
    pha
    jsr SetTile
    pla
    tay
    jmp .die
.notEgg:
    cmp #TB_PLATFORM
    bne .longCheckDone
    lda entityFlags,x
    and #ENT_F_ISVERTICAL
    beq .longCheckDone
    lda entityVelocity,y
    bmi .longCheckDone
.die:
    lda #$80
    sta entityXHi,y
    jmp .inactive
.noPause:

    jmp .inactive


.checkObstacle:    
    lda sav+3
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
    ; lda frame
    ; and #63
    ; bne .tileCheckDone
.reverse:
    lda frame
    and #2
    bne .noSwitch
    cpx #SLIME_ID
    beq .goVertical
    cpx #SLIME_ID+1
    beq .goHorizontal
    jmp .noSwitch
.goVertical:
    lda entityYHi,y
    clc
    adc #%10
    sta entityYHi,y
    jmp .noSwitch
.goHorizontal:
    lda entityYHi,y
    sec
    sbc #%10
    sta entityYHi,y
.noSwitch:
    lda #0
    cpx #HAMMER_ID
    bne .notHammer
    lda #5
.notHammer:
    sec
    sbc entityVelocity,y
    sta entityVelocity,y
    lda entityXHi,y
    and #~ENT_X_COUNT
    ora entityCounts,x
    sta entityXHi,y

.tileCheckDone:
    cpy #0
    beq .longimmortal

    lda entityXLo
    sta tmp
    lda entityXHi
    bmi .longimmortal
    and #ENT_X_POS
    sta tmp+1
    lda entityXLo,y
    sta tmp+2
    lda entityXHi,y
    and #ENT_X_POS
    sta tmp+3
    SUBI_D tmp, tmp, 8
    ADDI_D tmp+2, tmp+2, 8
    CMP_D tmp, tmp+2
    bcs .longimmortal
    ADDI_D tmp, tmp, 16
    SUBI_D tmp+2, tmp+2, 16
    CMP_D tmp, tmp+2
    bcc .longimmortal
    
    jmp .spam
.longimmortal:
    jmp .immortal
.spam:

    lda entityYLo
    sta tmp
    lda entityYHi
    and #ENT_Y_POS
    sta tmp+1
    lda entityYLo,y
    sta tmp+2
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+3
    SUBI_D tmp, tmp, 16
    ;ADDI_D tmp+2, tmp+2, 8
    CMP_D tmp, tmp+2
    bcs .longimmortal
    ADDI_D tmp, tmp, 16
    SUBI_D tmp+2, tmp+2, 16
    CMP_D tmp, tmp+2
    bcc .longimmortal
    
    ;destroy bullet
    lda entityFlags2,x
    and #ENT_F2_ISHITTABLE
    beq .longimmortal
    lda #$80
    sta entityXHi
    
    lda entityFlags,x
    and #ENT_F_ISMORTAL
    beq .longimmortal
    
    lda entityYHi
    lsr
    cmp #POWERSHOT_ID
    beq .reallyDead

    lda entityFlags2,x
    and #ENT_F2_NEEDPOWERSHOT
    bne .immortal

    lda entityHPs,x
    sta tmp
    lda entityXHi,y
    and #~ENT_X_HP
    sta tmp+1
    lda entityXHi,y
    and #ENT_X_HP
    lsr
    lsr
    clc
    adc #1
    cmp tmp
    bcc .notDead
.reallyDead:
    lda #$80
    sta entityXHi,y
    lda #10
    sta arg
    lda #0
    sta arg+1
    sta arg+2
    stx sav
    jsr AddScore
    ldx sav
    cpx #CATERPILLAR_ID
    beq .caterpillar
    jmp .inactive
.caterpillar:  
    lda caterpillarNext
    cmp #CATERPILLAR_ID+4
    bcc .segmentsleft 
    jmp .inactive
.segmentsleft:
    sty tmp
    ldy #0
.caterpillarLoop:
    lda entityYHi,y
    lsr
    cmp caterpillarNext
    bne .nodice
    lda entityYHi,y
    and #~ENT_Y_INDEX
    ora #CATERPILLAR_ID<<1
    sta entityYHi,y
    inc caterpillarNext
    jmp .inactive
.nodice:
    iny
    cpy #MAX_ENTITIES
    bne .caterpillarLoop
    ldy tmp
    jmp .inactive
.notDead:
    asl
    asl
    and #ENT_X_HP
    ora tmp+1
    sta entityXHi,y
.immortal:
.updateVel:
    lda entityFlags2,x
    and #ENT_F2_SWITCHID
    beq .notSwitchable
    stx tmp
    tax
    lda bits,x
    ldx tmp
    and switches
    bne .notSwitchable
    lda entityXHi,y
    ora #$10
    sta entityXHi,y
.notSwitchable:
    lda entityXHi,y
    REPEAT 4
    lsr
    REPEND
    beq .notPaused
    sec
    sbc #1
    REPEAT 4
    asl
    REPEND
    sta tmp
    lda frame
    and #31
    beq .updateCount
    jmp .inactive
.updateCount:
    lda entityXHi,y
    and #~ENT_X_COUNT
    ora tmp
    sta entityXHi,y
    jmp .inactive
.notPaused:
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sta tmp+1
    lda entityFlags,x
    and #ENT_F_ISVERTICAL
    beq .horizontal
    
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
.horizontal:
    lda entityVelocity,y
    and #1
    bne .extra
    lda entityVelocity,y
    jmp .noExtra
.extra:
    lda frame
    and #1
    bne .leapFrame
    lda entityVelocity,y
    jmp .noExtra
.leapFrame:
    lda entityVelocity,y
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
    sta tmp+2
    bmi .negative
    lda #0
    sta tmp+3
    jmp .continue
.negative:
    lda #$FF
    sta tmp+3
.continue:
    ADD_D tmp, tmp, tmp+2
    lda entityFlags,x
    and #ENT_F_ISVERTICAL
    bne .vertical
    lda tmp
    sta entityXLo,y
    lda entityXHi,y
    and #~ENT_X_POS
    ora tmp+1
    sta entityXHi,y
    cpy currPlatform
    bne .inactive
    ADD_D playerX, playerX, tmp+2
    jmp .inactive
.vertical:
    lda tmp
    sta entityYLo,y
    lda entityYHi,y
    and #~ENT_Y_POS
    ora tmp+1 ; just assuming that calculated y will never be out of bounds
    sta entityYHi,y
    cpy currPlatform
    bne .inactive
    ADD_D playerY, playerY, tmp+2
.inactive:
    jmp ER_Return
updateEntities_end:


ApplyVelocity subroutine
    MOV_D tmp, playerYVel
    lda playerYVel+1
    bmi .negativeY
    lda #0
    jmp .continueY
.negativeY:
    lda #$FF
.continueY:
    sta tmp+2
    clc
    lda tmp
    adc playerYFrac
    sta playerYFrac
    lda tmp+1
    adc playerY
    sta playerY
    lda tmp+2
    adc playerY+1
    sta playerY+1

    
    lda playerXVel
    sta tmp
    cmp #0
    bmi .negativeX
    lda #0
    jmp .continueX
.negativeX:
    lda #$FF
.continueX:
    sta tmp+1
    
    ADD_D playerX, playerX, tmp
ApplyVelocity_end:

UpdateCameraX subroutine
.Scroll_Left:
    ;no scrolling because player is not close to screen edge
    SUB_D sav, playerX, shr_cameraX
    lda sav ;player's on-screen x
    cmp #[MT_HSCROLL_MARGIN*PX_MT_WIDTH]
    bcs .Scroll_Left_end
    
    ;no scrolling because screen is at map edge
    lda shr_cameraX
    ora shr_cameraX+1
    beq .Scroll_Left_end
    
    ;scroll left one pixel
    DEC_D shr_cameraX
    inc sav
    
    ;no loading tiles if not at tile boundary
    lda shr_cameraX
    and #7
    bne .noTiles
    jsr LoadTilesOnMoveLeft
.noTiles:
    
    ;no loading attributes if not at attributes boundary
    lda shr_cameraX
    and #15
    cmp #15
    bne .Scroll_Left_end
    
    jsr LoadColorsOnMoveLeft
.Scroll_Left_end:

.Scroll_Right:
    ;no scrolling right because player not near screen edge
    lda sav ;player's on-screen x
    cmp #[[MT_VIEWPORT_WIDTH - MT_HSCROLL_MARGIN]*PX_MT_WIDTH]
    bcc .Scroll_Right_end
    
    ;no scrolling becuse screen is at map edge
    CMPI_D shr_cameraX, [[MT_MAP_WIDTH - MT_VIEWPORT_WIDTH]*PX_MT_WIDTH - 8]
    bcs .Scroll_Right_end
    
    ;scroll right 1 pixel
    INC_D shr_cameraX
    dec sav
    
    ;no loading tiles if not at tile boundary
    lda shr_cameraX
    and #7 ; 8-pixel boundaries
    cmp #1
    bne .Scroll_Right_end
    
    jsr LoadTilesOnMoveRight
    
    ;no loading tiles if not at tile boundary
    lda shr_cameraX
    and #15 ; 16-pixel boundaries
    cmp #1
    bne .Scroll_Right_end

    jsr LoadColorsOnMoveRight
.Scroll_Right_end:
UpdateCameraX_end:

UpdateCameraY subroutine
.Scroll_Up:
    SUB_D sav, playerY, shr_cameraY
    ;no scrolling because player not near screen edge
    lda sav ;player's on-screen y
    cmp #[MT_VSCROLL_MARGIN*PX_MT_HEIGHT]
    bcs .Scroll_Up_end
    
    ;no scrolling becuse screen is at map edge
    lda shr_cameraY
    ora shr_cameraY+1
    beq .Scroll_Up_end
    
    lda #[MT_VSCROLL_MARGIN*PX_MT_HEIGHT]
    sec
    sbc sav
    sta tmp
    lda #0
    sta tmp+1
    SUB_D shr_cameraY, shr_cameraY, tmp
    
    ;handle nametable boundary
    lda shr_cameraYMod
    cmp tmp
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
	sbc tmp
    sta shr_cameraYMod
.Scroll_Up_end:
    
.Scroll_Down:
    ;no scrolling because player not near screen edge
    SUB_D sav, playerY, shr_cameraY
    lda sav
    cmp #[[MT_VIEWPORT_HEIGHT - MT_VSCROLL_MARGIN]*PX_MT_HEIGHT]
    bcc .Scroll_Down_end
    
    ;no scrolling becuse screen is at map edge
    CMPI_D shr_cameraY, [[MT_MAP_HEIGHT - MT_VIEWPORT_HEIGHT]*PX_MT_HEIGHT]
    bcs .Scroll_Down_end
    
    ;scroll down one pixel
    lda sav ;player's on-screen y
    sec
    sbc #[[MT_VIEWPORT_HEIGHT - MT_VSCROLL_MARGIN]*PX_MT_HEIGHT]
    sta tmp
    lda #0
    sta tmp+1
    ADD_D shr_cameraY, shr_cameraY, tmp
    lda shr_cameraYMod
    clc
    adc tmp
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
UpdateCameraY_end:

UpdatePlayerSprite subroutine
    ;update position
    SUB_D sav, playerX, shr_cameraX
    lda sav
    clc
    adc #8
    sta shr_playerSprites+SPR_X
    clc
    adc #8
    sta shr_playerSprites+OAM_SIZE+SPR_X
    
    SUB_D sav, playerY, shr_cameraY
    lda sav
    clc
    adc #31
    sta shr_playerSprites+SPR_Y
    sta shr_playerSprites+OAM_SIZE+SPR_Y

    ;update tiles
    lda playerFrame
    clc
    adc playerXVel
    and #%00011111
    sta playerFrame

    lda playerFrame
    lsr
    lsr
    tax

    bit playerFlags
    bpl .walk_anim
    ldx #9
    jmp .do_anim

.walk_anim:
    lda #0
    cmp playerXVel
    bne .do_anim
    ldx #8

.do_anim:
    lda playerFlags
    and #PLY_ISFLIPPED
    sta shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+OAM_SIZE+SPR_FLAGS
    bit playerFlags
    bvs .left
.right:
    lda playerWalk,x
    sta shr_playerSprites+SPR_INDEX
    clc
    adc #2
    sta shr_playerSprites+OAM_SIZE+SPR_INDEX
    jmp .animEnd
.left:
    lda playerWalk,x
    sta shr_playerSprites+OAM_SIZE+SPR_INDEX
    clc
    adc #2
    sta shr_playerSprites+SPR_INDEX
.animEnd:

    lda mercyTime
    beq .notFlashing
    lda #$01
    ora shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+OAM_SIZE+SPR_FLAGS
.notFlashing:

    lda playerFlags
    and #PLY_ISBEHIND
    beq .notBehind
    lda #$20
    ora shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+OAM_SIZE+SPR_FLAGS
.notBehind:
    
    lda playerFlags
    and #PLY_ISUPSIDEDOWN
    beq .notUpsideDown
    lda #$80
    ora shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+OAM_SIZE+SPR_FLAGS
.notUpsideDown:

UpdatePlayerSprite_end:

UpdateEntitySprites subroutine
    lda #[shr_entitySprites-shr_oamShadow]
    sta startSprite
    ldy #[MAX_ENTITIES-1]
.loop:
    lda entityXHi,y
    bpl .active
    jmp .skip
.active:


    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    SUB_D sav, tmp, shr_cameraY
    lda sav+1
    beq .y_ok
    jmp .skip
.y_ok:
    
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sta tmp+1
    SUB_D sav+3, tmp, shr_cameraX
    lda sav+4
    beq .x_ok
    jmp .skip
.x_ok:
    
    lda entityYHi,y
    lsr
    tax
    lda entityTiles,x
    sta sav+1
    
    lda entityFlags,x
    and #ENT_F_COLOR
    lsr
    sta sav+2
        
    lda startSprite 
    sta tmp
    lda #$02
    sta tmp+1
    
    lda entityAnim,y
    asl
    tax
    lda animations,x
    sta tmp+6
    lda animations+1,x
    sta tmp+7
    sty tmp+2
    lda frame
    lsr
    lsr
    ldy #0
    and (tmp+6),y
    asl
    tay
    iny
    lda (tmp+6),y
    sta tmp+4
    iny
    lda (tmp+6),y
    sta tmp+5
    
    ldy #0
    lda (tmp+4),y
    sta tmp+6
    INC_D tmp+4
    
    ldx #0
.copyLoop:
    cpx tmp+6
    bcs .done
    ldy #0
    
.innerLoop:
    lda (tmp+4),y
    clc
    adc sav,y
    bcs .abort
    sta (tmp),y
    iny
    inx
    cpy #4
    bne .innerLoop
    
    lda #4
    clc
    adc tmp
    sta tmp
    
    ADDI_D tmp+4, tmp+4, 4
    
    jmp .copyLoop
.abort:
    sty tmp+3
    lda #4
    sec
    sbc tmp+3
    sta tmp+3
    txa
    clc
    adc tmp+3
    tax
    ADDI_D tmp+4, tmp+4, 4
    jmp .copyLoop
.done:
    lda tmp
    sta startSprite
    
    ldy tmp+2
.skip:
    dey
    bmi UpdateEntitySprites_end
    jmp .loop
UpdateEntitySprites_end

ClearSprites subroutine
    lda #$FF
    ldy startSprite
.loop:
    beq ClearSprites_end
    sta shr_oamShadow,y
    iny
    jmp .loop
ClearSprites_end:


    inc frame
    inc shr_doDma
    inc shr_doRegCopy
    jsr synchronize
    jmp MainLoop

;------------------------------------------------------------------------------
KillPlayer subroutine
    lda currLevel
    asl
    tay
    lda levelTable,y
    sta arg
    lda levelTable+1,y
    sta arg+1
    pla
    pla
    jmp EnterLevel
;------------------------------------------------------------------------------
DamagePlayer subroutine
    lda shr_hp
    bne .hurt
    jmp KillPlayer
.hurt:
    dec shr_hp
    lda #60
    sta mercyTime
    rts
;------------------------------------------------------------------------------
LoadTilesOnMoveRight subroutine
    ;get tile column on screen
    MOV_D tmp, shr_cameraX
    REPEAT 3
    LSR_D tmp
    REPEND
    lda tmp
    and #31
    clc
    adc #31
    and #31
    sta arg+2
    
    ;get map index
    ADDI_D tmp, tmp, 1
    LSR_D tmp
    ADDI_D tmp, tmp, 15
    MOV_D arg, tmp
    jsr MultiplyBy24 ;uses only arg 0..1
    ;keeping ret value for later
        
    MOVI_D arg, levelMap
    
    ADD_D arg, arg, ret
    
    lda shr_cameraX
    and #%00001000
    beq .odd
    jsr EvenColumn
    jmp .return
.odd:
    jsr OddColumn
.return:
    inc shr_doTileCol
    rts
;------------------------------------------------------------------------------
LoadTilesOnMoveLeft subroutine
    ;get tile column on screen
    MOV_D tmp, shr_cameraX
    REPEAT 3
    LSR_D tmp
    REPEND
    lda tmp
    and #31
    clc
    adc #31
    and #31
    sta arg+2
    
    ;get map index
    ADDI_D tmp, tmp, 1
    LSR_D tmp
    SUBI_D tmp, tmp, 1
    MOV_D arg, tmp
    jsr MultiplyBy24 ;uses only arg 0..1
    ;keeping ret value for later
        
    MOVI_D arg, levelMap
    
    ADD_D arg, arg, ret
    
    lda shr_cameraX
    and #%00001000
    beq .odd
    jsr EvenColumn
    jmp .return
.odd:
    jsr OddColumn
.return:
    inc shr_doTileCol
    rts
;------------------------------------------------------------------------------
LoadColorsOnMoveRight subroutine
    ;get tile column on screen
    MOV_D tmp, shr_cameraX
    REPEAT 4
    LSR_D tmp
    REPEND
    ADDI_D tmp, tmp, 15
    
    ;get index to attribute table
    lda tmp
    lsr
    and #7
    clc
    adc #7
    and #7
    sta arg+2
    
    ;get map index
    MOV_D arg, tmp
    jsr MultiplyBy24 ;uses only arg 0..1, keeping ret value for later
    ADDI_D arg, ret, levelMap
    
    lda shr_cameraX
    and #$10
    bne .unaligned
    SUBI_D arg, arg, [1*MT_MAP_HEIGHT]
    jsr ColorColumn
    inc shr_doAttrCol
    rts
.unaligned:
    jsr ColorWrappedColumn
    inc shr_doAttrCol
    rts
;------------------------------------------------------------------------------
LoadColorsOnMoveLeft subroutine
    ;get tile column on screen
    MOV_D tmp, shr_cameraX
    REPEAT 4
    LSR_D tmp
    REPEND
    
    ;get index to attribute table
    lda tmp
    lsr
    clc
    adc #7
    and #7
    sta arg+2
    
    ;get map index
    MOV_D arg, tmp
    jsr MultiplyBy24 ;uses only arg 0..1
    ADDI_D arg, ret, levelMap
    
    lda shr_cameraX
    and #$10
    bne .unaligned
    ;ADDI_D arg, arg, [3*MT_MAP_HEIGHT]
    jsr ColorColumn
    inc shr_doAttrCol
    rts
.unaligned:
    ADDI_D arg, arg, [15*MT_MAP_HEIGHT]
    jsr ColorWrappedColumn
    inc shr_doAttrCol
    rts
;------------------------------------------------------------------------------
GetTileBehavior ;arg0..1 = mt_x arg2..3 = mt_y ret0 = value
    jsr MultiplyBy24 ;takes arg0, which we no longer care about after this
                          ;returns
    ;t0 = y+ x*24
    ADD_D tmp, arg+2, ret
    
    ;lookup tile, get behavior
    ADDI_D tmp, tmp, levelMap
    ldy #0
    lda (tmp),y
    tay
    lda metatiles+256*4,y
    REPEAT 2
    lsr
    REPEND
    sta ret
    rts
;------------------------------------------------------------------------------
GetTile ;arg0..1 = mt_x arg2..3 = mt_y ret0 = value
    jsr MultiplyBy24 ;takes arg0, which we no longer care about after this
                          ;returns
    ;t0 = y+ x*24
    ADD_D tmp, arg+2, ret
    
    ;lookup tile, get behavior
    ADDI_D tmp, tmp, levelMap
    ldy #0
    lda (tmp),y
    sta ret
    rts
;------------------------------------------------------------------------------
SetTile ;arg0..1 = mt_x arg2..3 = mt_y, arg4 = value
    jsr MultiplyBy24
    ADDI_D ret, ret, levelMap
    ADD_D tmp, arg+2, ret
    lda arg+4
    ldy #0
    sta (tmp),y ;store updated tile into map
    
    ;update nametables
    lda shr_doTile
    beq .noWait
    jsr synchronize
.noWait:
    lda arg+4
    sta shr_tileMeta ;store tile for nametable update
    MOVI_D shr_tileAddr, [$2000+TOP_OFFSET]
    lda arg+2
    cmp #9
    bcc .upperTable
    MOVI_D shr_tileAddr, $2800
    SUBI_D arg+2, arg+2, 9
.upperTable:
    
    REPEAT 6
    ASL_D arg+2
    REPEND
    ADD_D shr_tileAddr, shr_tileAddr, arg+2
    
    ASL_D arg
    lda arg
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
MultiplyBy24: ;arg0..arg1 is factor, ret0..ret1 is result
    MOV_D ret, arg ; 1
    ASL_D ret
    ADD_D ret, ret, arg ;1
    ASL_D ret ;0
    ASL_D ret ;0
    ASL_D ret ;0
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
EvenColumn subroutine    
    ldy #0
    ldx #0
.first_loop
    sty tmp
    lda (arg),y
    tay
    lda metatiles,y
    sta shr_tileBuffer,x
    inx
    lda metatiles+512,y
    sta shr_tileBuffer,x
    inx
    ldy tmp
    iny
    cpx #TOP_HEIGHT
    bne .first_loop
    
    ADDI_D arg, arg, TOP_HEIGHT/2
    
    ldy #0
    ldx #0
.third_loop
    sty tmp
    lda (arg),y
    tay
    lda metatiles,y
    sta shr_tileBuffer+TOP_HEIGHT,x
    inx
    lda metatiles+512,y
    sta shr_tileBuffer+TOP_HEIGHT,x
    inx
    ldy tmp
    iny
    cpx #BOTTOM_HEIGHT
    bne .third_loop
    
    lda arg+2
    sta shr_tileCol
    rts
;------------------------------------------------------------------------------
;arg 0..1 -> rom address
;arg 2 -> nametable column
; 20 top 30 bottom, x2 right and left
OddColumn subroutine    
    ldy #0
    ldx #0
.second_loop
    sty tmp
    lda (arg),y
    tay
    lda metatiles+256,y
    sta shr_tileBuffer,x
    inx
    lda metatiles+768,y
    sta shr_tileBuffer,x
    inx
    ldy tmp
    iny
    cpx #TOP_HEIGHT
    bne .second_loop  
    
    ADDI_D arg, arg, TOP_HEIGHT/2
    
    ldy #0
    ldx #0
.fourth_loop
    sty tmp
    lda (arg),y
    tay
    lda metatiles+256,y
    sta shr_tileBuffer+TOP_HEIGHT,x
    inx
    lda metatiles+768,y
    sta shr_tileBuffer+TOP_HEIGHT,x
    inx
    ldy tmp
    iny
    cpx #BOTTOM_HEIGHT
    bne .fourth_loop 
    lda arg+2
    sta shr_tileCol
    
    rts
;------------------------------------------------------------------------------
;for revealing aligned columns - subtract 1 for moving viewport right
ColorColumn subroutine
    ldy #0
    ldx #0
.loop:
    cpx #TOP_ATTR_HEIGHT
    bne .no_partial
    dey
.no_partial:
    sty tmp
    
    lda (arg),y
    tay
    lda metatiles+256*4,y
    and #%00000011
    sta tmp+1
    
    
    ldy tmp
    iny
    sty tmp
    
    lda (arg),y
    tay
    lda metatiles+256*4,y
    and #%00000011
    REPEAT 4
    asl
    REPEND
    ora tmp+1
    sta tmp+1
    
    
    lda tmp
    clc
    adc #MT_MAP_HEIGHT-1
    tay
    sty tmp
    
    lda (arg),y
    tay
    lda metatiles+256*4,y
    and #%00000011
    REPEAT 2
    asl
    REPEND
    ora tmp+1
    sta tmp+1
    
    
    ldy tmp
    iny
    sty tmp
    
    lda (arg),y
    tay
    lda metatiles+256*4,y
    and #%00000011
    REPEAT 6
    asl
    REPEND
    ora tmp+1
    
    ;lda #%10101010
    sta shr_attrBuffer,x
    inx
    
    lda tmp
    sec
    sbc #MT_MAP_HEIGHT-1
    tay
    
    cpx #TOP_ATTR_HEIGHT+BOTTOM_ATTR_HEIGHT
    bne .loop
    rts
;------------------------------------------------------------------------------
;for revealing unaligned columns - add 15 for moving viewport left
ColorWrappedColumn subroutine
    ldy #0
    ldx #0
.loop:
    cpx #TOP_ATTR_HEIGHT
    bne .no_partial
    dey
.no_partial:
    sty tmp
    
    lda (arg),y
    tay
    lda metatiles+256*4,y
    and #%00000011
    sta tmp+1
    
    
    ldy tmp
    iny
    sty tmp
    
    lda (arg),y
    tay
    lda metatiles+256*4,y
    and #%00000011
    REPEAT 4
    asl
    REPEND
    ora tmp+1
    sta tmp+1
    
    
    ldy tmp
    dey
    sty tmp
    
    SUBI_D tmp+2, arg, [15*MT_MAP_HEIGHT]
    
    lda (tmp+2),y
    tay
    lda metatiles+256*4,y
    and #%00000011
    REPEAT 2
    asl
    REPEND
    ora tmp+1
    sta tmp+1
    
    
    ldy tmp
    iny
    sty tmp
    
    lda (tmp+2),y
    tay
    lda metatiles+256*4,y
    and #%00000011
    REPEAT 6
    asl
    REPEND
    ora tmp+1
    
    ;lda #%10101010
    sta shr_attrBuffer,x
    inx
    
    ldy tmp
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
AddScore subroutine ; arg 3 bytes value to add, A and X trashed
    ldx #0
.loop:
    lda arg,x
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
AddScore_end: