;------------------------------------------------------------------------------
; MAIN THREAD
;------------------------------------------------------------------------------

;map:
;underground bg element
;torch glow?

;sprites:
;falling rocks
;full-size hammers?
;explosions
;bonus fruit
;snake
;hopper
;bird
;triceratops
;stalk-eye
;rolling enemy
;robot
;wall snake
;flying alien wrench
;hidden crystal

;low gravity
;rex chasing
;strength mushroom melee
;more sounds
;music
;fades
;death animations
;full dump independent of nmi for brk handler?
;passwords?
;intro and ending
;test on hardware!
;door animation

;???
;parallaxing tiled backgrounds
;Hilltop style clouds on main map
;orbiting moon on map -- allow entities to switch between upper and lower 32?
;dynamically load small messages, e.g.: paused, hints
;separate top and bottom of main map to enable separate effects
;animated background objects
;move player into entity sprite space to share flickering
;flickering torch/pulsing lava emphasis effect
;mask right edge?


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
    jmp init_apu_end
.regs:
    .byte $30,$08,$00,$00 ;sq1
    .byte $30,$08,$00,$00 ;sq2
    .byte $80,$00,$00,$00 ;tri
    .byte $30,$00,$00,$00 ;noise
    .byte $00,$00,$00,$00 ;dmc
    .byte $00,$0F,$00,$40 ;ctrl
init_apu_end:

clearOAM subroutine
    lda #$FF
    ldy #0
.loop:
    dey
    sta shr_oamShadow,y
    bne .loop
clearOAM_end:
     
.vblankwait2:
    bit PPU_STATUS
    bpl .vblankwait2
;end reset subroutine

;setup nmi
    MOV16I shr_debugReg, $BEEF
    lda #<shr_copyBufferEnd
    sta shr_copyIndex
    jsr StartQueue
    lda #0
    sta PPU_MASK
    lda #1
    sta shr_earlyExit
    lda #PPU_CTRL_SETTING
    sta PPU_CTRL

    SELECT_BANK 0
LoadTitle subroutine
    MOV16I arg, titleTiles
    SET_PPU_ADDR VRAM_PATTERN_R
    ldx #16
    jsr PagesToPPU
    
    MOV16I arg, titleNames
    SET_PPU_ADDR VRAM_NAME_UL
    ldx #4
    jsr PagesToPPU
    
    ldy #15
    SET_PPU_ADDR VRAM_PALETTE_BG
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

    jsr QEnableDisplay
    jsr Synchronize
    
.waitForPress:
    jsr read_joy
    cmp #0
    beq .waitForPress
    
    jsr QDisableDisplay
    jsr Synchronize
DoTitleScreen_end:

LoadPatterns subroutine
    MOV16I arg, globalTiles
    SET_PPU_ADDR VRAM_PATTERN_L
    ldx #24
    jsr PagesToPPU
LoadPatterns_end:

InitNametables subroutine
    ldy #$A0
    SET_PPU_ADDR VRAM_NAME_UL
.clear_upper
    sta PPU_DATA
    dey
    bne .clear_upper

    ldy #$00
    SET_PPU_ADDR VRAM_NAME_UL
.load_hud
    lda hud,y
    sta PPU_DATA
    iny
    cpy #$80
    bne .load_hud

    SET_PPU_ADDR VRAM_ATTRIB_UL
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
    lda #62
    sta shr_spriteIndex,y
    lda #%00100000
    sta shr_spriteFlags,y
    REPEAT OAM_SIZE
    iny
    REPEND
    cpy #8*OAM_SIZE
    bne .loop

InitSpritePalette subroutine
    ldx shr_copyIndex
    
    ldy #11
.loop
    lda palettes,y
    PHXA
    dey
    bpl .loop

    ENQUEUE_ROUTINE nmi_Copy12
    ENQUEUE_PPU_ADDR [VRAM_PALETTE_SP+4]
    
    stx shr_copyIndex

    jsr Synchronize
;------------------------------------------------------------------------------
;New Game
;------------------------------------------------------------------------------
    lda #MAP_LEVEL
    sta currLevel
    lda #5
    sta ammo
    lda #0
    sta score
    sta score+1
    sta score+2
    lda #INVALID_MAP_STAT
    sta mapAmmo
    sta mapPX+1
    sta mapPY+1
    sta mapScore+2
    MOV16I arg, mainMap
;------------------------------------------------------------------------------
;Start of Level
;------------------------------------------------------------------------------
EnterLevel:
DisableDisplay subroutine
    jsr Synchronize
    jsr QDisableDisplay
    jsr Synchronize
    jsr QEnableSplitDisplay
DisableDisplay_end:

ResetStats subroutine
    lda #4
    sta switches
    lda #3
    sta hp
    jsr UpdateHeartsDisplay
    lda #MAX_ENTITIES
    sta currPlatform
    lda #0
    sta paused
    sta powerFrames
    sta powerSeconds
    sta powerType
    sta bonusCount
    sta crystalsLeft
    sta playerFlags
    sta playerYVel
    sta playerYVel+2
    lda #8
    sta shr_tempo
    ; lda #<testDrumSequence
    ; sta shr_musicStreamLo
    ; lda #>testDrumSequence
    ; sta shr_musicStreamHi
    ; lda #<testBassSequence
    ; sta shr_musicStreamLo+1
    ; lda #>testBassSequence
    ; sta shr_musicStreamHi+1
    
ResetStats_end:

LoadLevelTileset subroutine
    SELECT_BANK 2
    lda currLevel
    asl
    tay
    lda levelTilesets,y
    sta arg
    lda levelTilesets+1,y
    sta arg+1
    SET_PPU_ADDR [VRAM_PATTERN_R+2048]
    ldx #8
    jsr PagesToPPU

    
LoadLevelPal subroutine
    SELECT_BANK 0
    ldx shr_copyIndex
    
    lda currLevel
    asl
    tay
    lda levelPalettes,y
    sta tmp
    lda levelPalettes+1,y
    sta tmp+1
    ldy #19
.loop
    lda (tmp),y
    PHXA
    dey
    bpl .loop

    ENQUEUE_ROUTINE nmi_Copy20
    ENQUEUE_PPU_ADDR VRAM_PALETTE_BG
    
    stx shr_copyIndex
LoadLevelPal_end:

LoadLevel subroutine
    lda currLevel
    tax
    ldy levelBanks,x
    lda banktable,y
    sta banktable,y
    
    lda currLevel
    asl
    tay
    
    lda levelPointers,y
    sta sav
    lda levelPointers+1,y
    sta sav+1

    SUB16I tmp+2,sav,64
    MOV16I tmp,[levelMap-64]
    ldy #64
    ldx #4
.loop:
    lda (tmp+2),y
    sta (tmp),y
    sty tmp+4
    tay
    lda metatiles+256*4,y
    lsr
    lsr
    cmp #TB_CRYSTAL
    bne .notCrystal
    inc crystalsLeft
.notCrystal:
    ldy tmp+4
    iny
    bne .loop
    ADD16I tmp+2,tmp+2,256
    ADD16I tmp,tmp,256
    dex
    bne .loop

    ldx #MAX_ENTITIES-1
    lda #$80
.clearEntities:
    sta entityXHi,x
    dex
    bpl .clearEntities

    ADD16I tmp, sav, 960
    ldy #0
    ldx #RESERVED_ENTITIES
.entityLoop:
    lda (tmp),y
    iny
    cmp #$FF
    bne .notEnd
    jmp LoadLevel_end
.notEnd:
;get player start
    cmp #$FE
    bne .notPlayer
    lda (tmp),y
    iny
    sta playerX
    lda #0
    sta playerX+1
    REPEAT 4
    ASL16 playerX
    REPEND
    lda (tmp),y
    iny
    sta playerY
    lda #0
    sta playerY+1
    sta playerYFrac
    REPEAT 4
    ASL16 playerY
    REPEND
    jmp .entityLoop
.notPlayer:
;get door locations
    cmp #$FB
    bcc .notDoor
    sec
    sbc #$FB
    stx tmp+2
    tax
    lda (tmp),y
    iny
    sta doorsX,x
    lda (tmp),y
    iny
    sta doorsY,x
    ldx tmp+2
    jmp .entityLoop
.notDoor:
;get normal entity
    asl
    sta entityYHi,x
    lda (tmp),y
    iny
    sta tmp+2
    lda #0
    sta tmp+3
    REPEAT 4
    ASL16 tmp+2
    REPEND
    lda tmp+2
    sta entityXLo,x
    lda tmp+3
    sta entityXHi,x
    lda (tmp),y
    iny
    sta tmp+2
    lda #0
    sta tmp+3
    REPEAT 4
    ASL16 tmp+2
    REPEND
    lda tmp+2
    sta entityYLo,x
    lda tmp+3
    ora entityYHi,x
    sta entityYHi,x
    inx
    
    ;reserve children
    lsr
    stx tmp+2
    tax
    lda entityFlags,x
    and #ENT_F_CHILDREN
    REPEAT ENT_F_CHILDREN_SHIFT
    lsr
    REPEND
    clc
    adc tmp+2
    tax
    cpx #MAX_ENTITIES
    bcc .noOverflow
    brk
.noOverflow:
    jmp .entityLoop
LoadLevel_end:

LoadMapState subroutine
    lda currLevel
    cmp #MAP_LEVEL
    bne LoadMapState_end
    lda mapScore+2
    cmp #INVALID_MAP_STAT
    beq .keepStuff
    lda mapAmmo
    sta ammo
    MOV16 score, mapScore
    lda mapScore+2
    sta score+2
.keepStuff:
    lda mapPX+1
    cmp #INVALID_MAP_STAT
    beq LoadMapState_end
    MOV16 playerX, mapPX
    MOV16 playerY, mapPY
LoadMapState_end:

    jsr UpdateAmmoDisplay
    jsr UpdateScoreDisplay

InitCamera subroutine
    SUB16I shr_cameraX,playerX,128
    lda shr_cameraX+1
    bpl .notOffLeft
    MOV16I shr_cameraX,0
.notOffLeft:
    CMP16I shr_cameraX,[640-256-8]
    bcc .notOffRight
    MOV16I shr_cameraX,[640-256-8]
.notOffRight:
    
    SUB16I shr_cameraY,playerY,104
    lda shr_cameraY+1
    bpl .notOffTop
    MOV16I shr_cameraY,0
.notOffTop:
    CMP16I shr_cameraY,[384-208]
    bcc .notOffBottom
    MOV16I shr_cameraY,[384-208]
.notOffBottom:
    lda #0
    sta shr_nameTable
    ADD16I tmp,shr_cameraY,96
    lda tmp
    sta shr_cameraYMod
    CMP16I tmp,240
    bcc .notLow
    lda #$08
    sta shr_nameTable
    SUB16I tmp,tmp,240
    lda tmp
    sta shr_cameraYMod
.notLow:
    lda shr_cameraX
    and #$E0
    sta shr_cameraX

InitCamera_end:
    
InitEntities subroutine
    ldy #0
    ldx #0
.loop:
    lda entityYHi,y
    lsr
    tax
    
;init caterpillar segments
    cmp #CATERPILLAR_ID
    bne .notCaterpillar
    lda entityYHi,y
    clc
    adc #2
    sta entityYHi+1,y
    adc #2
    sta entityYHi+2,y
    adc #2
    sta entityYHi+3,y
    
    lda entityYLo,y
    sta entityYLo+1,y
    sta entityYLo+2,y
    sta entityYLo+3,y
    
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    sta tmp+1
    
    ADD16I tmp,tmp,16
    lda tmp
    sta entityXLo+1,y
    lda tmp+1
    sta entityXHi+1,y
    
    ADD16I tmp,tmp,16
    lda tmp
    sta entityXLo+2,y
    lda tmp+1
    sta entityXHi+2,y
    
    ADD16I tmp,tmp,16
    lda tmp
    sta entityXLo+3,y
    lda tmp+1
    sta entityXHi+3,y
.notCaterpillar:

;move hammers over
    cmp #HAMMER_ID
    bne .notHammer
    lda entityXLo,y
    clc
    adc #8
    sta entityXLo,y
    lda entityXHi,y
    adc #0
    sta entityXHi,y
.notHammer
    
    lda #0
    sta entityCount,y
    lda entitySpeeds,x
    sta entityVelocity,y
    lda entityInitialAnims,x
    sta entityAnim,y
    iny
    cpy #MAX_ENTITIES
    beq InitEntities_end
    jmp .loop
InitEntities_end:

LoadNametables subroutine
    MOV16 arg, shr_cameraX
    REPEAT 4
    LSR16 arg
    REPEND
    jsr MultiplyBy24
    ADD16I sav, ret, levelMap
    ldy #0
    MOV16 sav+2, shr_cameraX
    REPEAT 3
    LSR16 sav+2
    REPEND
        
.loop:
    ;args to buffer column    
    MOV16 arg, sav
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
    jsr CopyTileCol     ;terribly unsafe
    pla
    tay
    
    MOV16 arg, sav
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
    jsr CopyTileCol     ;ditto
    pla
    tay
    
    iny
    ADD16I sav, sav, 23
    cpy #16
    bne .loop
LoadNametables_end:

InitAttributes subroutine
    MOV16 arg, shr_cameraX
    REPEAT 4
    LSR16 arg
    REPEND
    jsr MultiplyBy24
    ADD16I arg, ret, levelMap
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
    jsr CopyAttrCol
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
    ;jsr Synchronize
ReenableDisplay_end:

;------------------------------------------------------------------------------
;Every Frame
;------------------------------------------------------------------------------
MainLoop:
UpdateInput subroutine
    lda ctrl
    sta oldCtrl
    jsr read_joy
    sta ctrl
    and oldCtrl
    eor ctrl
    sta pressed
UpdateInput_end:

Paused subroutine
    lda paused
    beq Paused_end
    lda pressed
    and #JOY_START_MASK
    beq .StartNotPressed
    lda #0
    sta paused
    lda #0
    sta arg
    lda crystalsLeft
    bne .notGreen
    lda currLevel
    cmp #MAP_LEVEL
    beq .notGreen
    lda #ALL_CRYSTALS_EFFECT
    sta arg
.notGreen:
    jsr QColorEffect
    jmp MainLoop
.StartNotPressed:
    lda pressed
    and #JOY_SELECT_MASK
    beq .SelectNotPressed
    lda #INVALID_MAP_STAT
    sta mapPX+1
    jmp doExit
.SelectNotPressed:
    lda #$E1
    sta arg
    lda frame
    and #$3F
    cmp #$1F
    bcs .light
    lda #1
    sta arg
.light
    jsr QColorEffect
    jsr Synchronize
    inc frame
    jmp MainLoop
Paused_end:

CheckInput subroutine
    lda #0
    sta playerXVel
.start:
    lda pressed
    and #JOY_START_MASK
    beq .left
    lda #1
    sta paused
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
    MOV16I playerYVel, JUMP_VELOCITY
    lda powerType
    cmp #POWER_GRAVITY
    bne .notUpsideDown
    MOV16I playerYVel, -JUMP_VELOCITY
.notUpsideDown:
    lda playerFlags
    ora #PLY_ISJUMPING
    sta playerFlags
    MOV16I arg, sfxJump
    jsr PlaySound
CheckInput_end:

TileInteraction subroutine
    lda playerFlags
    and #~PLY_ISBEHIND
    sta playerFlags

    ;a0 = x in tiles
    ADD16I arg, playerX, 7
    REPEAT 4
    LSR16 arg
    REPEND
    lda arg
    sta sav+1
    ;a2 = y in tiles
    ADD16I arg+2, playerY, 7
    REPEAT 4
    LSR16 arg+2
    REPEND
    lda arg+2
    sta sav+2
    
    jsr MultiplyBy24 ;takes arg0, which we no longer care about after this
                          ;returns
    ;t0 = y+ x*24
    ADD16 tmp, arg+2, ret
    
    ;lookup tile, get behavior
    ADD16I tmp, tmp, levelMap
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
    .word TC_Strength
    .word TC_Powershot
    .word TC_Gravity
    .word TC_Key
    .word TC_Stop
    .word TC_Chest
    .word TC_Crystal ;crystal
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
    
TC_Crystal:
    MOV16I arg,sfxCrystal
    jsr PlaySound
    dec crystalsLeft
    bne .notDone
    lda #ALL_CRYSTALS_EFFECT
    sta arg
    jsr QColorEffect
.notDone:
    lda #0
    sta arg+2
    sta arg+1
    lda #5
    sta arg
    jsr AddScore
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
    
    lda #0
    sta sav
    jmp TC_UpdateTile
TC_Points_end:

TC_Key:
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
    JEQ TC_Return
    
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
    lda ammo
    clc
    adc #5
    sta ammo
    jsr UpdateAmmoDisplay
    lda #0
    sta sav
    jmp TC_UpdateTile
TC_Ammo_end:

TC_Powershot:
    lda #10
    sta powerSeconds
    lda #60
    sta powerFrames
    lda #POWER_SHOT
    sta powerType
    lda #0
    sta sav
    jsr UpdatePowerDisplay
    jmp TC_UpdateTile
TC_Powershot_end:

TC_Strength:
    lda #15
    sta powerSeconds
    lda #60
    sta powerFrames
    lda #POWER_STRENGTH
    sta powerType
    lda #0
    sta sav
    jsr UpdatePowerDisplay
    jmp TC_UpdateTile
TC_Strength_end:

TC_Gravity:
    lda #10
    sta powerSeconds
    lda #60
    sta powerFrames
    lda #POWER_GRAVITY
    sta powerType
    lda #0
    sta sav
    jsr UpdatePowerDisplay
    jmp TC_UpdateTile
TC_Gravity_end:

TC_Stop:
    lda #20
    sta powerSeconds
    lda #60
    sta powerFrames
    lda #POWER_STOP
    sta powerType
    lda #0
    sta sav
    jsr UpdatePowerDisplay
    jmp TC_UpdateTile
TC_Stop_end:

TC_Foreground:
    lda playerFlags
    ora #PLY_ISBEHIND
    sta playerFlags
    jmp TC_Return
TC_Foreground_end:

TC_Exit:
    lda crystalsLeft
    JNE TC_Return
    
    lda #INVALID_MAP_STAT
    sta mapAmmo
    sta mapScore+2
    
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
    MOV16 mapPX, playerX
    MOV16 mapPY, playerY
    lda ammo
    sta mapAmmo
    MOV16 mapScore, score
    lda score+2
    sta mapScore+2
    jmp EnterLevel
TC_Entrance_end:
    
TC_Hidden:
    CMP16I playerYVel,0
    bpl .notJumping
    lda #HIDDEN_TILE
    sta sav
    jmp TC_UpdateTile
.notJumping:
    jmp TC_Return
TC_Hidden_end:
    
TC_Lock:
    lda #JOY_B_MASK
    and pressed
    JEQ TC_Return
    
    lda sav+3
    sec
    sbc #TB_LOCK
    tay
    lda doorsX,y
    sta sav+4
    sta arg
    lda doorsY,y
    sta sav+5
    sta arg+2
    lda #0
    sta arg+1
    sta arg+3
    sta arg+4
    jsr SetTile
    lda sav+4
    sta arg
    lda sav+5
    sta arg+2
    inc arg+2
    lda #0
    sta arg+1
    sta arg+3
    sta arg+4
    jsr SetTile
    inc sav
    jmp TC_UpdateTile
TC_Lock_end:

TC_On:
    lda #JOY_B_MASK
    and pressed
    JEQ TC_Return
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
    JEQ TC_Return
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
    JEQ TileInteraction_end
    bit entityXHi
    JPL TileInteraction_end
    lda powerType
    cmp #POWER_SHOT
    beq .InfiniteAmmo
    lda ammo
    JEQ TileInteraction_end
    dec ammo
    jsr UpdateAmmoDisplay
.InfiniteAmmo
    MOV16I arg, sfxShoot
    jsr PlaySound
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
    lda #ANIM_ROCKET
    sta entityAnim
    lda #0
    sta entityCount
    lda powerType
    cmp #POWER_SHOT
    bne .notPowerShot
    lda #POWERSHOT_ID<<1
    ora entityYHi
    sta entityYHi
    lda #ANIM_POWERSHOT
    sta entityAnim
.notPowerShot
    
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
    lda powerType
    cmp #POWER_GRAVITY
    beq .reverseGravity
    CMP16I playerYVel, TERMINAL_VELOCITY
    bpl ApplyGravity_end
    ADD16I playerYVel, playerYVel, GRAVITY
    jmp ApplyGravity_end
.reverseGravity:
    CMP16I playerYVel, -TERMINAL_VELOCITY
    bmi ApplyGravity_end
    SUB16I playerYVel, playerYVel, GRAVITY
ApplyGravity_end:


CheckLeft subroutine
    ;skip if not moving left (>= 0)
    lda playerXVel
    cmp #0
    bpl CheckLeft_end

    CMP16I playerX, 1
    bcc .hit
    
    ADD16I arg, playerX, PLAYER_HLEFT
    ADD16I arg+2, playerY, PLAYER_HTOP
    jsr TestCollision
    bcs .hit
    ADD16I arg, playerX, PLAYER_HLEFT
    ADD16I arg+2, playerY, PLAYER_HBOTTOM
    jsr TestCollision
    bcs .hit
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

    CMP16I playerX, [MT_MAP_WIDTH*PX_MT_WIDTH - 16]
    bcs .hit

    ADD16I arg, playerX, PLAYER_HRIGHT
    ADD16I arg+2, playerY, PLAYER_HTOP
    jsr TestCollision
    bcs .hit
    ADD16I arg, playerX, PLAYER_HRIGHT
    ADD16I arg+2, playerY, PLAYER_HBOTTOM
    jsr TestCollision
    bcs .hit
    jmp CheckRight_end
.hit:
    lda #0
    sta playerXVel
CheckRight_end:

CheckGround subroutine
    ;skip if not moving down (< 0)
    CMP16I playerYVel, 0
    JMI CheckGround_end

    lda powerType
    cmp #POWER_GRAVITY
    beq .upsideDown
    lda playerFlags
    ora #PLY_ISJUMPING
    sta playerFlags
.upsideDown:
    lda playerY
    and #$F
    cmp #8
    bcs .checkSpriteHit

    ADD16I arg, playerX, [PLAYER_HRIGHT-1]
    ADD16I arg+2, playerY, 16
    jsr TestCollisionTop
    bcs .hitGroundTile
    ADD16I arg, playerX, [PLAYER_HLEFT+1]
    ADD16I arg+2, playerY, 16
    jsr TestCollisionTop
    bcs .hitGroundTile
    
    jmp .checkSpriteHit
.hitGroundTile:
    lda playerY
    and #$F0
    sta playerY
    jmp .hit_ground

.checkSpriteHit:
    ldy #MAX_ENTITIES
    sty currPlatform
.loop:
    dey
    JMI CheckGround_end
    
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
    
    ADD16I tmp+2, playerX, 4
    SUB16I tmp, tmp, 8
    CMP16 tmp, tmp+2
    bpl .loop
    
    SUB16I tmp+2, playerX, 4
    ADD16I tmp, tmp, 16
    CMP16 tmp, tmp+2
    bmi .loop
    
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    
    SUB16I tmp, tmp, 15
    CMP16 tmp, playerY
    bmi .longLoop

    SUB16I tmp, tmp, 2
    CMP16 tmp, playerY
    bpl .longLoop
    
    jmp .hitSprite
.longLoop:
    jmp .loop
.hitSprite:
    
    ADD16I playerY, tmp, 1
    sty currPlatform
.hit_ground: ;stop if moving down
    lda #0
    sta playerYVel
    sta playerYVel+1
    sta playerYFrac
    lda powerType
    cmp #POWER_GRAVITY
    beq CheckGround_end
    lda playerFlags
    and #~PLY_ISJUMPING
    sta playerFlags
CheckGround_end:

CheckCieling subroutine

    ;skip if not moving up (>= 0)
    CMP16I playerYVel, 0
    JPL CheckCieling_end

    lda powerType
    cmp #POWER_GRAVITY
    beq .notUpsideDown
    lda playerFlags
    ora #PLY_ISJUMPING
    sta playerFlags
.notUpsideDown:


    ;hit head on top of screen
    CMP16I playerY, 8
    bcc .hit
    
    ADD16I arg, playerX, [PLAYER_HLEFT+1]
    SUB16I arg+2, playerY, 0
    jsr TestCollision
    bcs .hit
    ADD16I arg, playerX, [PLAYER_HRIGHT-1]
    SUB16I arg+2, playerY, 0
    jsr TestCollision
    bcs .hit
    jmp CheckCieling_end
.hit:
    ;handle girder
    ADD16I arg, playerX, PLAYER_HCENTER
    SUB16I arg+2, playerY, 0
    REPEAT 4
    LSR16 arg
    LSR16 arg+2
    REPEND
    jsr MultiplyBy24
    ADD16 tmp, arg+2, ret
    ADD16I tmp, tmp, levelMap
    ldy #0
    lda (tmp),y
    tay
    lda metatiles+256*4,y
    REPEAT 2
    lsr
    REPEND
    cmp #TB_GIRDER_LEFT
    bcc .normal
    cmp #TB_GIRDER_RIGHT+1
    bcs .normal
    sta sav
    
    MOV16 tmp+2,arg
    MOV16 tmp+4,arg+2
    REPEAT 4
    ASL16 tmp+2
    ASL16 tmp+4
    REPEND
    ldx #1
    lda tmp+2
    sta entityXLo,x
    lda tmp+3
    sta entityXHi,x
    lda tmp+4
    sta entityYLo,x
    lda tmp+5
    ora #GIRDER_ID<<1
    sta entityYHi,x
    lda #0
    sta entityCount,x
    lda arg+2
    sta entityVelocity,x
    lda sav
    sec
    sbc #TB_GIRDER_LEFT
    clc
    adc #ANIM_GIRDER_LEFT
    sta entityAnim,x

    
    ldy #0
    lda (tmp),y
    ora #1
    sta arg+4
    jsr SetTile
    
    
    
.normal:
    MOV16I playerYVel, 0
    lda #0
    sta playerYFrac
    lda playerY
    and #$F0
    ora #$F
    sta playerY
    lda powerType
    cmp #POWER_GRAVITY
    JNE CheckCieling_end
    lda playerFlags
    and #~PLY_ISJUMPING
    sta playerFlags
    
    
CheckCieling_end:
    
CheckHurt subroutine
    lda mercyTime
    beq CheckHurt_end
    dec mercyTime
    jmp CheckHurt_end
CheckHurt_end:


ApplyVelocity subroutine
    MOV16 tmp,playerYVel
    EXTEND tmp+1,playerYVel+1
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

    
    EXTEND tmp,playerXVel   
    ADD16 playerX, playerX, tmp
ApplyVelocity_end:

UpdateCameraX subroutine
.Scroll_Left:
    ;no scrolling because player is not close to screen edge
    SUB16 sav, playerX, shr_cameraX
    lda sav ;player's on-screen x
    cmp #[MT_HSCROLL_MARGIN*PX_MT_WIDTH]
    bcs .Scroll_Left_end
    
    ;no scrolling because screen is at map edge
    lda shr_cameraX
    ora shr_cameraX+1
    beq .Scroll_Left_end
    
    ;scroll left one pixel
    DEC16 shr_cameraX
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
    CMP16I shr_cameraX, [[MT_MAP_WIDTH - MT_VIEWPORT_WIDTH]*PX_MT_WIDTH - 8]
    bcs .Scroll_Right_end
    
    ;scroll right 1 pixel
    INC16 shr_cameraX
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
    SUB16 sav, playerY, shr_cameraY
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
    SUB16 shr_cameraY, shr_cameraY, tmp
    lda shr_cameraY+1
    bpl .notminus
    lda #0
    sta shr_cameraY
    sta shr_cameraY+1
.notminus:
    lda #0
    sta shr_nameTable
    ADD16I tmp,shr_cameraY,96
    lda tmp
    sta shr_cameraYMod
    CMP16I tmp,240
    bcc .notLow
    lda #$08
    sta shr_nameTable
    SUB16I tmp,tmp,240
    lda tmp
    sta shr_cameraYMod
.notLow:
    
.Scroll_Up_end:
    
.Scroll_Down:
    ;no scrolling because player not near screen edge
    SUB16 sav, playerY, shr_cameraY
    lda sav
    cmp #[[MT_VIEWPORT_HEIGHT - MT_VSCROLL_MARGIN]*PX_MT_HEIGHT]
    bcc .Scroll_Down_end
    
    ;no scrolling becuse screen is at map edge
    CMP16I shr_cameraY, [[MT_MAP_HEIGHT - MT_VIEWPORT_HEIGHT]*PX_MT_HEIGHT]
    bcs .Scroll_Down_end
    
    ;scroll down one pixel
    lda sav ;player's on-screen y
    sec
    sbc #[[MT_VIEWPORT_HEIGHT - MT_VSCROLL_MARGIN]*PX_MT_HEIGHT]
    sta tmp
    lda #0
    sta tmp+1
    ADD16 shr_cameraY, shr_cameraY, tmp
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

UpdatePower subroutine
    lda powerSeconds
    beq UpdatePower_end
    dec powerFrames
    bne UpdatePower_end
    lda #60
    sta powerFrames
    dec powerSeconds
    bne .display
    lda #0
    sta powerType
.display:
    jsr UpdatePowerDisplay
UpdatePower_end:

UpdateEntities subroutine
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

    cpy #0
    beq .noStop
    lda powerType
    cmp #POWER_STOP
    bne .noStop
    jmp .offScreen
.noStop:

.xtest:
    lda entityFlags,x
    and #ENT_F_SKIPXTEST
    bne .ytest
    lda entityXLo,y
    sec
    sbc shr_cameraX
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sbc shr_cameraX+1
    sta tmp+1
    CMP16I tmp, [MT_VIEWPORT_WIDTH*PX_MT_WIDTH + PX_MT_WIDTH]
    bpl .offScreen
    CMP16I tmp, -PX_MT_WIDTH
    bmi .offScreen
.ytest:
    lda entityFlags,x
    and #ENT_F_SKIPYTEST
    bne .persistent
    lda entityYLo,y
    sec
    sbc shr_cameraY
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sbc shr_cameraY+1
    sta tmp+1
    CMP16I tmp, [MT_VIEWPORT_HEIGHT*PX_MT_HEIGHT + PX_MT_HEIGHT]
    bpl .offScreen
    CMP16I tmp, -PX_MT_HEIGHT
    bmi .offScreen
    jmp .persistent
.offScreen:
    lda entityFlags,x
    and #ENT_F_ISTEMPORARY
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
    JMI updateEntities_end
    jmp .loop
    
    include entities.asm

updateEntities_end:


UpdatePlayerSprite subroutine
    ;update position
    SUB16 sav, playerX, shr_cameraX
    lda sav
    clc
    adc #8
    sta shr_playerSprites+SPR_X
    clc
    adc #8
    sta shr_playerSprites+OAM_SIZE+SPR_X
    
    SUB16 sav, playerY, shr_cameraY
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
    ora #1
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
    lda frame
    and #3
    eor shr_playerSprites+SPR_FLAGS
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
    
    lda powerType
    cmp #POWER_GRAVITY
    bne .notUpsideDown
    lda #$80
    ora shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+SPR_FLAGS
    sta shr_playerSprites+OAM_SIZE+SPR_FLAGS
.notUpsideDown:

UpdatePlayerSprite_end:

ClearSprites subroutine
    ldy #0
    lda #$FF
.loop:
    sta shr_entitySprites,y
    iny
    cpy #32*OAM_SIZE
    bne .loop
ClearSprites_end:

UpdateEntitySprites subroutine
    SELECT_BANK 3
    lda startSprite
    and #$7C
    ora #$80
    sta sav+5
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
    SUB16 sav, tmp, shr_cameraY
    lda sav+1
    beq .y_ok
    jmp .skip
.y_ok:
    
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sta tmp+1
    SUB16 sav+3, tmp, shr_cameraX
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
    sta sav+2
        
    lda sav+5
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
    
    cpy #0
    beq .noStop
    lda powerType
    cmp #POWER_STOP
    bne .noStop
    lda #0
    jmp .getFrame
.noStop:
    lda frame
    lsr
    lsr
.getFrame:
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
    INC16 tmp+4
    
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
    and #$7F
    ora #$80
    sta tmp
    
    
    ADD16I tmp+4, tmp+4, 4
    
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
    ADD16I tmp+4, tmp+4, 4
    jmp .copyLoop
.done:
    lda tmp
    sta sav+5
    
    ldy tmp+2
.skip:
    dey
    bmi UpdateEntitySprites_end
    jmp .loop
UpdateEntitySprites_end

    lda startSprite
    clc
    adc #21*4
    sta startSprite
    inc frame
    jsr Synchronize
    jmp MainLoop

;------------------------------------------------------------------------------
KillPlayer subroutine
    pla
    pla
    lda mapAmmo
    sta ammo
    MOV16 score, mapScore
    lda mapScore+2
    sta score
    jmp EnterLevel
;------------------------------------------------------------------------------
DamagePlayer subroutine
    lda mercyTime
    bne .invulnerable
    lda powerType
    cmp #POWER_STRENGTH
    beq .invulnerable
.hurt:
    dec hp
    jsr UpdateHeartsDisplay
    lda #60
    sta mercyTime
    lda hp
    bne .invulnerable
    jmp KillPlayer
.invulnerable:
    rts
;------------------------------------------------------------------------------
LoadTilesOnMoveRight subroutine
    ;get tile column on screen
    MOV16 tmp, shr_cameraX
    REPEAT 3
    LSR16 tmp
    REPEND
    lda tmp
    and #31
    clc
    adc #31
    and #31
    sta arg+2
    
    ;get map index
    ADD16I tmp, tmp, 1
    LSR16 tmp
    ADD16I tmp, tmp, 15
    MOV16 arg, tmp
    jsr MultiplyBy24 ;uses only arg 0..1
    ;keeping ret value for later
        
    MOV16I arg, levelMap
    
    ADD16 arg, arg, ret
    
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
    MOV16 tmp, shr_cameraX
    REPEAT 3
    LSR16 tmp
    REPEND
    lda tmp
    and #31
    clc
    adc #31
    and #31
    sta arg+2
    
    ;get map index
    ADD16I tmp, tmp, 1
    LSR16 tmp
    SUB16I tmp, tmp, 1
    MOV16 arg, tmp
    jsr MultiplyBy24 ;uses only arg 0..1
    ;keeping ret value for later
        
    MOV16I arg, levelMap
    
    ADD16 arg, arg, ret
    
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
    MOV16 tmp, shr_cameraX
    REPEAT 4
    LSR16 tmp
    REPEND
    ADD16I tmp, tmp, 15
    
    ;get index to attribute table
    lda tmp
    lsr
    and #7
    clc
    adc #7
    and #7
    sta arg+2
    
    ;get map index
    MOV16 arg, tmp
    jsr MultiplyBy24 ;uses only arg 0..1, keeping ret value for later
    ADD16I arg, ret, levelMap
    
    lda shr_cameraX
    and #$10
    bne .unaligned
    SUB16I arg, arg, [1*MT_MAP_HEIGHT]
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
    MOV16 tmp, shr_cameraX
    REPEAT 4
    LSR16 tmp
    REPEND
    
    ;get index to attribute table
    lda tmp
    lsr
    clc
    adc #7
    and #7
    sta arg+2
    
    ;get map index
    MOV16 arg, tmp
    jsr MultiplyBy24 ;uses only arg 0..1
    ADD16I arg, ret, levelMap
    
    lda shr_cameraX
    and #$10
    bne .unaligned
    ;ADD16I arg, arg, [3*MT_MAP_HEIGHT]
    jsr ColorColumn
    inc shr_doAttrCol
    rts
.unaligned:
    ADD16I arg, arg, [15*MT_MAP_HEIGHT]
    jsr ColorWrappedColumn
    inc shr_doAttrCol
    rts
;------------------------------------------------------------------------------
GetTileBehavior ;arg0..1 = mt_x arg2..3 = mt_y ret0 = value
    jsr MultiplyBy24 ;takes arg0, which we no longer care about after this
                          ;returns
    ;t0 = y+ x*24
    ADD16 tmp, arg+2, ret
    
    ;lookup tile, get behavior
    ADD16I tmp, tmp, levelMap
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
    jsr MultiplyBy24 ;takes arg0
    ;t0 = y+ x*24
    ADD16 tmp, arg+2, ret
    
    ;lookup tile
    ADD16I tmp, tmp, levelMap
    ldy #0
    lda (tmp),y
    sta ret
    rts
;------------------------------------------------------------------------------
SetTile ;arg0..1 = mt_x arg2..3 = mt_y, arg4 = value
    PUSH16 sav
    jsr MultiplyBy24
    ADD16I ret, ret, levelMap
    ADD16 tmp, arg+2, ret
    lda arg+4
    ldy #0
    sta (tmp),y ;store updated tile into map
    
    MOV16 tmp,shr_cameraX
    REPEAT 4
    LSR16 tmp
    REPEND
    CMP16 arg, tmp
    bpl .notBefore
    jmp .end
.notBefore:
    ADD16I tmp, tmp, MT_VIEWPORT_WIDTH
    CMP16 arg, tmp
    bmi .notAfter
    jmp .end
.notAfter:

    MOV16I sav, [VRAM_NAME_UL+TOP_OFFSET]
    lda arg+2
    cmp #9
    bcc .upperTable
    MOV16I sav, VRAM_NAME_LL
    SUB16I arg+2, arg+2, 9
.upperTable:
    
    REPEAT 6
    ASL16 arg+2
    REPEND
    ADD16 sav, sav, arg+2
    
    ASL16 arg
    lda arg
    and #31
    clc
    adc sav
    sta sav
    lda #0
    adc sav+1
    sta sav+1
    
    ldx shr_copyIndex
    ldy arg+4
    
    lda metatiles+256,y
    PHXA
    lda metatiles,y
    PHXA
    lda #>[nmi_Copy2-1]
    PHXA
    lda #<[nmi_Copy2-1]
    PHXA
    lda sav
    PHXA
    lda sav+1
    PHXA
    
    lda metatiles+768,y
    PHXA
    lda metatiles+512,y
    PHXA
    ADD16I sav,sav,32
    lda #>[nmi_Copy2-1]
    PHXA
    lda #<[nmi_Copy2-1]
    PHXA
    lda sav
    PHXA
    lda sav+1
    PHXA
    
    stx shr_copyIndex
    
.end:
    POP16 sav
    rts
;------------------------------------------------------------------------------
MultiplyBy24: ;arg0..arg1 is factor, ret0..ret1 is result
    MOV16 ret, arg ; 1
    ASL16 ret
    ADD16 ret, ret, arg ;1
    ASL16 ret ;0
    ASL16 ret ;0
    ASL16 ret ;0
    rts
;------------------------------------------------------------------------------
Synchronize subroutine  
    inc shr_sleeping
.loop
    lda shr_sleeping
    bne .loop
StartQueue subroutine
    ldx shr_copyIndex
    lda #>END_COPY
    PHXA
    lda #<END_COPY
    PHXA
    lda #0
    PHXA
    PHXA
    stx shr_copyIndex
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
    
    ADD16I arg, arg, TOP_HEIGHT/2
    
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
    
    ADD16I arg, arg, TOP_HEIGHT/2
    
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
    
    SUB16I tmp+2, arg, [15*MT_MAP_HEIGHT]
    
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
CentToDec subroutine ;input in A, output ones to A, tens to Y
    ldy #0
.loop:
    cmp #10
    bcc .end
    sbc #10
    iny
    jmp .loop
.end:
    rts
;------------------------------------------------------------------------------
AddScore subroutine ; arg 3 bytes value to add, A and X trashed
    ldx #0
.loop:
    lda arg,x
    clc
    adc score,x
    cmp #100
    bcc .foo
    sbc #100
    inc score+1,x
.foo
    sta score,x
    inx
    cpx #3
    bne .loop
    
UpdateScoreDisplay subroutine

    lda score
    jsr CentToDec
    sta tmp
    tya
    sta tmp+1
    lda score+1
    jsr CentToDec
    sta tmp+2
    tya
    sta tmp+3
    lda score+2
    jsr CentToDec
    sta tmp+4
    tya
    sta tmp+5
    
    ldy #5
.prefixloop:
    lda tmp,y
    bne .nonzero
    lda #$10
    sta tmp,y
    dey
    bpl .prefixloop
.nonzero    

    ldx shr_copyIndex
    
    ldy #0
.pushloop:
    lda tmp,y
    PHXA
    iny
    cpy #6
    bne .pushloop
    
    lda #>[nmi_Copy6-1]
    PHXA
    lda #<[nmi_Copy6-1]
    PHXA
    
    lda #$65
    PHXA
    lda #$20
    PHXA 
    
    stx shr_copyIndex
    
    
    rts
;------------------------------------------------------------------------------
UpdateAmmoDisplay subroutine
    ldx shr_copyIndex

    lda ammo
    jsr CentToDec
    PHXA
    tya
    bne .nonzero
    ora #$10
.nonzero
    PHXA
    
    lda #>[nmi_Copy2-1]
    PHXA
    lda #<[nmi_Copy2-1]
    PHXA
    
    lda #$71
    PHXA
    lda #$20
    PHXA 
    
    stx shr_copyIndex

    rts
;------------------------------------------------------------------------------
UpdatePowerDisplay subroutine
    ldx shr_copyIndex

    lda powerSeconds
    beq .none
    jsr CentToDec
    PHXA
    tya
    PHXA
    jmp .finish
.none:
    lda #$10
    PHXA
    PHXA
.finish:

    lda #>[nmi_Copy2-1]
    PHXA
    lda #<[nmi_Copy2-1]
    PHXA
    
    lda #$7A
    PHXA
    lda #$20
    PHXA 
    
    stx shr_copyIndex

    rts
;------------------------------------------------------------------------------
UpdateHeartsDisplay subroutine
    ldx shr_copyIndex
    
    ldy #3
.loop:
    cpy hp
    beq .heart
    bcs .no_heart
.heart:
    lda #$11
    PHXA
    jmp .continue_loop
.no_heart:
    lda #$10
    PHXA
.continue_loop:
    dey
    bne .loop

    
    lda #>[nmi_Copy3-1]
    PHXA
    lda #<[nmi_Copy3-1]
    PHXA
    
    lda #$76
    PHXA
    lda #$20
    PHXA
    
    stx shr_copyIndex
    
    rts
;------------------------------------------------------------------------------
CopyAttrCol subroutine
    lda shr_tileCol
    lsr
    lsr
    sta tmp+2

;top
    lda #<TOP_ATTR_OFFSET
    sta tmp
    lda #>TOP_ATTR_OFFSET
    sta tmp+1
    clc
    lda tmp
    adc tmp+2
    sta tmp
    lda tmp+1
    adc #0
    sta tmp+1

    ldy #0
    bit PPU_STATUS
    
    REPEAT TOP_ATTR_HEIGHT
    lda tmp+1
    sta PPU_ADDR
    lda tmp
    sta PPU_ADDR
    lda shr_attrBuffer,y
    sta PPU_DATA
    iny
    ADD16I tmp, tmp, 8
    REPEND
    
;bottom    
    lda #<BOTTOM_ATTR_OFFSET
    sta tmp
    lda #>BOTTOM_ATTR_OFFSET
    sta tmp+1
    clc
    lda tmp
    adc tmp+2
    sta tmp
    lda tmp+1
    adc #0
    sta tmp+1
    
    REPEAT BOTTOM_ATTR_HEIGHT
    lda tmp+1
    sta PPU_ADDR
    lda tmp
    sta PPU_ADDR
    lda shr_attrBuffer,y
    sta PPU_DATA
    iny
    ADD16I tmp, tmp, 8
    REPEND
    rts
;------------------------------------------------------------------------------
CopyTileCol subroutine
    ;vertical mode
    lda #PPU_CTRL_SETTING | %00000100
    sta PPU_CTRL

;top nametable
    bit PPU_STATUS
    lda #>[$2000+TOP_OFFSET]
    sta PPU_ADDR
    lda shr_tileCol
    clc
    adc #<[$2000+TOP_OFFSET]
    sta PPU_ADDR
    ldy #0
    REPEAT TOP_HEIGHT
    lda shr_tileBuffer,y
    sta PPU_DATA
    iny
    REPEND
    
    ;bottom nametable
    lda #$28
    sta PPU_ADDR
    lda shr_tileCol
    sta PPU_ADDR
    REPEAT BOTTOM_HEIGHT
    lda shr_tileBuffer,y
    sta PPU_DATA
    iny
    REPEND
    lda #PPU_CTRL_SETTING & %11111011
   rts
;------------------------------------------------------------------------------
PagesToPPU subroutine ;PPU_ADDR set, x = number of 256 byte quantities, arg = address
    ldy #0
.innerloop:
    lda (arg),y
    sta PPU_DATA
    iny
    bne .innerloop
    ADD16I arg, arg, 256
    dex
    bne .innerloop
    rts
;------------------------------------------------------------------------------
TestCollisionTop subroutine
    REPEAT 4
    LSR16 arg
    LSR16 arg+2
    REPEND
    
    jsr GetTileBehavior
    lda ret
    cmp #TB_SOLID
    beq .hit
    cmp #TB_GIRDER_LEFT
    beq .hit
    cmp #TB_GIRDER_MIDDLE
    beq .hit
    cmp #TB_GIRDER_RIGHT
    beq .hit
    cmp #TB_WEAKBLOCK
    beq .hit
    cmp #TB_PLATFORM
    beq .hit
    cmp #TB_EXIT
    bne .nohit
    lda crystalsLeft
    bne .hit
.nohit
    clc
    rts
.hit:
    sec
    rts    
;------------------------------------------------------------------------------
TestCollision subroutine
    REPEAT 4
    LSR16 arg
    LSR16 arg+2
    REPEND
    
    jsr GetTileBehavior
    lda ret
    cmp #TB_SOLID
    beq .hit
    cmp #TB_GIRDER_LEFT
    beq .hit
    cmp #TB_GIRDER_MIDDLE
    beq .hit
    cmp #TB_GIRDER_RIGHT
    beq .hit
    cmp #TB_WEAKBLOCK
    beq .hit
    cmp #TB_EXIT 
    bne .nohit
    lda crystalsLeft
    bne .hit
.nohit
    clc
    rts
.hit:
    sec
    rts
;------------------------------------------------------------------------------
PlaySound subroutine
    MOV16 shr_sfxPtr,arg
    rts
;------------------------------------------------------------------------------
QDisableDisplay subroutine
    ldx shr_copyIndex
    lda #1
    PHXA
    lda #0
    PHXA
    ENQUEUE_ROUTINE nmi_UpdateMask
    ENQUEUE_PPU_ADDR $0000
    stx shr_copyIndex
    rts
;------------------------------------------------------------------------------
QEnableDisplay subroutine
    ldx shr_copyIndex
    lda #1
    PHXA
    lda #PPU_MASK_SETTING
    PHXA
    ENQUEUE_ROUTINE nmi_UpdateMask
    ENQUEUE_PPU_ADDR $0000
    stx shr_copyIndex
    rts
    ;------------------------------------------------------------------------------
QEnableSplitDisplay subroutine
    ldx shr_copyIndex
    lda #0
    PHXA
    lda #PPU_MASK_SETTING
    PHXA
    ENQUEUE_ROUTINE nmi_UpdateMask
    ENQUEUE_PPU_ADDR $0000
    stx shr_copyIndex
    rts
;------------------------------------------------------------------------------
QColorEffect subroutine
    ldx shr_copyIndex
    lda #0
    PHXA
    lda #PPU_MASK_SETTING
    ora arg
    PHXA
    ENQUEUE_ROUTINE nmi_UpdateMask
    ENQUEUE_PPU_ADDR $0000
    stx shr_copyIndex
    rts