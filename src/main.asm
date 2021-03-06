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
    stx APU_FRAME  ;; disable APU frame IRQ
    ldx #$ff
    txs        ;; Set up stack
    inx        ;; now X = 0
    stx PPU_CTRL  ;; disable NMI
    stx PPU_MASK  ;; disable rendering
    stx APU_DMC_FREQ  ;; disable DMC IRQs
 
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
 
    jsr ResetAPU

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

LoadTitle subroutine
    SELECT_BANK 0
    MOV16I arg, titleTiles
    SET_PPU_ADDR VRAM_PATTERN_R
    ldx #16
    jsr PagesToPPU
    
    MOV16I arg, titleNames
    SET_PPU_ADDR VRAM_NAME_UL
    ldx #4
    jsr PagesToPPU
    
LoadTitle_end:

DoTitleScreen subroutine
    jsr QEnableStaticDisplay
    MOV16I arg+2, titlePalette
    jsr FadeInBg
    ldx #TITLE_LEVEL<<1
    jsr StartMusic
    jsr WaitForPress
DoTitleScreen_end:

DoMenu subroutine
    jsr ResetAPU
    jsr OpenTextBox
.resume:
    MOV16I arg,menuText
    MOV16I arg+2,[VRAM_NAME_UL + 32*5 + TEXT_MARGIN]
    jsr Print
    jsr QEnableStaticDisplay
    jsr Synchronize
    
    lda #0
    sta sav
    ldx #SFX_TEXTBOX
    jsr PlaySound
.WaitForPress:
    jsr UpdateInput
    jsr UpdateSound
    jsr Synchronize
    lda pressed
    and #[JOY_A_MASK | JOY_B_MASK | JOY_START_MASK]
    beq .CheckMove
    jmp .select
.CheckMove:
    lda pressed
    and #[JOY_DOWN_MASK | JOY_SELECT_MASK | JOY_UP_MASK]
    bne .move
    jmp .WaitForPress
.move:
    lda sav
    sta arg
    lda #0
    sta arg+1
    jsr ClearCursor
    
    lda pressed
    and #JOY_UP_MASK
    bne .up
    lda sav
    clc
    adc #1
    and #3
    sta sav
    jmp .redraw
.up:
    lda sav
    sec
    sbc #1
    and #3
    sta sav
.redraw:
    lda sav
    sta arg
    lda #0
    sta arg+1
    jsr DrawCursor
    
    jmp .WaitForPress
    
.select:
    lda sav
    cmp #0
    beq .newgame
    cmp #2
    beq .instructions
    cmp #3
    beq .story
    jmp PasswordEntry ;sav = 1
.newgame:
    jsr ResetAPU
    MOV16I arg+2, textPalette
    jsr FadeOutBg     
    jsr QDisableDisplay
    jsr Synchronize
    jmp NewGame
.story:
    jsr QDisableDisplay
    jsr Synchronize
    MOV16I arg,storyText
    jsr PrintPages
    jsr QDisableDisplay
    jsr Synchronize
    jsr EmptyTextBox
    jmp .resume
.instructions:
    jsr QDisableDisplay
    jsr Synchronize
    MOV16I arg,helpText
    jsr PrintPages
    jsr QDisableDisplay
    jsr Synchronize
    jsr EmptyTextBox
    jmp .resume
DoMenu_end:

passwordChars:
    .byte "123A456B789C#0*D"
PasswordEntry subroutine
    jsr ResetAPU
    jsr QDisableDisplay
    jsr Synchronize
    jsr EmptyTextBox
    
    SELECT_BANK 3
    MOV16I arg,passwordText
    MOV16I arg+2,[VRAM_NAME_UL + 32*5 + TEXT_MARGIN]
    jsr Print

    jsr QEnableStaticDisplay
    jsr Synchronize
    
    lda #0
    sta sav ;cursor y
    sta sav+1 ;cursor x
    sta sav+2 ;password index
    ;password chars
    sta password
    sta password+1
    sta password+2
    sta password+3
    sta password+4
    sta password+5
    sta password+6
    sta password+7
    sta password+8
    sta password+9
    sta password+$A
    sta password+$B
    
    ldx #SFX_TEXTBOX
    jsr PlaySound
.WaitForPress:
    jsr UpdateInput
    jsr UpdateSound
    jsr Synchronize
    lda pressed
    and #JOY_SELECT_MASK
    beq .NotBack
    jmp DoMenu
.NotBack:
    lda pressed
    and #JOY_START_MASK
    beq .NotEnter
    ;must have entered a complete password
    lda sav+2
    cmp #$C
    bcc .NotEnter
    jmp .verify
.NotEnter:
    lda pressed
    and #[JOY_A_MASK | JOY_B_MASK]
    beq .CheckMove
    jmp .select
.CheckMove:
    lda pressed
    and #[JOY_DOWN_MASK | JOY_UP_MASK | JOY_LEFT_MASK | JOY_RIGHT_MASK]
    bne .move
    jmp .WaitForPress
.move:

    lda sav
    clc
    adc #1
    sta arg
    lda sav+1
    clc
    adc #3
    sta arg+1
    jsr ClearCursor


    lda pressed
    and #JOY_UP_MASK
    beq .NotUp
    dec sav
.NotUp:

    lda pressed
    and #JOY_LEFT_MASK
    beq .NotLeft
    dec sav+1
.NotLeft:

    lda pressed
    and #JOY_DOWN_MASK
    beq .NotDown
    inc sav
.NotDown:

    lda pressed
    and #JOY_RIGHT_MASK
    beq .NotRight
    inc sav+1
.NotRight:
    
    lda sav+1
    and #3
    sta sav+1
    lda sav
    and #3
    sta sav
    
.redraw:
    lda sav
    clc
    adc #1
    sta arg
    lda sav+1
    clc
    adc #3
    sta arg+1
    jsr DrawCursor

    jmp .WaitForPress
    
.select:
    lda sav+2
    sta tmp
    
    lda pressed
    and #JOY_B_MASK
    beq .NotDelete
    lda sav+2
    beq .abort
    lda #$FF
    sta password,x
    lda #"_"
    dec sav+2
    dec tmp
    jmp .draw
    
.NotDelete:
    lda sav+2
    cmp #12
    bcs .abort
    ldx sav+2    
    lda sav
    REPEAT 2
    asl
    REPEND
    ora sav+1
    sta password,x
    tax
    lda passwordChars,x
    inc sav+2

    
.draw:
    ldx shr_copyIndex
    PHXA
    ENQUEUE_ROUTINE nmi_Copy1
    lda #0
    sta tmp+1
    ADD16I tmp,tmp,[VRAM_NAME_UL + 32*9 + TEXT_MARGIN+7]
    lda tmp
    PHXA
    lda tmp+1
    PHXA
    stx shr_copyIndex
    
.abort:
    jmp .WaitForPress
    
    
.verify:


;interleave nybbles at x and x+6 into odd and even bits of a byte respectively
    ldx #11
.spreadPairs:
    lda password,x
    asl
    asl
    ora password,x
    and #%00110011
    sta password,x
    dex
    bpl .spreadPairs
    
    ldx #11
.spreadSingles:
    lda password,x
    asl
    ora password,x
    and #%01010101
    sta password,x
    dex
    bpl .spreadSingles
    
    ldx #5
.interleave:
    lda password,x
    asl
    ora password+6,x
    sta savedStats,x
    dex
    bpl .interleave ;x = -1 at end
    
;rotate bytes
.rotate:
    lsr savedStats+5
    ror savedStats+4
    ror savedStats+3
    ror savedStats+2
    ror savedStats+1
    ror savedStats
    bcc .nocarry
    lda savedStats+5
    ora #$80
    sta savedStats+5
.nocarry:
    inx
    beq .rotate ;rotate twice: x = -1, x = 0
    
    ;check that centennial numbers are in range
    lda mapAmmo
    cmp #100
    bcs .fail
    lda mapScore
    cmp #100
    bcs .fail
    lda mapScore+1
    cmp #100
    bcs .fail
    lda mapScore+2
    cmp #100
    bcs .fail
    ;no instant-win password
    lda cleared
    and cleared+1
    cmp #$FF
    beq .fail
    
    ;restored game
    lda mapAmmo
    sta ammo
    lda mapScore
    sta score
    lda mapScore+1
    sta score+1
    lda mapScore+2
    sta score+2
    lda #MAP_LEVEL
    sta currLevel
    lda #INVALID_MAP_STAT
    sta mapPX+1
    sta mapPY+1
    jsr ResetAPU
    jsr QDisableDisplay
    jsr Synchronize
    jmp RestoreGame
    
.fail:
    jsr ResetAPU
    jsr QDisableDisplay
    jsr Synchronize
    
    SELECT_BANK 3
    MOV16I arg,failText
    MOV16I arg+2,[VRAM_NAME_UL + 32*20 + TEXT_MARGIN]
    jsr Print

    jsr QEnableStaticDisplay
    jsr Synchronize
    jmp .WaitForPress
.good:
    jmp DoMenu

PasswordEntry_end:

;------------------------------------------------------------------------------
;New Game
;------------------------------------------------------------------------------
NewGame:
    lda #INTRO_LEVEL
    sta currLevel
    lda #5
    sta ammo
    sta mapAmmo
    lda #0
    sta score
    sta score+1
    sta score+2
    sta mapScore
    sta mapScore+1
    sta mapScore+2
    sta cleared
    sta cleared+1
    lda #INVALID_MAP_STAT
    sta mapPX+1
    sta mapPY+1
RestoreGame:
LoadPatterns subroutine
    SELECT_BANK 0
    MOV16I arg, globalTiles
    SET_PPU_ADDR VRAM_PATTERN_L
    ldx #24
    jsr PagesToPPU
LoadPatterns_end:

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
    jsr Synchronize
;------------------------------------------------------------------------------
;Start of Level
;------------------------------------------------------------------------------
EnterLevel:
DisableDisplay subroutine
    jsr ClearSounds
    jsr ResetAPU
    jsr Synchronize
    jsr QDisableDisplay
    jsr Synchronize
DisableDisplay_end:

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

LoadLevel subroutine
    ;to be calculated from tile map
    lda #0
    sta crystalsLeft
    lda #[4|8] ;cannons and lights on
    sta switches

    lda currLevel
    tax
    ldy levelBanks,x
    lda banktable,y
    sta banktable,y
    sty currBank
    
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
    cmp #TB_OFF+3
    bne .notLightswitch
    lda switches
    and #~8
    sta switches
.notLightswitch
    cmp #TB_MAPDOOR
    bcc .notEntrance
    sec
    sbc #TB_MAPDOOR
    cmp #8
    bcc .lower
    sbc #8
    tay
    lda bits+1,y
    and cleared+1
    beq .not_cleared
    jmp .cleared
.lower:
    tay
    lda bits+1,y
    and cleared
    beq .not_cleared
.cleared:
    lda #CLEARED_DOOR_TILE
    ldy tmp+4
    sta (tmp),y
.not_cleared:
    
.notEntrance:
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
    lda #PLAYER_ID<<1
    sta entityYHi+PLAYER_INDEX
    jmp .entityLoop
.notPlayer:
;get intro player start
    cmp #$F9
    bne .notKiwi
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
    lda #KIWI_ID<<1
    sta entityYHi+PLAYER_INDEX
    jmp .entityLoop
.notKiwi:
;get farm player start
    cmp #$F8
    bne .notFarmer
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
    lda #FARMMYLO_ID<<1
    sta entityYHi+PLAYER_INDEX
    jmp .entityLoop
.notFarmer:
;get door locations
    cmp #$FA
    bcc .notDoor
    sec
    sbc #$FA
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
    
    sty sav
    PUSH_BANK
    SELECT_BANK 3
    
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
    POP_BANK
    ldy sav
    jmp .entityLoop
LoadLevel_end:
        
InitEntities subroutine
    SELECT_BANK 3
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

;move hammers and signs over
    cmp #SIGN_ID
    beq .sortahammer
    cmp #HAMMER_ID
    bne .notHammer
.sortahammer:
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
    sta entityFrame,y
    lda entitySpeeds,x
    sta entityVelocity,y
    lda entityInitialAnims,x
    sta entityAnim,y
    iny
    cpy #MAX_ENTITIES
    beq InitEntities_end
    jmp .loop
InitEntities_end:

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

ResetStats subroutine
    lda #3
    sta hp
    lda #0
    sta powerFrames
    sta powerSeconds
    sta powerType
    sta bonusCount
    sta playerFlags
    sta playerYVel
    sta playerYVel+2
    sta fruitTime
    sta fruitTime+1
    sta random
    sta random+1
    sta messageTime
    sta messagePtr+1
    sta messageCursor
    
    lda currLevel
    cmp #5
    bne .NormalGravity
    lda #PLY_UPSIDEDOWN
    sta playerFlags
.NormalGravity:
    
    SELECT_BANK 3
    lda currLevel
    asl
    tax
    jsr StartMusic
ResetStats_end:

    jsr ClearStatusBar
    lda currLevel
    cmp #MAP_LEVEL+1
    bcs .noHUD
    jsr InitHUD
.noHUD:
    jsr ResetCamera
    jsr InitialDrawLevel

ReenableDisplay subroutine
    jsr QEnableSplitDisplay
    jsr UpdateSprites
    lda switches
    and #8
    beq .dark
    jsr FadeIn
    jmp ReenableDisplay_end
.dark:
    lda #$20
    sta arg
    jsr QLoadDarkenedLevelColors
    ;jsr Synchronize
ReenableDisplay_end:

;------------------------------------------------------------------------------
;Every Frame
;------------------------------------------------------------------------------
MainLoop:

HandleExit subroutine
    lda exitTriggered
    beq HandleExit_end
    lda messageTime
    bne HandleExit_end
doExit:
    jsr FadeOut
    lda cleared
    and cleared+1
    cmp #$FF
    bne .notdone
    lda currLevel
    cmp #END_LEVEL
    bne .gotoendscene
    lda #FARM_LEVEL
    sta currLevel
    jmp .continue
.gotoendscene:
    lda #END_LEVEL
    sta currLevel
    jmp .continue
.notdone:
    lda #MAP_LEVEL
    sta currLevel
.continue:
    lda #0
    sta exitTriggered
    jmp EnterLevel
HandleExit_end:

    inc frame
    jsr UpdateInput
    jsr UpdateSound

CheckSpecialButtons subroutine
    lda playerFlags
    and #PLY_LOCKED
    JNE CheckSpecialButtons_end
    lda pressed
    and #JOY_START_MASK
    JEQ CheckSpecialButtons_end
    PUSH_BANK
    jsr ResetAPU
    jsr OpenTextBox
    MOV16I arg,mapPauseText
    lda currLevel
    cmp #MAP_LEVEL
    beq .MapLevel
    MOV16I arg,pauseText
.MapLevel:
    MOV16I arg+2,[VRAM_NAME_UL + 32*5 + TEXT_MARGIN]
    jsr Print
    
    ldx #5
.copyStats:
    lda savedStats,x
    sta password,x
    dex
    bpl .copyStats ;x= -1 at end

.rotate:
    asl password
    rol password+1
    rol password+2
    rol password+3
    rol password+4
    rol password+5
    bcc .nocarry
    lda password
    ora #1
    sta password
.nocarry:
    inx
    beq .rotate ;rotate twice: x = -1, x = 0
    
    ldx #5
.deinterleave:
    lda password,x
    and #%01010101
    sta password+6,x
    lda password,x
    and #%10101010
    lsr
    sta password,x
    dex
    bpl .deinterleave
    
    ldx #11
.combinePairs:
    lda password,x
    lsr
    ora password,x
    and #%00110011
    sta password,x
    dex
    bpl .combinePairs

    ldx #11
.combineNybbles:
    lda password,x
    lsr
    lsr
    ora password,x
    and #%00001111
    sta password,x
    dex
    bpl .combineNybbles

    SET_PPU_ADDR [VRAM_NAME_UL + 32*13 + TEXT_MARGIN+8]
    ldx #0
.printPassword:
    lda password,x
    tay
    lda passwordChars,y
    sta PPU_DATA
    inx
    cpx #12
    bne .printPassword
    
.show:
    jsr QEnableStaticDisplay
    SELECT_BANK 0
    lda #0
    sta arg
    sta arg+1
    MOV16I arg+2,textPalette
    jsr QLoadDarkenedBgColors
    jsr Synchronize

    ldx #SFX_TEXTBOX
    jsr PlaySound
.WaitForPress:
    jsr Synchronize
    jsr UpdateSound
    jsr UpdateInput
    lda currLevel
    cmp #MAP_LEVEL
    beq .NoExit
    lda pressed
    and #JOY_SELECT_MASK
    beq .NoExit
    lda #INVALID_MAP_STAT
    sta mapPX+1
    inc exitTriggered
    jmp .end
.NoExit:
    lda pressed
    and #JOY_START_MASK
    beq .WaitForPress
.end:
    jsr CloseTextBox
    POP_BANK
    
    ; lda #1
    ; sta paused
    ; jsr ResetAPU
;.notstart:

;;CHEAT
    ; lda pressed
    ; and #JOY_SELECT_MASK
    ; beq .notselect
    ; lda #0
    ; sta crystalsLeft
; .notselect:

CheckSpecialButtons_end:

CheckPlayerActions subroutine
    lda playerFlags
    and #PLY_LOCKED
    bne CheckPlayerActions_end
    
    lda playerXVel
    bmi .negative
    beq .DecelerrateEnd
    dec playerXVel
    jmp .DecelerrateEnd
.negative
    inc playerXVel
.DecelerrateEnd

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

.jump:
    lda ctrl
    and #JOY_A_MASK
    beq CheckPlayerActions_end
    lda playerFlags
    and #PLY_ISJUMPING
    bne CheckPlayerActions_end
    MOV16I playerYVel, JUMP_VELOCITY
    lda playerFlags
    and #PLY_UPSIDEDOWN
    beq .notUpsideDown
    MOV16I playerYVel, -JUMP_VELOCITY
.notUpsideDown:
    lda playerFlags
    ora #PLY_ISJUMPING
    sta playerFlags
    ldx #SFX_JUMP
    jsr PlaySound
CheckPlayerActions_end:

TileInteraction subroutine
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
    cmp #TB_LOCK
    bcs .IsMessageType
    lda playerFlags
    and #~PLY_MSGTRIGGER
    sta playerFlags
.IsMessageType:
    lda sav+3
    cmp #TB_MAPDOOR
    bcc .notEntrance
    jmp TC_Entrance
.notEntrance:
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
    .word TC_Nop;TC_Foreground
    .word TC_Nop;TC_FgPlatform
    .word TC_Deadly
    .word TC_Hidden
    .word TC_Exit
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
    .word TC_Harmful
    .word TC_Nop ; unused
    .word TC_Nop ; girder
    .word TC_Nop ;"
    .word TC_Nop ;"
    .word TC_Lock
    .word TC_Lock
    .word TC_Lock
    .word TC_Nop ;unused
    .word TC_Nop ;unused
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
    MOV16I arg,poisonMsg
    jsr DisplayMessage
    jsr KillPlayer
    lda #0
    sta sav
    jmp TC_UpdateTile
    
TC_Crystal:
    ldx #SFX_CRYSTAL
    jsr PlaySound
    dec crystalsLeft
    bne .notDone
    MOV16I arg,gotAllMsg
    jsr DisplayMessage
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
    
    ldx #SFX_POINTS
    jsr PlaySound
    
    lda #0
    sta sav
    jmp TC_UpdateTile
TC_Points_end:

TC_Key:
    MOV16I arg, keyMsg
    jsr DisplayMessage
    lda playerFlags
    ora #PLY_HASKEY
    sta playerFlags
    lda #0
    sta sav
    jmp TC_UpdateTile
TC_Key_end:

chestValues:
    .byte 1
    .byte 2
    .byte 5
    .byte 5

TC_Chest:
    lda #PLY_HASKEY
    and playerFlags
    JEQ TC_Return
    
    jsr Randomize
    and #3
    tax
    lda chestValues,x
    sta arg+1
    lda #0
    sta arg
    sta arg+2
    jsr AddScore
    
    ldx #SFX_CHEST
    jsr PlaySound
    
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
    ldx #SFX_AMMO
    jsr PlaySound
    jmp TC_UpdateTile
TC_Ammo_end:

TC_Powershot:
    MOV16I arg, powershotMsg
    jsr DisplayMessage
    lda #10
    sta powerSeconds
    lda #60
    sta powerFrames
    lda #POWER_SHOT
    sta powerType
    lda #0
    sta sav
    jsr UpdatePowerDisplay
    ldx #SFX_POWER
    jsr PlaySound
    jmp TC_UpdateTile
TC_Powershot_end:

TC_Strength:
    MOV16I arg, strengthMsg
    jsr DisplayMessage
    lda #15
    sta powerSeconds
    lda #60
    sta powerFrames
    lda #POWER_STRENGTH
    sta powerType
    lda #0
    sta sav
    jsr UpdatePowerDisplay
    ldx #SFX_POWER
    jsr PlaySound
    jmp TC_UpdateTile
TC_Strength_end:

TC_Gravity:
    MOV16I arg, gravityMsg
    jsr DisplayMessage
    lda #20
    sta powerSeconds
    lda #60
    sta powerFrames
    lda #POWER_GRAVITY
    sta powerType
    lda #PLY_UPSIDEDOWN
    ora playerFlags
    sta playerFlags
    lda #0
    sta sav
    jsr UpdatePowerDisplay
    ldx #SFX_POWER
    jsr PlaySound
    jmp TC_UpdateTile
TC_Gravity_end:

TC_Stop:
    MOV16I arg, stopMsg
    jsr DisplayMessage
    lda #20
    sta powerSeconds
    lda #60
    sta powerFrames
    lda #POWER_STOP
    sta powerType
    lda #0
    sta sav
    jsr UpdatePowerDisplay
    ldx #SFX_POWER
    jsr PlaySound
    jmp TC_UpdateTile
TC_Stop_end:

TC_Foreground:
    lda entityXHi+PLAYER_INDEX
    ora #ENT_X_PRIORITY
    sta entityXHi+PLAYER_INDEX
    jmp TC_Return
TC_Foreground_end:

TC_Exit:
    lda crystalsLeft
    JNE TC_Return
    lda playerFlags
    and #PLY_LOCKED
    JNE TC_Return
    
    lda #INVALID_MAP_STAT
    sta mapAmmo
    sta mapScore+2
    
    ldy currLevel
    cpy #8
    bcs .upperLevels
    lda bits+1,y
    ora cleared
    sta cleared
    jmp walkOut
.upperLevels:
    tya
    sec
    sbc #8
    tay
    lda bits+1,y
    ora cleared+1
    sta cleared+1
walkOut:
    lda playerFlags
    ora #PLY_LOCKED
    sta playerFlags
    lda #64
    sta entityCount+2
    
    lda doorsX
    sta arg
    lda doorsY
    sta arg+2
    lda #0
    sta arg+1
    sta arg+3
    sta arg+4
    jsr SetTile
    lda doorsX
    sta arg
    lda doorsY
    sta arg+2
    inc arg+2
    lda #0
    sta arg+1
    sta arg+3
    sta arg+4
    jsr SetTile
    
    lda hp
    cmp #3
    bne .noBonus
    MOV16I arg,perfectHealthMsg
    jsr DisplayMessage
    lda #50
    sta arg+1
    lda #0
    sta arg
    sta arg+2
    jsr Synchronize
    jsr AddScore
.noBonus:
    
    jmp TC_Return
TC_Exit_end:

TC_Entrance:
    jsr FadeOut
    lda sav+3
    sec
    sbc #TB_MAPDOOR
    sta currLevel
DoEnterLevel:
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
    lda playerFlags
    and #PLY_MSGTRIGGER
    bne .noLeverMessage
    MOV16I arg, leverMsg
    jsr DisplayMessage
    lda playerFlags
    ora #PLY_MSGTRIGGER
    sta playerFlags
.noLeverMessage:
    lda #JOY_B_MASK
    and pressed
    JEQ TC_Return
    
    lda sav+3
    sec
    sbc #TB_LOCK
    tay
    lda doorsX+1,y
    sta sav+4
    sta arg
    lda doorsY+1,y
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
    ldx #SFX_DOOR
    jsr PlaySound
    jmp TC_UpdateTile
TC_Lock_end:

TC_On:
    lda playerFlags
    and #PLY_MSGTRIGGER
    bne .noOnMessage
    MOV16I arg,switchMsg
    jsr DisplayMessage
    lda playerFlags
    ora #PLY_MSGTRIGGER
    sta playerFlags
.noOnMessage:
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
    cpy #3
    bne .notlightsoff
    lda #$20
    sta arg
    jsr QLoadDarkenedLevelColors
    jsr Synchronize
.notlightsoff
    dec sav
    ldx #SFX_SWITCH
    jsr PlaySound
    jmp TC_UpdateTile
TC_On_end:

TC_Off:
    lda playerFlags
    and #PLY_MSGTRIGGER
    bne .noOffMessage
    MOV16I arg,switchMsg
    jsr DisplayMessage
    lda playerFlags
    ora #PLY_MSGTRIGGER
    sta playerFlags
.noOffMessage:
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
    cpy #3
    bne .notlights
    lda #0
    sta arg
    jsr QLoadDarkenedLevelColors
    jsr Synchronize
.notlights
    inc sav
    ldx #SFX_SWITCH
    jsr PlaySound
    jmp TC_UpdateTile
TC_Off_end:

    
TC_Return:
TC_Nop:
    lda playerFlags
    and #PLY_LOCKED
    JNE TileInteraction_end
    lda #JOY_B_MASK
    and pressed
    JEQ TileInteraction_end
    lda entityYHi
    lsr
    cmp #EXPLOSION_ID
    beq .SlotFree
    bit entityXHi
    JPL TileInteraction_end
.SlotFree:
    lda powerType
    cmp #POWER_SHOT
    beq .InfiniteAmmo
    lda ammo
    JEQ TileInteraction_end
    dec ammo
    jsr UpdateAmmoDisplay
.InfiniteAmmo
    ldx #SFX_SHOOT
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
    ora #BULLET_ID<<1
    sta entityYHi
    lda #ANIM_ROCKET
    sta entityAnim
    lda #0
    sta entityCount
    lda powerType
    cmp #POWER_SHOT
    bne .notPowerShot
    lda entityYHi
    and #ENT_Y_POS
    ora #POWERSHOT_ID<<1
    sta entityYHi
    lda #ANIM_POWERSHOT
    sta entityAnim
.notPowerShot
    
    lda playerFlags
    and #PLY_ISFLIPPED
    bne .shootLeft
.shootRight:
    lda currLevel
    cmp #13-1
    bne .noRecoilR
    lda #-RECOIL13
    sta playerXVel
.noRecoilR:
    lda currLevel
    cmp #14-1
    bne .noRecoilR14
    lda #-RECOIL14
    sta playerXVel
.noRecoilR14:
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
    lda currLevel
    cmp #13-1
    bne .noRecoilL
    lda #RECOIL13
    sta playerXVel
.noRecoilL:
    lda currLevel
    cmp #14-1
    bne .noRecoilL14
    lda #RECOIL14
    sta playerXVel
.noRecoilL14:
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

UpdateFruit subroutine
    lda currLevel
    cmp #INTRO_LEVEL
    JCS UpdateFruit_end
    INC16 fruitTime
    lda entityXHi+FRUIT_INDEX
    bmi .in
    CMP16I fruitTime, FRUIT_OUT_TIME
    JCC UpdateFruit_end
    lda #$80
    sta entityXHi+FRUIT_INDEX
.in:
    CMP16I fruitTime, FRUIT_IN_TIME
    JCC UpdateFruit_end
    lda #0
    sta fruitTime
    sta fruitTime+1
    lda entityXHi+FRUIT_INDEX
    eor #$80
    sta entityXHi+FRUIT_INDEX
    bmi UpdateFruit_end
    jsr Randomize
    sta tmp
    lda #0
    sta tmp+1
    ADD16 tmp, tmp, shr_cameraX
    lda tmp
    and #$F0
    sta entityXLo+FRUIT_INDEX
    lda tmp+1
    and #3
    sta entityXHi+FRUIT_INDEX
    jsr Randomize
    cmp #MT_VIEWPORT_HEIGHT*PX_MT_HEIGHT
    bcc .NoAdjust
    sec
    sbc #PX_VIEWPORT_OFFSET
.NoAdjust:
    sta tmp
    lda #0
    sta tmp+1
    ADD16 tmp, tmp, shr_cameraY
    lda tmp
    and #$F0
    sta entityYLo+FRUIT_INDEX
    lda tmp+1
    and #1
    sta entityYHi+FRUIT_INDEX
    jsr Randomize
    and #3
    cmp #3
    bne .notpast
    lda #0
.notpast
    clc
    adc #FRUIT_ID
    asl
    ora entityYHi+FRUIT_INDEX
    sta entityYHi+FRUIT_INDEX
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim+FRUIT_INDEX
    lda #0
    sta entityCount+FRUIT_INDEX
UpdateFruit_end:



CheckLeft subroutine
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
    lda playerX
    and #$F0
    ora #15-PLAYER_HLEFT
    sta playerX
    ;skip if not moving left (-x)
    lda playerXVel
    cmp #0
    bpl CheckLeft_end
    lda #0
    sta playerXVel
CheckLeft_end:

CheckRight subroutine

    CMP16I playerX, [MT_MAP_WIDTH*PX_MT_WIDTH - 13]
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
    lda playerX
    and #$F0
    ora #16-PLAYER_HRIGHT
    sta playerX
    
    ;skip if not moving right (+x)
    lda playerXVel
    cmp #0
    bmi CheckRight_end
    beq CheckRight_end
    lda #0
    sta playerXVel
CheckRight_end:

CheckGround subroutine
    ;skip if not moving down (< 0)
    CMP16I playerYVel, 0
    JMI CheckGround_end
    lda playerFlags
    and #PLY_UPSIDEDOWN
    bne .upsideDown
    lda playerFlags
    ora #PLY_ISJUMPING
    sta playerFlags
.upsideDown:
    lda playerY
    and #$F
    cmp #4
    bcs .GoToCheckSpriteHit

    ADD16I arg, playerX, [PLAYER_HRIGHT-1]
    ADD16I arg+2, playerY, 16
    jsr TestCollisionTop
    bcs .hitGroundTile
    ADD16I arg, playerX, [PLAYER_HLEFT+1]
    ADD16I arg+2, playerY, 16
    jsr TestCollisionTop
    bcs .hitGroundTile
.GoToCheckSpriteHit
    jmp CheckGround_end
.hitGroundTile:
    EXTEND tmp,playerYVel+1
    ADD16 tmp,tmp,playerY
    lda playerY
    and #$F0
    sta playerY
    jmp .hit_ground
.hit_ground:
    lda #0
    sta playerYVel
    sta playerYVel+1
    sta playerYFrac
    lda playerFlags
    and #PLY_UPSIDEDOWN
    bne CheckGround_end
    lda playerFlags
    and #~PLY_ISJUMPING
    sta playerFlags
CheckGround_end:

CheckCieling subroutine
    CMP16I playerYVel, 0
    beq .notUpsideDown
    lda playerFlags
    and #PLY_UPSIDEDOWN
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
    lda playerFlags
    and #PLY_UPSIDEDOWN
    beq .HandleGirder
    jmp .normal
.HandleGirder:
    lda entityXHi+GIRDER_INDEX
    bmi .slotFree
    jmp .normal
.slotFree:
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
    lda tmp+2
    sta entityXLo+GIRDER_INDEX
    lda tmp+3
    sta entityXHi+GIRDER_INDEX
    lda tmp+4
    sta entityYLo+GIRDER_INDEX
    lda tmp+5
    ora #GIRDER_ID<<1
    sta entityYHi+GIRDER_INDEX
    lda #0
    sta entityCount+GIRDER_INDEX
    lda arg+2
    sta entityVelocity+GIRDER_INDEX
    lda sav
    sec
    sbc #TB_GIRDER_LEFT
    clc
    adc #ANIM_GIRDER_LEFT
    sta entityAnim+GIRDER_INDEX

    
    ldy #0
    lda (tmp),y
    ora #1
    sta arg+4
    jsr SetTile
    
.normal:
    lda #0
    lda playerY
    and #$F0
    ora #$F
    sta playerY
    
    CMP16I playerYVel, 0
    bpl CheckCieling_end
    lda #0
    sta playerYFrac
    sta playerYVel
    sta playerYVel+1
    lda playerFlags
    and #PLY_UPSIDEDOWN
    beq CheckCieling_end
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

UpdatePower subroutine
    lda powerSeconds
    beq .end
    dec powerFrames
    bne UpdatePower_end
    lda #60
    sta powerFrames
    dec powerSeconds
    bne .display
    lda powerType
    cmp #POWER_GRAVITY
    bne .NotGravity
    lda playerFlags
    and #~PLY_UPSIDEDOWN
    sta playerFlags
.NotGravity:
    lda #0
    sta powerType
.display:
    jsr UpdatePowerDisplay
.end:
UpdatePower_end:

UpdateMessage subroutine
    lda frame
    and #3
    JNE UpdateMessage_end
    SELECT_BANK TEXT_BANK
        
    lda messagePtr+1
    JEQ UpdateMessage_end
    
    ldx shr_copyIndex
    ldy #0
    lda (messagePtr),y
    bne .fresh
    
    lda messageTime
    beq .stale
    dec messageTime
    jmp UpdateMessage_end
.stale:
    lda messageCursor
    JEQ UpdateMessage_end
    dec messageCursor
    lda #HUD_BLANK
    PHXA
    ENQUEUE_ROUTINE nmi_Copy1
    lda messageCursor
    sta tmp
    EXTEND tmp,tmp
    ADD16I tmp, tmp, [VRAM_NAME_UL+$41]
    lda tmp
    PHXA
    lda tmp+1
    PHXA
    stx shr_copyIndex
    jmp UpdateMessage_end

.fresh:
.space:
    cmp #" "
    bne .numeric
    lda #HUD_BLANK
    jmp .store
.numeric:
    sta sav
    stx sav+1
    ldx #SFX_RTTY
    jsr PlaySound
    ldx sav+1
    lda sav
    
    cmp #"A"
    bcs .letter
    sec
    sbc #"0"
    jmp .store
.letter:
    sec
    sbc #"A"-$0A
.store:
    PHXA
    
    ENQUEUE_ROUTINE nmi_Copy1
    lda messageCursor
    sta tmp
    EXTEND tmp,tmp
    ADD16I tmp, tmp, [VRAM_NAME_UL+$41]
    lda tmp
    PHXA
    lda tmp+1
    PHXA
    stx shr_copyIndex
    INC16 messagePtr
    inc messageCursor
UpdateMessage_end:

UpdateEntities subroutine
    SELECT_BANK 3
    ldx #[MAX_ENTITIES-1]
.loop:
    lda entityXHi,x
    bpl .active
    jmp ER_Return
.active:   
    lda entityYHi,x
    and #ENT_Y_INDEX
    lsr
    tay

.xtest:
    lda entityFlags,y
    and #ENT_F_SKIPXTEST
    bne .ytest
    lda entityXLo,x
    sec
    sbc shr_cameraX
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sbc shr_cameraX+1
    sta tmp+1
    CMP16I tmp, [MT_VIEWPORT_WIDTH*PX_MT_WIDTH + PX_MT_WIDTH]
    bpl .offScreen
    CMP16I tmp, [-PX_MT_WIDTH]
    bmi .offScreen
.ytest:
    lda entityFlags,y
    and #ENT_F_SKIPYTEST
    bne .persistent
    lda entityYLo,x
    sec
    sbc shr_cameraY
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sbc shr_cameraY+1
    sta tmp+1
    CMP16I tmp, [MT_VIEWPORT_HEIGHT*PX_MT_HEIGHT + PX_MT_HEIGHT]
    bpl .offScreen
    CMP16I tmp, -PX_MT_HEIGHT
    bmi .offScreen
    jmp .persistent
.offScreen:
    lda entityXHi,x
    ora #ENT_X_OFFSCREEN
    sta entityXHi,x
    lda entityFlags,y
    and #ENT_F_ISTEMPORARY
    beq .normal
    lda #$80
    sta entityXHi,x
.normal:
    jmp ER_Return
.persistent:
    lda entityXHi,x
    and #~ENT_X_OFFSCREEN
    sta entityXHi,x

    cpx #RESERVED_ENTITIES
    bcc .noStop
    lda powerType
    cmp #POWER_STOP
    beq ER_Return
.noStop:
    inc entityFrame,x
    lda entityRoutineLo,y
    sta tmp
    lda entityRoutineHi,y
    sta tmp+1
    jmp (tmp)
ER_Return:
    dex
    JMI UpdateEntities_end
    jmp .loop
    
UpdateEntities_end:

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
    cmp #12
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
    bne .NoTilesOnRight
    jsr LoadTilesOnMoveRight
.NoTilesOnRight:
    
    ;no loading attributes if not at attribute boundary
    lda shr_cameraX
    and #15 ; 16-pixel boundaries
    cmp #12
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

    jsr UpdateSprites
    jsr Synchronize
    jmp MainLoop

;------------------------------------------------------------------------------
EmptyTextBox subroutine
    SET_PPU_ADDR [VRAM_NAME_UL + 32*5 + TEXT_MARGIN]
    lda #" "
    ldy #[TEXTBOX_HEIGHT-2]
.outerloop:
    ldx #27
.loop:
    sta PPU_DATA
    dex
    bne .loop
    REPEAT 5
    bit PPU_DATA
    REPEND
    dey
    bne .outerloop
    rts
;------------------------------------------------------------------------------
;print caret-terminated string with LF line breaks
Print subroutine ;arg0..1 source, arg2..3 PPU dest; ret1 next page
    PUSH_BANK
    SELECT_BANK TEXT_BANK
    ldy #0
    lda arg+3
    bit PPU_STATUS
    sta PPU_ADDR
    lda arg+2
    sta PPU_ADDR
.TextLoop:
    lda (arg),y
    cmp #"^"
    bne .NotEnd
    ADD16I ret,arg,1
    POP_BANK
    rts
.NotEnd:
    cmp #$0A
    bne .NotLineFeed
    ADD16I arg+2,arg+2,32
    lda arg+2
    and #%11100000
    clc
    adc #TEXT_MARGIN
    sta arg+2
    lda arg+3
    bit PPU_STATUS
    sta PPU_ADDR
    lda arg+2
    sta PPU_ADDR
    jmp .Next
.NotLineFeed:
    sta PPU_DATA
    INC16 arg+2
.Next:
    INC16 arg
    jmp .TextLoop
;------------------------------------------------------------------------------
FadeOut subroutine
    SELECT_BANK 0
    ldy #0
.fadeloop:
    tya
    REPEAT 4
    asl
    REPEND
    sta arg
    sty sav
    jsr QLoadDarkenedLevelColors
    ldy sav
    REPEAT FADE_DELAY
    jsr Synchronize
    REPEND
    iny
    cpy #4
    bne .fadeloop
    rts
;------------------------------------------------------------------------------
FadeIn subroutine
    ldy #3
.fadeloop:
    tya
    REPEAT 4
    asl
    REPEND
    sta arg
    sty sav
    jsr QLoadDarkenedLevelColors
    ldy sav
    REPEAT FADE_DELAY
    jsr Synchronize
    REPEND
    dey
    bpl .fadeloop
    rts

;------------------------------------------------------------------------------
QLoadDarkenedLevelColors subroutine
    SELECT_BANK 0
    ldx shr_copyIndex
    
    ldy #11
.loop
    lda globalPalette,y
    sec
    sbc arg
    bpl .nn1
    lda #$0f
.nn1:
    PHXA
    dey
    bpl .loop
    
    lda currLevel
    asl
    tay
    lda levelPalettes,y
    sta tmp
    lda levelPalettes+1,y
    sta tmp+1
    ldy #19
.loop2
    lda (tmp),y
    sec
    sbc arg
    bpl .nn2
    lda #$0f
.nn2:
    PHXA
    dey
    bpl .loop2

    ENQUEUE_ROUTINE nmi_Copy32
    ENQUEUE_PPU_ADDR VRAM_PALETTE_BG
    
    stx shr_copyIndex
    rts
;------------------------------------------------------------------------------
FadeOutBg subroutine ; arg+2 passes thru to nested call
    lda sav
    pha
    ldy #0
.fadeloop:
    tya
    REPEAT 4
    asl
    REPEND
    sta arg
    sty sav
    jsr QLoadDarkenedBgColors
    ldy sav
    REPEAT FADE_DELAY
    jsr Synchronize
    REPEND
    iny
    cpy #4
    bne .fadeloop
    pla
    sta sav
    rts
;------------------------------------------------------------------------------
FadeInBg subroutine ; arg+2 passes thru to nested call
    lda sav
    pha
    ldy #3
.fadeloop:
    tya
    REPEAT 4
    asl
    REPEND
    sta arg
    sty sav
    jsr QLoadDarkenedBgColors
    ldy sav
    REPEAT FADE_DELAY
    jsr Synchronize
    REPEND
    dey
    bpl .fadeloop
    pla
    sta sav
    rts
;------------------------------------------------------------------------------
QLoadDarkenedBgColors subroutine
    ldx shr_copyIndex
    
    ldy #0
.loop
    lda (arg+2),y
    sec
    sbc arg
    bpl .nn1
    lda #$0f
.nn1:
    PHXA
    iny
    cpy #16
    bne .loop
    
    ENQUEUE_ROUTINE nmi_Copy16
    ENQUEUE_PPU_ADDR VRAM_PALETTE_BG
    
    stx shr_copyIndex
    rts
;------------------------------------------------------------------------------
UpdateSprites subroutine
    PUSH_BANK
    SELECT_BANK 3

;update player sprite pos
    lda playerX
    sta entityXLo+PLAYER_INDEX
    lda entityXHi+PLAYER_INDEX
    and #~[ENT_X_POS|ENT_X_DEAD]
    ora playerX+1
    sta entityXHi+PLAYER_INDEX
    lda playerY
    sta entityYLo+PLAYER_INDEX
    lda entityYHi+PLAYER_INDEX
    and #$FE
    ora playerY+1
    sta entityYHi+PLAYER_INDEX
    
;clear sprites
    ldy #0
    lda #$FF
.clearloop:
    sta shr_entitySprites,y
    iny
    cpy #32*OAM_SIZE
    bne .clearloop

;process entities
    lda startSprite
    ora #$80
    sta arg
    ldx #[MAX_ENTITIES]
.outerloop:
    dex
    bpl .continue
    jmp .exit
.continue:
    lda entityXHi,x
    bmi .outerloop
    and #ENT_X_OFFSCREEN
    bne .outerloop
.active:
    ;prepare coordinates in sav+4 (Y) and sav+5 (X)
    lda entityYLo,x
    sta sav+4
    lda entityYHi,x
    and #ENT_Y_POS
    sta sav+5
    SUB16 sav+4,sav+4,shr_cameraY  
    lda entityXLo,x
    sta sav+6
    lda entityXHi,x
    and #ENT_X_POS
    sta sav+7
    SUB16 sav+6,sav+6,shr_cameraX 
    
    ;get base tile in arg+2
    lda entityYHi,x
    lsr
    stx tmp
    tax
    lda entityTiles,x
    ldx tmp
    sta arg+2
    
    ;get base attribute in arg+3
    lda entityYHi,x
    lsr
    stx tmp
    tax
    lda entityFlags,x
    and #ENT_F_COLOR
    ldx tmp    
    sta arg+3
    lda entityXHi,x
    and #ENT_X_PRIORITY
    ora arg+3
    sta arg+3
    lda entityXHi,x
    and #ENT_X_FLASH
    beq .noFlash
    lda frame
    lsr
    and #3
    eor arg+3
    sta arg+3
.noFlash:

    ;get frame in sav
    lda entityFrame,x
    sta tmp+2
    lda entityAnim,x
    stx arg+4 ; entity index in arg+4
    tax
    lda animsLo,x
    sta tmp
    lda animsHi,x
    sta tmp+1
    ldy #0
    lda tmp+2
    lsr
    lsr
    and (tmp),y
    asl
    tay
    INC16 tmp
    lda (tmp),y
    sta sav
    iny
    lda (tmp),y
    sta sav+1
    
    ;get size in sav+2, def index in y
    ldy #0
    lda (sav),y
    bne .nonzero
    ldx arg+4
    jmp .outerloop
.nonzero:
    sta sav+2
    INC16 sav
    
    ;sprite base in x
    ldx arg
    ;---------------
    ;load frame from (sav) into $200,x until sav+2
    ;---------------
.loop:
;--Y--
    lda (sav),y
    iny
    sta tmp
    EXTEND tmp,tmp
    ADD16 tmp,tmp,sav+4
    CMP16I tmp,-16
    bpl .notabove
    iny
    iny
    iny
    jmp .abort
.notabove:
    CMP16I tmp,[MT_VIEWPORT_HEIGHT*PX_MT_HEIGHT+16]
    bmi .notbelow
    iny
    iny
    iny
    jmp .abort
.notbelow:
    lda tmp
    clc
    adc #PX_VIEWPORT_OFFSET-1
    sta shr_spriteY,x
;--tile--
    lda arg+2
    clc
    adc (sav),y
    iny
    sta shr_spriteIndex,x
;--flags--
    lda arg+3
    eor (sav),y
    iny
    sta shr_spriteFlags,x
;--X--
    lda (sav),y
    iny
    sta tmp
    EXTEND tmp,tmp
    ADD16 tmp,tmp,sav+6
    CMP16I tmp,-8
    bpl .notLeft
    lda #$FF
    sta shr_spriteY,x
    jmp .abort
.notLeft:
    CMP16I tmp,[MT_VIEWPORT_WIDTH*PX_MT_WIDTH+8]
    bmi .notRight
    lda #$FF
    sta shr_spriteY,x
    jmp .abort
.notRight:
    lda tmp
    clc
    adc #8
    sta shr_spriteX,x
;--commit--
    
    txa
    clc
    adc #4
    ora #$80
    tax
.abort:
    cpy sav+2
    bcs .done
    jmp .loop
.done:
    stx arg ;save sprite addr
    ldx arg+4 ;reload entity index
    jmp .outerloop
.exit:
    
;cycle starting position
    lda startSprite
    clc
    adc #21*4
    sta startSprite
    
    POP_BANK
    rts
;------------------------------------------------------------------------------
KillPlayer subroutine
    ;pla
    ;pla
    lda mapAmmo
    sta ammo
    MOV16 score, mapScore
    lda mapScore+2
    sta score
    lda #ANIM_PLAYER_DIE
    sta entityAnim+PLAYER_INDEX
    lda #0
    sta entityFrame+PLAYER_INDEX
    sta playerXVel
    lda playerFlags
    ora #PLY_LOCKED
    sta playerFlags
    lda #$FF
    sta mercyTime
    rts
    ;jmp EnterLevel
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
    ldx #SFX_HURT
    jsr PlaySound
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
    sta shr_tileCol
    
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
    sta shr_tileCol
    
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
    ADD16I tmp, tmp, 16
    
    ;get index to attribute table
    lda tmp
    lsr
    and #7
    sta shr_tileCol
    
    ;get map index
    MOV16 arg, tmp
    jsr MultiplyBy24
    ADD16I arg, ret, levelMap
    
    lda shr_cameraX
    and #$10
    beq .unaligned
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
    and #7
    sta shr_tileCol
    
    ;get map index
    MOV16 arg, tmp
    jsr MultiplyBy24
    ADD16I arg, ret, levelMap
    
    lda shr_cameraX
    and #$10
    bne .unaligned
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
    MUL_BY_24 tmp, arg
    ADD16 tmp, tmp, arg+2
    
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
    cpx #TOP_HEIGHT+BOTTOM_HEIGHT
    bne .first_loop
    rts
;------------------------------------------------------------------------------
;arg 0..1 -> rom address
;arg 2 -> nametable column
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
    cpx #TOP_HEIGHT+BOTTOM_HEIGHT
    bne .second_loop 
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
DisplayMessage subroutine
    ldx shr_copyIndex
    lda #HUD_BLANK
    PHXA
    ENQUEUE_ROUTINE nmi_Fill24
    ENQUEUE_PPU_ADDR [VRAM_NAME_UL+$41]
    stx shr_copyIndex
    jsr Synchronize
    
    MOV16 messagePtr,arg
    lda #0
    sta messageCursor
    lda #60
    sta messageTime
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
    lda #HUD_BLANK
    sta tmp,y
    dey
    bpl .prefixloop
.nonzero    

    ldx shr_copyIndex
    
    lda #0
    PHXA
    
    ldy #0
.pushloop:
    lda tmp,y
    PHXA
    iny
    cpy #6
    bne .pushloop
    
    ENQUEUE_ROUTINE nmi_Copy7
    ENQUEUE_PPU_ADDR $2065    
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
    ora #HUD_BLANK
.nonzero
    PHXA
    
    ENQUEUE_ROUTINE nmi_Copy2
    ENQUEUE_PPU_ADDR $2071
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
    bne .nonzero
    ora #HUD_BLANK
.nonzero:
    PHXA
    jmp .finish
.none:
    lda #HUD_BLANK
    PHXA
    PHXA
.finish:

    ENQUEUE_ROUTINE nmi_Copy2
    ENQUEUE_PPU_ADDR $207A
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
    lda #HUD_HEART
    PHXA
    jmp .continue_loop
.no_heart:
    lda #HUD_BLANK
    PHXA
.continue_loop:
    dey
    bne .loop

    ENQUEUE_ROUTINE nmi_Copy3
    ENQUEUE_PPU_ADDR $2076
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
    cmp #TB_FGPLATFORM
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
PlaySound subroutine ;argument in x, uses both index regs
    PUSH_BANK
    SELECT_BANK SOUNDS_BANK
    lda sounds,x
    sta tmp
    lda sounds+1,x
    sta tmp+1
    ldy #0
    lda (tmp),y
    sta arg+2
    ADD16I arg,tmp,1
    jsr LoadSfx
    POP_BANK
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
QEnableStaticDisplay subroutine
    ldx shr_copyIndex
    lda #1
    PHXA
    lda #[PPU_MASK_SETTING | %00000010] & %11101111
    PHXA
    ENQUEUE_ROUTINE nmi_UpdateMask
    ENQUEUE_PPU_ADDR $0000
    
    lda #0
    PHXA
    PHXA
    ENQUEUE_ROUTINE nmi_UpdateScroll
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
;------------------------------------------------------------------------------
WaitForPress subroutine
    jsr Synchronize
    jsr UpdateSound
    jsr UpdateInput
    lda pressed
    cmp #0
    beq WaitForPress
    rts
;------------------------------------------------------------------------------
ClearNameTable subroutine
    SET_PPU_ADDR VRAM_NAME_UL
    lda #0
    ldx #4
    ldy #0
.loop:
    sta PPU_DATA
    dey
    bne .loop
    dex
    bne .loop
    rts
;------------------------------------------------------------------------------
UpdateInput subroutine
    lda ctrl
    sta oldCtrl
    
    ;; Strobe controller
    lda #1
    sta JOYPAD1
    lda #0
    sta JOYPAD1
    ;; Read all 8 buttons
    REPEAT 8
    sta ctrl
    ;; Read next button state and mask off low 2 bits.
    ;; Compare with $01, which will set carry flag if
    ;; either or both bits are set.
    lda JOYPAD1
    and #$03
    cmp #$01
    ;; Now, rotate the carry flag into the top of A,
    ;; land shift all the other buttons to the right
    lda ctrl
    ror
    REPEND
    
    sta ctrl
    and oldCtrl
    eor ctrl
    sta pressed
    rts
UpdateInput_end:
;------------------------------------------------------------------------------
ResetAPU subroutine
    ;mute everything
    lda #$00
    sta APU_ENABLE
    
    ;silence square and noise
    lda #$30
    sta APU_SQ1_VOL
    sta APU_SQ2_VOL
    sta APU_NOISE_VOL
    
    ;disable sweep
    lda #$08
    sta APU_SQ1_SWEEP
    sta APU_SQ2_SWEEP
    
    ;silence triangle
    lda #$80
    sta APU_TRI_LINEAR
        
    ;unmute
    lda #$0F
    sta APU_ENABLE
    rts
    
ClearSounds subroutine
    lda #0    
    ldy #16
.loop:
    sta sfxPriority,y
    sta sfxPatch,y
    dey
    bne .loop
    rts
;------------------------------------------------------------------------------
Randomize subroutine
    lda random
    ora random+1
    bne .nonzero
    lda frame
    sta random
    eor #$B4
    sta random+1
.nonzero:
    lda random
    lsr
    rol random+1
    bcc .noeor
    eor #$B4 
.noeor
    sta random
    eor random+1
    rts 
    
;------------------------------------------------------------------------------
ClearStatusBar subroutine
    ldy #$A0
    SET_PPU_ADDR VRAM_NAME_UL
    lda #HUD_BLANK
.clear_upper
    sta PPU_DATA
    dey
    bne .clear_upper

    ldy #0
    SET_PPU_ADDR VRAM_ATTRIB_UL
    lda #%11111111
.load_hud_attr
    sta PPU_DATA
    iny
    cpy #8
    bne .load_hud_attr
    rts
    
InitHUD subroutine
    SET_PPU_ADDR [VRAM_NAME_UL+100]
    lda #HUD_DOLLAR
    sta PPU_DATA
    SET_PPU_ADDR [VRAM_NAME_UL+111]
    lda #HUD_GUN
    sta PPU_DATA
    jsr UpdateAmmoDisplay
    jsr UpdateHeartsDisplay
    jmp UpdateScoreDisplay
;------------------------------------------------------------------------------
InitialDrawLevel subroutine
    PUSH16 sav
    PUSH16 sav+2
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
    sta shr_tileCol
    tya
    pha
    jsr EvenColumn
    jsr CopyTileCol 
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
    sta shr_tileCol
    tya
    pha
    jsr OddColumn
    jsr CopyTileCol
    pla
    tay
    
    iny
    ADD16I sav, sav, 23
    cpy #16
    bne .loop

;set attributes
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
.loopattr:
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
    bne .loopattr

    POP16 sav+2
    POP16 sav
    jmp LoadTilesOnMoveLeft
;------------------------------------------------------------------------------
ResetCamera subroutine
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
    rts
;------------------------------------------------------------------------------
OpenTextBox subroutine
    PUSH_BANK
    jsr QDisableDisplay
    jsr Synchronize
    SELECT_BANK 0
    MOV16I arg, textTiles
    SET_PPU_ADDR VRAM_PATTERN_R
    ldx #8
    jsr PagesToPPU
    
    jsr ClearNameTable
    
    SET_PPU_ADDR [VRAM_NAME_UL + 32*3]
    lda #2
    sta PPU_DATA
    lda #3
    ldx #29
.topbar:
    sta PPU_DATA
    dex
    bne .topbar
    lda #4
    sta PPU_DATA
    
    
    SET_PPU_ADDR [VRAM_NAME_UL + 32*[TEXTBOX_HEIGHT+4]]
    lda #7
    sta PPU_DATA
    lda #8
    ldx #29
.bottombar:
    sta PPU_DATA
    dex
    bne .bottombar
    lda #9
    sta PPU_DATA
    
    SET_PPU_ADDR [VRAM_NAME_UL + 32*[TEXTBOX_HEIGHT+5] + 1]
    lda #1
    ldx #30
.bottomshadow:
    sta PPU_DATA
    dex
    bne .bottomshadow
    
    
    SET_PPU_ADDR [VRAM_NAME_UL + 32*4]
    lda #PPU_CTRL_SETTING | %100
    sta PPU_CTRL
    lda #5
    ldx #TEXTBOX_HEIGHT
.leftbar:
    sta PPU_DATA
    dex
    bne .leftbar
    
    SET_PPU_ADDR [VRAM_NAME_UL + 32*4 + 30]
    lda #6
    ldx #TEXTBOX_HEIGHT
.rightbar:
    sta PPU_DATA
    dex
    bne .rightbar
    
    SET_PPU_ADDR [VRAM_NAME_UL + 32*4 + 31]
    lda #1
    ldx #TEXTBOX_HEIGHT+2
.rightshadow:
    sta PPU_DATA
    dex
    bne .rightshadow
    
    lda #PPU_CTRL_SETTING
    sta PPU_CTRL
    
    ;jsr QEnableStaticDisplay
    SELECT_BANK 0
    lda #0
    sta arg
    sta arg+1
    MOV16I arg+2,textPalette
    jsr QLoadDarkenedBgColors
    jsr Synchronize
    
    POP_BANK
    rts
;------------------------------------------------------------------------------
CloseTextBox subroutine
    PUSH_BANK
    jsr QDisableDisplay
    jsr Synchronize
    
    SELECT_BANK 0
    MOV16I arg, globalBgTiles
    SET_PPU_ADDR VRAM_PATTERN_R
    ldx #8
    jsr PagesToPPU
    
    jsr ClearStatusBar
    lda currLevel
    cmp #MAP_LEVEL+1
    bcs .noHUD
    jsr InitHUD
    jmp .noMiniHUD
.noHUD
    lda currLevel
    cmp #END_LEVEL
    bne .noMiniHUD
    SET_PPU_ADDR [VRAM_NAME_UL+100]
    lda #HUD_DOLLAR
    sta PPU_DATA
    jsr UpdateScoreDisplay
.noMiniHUD:
    
    jsr ResetCamera
    jsr InitialDrawLevel
    lda #0
    sta arg
    jsr QEnableSplitDisplay
    lda switches
    and #8
    bne .light
    lda #$20
    sta arg
.light:
    jsr QLoadDarkenedLevelColors
    
    jsr Synchronize
    POP_BANK
    rts
;------------------------------------------------------------------------------

PrintPages subroutine
    PUSH_BANK
    PUSH16 sav
    MOV16 sav,arg    
.loop:
    jsr QDisableDisplay
    jsr Synchronize
    jsr EmptyTextBox
    
    MOV16I arg,pressAnyKey
    MOV16I arg+2,[VRAM_NAME_UL + 32*[TEXTBOX_HEIGHT+2] + TEXT_MARGIN + 7]
    jsr Print
    
    MOV16 arg,sav
    MOV16I arg+2,[VRAM_NAME_UL + 32*5 + TEXT_MARGIN]
    jsr Print
    MOV16 sav,ret

    jsr QEnableStaticDisplay
    jsr Synchronize
    ldx #SFX_TEXTBOX
    jsr PlaySound
    jsr WaitForPress
    SELECT_BANK TEXT_BANK
    ldy #0
    lda (ret),y
    cmp #"@"
    bne .loop

.exit:
    POP16 sav
    POP_BANK
    rts
;------------------------------------------------------------------------------
StartMusic subroutine
    PUSH_BANK
    SELECT_BANK SOUNDS_BANK
    lda levelMusic,x
    sta tmp
    lda levelMusic+1,x
    sta tmp+1
    ldy #0
    lda (tmp),y
    iny
    sta tempo
.loopSequences:
    lda (tmp),y
    sta musicSequence-1,y
    lda #0
    sta musicSequenceIndex-1,y
    sta musicPatternPtr-1,y
    iny
    cpy #9
    bne .loopSequences
    lda #0
    sta beatTimer
    POP_BANK
    rts
;------------------------------------------------------------------------------
UpdateSound subroutine
    PUSH_BANK
    SELECT_BANK SOUNDS_BANK
    jsr SoundRoutine
    POP_BANK
    rts
;------------------------------------------------------------------------------
ClearCursor subroutine
    ldx shr_copyIndex
    lda #" "
    PHXA
    ENQUEUE_ROUTINE nmi_Copy1
    lda arg
    sta tmp
    lda #0
    sta tmp+1
    REPEAT 6
    ASL16 tmp
    REPEND
    lda arg+1
    asl
    ora tmp
    sta tmp
    ADD16I tmp,tmp,[VRAM_NAME_UL + 32*11 + TEXT_MARGIN+3]
    lda tmp
    PHXA
    lda tmp+1
    PHXA
    stx shr_copyIndex
    rts
;------------------------------------------------------------------------------
DrawCursor subroutine
    ldx shr_copyIndex
    lda #$10
    PHXA
    ENQUEUE_ROUTINE nmi_Copy1
    lda arg
    sta tmp
    lda #0
    sta tmp+1
    REPEAT 6
    ASL16 tmp
    REPEND
    lda arg+1
    asl
    ora tmp
    sta tmp
    ADD16I tmp,tmp,[VRAM_NAME_UL + 32*11 + TEXT_MARGIN+3]
    lda tmp
    PHXA
    lda tmp+1
    PHXA
    stx shr_copyIndex
    rts