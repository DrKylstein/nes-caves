entityRoutine:
    .word ER_Player
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
    .word ER_Girder
    .word ER_Rex
    .word ER_Stalactite
    .word ER_SpiderWeb
    .word ER_Flame
    .word ER_PipeRight
    .word ER_PipeLeft
    .word ER_Return ; torch
    .word ER_Spike
    .word ER_Planet
    .word ER_Bullet
    .word ER_Explosion
    .word ER_Fruit ;cherry
    .word ER_Fruit ;strawberry
    .word ER_Fruit ;peach
    .word ER_Ball
    
entityFlags:
    .byte 1 ; player
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
    .byte 0 ; planet
    .byte ENT_F_ISTEMPORARY | 2; bullet
    .byte ENT_F_ISTEMPORARY | 1; explosion
    .byte 1 ; cherry
    .byte 1 ; strawberry
    .byte 1 ; peach
    .byte 2 ; ball
        
entityTiles:
    .byte 0 ; player
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
    .byte [31+32*3]*2 ; torch
    .byte 32*3 + 16 + 1; spike
    .byte 32*4 + 24 + 1;planet
    .byte 14*2 ; bullet
    .byte 24*2 ; explosion
    .byte 28*2 ; cherry
    .byte 27*2 ; strawberry
    .byte 29*2 ; peach
    .byte [19+32*3]*2 ; ball
    
    
entitySpeeds:
    .byte 0 ; player
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
    .byte 0 ; planet
    .byte 4 ; bullet
    .byte 0 ; explosion
    .byte 0 ; cherry
    .byte 0 ; strawberry
    .byte 0 ; peach
    .byte 2 ; ball
    
entityInitialAnims:
    .byte ANIM_SMALL_NONE ; player
    .byte ANIM_SPIDER ; vertical platform
    .byte ANIM_SPIDER ; horizontal platform
    .byte ANIM_SPIDER ; spider
    .byte ANIM_SYMMETRICAL_OSCILLATE ; bat
    .byte ANIM_POWERSHOT ; power shot
    .byte ANIM_SMALL_OSCILLATE ; rock
    .byte ANIM_SYMMETRICAL_OSCILLATE ; cart
    .byte ANIM_SMALL_NONE ; caterpillar head
    .byte ANIM_SMALL_NONE ; caterpillar front
    .byte ANIM_SMALL_NONE ; caterpillar back
    .byte ANIM_SMALL_NONE ; caterpillar tail
    .byte ANIM_SLIME_RIGHT ; slime horizontal
    .byte ANIM_SLIME_DOWN ; slime vertical
    .byte ANIM_HAMMER ; hammer
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
    .byte ANIM_PLANET
    .byte ANIM_ROCKET ; bullet
    .byte ANIM_SYMMETRICAL_OSCILLATE ; explosion
    .byte ANIM_SYMMETRICAL_NONE ; cherry
    .byte ANIM_SYMMETRICAL_NONE ; strawberry
    .byte ANIM_SYMMETRICAL_NONE ; peach
    .byte ANIM_BALL_RIGHT

    
EntAwayFromPlayerX subroutine ; distance in arg 0-1, result in carry
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    SUB16 tmp,tmp,playerX
    ABS16 tmp,tmp
    CMP16 tmp,arg
    rts
    
EntAwayFromPlayerY subroutine ; distance in arg 0-1, result in carry
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    SUB16 tmp,tmp,playerY
    ABS16 tmp,tmp
    CMP16 tmp,arg
    rts

EntMoveHorizontally subroutine
    lda entityVelocity,x
    NMOS_ASR
    sta tmp
    EXTEND tmp, tmp
    lda frame
    and #1
    beq .noExtra
    lda entityVelocity,x
    bpl .positive
    DEC16 tmp
    jmp .noExtra
.positive:
    INC16 tmp
.noExtra:
    clc
    lda entityXLo,x
    adc tmp
    sta entityXLo,x
    lda entityXHi,x
    adc tmp+1
    and #ENT_X_POS
    sta tmp
    lda entityXHi,x
    and #~ENT_X_POS
    ora tmp
    sta entityXHi,x
    rts
    
EntMoveVertically subroutine
    lda entityVelocity,x
    NMOS_ASR
    sta tmp
    EXTEND tmp, tmp
    lda frame
    and #1
    beq .noExtra
    lda entityVelocity,x
    bpl .positive
    DEC16 tmp
    jmp .noExtra
.positive:
    INC16 tmp
.noExtra:
    clc
    lda entityYLo,x
    adc tmp
    sta entityYLo,x
    lda entityYHi,x
    adc tmp+1
    and #ENT_Y_POS
    sta tmp
    lda entityYHi,x
    and #~ENT_Y_POS
    ora tmp
    sta entityYHi,x
    rts

EntIsStrongPlayerNear subroutine
    lda powerType
    cmp #POWER_STRENGTH
    beq .maybe
    jmp .no
.maybe:
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    lda entityYLo,x
    sta tmp+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+3
    
    SUB16 tmp+4, tmp, playerX
    ABS16 tmp+4, tmp+4
    CMP16I tmp+4, 12
    bcs .no
    
    SUB16 tmp+4, tmp+2, playerY
    ABS16 tmp+4, tmp+4
    CMP16I tmp+4, 12
    bcs .no
    
    sec
    rts
.no:
    clc
    rts
    
EntIsStrongPlayerNearTall subroutine
    lda powerType
    cmp #POWER_STRENGTH
    beq .maybe
    jmp .no
.maybe:
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    lda entityYLo,x
    sta tmp+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+3
    
    SUB16 tmp+4, tmp, playerX
    ABS16 tmp+4, tmp+4
    CMP16I tmp+4, 12
    bcs .no
    
    SUB16I tmp+2, tmp+2, 8
    SUB16 tmp+4, tmp+2, playerY
    ABS16 tmp+4, tmp+4
    CMP16I tmp+4, [12+8]
    bcs .no
    
    sec
    rts
.no:
    clc
    rts


EntIsBulletNear subroutine
    lda entityXHi
    bpl .Exists
    jmp .no
.Exists:
    lda entityYHi
    lsr
    cmp #EXPLOSION_ID
    bne .NotExplosion
    jmp .no
.NotExplosion:
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
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
    
    
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
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

EntIsBulletNearTall subroutine
    lda entityXHi
    bpl .Exists
    jmp .no
.Exists:
    lda entityYHi
    lsr
    cmp #EXPLOSION_ID
    bne .NotExplosion
    jmp .no
.NotExplosion:
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
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
    
    
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    lda entityYLo
    sta tmp+2
    lda entityYHi
    and #ENT_Y_POS
    sta tmp+3
    
    SUB16I tmp,tmp,8
    SUB16 tmp, tmp, tmp+2
    ABS16 tmp, tmp
    CMP16I tmp, [14+8]
    bcs .no
    sec
    rts
    
.no:
    clc
    rts

EntTryMelee subroutine
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    lda entityYLo,x
    sta tmp+2
    lda entityYHi,x
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
    lda entityXLo,x
    sta arg
    lda entityXHi,x
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,x
    sta arg+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg+2,arg+2, 8
    lda entityVelocity,x
    bmi .notRight
    ADD16I arg,arg,16
.notRight:
    MOV16 sav,arg
    MOV16 sav+2,arg+2
    jsr TestCollision
    bcs .hit
    ADD16I arg+2,sav+2,8
    MOV16 arg,sav
    jsr TestCollisionTop
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
    lda entityXLo,x
    sta arg
    lda entityXHi,x
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,x
    sta arg+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg+2,arg+2,8
    lda entityVelocity,x
    bmi .notRight
    ADD16I arg,arg,16
.notRight:
    jmp TestCollision

EntTestVerticalCollision
    lda entityXLo,x
    sta arg
    lda entityXHi,x
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,x
    sta arg+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg,arg, 8
    lda entityVelocity,x
    bmi .notDown
    ADD16I arg+2,arg+2,16
.notDown:
    jmp TestCollision


EntFall subroutine
    lda entityCount,x
    clc
    adc #1
    sta entityCount,x
    cmp #STALACTITE_GRAVITY
    bmi .noAccel
    
    lda #1
    sta entityCount,x
    lda entityVelocity,x
    clc
    adc #1
    cmp #>TERMINAL_VELOCITY
    bcc .nonTerminal
    lda #>TERMINAL_VELOCITY
.nonTerminal:
    sta entityVelocity,x
.noAccel:
    ;apply velocity at 1 pixel per frame resolution
    lda entityVelocity,x
    sta tmp
    EXTEND tmp,tmp
    lda tmp
    clc
    adc entityYLo,x
    sta entityYLo,x
    lda entityYHi,x
    and #ENT_Y_POS
    adc tmp+1
    sta tmp
    lda entityYHi,x
    and #ENT_Y_INDEX
    ora tmp
    sta entityYHi,x
    rts

EntDieByPowerOnly subroutine
    jsr EntIsStrongPlayerNear
    bcs .Melee
    jsr EntIsBulletNear
    bcc .alive
    lda entityYHi
    lsr
    cmp #POWERSHOT_ID
    bne .alive
    lda #$80
    sta entityXHi
.Melee:
    ;lda #$80
    ;sta entityXHi,x
    lda entityYHi,x
    and #1
    ora #EXPLOSION_ID<<1
    sta entityYHi,x
    lda #ANIM_SYMMETRICAL_OSCILLATE
    sta entityAnim,x
    lda #10
    sta arg
    lda #0
    sta arg+1
    sta arg+2
    stx sav
    jsr AddScore
    ldx sav
.alive:
    rts
    
EntDieInOneShot subroutine
    jsr EntIsStrongPlayerNear
    bcs .Melee
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
.Melee:
    ;lda #$80
    ;sta entityXHi,x
    lda entityYHi,x
    and #1
    ora #EXPLOSION_ID<<1
    sta entityYHi,x
    lda #ANIM_SYMMETRICAL_OSCILLATE
    sta entityAnim,x
    lda #10
    sta arg
    lda #0
    sta arg+1
    sta arg+2
    stx sav
    jsr AddScore
    ldx sav
.alive:
    rts

ER_Ball subroutine
    jsr EntTryMelee
    jsr EntIsStrongPlayerNear
    bcs .Melee
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
    lda entityCount,x
    bmi .Melee
    lda entityYHi
    lsr
    cmp #POWERSHOT_ID
    bne .alive
.Melee:
    lda entityYHi,x
    and #1
    ora #EXPLOSION_ID<<1
    sta entityYHi,x
    lda #ANIM_SYMMETRICAL_OSCILLATE
    sta entityAnim,x
    lda #5
    sta arg+1
    lda #0
    sta arg
    sta arg+2
    stx sav
    jsr AddScore
    ldx sav
    jmp ER_Return
.alive:
    lda entityCount,x
    bpl .rolling
    sec
    sbc #1
    sta entityCount,x
    lda #ANIM_BALL_SLEEP
    sta entityAnim,x
    jmp ER_Return
.rolling:
    cmp #-127
    bne .continue
    lda #30
    sta entityCount,x
.continue:
    sec
    sbc #1
    sta entityCount,x
    jsr EntMoveHorizontally
    jsr EntTestWalkingCollision
    bcc .nohit
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.nohit:
    lda #ANIM_BALL_RIGHT
    sta entityAnim,x
    lda entityVelocity,x
    bpl .right
    lda #ANIM_BALL_LEFT
    sta entityAnim,x
.right:
    jmp ER_Return


ER_Fruit subroutine
    lda entityXLo,x
    sta arg
    lda entityXHi,x
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,x
    sta arg+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg+2,arg+2,8
    ADD16I arg,arg,8
    jsr TestCollision
    bcc .alive
    lda #$80
    sta entityXHi,x
    jmp ER_Return
.alive:
    lda entityCount,x
    bne .notStart
    lda #1
    sta entityCount,x
    MOV16I arg, sfxCrystal
    jsr PlaySound
.notStart:
    MOV16I arg, 12
    jsr EntAwayFromPlayerX
    bcs .DoNothing
    MOV16I arg, 12
    jsr EntAwayFromPlayerY
    bcs .DoNothing
    lda #$80
    sta entityXHi,x
    lda #5
    sta arg+1
    lda #0
    sta arg
    sta arg+2
    stx sav
    jsr AddScore
    ldx sav
.DoNothing:
    jmp ER_Return

ER_Explosion subroutine
    lda entityCount,x
    clc
    adc #1
    sta entityCount,x
    cmp #12
    bcc .alive
    lda #$80
    sta entityXHi,x
.alive:
    jmp ER_Return

ER_Player subroutine
    lda entityCount,x
    cmp #250
    bne .nodialog
    stx sav
    MOV16I arg,openingText
    jsr MessageBox
    ldx sav
.nodialog:
    
    lda playerFlags
    and #PLY_LOCKED
    beq .end
    lda entityCount,x
    beq .end
    lda #1
    sta playerXVel
    lda entityCount,x
    sec
    sbc #1
    sta entityCount,x
    bne .end
    inc exitTriggered
.end:
    jmp ER_Return

ER_Planet subroutine
    ADD16I tmp, shr_cameraX, 160
    ; MOV16 tmp+2, shr_cameraX
    ; REPEAT 1
    ; LSR16 tmp+2
    ; REPEND
    ; SUB16 tmp, tmp, tmp+2
    
    lda tmp
    sta entityXLo,x
    lda tmp+1
    sta entityXHi,x
    jmp ER_Return

ER_Spike subroutine
    jsr EntTryMelee
    lda entityYLo,x
    ora #$0A
    sta entityYLo,x

    MOV16I arg, 10
    jsr EntAwayFromPlayerX
    bcs .end
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    CMP16 playerY,tmp
    bcs .end
    SUB16I tmp, tmp, 4*16
    CMP16 playerY,tmp
    bcc .end
    lda entityYLo,x
    and #$F0
    sta entityYLo,x
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
    lda entityCount,x
    cmp #8
    bne .continue    
    lda entityXLo,x
    sta arg
    lda entityXHi,x
    sta arg+1
    lda entityYLo,x
    sta arg+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta arg+3
    REPEAT 4
    LSR16 arg
    LSR16 arg+2
    REPEND
    stx sav
    jsr GetTile
    ldx sav
    lda ret
    and #$FE
    sta arg+4
    jsr SetTile
    ldx sav
    lda #$80
    sta entityXHi,x
    jmp ER_Return
.continue:
    lda entityCount,x
    tay
    lda girderTable,y
    sta tmp
    iny
    tya
    sta entityCount,x
    EXTEND tmp,tmp
    lda tmp
    clc
    adc entityYLo,x
    sta entityYLo,x
    lda tmp+1
    adc entityYHi,x
    sta entityYHi,x
    jmp ER_Return

ER_PipeRight subroutine
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
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
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
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
    lda entityVelocity,x
    sta tmp
    EXTEND tmp,tmp
    ADD16 playerX, playerX, tmp
.end:
    jmp ER_Return

flameTable:
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
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
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
    .byte -1 ;1
    .byte -1 ;2
    .byte -2 ;4
    .byte -4 ;8
    .byte -8 ;16
    
ER_Flame subroutine
    lda entityCount,x
    lsr
    tay
    lda flameTable,y
    sta tmp
    lda entityCount,x
    clc
    adc #1
    sta entityCount,x
    EXTEND tmp,tmp
    lda tmp
    clc
    adc entityYLo,x
    sta entityYLo,x
    lda tmp+1
    adc entityYHi,x
    sta entityYHi,x    
    jsr EntTryMelee
    jmp ER_Return

ER_Stalactite subroutine
    jsr EntTryMelee
    lda entityCount,x
    beq .notFalling
    jsr EntFall
    jsr EntTestVerticalCollision
    bcs .hit
    jmp .nohit
.hit:
    lda #$80
    sta entityXHi,x
.nohit:
    jmp ER_Return

.notFalling:
    MOV16I arg, 8
    jsr EntAwayFromPlayerX
    bcs .noFall
    
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    CMP16I tmp, playerY
    bcs .noFall
    lda #1
    sta entityCount,x
.noFall:
    jmp ER_Return
    
    
ER_Mimrock subroutine
    jsr EntTryMelee
    MOV16I arg, 32
    jsr EntAwayFromPlayerY
    bcs .hiding
    MOV16I arg, 64
    jsr EntAwayFromPlayerX
    bcs .hiding
    lda #ANIM_SMALL_OSCILLATE
    sta entityAnim,x
    lda entityVelocity,x
    bpl .notLeft
    lda #ANIM_SMALL_HFLIP_OSCILLATE
    sta entityAnim,x
.notLeft:
    jsr EntTestWalkingCollision
    bcc .noTurn
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.noTurn:
    jsr EntMoveHorizontally
    jmp .end
.hiding:
    lda #ANIM_ROCK_HIDING
    sta entityAnim,x
.end:
    jsr EntDieByPowerOnly
    jmp ER_Return

ER_RightCannon subroutine
    lda #4
    sta entityVelocity+1,x
    jmp ER_Cannon
ER_LeftCannon subroutine
    lda #<-4
    sta entityVelocity+1,x
ER_Cannon
    lda #SWITCH_TURRETS
    bit switches
    beq return$
    MOV16I arg, 8
    jsr EntAwayFromPlayerY
    bcs return$
    lda entityXHi+1,x
    bpl return$
    lda entityCount,x
    clc
    adc #1
    sta entityCount,x
    cmp #$10
    bne return$
    
    MOV16I arg, sfxLaser
    jsr PlaySound
    
    lda #0
    sta entityCount,x
    lda entityXHi,x
    sta entityXHi+1,x
    lda entityXLo,x
    sta entityXLo+1,x
    lda entityYHi,x
    and #~ENT_Y_INDEX
    ora #40
    sta entityYHi+1,x
    lda entityYLo,x
    sta entityYLo+1,x
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim+1,x
return$:
    jmp ER_Return
    
ER_Faucet subroutine
    lda entityXHi+1,x
    bpl return$
    lda entityCount,x
    clc
    adc #1
    sta entityCount,x
    cmp #$30
    bne return$
    lda #0
    sta entityCount,x
    lda entityXHi,x
    sta entityXHi+1,x
    lda entityXLo,x
    sta entityXLo+1,x
    lda entityYHi,x
    and #~ENT_Y_INDEX
    ora #32
    sta entityYHi+1,x
    lda entityYLo,x
    sta entityYLo+1,x
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim+1,x
    lda #4
    sta entityVelocity+1,x
return$:
    jmp ER_Return
    
ER_PowerShot:
ER_Bullet subroutine
    lda entityXLo,x
    sta sav
    lda entityXHi,x
    and #ENT_X_POS
    sta sav+1
    ADD16I sav,sav,2
    lda entityYLo,x
    sta sav+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta sav+3
    ADD16I sav+2,sav+2,8
    lda entityVelocity,x
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
    stx sav+4
    jsr GetTileBehavior
    ldx sav+4
    lda ret
    cmp #TB_AIR
    bne .notAir
    stx sav
    MOV16I arg,airMsg
    jsr MessageBox
    ldx sav
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
    stx sav
    jsr SetTile
    ldx sav
.die:
    lda entityYHi,x
    and #1
    ora #EXPLOSION_ID<<1
    sta entityYHi,x
    lda #ANIM_SYMMETRICAL_OSCILLATE
    sta entityAnim,x
    jmp ER_Return
.notEgg:

    jsr EntMoveHorizontally
    lda entityCount,x
    clc
    adc #1
    sta entityCount,x
    cmp #$28
    bne done$
    
    lda entityVelocity,x
    bmi negative$
    clc
    adc #3
    sta entityVelocity,x
    jmp ER_Return
negative$:
    sec
    sbc #3
    sta entityVelocity,x
done$:
    jmp ER_Return


ER_Spider subroutine
    lda #ANIM_SPIDER_VFLIP
    sta entityAnim,x
    lda entityVelocity,x
    bmi .notDown
    lda #ANIM_SPIDER
    sta entityAnim,x
.notDown:
    jsr EntTestVerticalCollision
    bcs .hit
    jmp .nohit
.hit:
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.nohit
    jsr EntTryMelee
    jsr EntMoveVertically
    
    lda entityCount,x
    bne .notShoot
    MOV16I arg, 8
    jsr EntAwayFromPlayerX
    bcs .notShoot
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    CMP16 playerY,tmp
    bcc .notShoot
    lda entityXHi+1,x
    bpl .notShoot
    ADD16I tmp, tmp, 16
    lda tmp
    sta entityYLo+1,x
    lda tmp+1
    ora #SPIDERWEB_ID<<1
    sta entityYHi+1,x
    lda entityXLo,x
    sta entityXLo+1,x
    lda entityXHi,x
    sta entityXHi+1,x
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim+1,x
    lda #2
    sta entityVelocity+1,x
    lda #60
    sta entityCount,x
.notShoot:
    lda entityCount,x
    beq .noDecrement
    sec
    sbc #1
    sta entityCount,x
.noDecrement
    jsr EntDieInOneShot
    jmp ER_Return
    
ER_SpiderWeb subroutine
    jsr EntTestVerticalCollision
    bcc .notDead
    lda #$80
    sta entityXHi,x
    jmp ER_Return
.notDead:
    jsr EntMoveVertically
    jsr EntTryMelee
    jmp ER_Return
    
ER_Bat subroutine
    jsr EntTestFlyingCollision
    bcc .nohit
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.nohit
    jsr EntTryMelee
    jsr EntMoveHorizontally
    jsr EntDieInOneShot
    jmp ER_Return


ER_Rex subroutine
    jsr EntTestWalkingCollision
    bcc .nohit
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.nohit:
    lda #ANIM_REX
    sta entityAnim,x
    lda entityVelocity,x
    bpl .notRight
    lda #ANIM_REX_HFLIP
    sta entityAnim,x
.notRight:
    jsr EntMoveHorizontally
    
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    lda entityYLo,x
    sta tmp+2
    lda entityYHi,x
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
    jsr EntIsStrongPlayerNearTall
    bcs .dead
    jsr EntIsBulletNearTall
    bcc .noBullet
    lda #$80
    sta entityXHi
    lda entityYHi
    asl
    cmp #POWERSHOT_ID
    beq .dead
    lda entityCount,x
    cmp #5
    beq .dead
    clc
    adc #1
    sta entityCount,x
    jmp .noBullet
.dead
    ;lda #$80
    ;sta entityXHi,x
    lda entityYHi,x
    and #1
    ora #EXPLOSION_ID<<1
    sta entityYHi,x
    lda #ANIM_SYMMETRICAL_OSCILLATE
    sta entityAnim,x
    
    lda #0
    sta arg
    lda #5
    sta arg+1
    lda #0
    sta arg+2
    stx sav
    jsr AddScore
    ldx sav
.noBullet:    
    jmp ER_Return


ER_CaterpillarHead:
    jsr EntIsStrongPlayerNear
    bcs .MeleeDeath
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
.MeleeDeath:
    ;lda #$80
    ;sta entityXHi,x
    lda entityYHi,x
    sta tmp
    and #1
    ora #EXPLOSION_ID<<1
    sta entityYHi,x
    lda #ANIM_SYMMETRICAL_OSCILLATE
    sta entityAnim,x
    
    lda entityYHi+1,x
    lsr
    cmp #CATERPILLAR_ID
    bcc .lastOne
    cmp #CATERPILLAR_ID+4
    bcs .lastOne
    lda tmp ;should be on same y coord, no need to extract
    sta entityYHi+1,x
.lastOne:
    lda #1
    sta arg+1
    lda #0
    sta arg
    sta arg+2
    stx sav
    jsr AddScore
    ldx sav
    jmp ER_Return
.alive:
ER_CaterpillarBack subroutine
    lda entityYLo,x
    and #$FE
    sta entityYLo,x
    lda frame
    lsr
    lsr
    lsr
    and #1
    ora entityYLo,x
    sta entityYLo,x
    jmp ER_Caterpillar
    
ER_CaterpillarFront:
ER_CaterpillarTail subroutine
    lda entityYLo,x
    and #$FE
    sta entityYLo,x
    lda frame
    lsr
    lsr
    lsr
    and #1
    eor #1
    ora entityYLo,x
    sta entityYLo,x
ER_Caterpillar subroutine
    lda #ANIM_SMALL_NONE
    sta entityAnim,x
    lda entityVelocity,x
    bpl .notRight
    lda #ANIM_SMALL_HFLIP_NONE
    sta entityAnim,x
.notRight:
    jsr EntTestWalkingCollision
    bcc .noTurn
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.noTurn:
    jsr EntMoveHorizontally
    jsr EntTryMelee
    jmp ER_Return

ER_Cart subroutine
    lda #ANIM_SYMMETRICAL_OSCILLATE
    sta entityAnim,x
    jsr EntTestWalkingCollision
    bcs .hit
    jmp .nohit
.hit:
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
    lda #$60
    sta entityCount,x
.nohit:
    jsr EntTryMelee
    lda entityCount,x
    beq .nopause
    sec
    sbc #1
    sta entityCount,x
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim,x
    jmp .end
.nopause:
    jsr EntMoveHorizontally
.end:
    jsr EntDieByPowerOnly
    jmp ER_Return


ER_SlimeHorizontal subroutine
    jsr EntTestFlyingCollision
    bcs .hit
    jmp .nohit
.hit:
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.nohit
    jsr EntMoveHorizontally
    jsr EntTryMelee
    jsr EntDieInOneShot
    jmp ER_Return
ER_SlimeVertical subroutine
    jsr EntTestVerticalCollision
    bcs .hit
    jmp .nohit
.hit:
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.nohit
    jsr EntMoveVertically
    jsr EntTryMelee
    jsr EntDieInOneShot
    jmp ER_Return
    
ER_Hammer subroutine    
    jsr EntTryMelee
    
    lda entityCount,x
    beq .notFalling
    lda entityXLo,x
    sta arg
    lda entityXHi,x
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,x
    sta arg+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg,arg, 8
    ADD16I arg+2,arg+2,16
    jsr TestCollision
    bcc .notLanded
    lda #0
    sta entityCount,x
    lda #<-1
    sta entityVelocity,x
    MOV16I arg,sfxHeavyImpact
    jsr PlaySound
    jmp ER_Return
.notLanded:
    jsr EntFall
    jmp ER_Return
.notFalling:
    lda entityXLo,x
    sta arg
    lda entityXHi,x
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,x
    sta arg+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta arg+3
    SUB16I arg+2,arg+2,16
    ADD16I arg,arg, 8
    jsr TestCollision
    bcc .notApex
    lda #4
    sta entityCount,x
    lda #2
    sta entityVelocity,x
    jmp ER_Return
.notApex:
    jsr EntMoveVertically
    jmp ER_Return
    
ER_Water subroutine
    lda entityXLo,x
    sta arg
    lda entityXHi,x
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,x
    sta arg+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg,arg, 8
    lda entityVelocity,x
    bmi .notDown
    ADD16I arg+2,arg+2,16
.notDown:
    jsr TestCollisionTop
    bcc .notDead
    lda #$80
    sta entityXHi,x
    jmp ER_Return
.notDead:
    jsr EntMoveVertically
    jsr EntTryMelee
    jmp ER_Return
    
ER_RightLaser subroutine
ER_LeftLaser subroutine
    jsr EntTestFlyingCollision
    bcc .notDead
    lda #$80
    sta entityXHi,x
    jmp ER_Return
.notDead:
    jsr EntMoveHorizontally
    jsr EntTryMelee
    jmp ER_Return

ER_VerticalPlatform subroutine
    lda entityXLo,x
    sta arg
    lda entityXHi,x
    and #ENT_X_POS
    sta arg+1
    lda entityYLo,x
    sta arg+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta arg+3
    ADD16I arg,arg, 8
    SUB16I arg+2,arg+2,16
    lda entityVelocity,x
    bmi .notDown
    ADD16I arg+2,arg+2,32
.notDown:
    jsr TestCollision
    bcc .nohit
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.nohit:
    lda entityYLo,x
    sta sav
    lda entityYHi,x
    and #ENT_Y_POS
    sta sav+1
    jsr EntMoveVertically
    MOV16I arg, 8
    jsr EntAwayFromPlayerX
    bcs .noRider
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    SUB16I tmp,tmp,16
    SUB16 tmp,tmp,playerY
    ABS16 tmp,tmp
    CMP16I tmp,4
    bcs .noRider
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    SUB16 tmp, tmp, sav
    ADD16 playerY, playerY, tmp
.noRider:
    jmp ER_Return
    
ER_HorizontalPlatform subroutine
    jsr EntTestFlyingCollision
    bcc .nohit
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.nohit:
    lda entityXLo,x
    sta sav
    lda entityXHi,x
    and #ENT_X_POS
    sta sav+1
    jsr EntMoveHorizontally
    MOV16I arg, 8
    jsr EntAwayFromPlayerX
    bcs .noRider
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    SUB16I tmp,tmp,16
    SUB16 tmp,tmp,playerY
    ABS16 tmp,tmp
    CMP16I tmp,4
    bcs .noRider
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
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
