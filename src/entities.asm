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
    .word ER_Girder ; girder
    .word ER_Rex
    .word ER_Stalactite
    .word ER_SpiderWeb
    .word ER_Flame
    .word ER_PipeRight
    .word ER_PipeLeft
    .word ER_Return ; torch
    .word ER_Spike ; spike
    
entityFlags:
    .byte ENT_F_ISTEMPORARY | 2; bullet
    .byte ENT_F_ISPLATFORM | ENT_F_SKIPYTEST | 2; vertical platform
    .byte ENT_F_ISPLATFORM | ENT_F_SKIPXTEST | 2; horizontal platform
    .byte [1<<ENT_F_CHILDREN_SHIFT] | 2 ; spider
    .byte 2 ; bat
    .byte ENT_F_ISTEMPORARY | 1; power shot
    .byte 0; rock
    .byte 2 ; cart
    .byte ENT_F_SKIPXTEST | [3<<ENT_F_CHILDREN_SHIFT] | 3 ; caterpillar head
    .byte ENT_F_SKIPXTEST | 3 ; caterpillar front
    .byte ENT_F_SKIPXTEST | 3 ; caterpillar back
    .byte ENT_F_SKIPXTEST | 3 ; caterpillar tail
    .byte 3 ; slime horizontal
    .byte 3 ; slime horizontal
    .byte 2 ; hammer
    .byte [1<<ENT_F_CHILDREN_SHIFT] | 2 ; faucet
    .byte ENT_F_ISTEMPORARY | 2 ; water
    .byte ENT_F_ISPLATFORM | ENT_F_SKIPYTEST | 2; vertical platform
    .byte ENT_F_ISPLATFORM | ENT_F_SKIPXTEST | 2; horizontal platform
    .byte [1<<ENT_F_CHILDREN_SHIFT] | 2 ; right cannon
    .byte ENT_F_ISTEMPORARY | 1 ; right laser
    .byte [1<<ENT_F_CHILDREN_SHIFT] | 2 ; left cannon
    .byte 0 ;girder
    .byte 3  ; rex
    .byte 0 ; stalactite
    .byte ENT_F_ISTEMPORARY | 2 ; spider web
    .byte ENT_F_SKIPYTEST | 1 ;flame
    .byte 3 ;pipe right
    .byte 3 ;pipe left
    .byte 1 ;torch
    .byte 0 ;spike
        
entityTiles:
    .byte 14*2 ; bullet
    .byte [0+32]*2 ; vertical platform
    .byte [0+32]*2 ; horizontal platform
    .byte [16+32]*2 ; spider
    .byte [19+32]*2 ; bat
    .byte 20*2 ; power shot
    .byte [22+32]*2 ; rock
    .byte [5+32]*2 ; cart
    .byte [23+32*2]*2 ; caterpillar head
    .byte [21+32*2]*2 ; caterpillar front
    .byte [21+32*2]*2 ; caterpillar back
    .byte [19+32*2]*2 ; caterpillar tail
    .byte [28+32]*2 ; slime horizontal
    .byte [30+32]*2 ; slime vertical
    .byte [15+32*2]*2 ; hammer
    .byte [9+32]*2 ; faucet
    .byte [8+32]*2 ; water
    .byte [0+32]*2 ; vertical platform
    .byte [0+32]*2 ; horizontal platform
    .byte [2+32]*2 ; right cannon
    .byte [4+32]*2 ; right laser
    .byte [2+32]*2 ; left cannon
    .byte 123 ; girder
    .byte [25+32*2]*2 ; rex
    .byte 32*2 + 16 + 1; stalactite
    .byte [18+32]*2 ; spider web
    .byte [14+32]*2 ; flame
    .byte [10+32]*2 ; pipe right
    .byte [10+32]*2 ; pipe left
    .byte 251 ;torch
    .byte 32*3 + 16 + 1; spike
    
entitySpeeds:
    .byte 4 ; bullet
    .byte 1 ; vertical platform
    .byte 1 ; horizontal platform
    .byte 1 ; spider
    .byte 1 ; bat
    .byte 4 ; power shot
    .byte 1 ; rock
    .byte 2 ; cart
    .byte -1 ; caterpillar head
    .byte -1 ; caterpillar front
    .byte -1 ; caterpillar back
    .byte -1 ; caterpillar tail
    .byte 2 ; slime horizontal
    .byte 2 ; slime vertical
    .byte -1 ; hammer
    .byte 0 ; faucet
    .byte 4 ; water
    .byte 1 ; vertical platform
    .byte 1 ; horizontal platform
    .byte 0 ; right cannon
    .byte 4 ; right laser
    .byte 0 ; left cannon
    .byte 0 ;girder
    .byte 1; rex
    .byte 0; stalactite
    .byte 2; spider web
    .byte 0 ; flame
    .byte -1 ;pipe right
    .byte 1 ; pipe left
    .byte 0 ; torch
    .byte 0 ; spike
    
entityInitialAnims:
    .byte ANIM_SMALL_LONG ; bullet
    .byte ANIM_SPIDER ; vertical platform
    .byte ANIM_SPIDER ; horizontal platform
    .byte ANIM_SPIDER ; spider
    .byte ANIM_SYMMETRICAL_OSCILLATE ; bat
    .byte ANIM_POWERSHOT ; power shot
    .byte ANIM_SMALL_OSCILLATE ; rock
    .byte ANIM_SMALL_OSCILLATE ; cart
    .byte ANIM_CATERPILLAR ; caterpillar head
    .byte ANIM_CATERPILLAR_2 ; caterpillar front
    .byte ANIM_CATERPILLAR ; caterpillar back
    .byte ANIM_CATERPILLAR_2 ; caterpillar tail
    .byte ANIM_SLIME_RIGHT ; slime horizontal
    .byte ANIM_SLIME_DOWN ; slime vertical
    .byte ANIM_SYMMETRICAL_NONE ; hammer
    .byte ANIM_SYMMETRICAL_NONE ; faucet
    .byte ANIM_SYMMETRICAL_NONE ; water
    .byte ANIM_SPIDER ; vertical platform
    .byte ANIM_SPIDER ; horizontal platform
    .byte ANIM_SMALL_NONE ; right cannon
    .byte ANIM_SYMMETRICAL_NONE ; laser
    .byte ANIM_SMALL_HFLIP_NONE ; left cannon
    .byte ANIM_GIRDER_MIDDLE ; girder
    .byte ANIM_REX ;rex
    .byte ANIM_STALACTITE
    .byte ANIM_SYMMETRICAL_NONE ; spider web
    .byte ANIM_FLAME
    .byte ANIM_PIPE_RIGHT
    .byte ANIM_PIPE_LEFT
    .byte ANIM_TORCH
    .byte ANIM_SPIKE

    
EntAwayFromPlayerX subroutine ; distance in arg 0-1, result in carry
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sta tmp+1
    SUB16 tmp,tmp,playerX
    ABS16 tmp,tmp
    CMP16 tmp,arg
    rts
    
EntAwayFromPlayerY subroutine ; distance in arg 0-1, result in carry
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    SUB16 tmp,tmp,playerY
    ABS16 tmp,tmp
    CMP16 tmp,arg
    rts

EntMoveHorizontally subroutine
    lda entityVelocity,y
    NMOS_ASR
    sta tmp
    EXTEND tmp, tmp
    lda frame
    and #1
    beq .noExtra
    lda entityVelocity,y
    bpl .positive
    DEC16 tmp
    jmp .noExtra
.positive:
    INC16 tmp
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
    
EntMoveVertically subroutine
    lda entityVelocity,y
    NMOS_ASR
    sta tmp
    EXTEND tmp, tmp
    lda frame
    and #1
    beq .noExtra
    lda entityVelocity,y
    bpl .positive
    DEC16 tmp
    jmp .noExtra
.positive:
    INC16 tmp
.noExtra:
    clc
    lda entityYLo,y
    adc tmp
    sta entityYLo,y
    lda entityYHi,y
    adc tmp+1
    and #ENT_Y_POS
    sta tmp
    lda entityYHi,y
    and #~ENT_Y_POS
    ora tmp
    sta entityYHi,y
    rts
   
EntIsBulletNear subroutine
    lda entityXHi
    bpl .exists
    clc
    rts
.exists
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sta tmp+1
    lda entityXLo
    sta tmp+2
    lda entityXHi
    and #ENT_X_POS
    sta tmp+3
    
    SUB16 tmp, tmp, tmp+2
    ABS16 tmp, tmp
    CMP16I tmp, 14
    bcs .no
    
    
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    lda entityYLo
    sta tmp+2
    lda entityYHi
    and #ENT_Y_POS
    sta tmp+3
    
    SUB16 tmp, tmp, tmp+2
    ABS16 tmp, tmp
    CMP16I tmp, 14
    bcs .no
    sec
    rts
    
.no:
    clc
    rts

EntTryMelee subroutine
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sta tmp+1
    lda entityYLo,y
    sta tmp+2
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+3
    
    SUB16 tmp+4, tmp, playerX
    ABS16 tmp+4, tmp+4
    CMP16I tmp+4, 12
    bcs .noMelee
    
    SUB16 tmp+4, tmp+2, playerY
    ABS16 tmp+4, tmp+4
    CMP16I tmp+4, 12
    bcs .noMelee
    
    jsr DamagePlayer
    
.noMelee:
    rts

EntTestWalkingCollision subroutine
    PUSH16 sav
    PUSH16 sav+2
    lda entityXLo,y
    sta arg
    lda entityXHi,y
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,y
    sta arg+2
    lda entityYHi,y
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg+2,arg+2, 8
    lda entityVelocity,y
    bmi .notRight
    ADD16I arg,arg,16
.notRight:
    MOV16 sav,arg
    MOV16 sav+2,arg+2
    jsr TestCollision
    bcs .hit
    ADD16I arg+2,sav+2,8
    MOV16 arg,sav
    jsr TestCollision
    bcc .hit
    jmp .nohit
.hit:
    POP16 sav+2
    POP16 sav
    sec
    rts
.nohit:
    POP16 sav+2
    POP16 sav
    clc
    rts

EntTestFlyingCollision subroutine
    lda entityXLo,y
    sta arg
    lda entityXHi,y
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,y
    sta arg+2
    lda entityYHi,y
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg+2,arg+2,8
    lda entityVelocity,y
    bmi .notRight
    ADD16I arg,arg,16
.notRight:
    jmp TestCollision

EntTestVerticalCollision
    lda entityXLo,y
    sta arg
    lda entityXHi,y
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,y
    sta arg+2
    lda entityYHi,y
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg,arg, 8
    lda entityVelocity,y
    bmi .notDown
    ADD16I arg+2,arg+2,16
.notDown:
    jmp TestCollision


EntFall subroutine
    lda entityCount,y
    clc
    adc #1
    sta entityCount,y
    cmp #STALACTITE_GRAVITY
    bmi .noAccel
    
    lda #1
    sta entityCount,y
    lda entityVelocity,y
    clc
    adc #1
    cmp #>TERMINAL_VELOCITY
    bcc .nonTerminal
    lda #>TERMINAL_VELOCITY
.nonTerminal:
    sta entityVelocity,y
.noAccel:
    ;apply velocity at 1 pixel per frame resolution
    lda entityVelocity,y
    sta tmp
    EXTEND tmp,tmp
    lda tmp
    clc
    adc entityYLo,y
    sta entityYLo,y
    lda entityYHi,y
    and #ENT_Y_POS
    adc tmp+1
    sta tmp
    lda entityYHi,y
    and #ENT_Y_INDEX
    ora tmp
    sta entityYHi,y
    rts

ER_Spike subroutine
    jsr EntTryMelee
    lda entityYLo,y
    ora #$0A
    sta entityYLo,y

    MOV16I arg, 10
    jsr EntAwayFromPlayerX
    bcs .end
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    CMP16 playerY,tmp
    bcs .end
    SUB16I tmp, tmp, 4*16
    CMP16 playerY,tmp
    bcc .end
    lda entityYLo,y
    and #$F0
    sta entityYLo,y
.end:
    jmp ER_Return

girderTable
    .byte #-2
    .byte #-1
    .byte #-1
    .byte #0
    .byte #2
    .byte #1
    .byte #0
    .byte #1

ER_Girder subroutine
    lda entityCount,y
    cmp #8
    bne .continue    
    lda entityXLo,y
    sta arg
    lda entityXHi,y
    sta arg+1
    lda entityYLo,y
    sta arg+2
    lda entityYHi,y
    and #ENT_Y_POS
    sta arg+3
    REPEAT 4
    LSR16 arg
    LSR16 arg+2
    REPEND
    sty sav
    jsr GetTile
    ldy sav
    lda ret
    and #$FE
    sta arg+4
    jsr SetTile
    ldy sav
    lda #$80
    sta entityXHi,y
    jmp ER_Return
.continue:
    lda entityCount,y
    tax
    lda girderTable,x
    sta tmp
    inx
    txa
    sta entityCount,y
    EXTEND tmp,tmp
    lda tmp
    clc
    adc entityYLo,y
    sta entityYLo,y
    lda tmp+1
    adc entityYHi,y
    sta entityYHi,y
    jmp ER_Return

ER_PipeRight subroutine
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    sta tmp+1
    CMP16 playerX,tmp
    bcs .notbehind
    jmp ER_Return
.notbehind:
    ADD16I tmp,tmp,[5*16]
    CMP16 playerX,tmp
    bcc .notBeyond
    jmp ER_Return
.notBeyond:
    Jmp ER_Pipe
    
ER_PipeLeft subroutine
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    sta tmp+1
    ADD16I tmp,tmp,16
    CMP16 playerX,tmp
    bcc .notbehind
    jmp ER_Return
.notbehind:
    SUB16I tmp,tmp,[5*16]
    CMP16 playerX,tmp
    bcs .notBeyond
    jmp ER_Return
.notBeyond:
    Jmp ER_Pipe
    
ER_Pipe subroutine
    MOV16I arg, 10
    jsr EntAwayFromPlayerY
    bcs .end
    MOV16I arg, 10
    jsr EntAwayFromPlayerX
    bcs .noKill
    jsr KillPlayer
.noKill:
    lda frame
    and #1
    beq .end
    lda entityVelocity,y
    sta tmp
    EXTEND tmp,tmp
    ADD16 playerX, playerX, tmp
.end:
    jmp ER_Return

FlameTable:
    .byte 16
    .byte 15
    .byte 14
    .byte 13
    .byte 12
    .byte 11
    .byte 10
    .byte 9
    .byte 8
    .byte 7
    .byte 6
    .byte 5
    .byte 4
    .byte 3
    .byte 2
    .byte 1
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 1
    .byte 2
    .byte 4
    .byte 8
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    
ER_Flame subroutine
    lda entityXHi,y
    and #ENT_X_STATE
    bne .notFirstUpdate
    lda entityYLo,y
    sta entityCount,y
    lda entityYHi,y
    sta entityVelocity,y
    lda entityXHi,y
    ora #[1<<ENT_X_STATE_SHIFT]
    sta entityXHi,y
.notFirstUpdate:
    lda frame
    lsr
    tax
    lda FlameTable,x
    clc
    adc entityCount,y
    sta entityYLo,y
    lda #0
    adc entityVelocity,y
    sta entityYHi,y
    jsr EntTryMelee
    jmp ER_Return

ER_Stalactite subroutine
    jsr EntTryMelee
    lda entityCount,y
    beq .notFalling
    jsr EntFall
    sty sav
    jsr EntTestVerticalCollision
    ldy sav
    bcs .hit
    jmp .nohit
.hit:
    lda #$80
    sta entityXHi,y
.nohit:
    jmp ER_Return

.notFalling:
    MOV16I arg, 8
    jsr EntAwayFromPlayerX
    bcs .noFall
    
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    CMP16I tmp, playerY
    bcs .noFall
    lda #1
    sta entityCount,y
.noFall:
    jmp ER_Return
    
    
ER_Mimrock subroutine
    jsr EntTryMelee
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
    lda entityYHi
    lsr
    cmp #POWERSHOT_ID
    bne .alive
    lda #$80
    sta entityXHi,y
    lda #10
    sta arg
    lda #0
    sta arg+1
    sta arg+2
    jsr AddScore
.alive:
    MOV16I arg, 32
    jsr EntAwayFromPlayerY
    bcs .hiding
    MOV16I arg, 64
    jsr EntAwayFromPlayerX
    bcs .hiding
    lda #ANIM_SMALL_OSCILLATE
    sta entityAnim,y
    lda entityVelocity,y
    bpl .notLeft
    lda #ANIM_SMALL_HFLIP_OSCILLATE
    sta entityAnim,y
.notLeft:
    sty sav
    jsr EntTestWalkingCollision
    ldy sav
    bcc .noTurn
    lda entityVelocity,y
    eor #$FF
    clc
    adc #1
    sta entityVelocity,y
.noTurn:
    jsr EntMoveHorizontally
    jmp ER_Return
.hiding:
    lda #ANIM_ROCK_HIDING
    sta entityAnim,y
    jmp ER_Return

ER_RightCannon subroutine
    lda #4
    sta entityVelocity+1,y
    jmp ER_Cannon
ER_LeftCannon subroutine
    lda #<-4
    sta entityVelocity+1,y
ER_Cannon
    lda #SWITCH_TURRETS
    bit switches
    beq return$
    MOV16I arg, 8
    jsr EntAwayFromPlayerY
    bcs return$
    lda entityXHi+1,y
    bpl return$
    lda entityCount,y
    clc
    adc #1
    sta entityCount,y
    cmp #$10
    bne return$
    
    MOV16I arg, sfxLaser
    jsr PlaySound
    
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
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim+1,y
return$:
    jmp ER_Return
    
ER_Faucet subroutine
    lda entityXHi+1,y
    bpl return$
    lda entityCount,y
    clc
    adc #1
    sta entityCount,y
    cmp #$30
    bne return$
    lda #0
    sta entityCount,y
    lda entityXHi,y
    sta entityXHi+1,y
    lda entityXLo,y
    sta entityXLo+1,y
    lda entityYHi,y
    and #~ENT_Y_INDEX
    ora #32
    sta entityYHi+1,y
    lda entityYLo,y
    sta entityYLo+1,y
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim+1,y
    lda #4
    sta entityVelocity+1,y
return$:
    jmp ER_Return
    
ER_PowerShot:
ER_Bullet subroutine
    lda entityXLo,y
    sta sav
    lda entityXHi,y
    and #ENT_X_POS
    sta sav+1
    ADD16I sav,sav,2
    lda entityYLo,y
    sta sav+2
    lda entityYHi,y
    and #ENT_Y_POS
    sta sav+3
    ADD16I sav+2,sav+2,8
    lda entityVelocity,y
    bmi .notRight
    ADD16I sav,sav,12
.notRight:
    REPEAT 4
    LSR16 sav
    LSR16 sav+2
    REPEND
    ;sav = map cell x
    ;sav+2 = map cell y

    MOV16 arg,sav
    MOV16 arg+2,sav+2
    sty sav+4
    jsr GetTileBehavior
    ldy sav+4
    lda ret
    cmp #TB_AIR
    bne .notAir
    jsr KillPlayer
.notAir:
    cmp #TB_SOLID
    beq .die
    cmp #TB_WEAKBLOCK
    bne .notWeakBlock
    MOV16 arg,sav
    MOV16 arg+2,sav+2
    lda #0 
    sta arg+4
    jmp .changeTile
.notWeakBlock:
    cmp #TB_EGG
    bne .notEgg
    MOV16 arg,sav
    MOV16 arg+2,sav+2
    lda bonusCount
    and #7
    clc
    adc #BONUS_TILES
    sta arg+4
    inc bonusCount
.changeTile:
    sty sav
    jsr SetTile
    ldy sav
.die:
    lda #$80
    sta entityXHi,y
    jmp ER_Return
.notEgg:

    jsr EntMoveHorizontally
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


ER_Spider subroutine
    lda #ANIM_SPIDER_VFLIP
    sta entityAnim,y
    lda entityVelocity,y
    bmi .notDown
    lda #ANIM_SPIDER
    sta entityAnim,y
.notDown:
    sty sav
    jsr EntTestVerticalCollision
    ldy sav
    bcs .hit
    jmp .nohit
.hit:
    lda entityVelocity,y
    eor #$FF
    clc
    adc #1
    sta entityVelocity,y
.nohit
    jsr EntTryMelee
    jsr EntMoveVertically
    
    lda entityCount,y
    bne .notShoot
    MOV16I arg, 8
    jsr EntAwayFromPlayerX
    bcs .notShoot
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    CMP16 playerY,tmp
    bcc .notShoot
    lda entityXHi+1,y
    bpl .notShoot
    ADD16I tmp, tmp, 16
    lda tmp
    sta entityYLo+1,y
    lda tmp+1
    ora #SPIDERWEB_ID<<1
    sta entityYHi+1,y
    lda entityXLo,y
    sta entityXLo+1,y
    lda entityXHi,y
    sta entityXHi+1,y
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim+1,y
    lda #2
    sta entityVelocity+1,y
    lda #60
    sta entityCount,y
.notShoot:
    lda entityCount,y
    beq .noDecrement
    sec
    sbc #1
    sta entityCount,y
.noDecrement
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
    sta entityXHi,y
    lda #10
    sta arg
    lda #0
    sta arg+1
    sta arg+2
    jsr AddScore
.alive:
    jmp ER_Return
    
ER_SpiderWeb subroutine
    sty sav
    jsr EntTestVerticalCollision
    ldy sav
    bcc .notDead
    lda #$80
    sta entityXHi,y
    jmp ER_Return
.notDead:
    jsr EntMoveVertically
    jsr EntTryMelee
    jmp ER_Return
    
ER_Bat subroutine
    sty sav
    jsr EntTestFlyingCollision
    ldy sav
    bcc .nohit
    lda entityVelocity,y
    eor #$FF
    clc
    adc #1
    sta entityVelocity,y
.nohit
    jsr EntTryMelee
    jsr EntMoveHorizontally
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
    sta entityXHi,y
    lda #10
    sta arg
    lda #0
    sta arg+1
    sta arg+2
    jsr AddScore
.alive:
    jmp ER_Return


ER_Rex subroutine
    sty sav
    jsr EntTestWalkingCollision
    ldy sav
    bcc .nohit
    lda entityVelocity,y
    eor #$FF
    clc
    adc #1
    sta entityVelocity,y
.nohit:
    lda #ANIM_REX
    sta entityAnim,y
    lda entityVelocity,y
    bpl .notRight
    lda #ANIM_REX_HFLIP
    sta entityAnim,y
.notRight:
    jsr EntMoveHorizontally
    
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sta tmp+1
    lda entityYLo,y
    sta tmp+2
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+3
    SUB16I tmp+2,tmp+2,8
    SUB16 tmp+4, tmp, playerX
    ABS16 tmp+4, tmp+4
    CMP16I tmp+4, 14
    bcs .noMelee
    SUB16 tmp+4, tmp+2, playerY
    ABS16 tmp+4, tmp+4
    CMP16I tmp+4, 24
    bcs .noMelee
    jsr DamagePlayer
.noMelee:

    lda entityXHi
    bpl .exists
    jmp .noBullet
.exists
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sta tmp+1
    lda entityXLo
    sta tmp+2
    lda entityXHi
    and #ENT_X_POS
    sta tmp+3
    
    SUB16 tmp, tmp, tmp+2
    ABS16 tmp, tmp
    CMP16I tmp, 14
    bcc .maybeBullet
    jmp .noBullet
.maybeBullet:
    
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    lda entityYLo
    sta tmp+2
    lda entityYHi
    and #ENT_Y_POS
    sta tmp+3
    ADD16I tmp+2,tmp+2,8

    SUB16 tmp, tmp, tmp+2
    ABS16 tmp,tmp
    CMP16I tmp, 24
    bcs .noBullet
    
    lda #$80
    sta entityXHi
    lda entityYHi
    asl
    cmp #POWERSHOT_ID
    beq .dead
    lda entityCount,y
    cmp #5
    beq .dead
    clc
    adc #1
    sta entityCount,y
    jmp .noBullet
.dead
    lda #$80
    sta entityXHi,y
    lda #0
    sta arg
    lda #5
    sta arg+1
    lda #0
    sta arg+2
    jsr AddScore
.noBullet:    
    jmp ER_Return


ER_CaterpillarHead:
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
    sta entityXHi,y
    
    lda entityYHi+1,y
    lsr
    cmp #CATERPILLAR_ID
    bcc .lastOne
    cmp #CATERPILLAR_ID+4
    bcs .lastOne
    lda entityYHi,y ;should be on same y coord, no need to extract
    sta entityYHi+1,y
.lastOne:
    lda #1
    sta arg+1
    lda #0
    sta arg
    sta arg+2
    jsr AddScore
    jmp ER_Return
.alive:
ER_CaterpillarBack subroutine
    lda #ANIM_CATERPILLAR
    sta entityAnim,y
    lda entityVelocity,y
    bpl .notRight
    lda #ANIM_CATERPILLAR_HFLIP
    sta entityAnim,y
.notRight:
    jmp ER_Caterpillar
    
ER_CaterpillarFront:
ER_CaterpillarTail subroutine
    lda #ANIM_CATERPILLAR_2
    sta entityAnim,y
    lda entityVelocity,y
    bpl .notRight
    lda #ANIM_CATERPILLAR_HFLIP_2
    sta entityAnim,y
.notRight:
ER_Caterpillar subroutine
    sty sav
    jsr EntTestWalkingCollision
    ldy sav
    bcc .noTurn
    lda entityVelocity,y
    eor #$FF
    clc
    adc #1
    sta entityVelocity,y
.noTurn:
    jsr EntMoveHorizontally
    jsr EntTryMelee
    jmp ER_Return

ER_Cart subroutine
    lda #ANIM_SYMMETRICAL_OSCILLATE
    sta entityAnim,y
    sty sav
    jsr EntTestWalkingCollision
    ldy sav
    bcs .hit
    jmp .nohit
.hit:
    lda entityVelocity,y
    eor #$FF
    clc
    adc #1
    sta entityVelocity,y
    lda #$60
    sta entityCount,y
.nohit:
    jsr EntTryMelee
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
    
    lda entityYHi
    asl
    cmp #POWERSHOT_ID
    bne .alive
    
    lda #$80
    sta entityXHi,y
    lda #10
    sta arg
    lda #0
    sta arg+1
    sta arg+2
    jsr AddScore
.alive:
    lda entityCount,y
    beq .nopause
    sec
    sbc #1
    sta entityCount,y
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim,y
    jmp ER_Return
.nopause:
    jsr EntMoveHorizontally
    jmp ER_Return


ER_SlimeHorizontal subroutine
    jsr EntTryMelee
    jmp ER_Return
ER_SlimeVertical subroutine
    jsr EntTryMelee
    jmp ER_Return
    
ER_Hammer subroutine    
    jsr EntTryMelee
    
    lda entityCount,y
    beq .notFalling
    lda entityXLo,y
    sta arg
    lda entityXHi,y
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,y
    sta arg+2
    lda entityYHi,y
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg,arg, 8
    ADD16I arg+2,arg+2,16
    sty sav
    jsr TestCollision
    ldy sav
    bcc .notLanded
    lda #0
    sta entityCount,y
    lda #<-1
    sta entityVelocity,y
    jmp ER_Return
.notLanded:
    jsr EntFall
    jmp ER_Return
.notFalling:
    lda entityXLo,y
    sta arg
    lda entityXHi,y
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,y
    sta arg+2
    lda entityYHi,y
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg,arg, 8
    sty sav
    jsr TestCollision
    ldy sav
    bcc .notApex
    lda #1
    sta entityCount,y
    lda #0
    sta entityVelocity,y
    jmp ER_Return
.notApex:
    jsr EntMoveVertically
    jmp ER_Return
    
ER_Water subroutine
    lda entityXLo,y
    sta arg
    lda entityXHi,y
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,y
    sta arg+2
    lda entityYHi,y
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg,arg, 8
    lda entityVelocity,y
    bmi .notDown
    ADD16I arg+2,arg+2,16
.notDown:
    sty sav
    jsr TestCollisionTop
    ldy sav
    bcc .notDead
    lda #$80
    sta entityXHi,y
    jmp ER_Return
.notDead:
    jsr EntMoveVertically
    jsr EntTryMelee
    jmp ER_Return
    
ER_RightLaser subroutine
ER_LeftLaser subroutine
    sty sav
    jsr EntTestFlyingCollision
    ldy sav
    bcc .notDead
    lda #$80
    sta entityXHi,y
    jmp ER_Return
.notDead:
    jsr EntMoveHorizontally
    jsr EntTryMelee
    jmp ER_Return

ER_VerticalPlatform subroutine
    lda entityXLo,y
    sta arg
    lda entityXHi,y
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,y
    sta arg+2
    lda entityYHi,y
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg,arg, 8
    SUB16I arg+2,arg+2,16
    lda entityVelocity,y
    bmi .notDown
    ADD16I arg+2,arg+2,32
.notDown:
    sty sav
    jsr TestCollision
    ldy sav
    bcc .nohit
    lda entityVelocity,y
    eor #$FF
    clc
    adc #1
    sta entityVelocity,y
.nohit:
    lda entityYLo,y
    sta sav
    lda entityYHi,y
    and #ENT_Y_POS
    sta sav+1
    jsr EntMoveVertically
    MOV16I arg, 8
    jsr EntAwayFromPlayerX
    bcs .noRider
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    SUB16I tmp,tmp,16
    SUB16 tmp,tmp,playerY
    ABS16 tmp,tmp
    CMP16I tmp,4
    bcs .noRider
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    SUB16 tmp, tmp, sav
    ADD16 playerY, playerY, tmp
.noRider:
    jmp ER_Return
    
ER_HorizontalPlatform subroutine
    sty sav
    jsr EntTestFlyingCollision
    ldy sav
    bcc .nohit
    lda entityVelocity,y
    eor #$FF
    clc
    adc #1
    sta entityVelocity,y
.nohit:
    lda entityXLo,y
    sta sav
    lda entityXHi,y
    and #ENT_X_POS
    sta sav+1
    jsr EntMoveHorizontally
    MOV16I arg, 8
    jsr EntAwayFromPlayerX
    bcs .noRider
    lda entityYLo,y
    sta tmp
    lda entityYHi,y
    and #ENT_Y_POS
    sta tmp+1
    SUB16I tmp,tmp,16
    SUB16 tmp,tmp,playerY
    ABS16 tmp,tmp
    CMP16I tmp,4
    bcs .noRider
    lda entityXLo,y
    sta tmp
    lda entityXHi,y
    and #ENT_X_POS
    sta tmp+1
    SUB16 tmp, tmp, sav
    ADD16 playerX, playerX, tmp
.noRider:
    jmp ER_Return
    
ER_VerticalPlatformIdle subroutine
    lda #1
    bit switches
    beq .off
    jmp ER_VerticalPlatform
.off:
    jmp ER_Return
    
ER_HorizontalPlatformIdle subroutine
    lda #2
    bit switches
    beq .off
    jmp ER_HorizontalPlatform
.off:
    jmp ER_Return
