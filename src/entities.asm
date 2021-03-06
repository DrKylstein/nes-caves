    SEG.U ENTITY_IDS
    ORG $0000
PLAYER_ID                   ds 1
VERTICALPLATFORM_ID         ds 1
HORIZONTALPLATFORM_ID       ds 1
SPIDER_ID                   ds 1
BAT_ID                      ds 1
POWERSHOT_ID                ds 1
MIMROCK_ID                  ds 1
CART_ID                     ds 1
CATERPILLAR_ID              ds 4
SLIME_ID                    ds 2
HAMMER_ID                   ds 1
FAUCET_ID                   ds 1
WATER_ID                    ds 1
VERTICALPLATFORMIDLE_ID     ds 1
HORIZONTALPLATFORMIDLE_ID   ds 1
RIGHTCANNON_ID              ds 1
LASER_ID                    ds 1
LEFTCANNON_ID               ds 1
GIRDER_ID                   ds 1
REX_ID                      ds 1
STALACTITE_ID               ds 1
SPIDERWEB_ID                ds 1
FLAME_ID                    ds 1
PIPERIGHT_ID                ds 1
PIPELEFT_ID                 ds 1
TORCH_ID                    ds 1
SPIKE_ID                    ds 1
PLANET_ID                   ds 1
BULLET_ID                   ds 1
EXPLOSION_ID                ds 1
FRUIT_ID                    ds 3
BALL_ID                     ds 1
RIGHTCANNONMOVING_ID        ds 1
LEFTCANNONMOVING_ID         ds 1
AIRGENERATOR_ID             ds 1
KIWI_ID                     ds 1
EYEMONSTER_ID               ds 1
BIGEYE_ID                   ds 1
ROCK_ID                     ds 1
SNAKE_ID                    ds 1
SNAKEPAUSE_ID               ds 1
DEADSNAKE_ID                ds 1
ENEMYBULLET_ID              ds 1
ROBOT_ID                    ds 1
BIRD_ID                     ds 1
EGG_ID                      ds 1
SIGN_ID                     ds 1
WORM_RIGHT_ID               ds 1
WORM_LEFT_ID                ds 1
HIDDEN_GEM_ID               ds 1
TWIBBLE_ID                  ds 1
FARMMYLO_ID                 ds 1
    SEG ROM_FILE

entityRoutineLo:
    .byte <ER_Player
    .byte <ER_VerticalPlatform
    .byte <ER_HorizontalPlatform
    .byte <ER_Spider
    .byte <ER_Bat
    .byte <ER_PowerShot
    .byte <ER_Mimrock
    .byte <ER_Cart
    .byte <ER_CaterpillarHead
    .byte <ER_CaterpillarFront
    .byte <ER_CaterpillarBack
    .byte <ER_CaterpillarTail
    .byte <ER_SlimeHorizontal
    .byte <ER_SlimeVertical
    .byte <ER_Hammer
    .byte <ER_Faucet
    .byte <ER_Water
    .byte <ER_VerticalPlatformIdle
    .byte <ER_HorizontalPlatformIdle
    .byte <ER_RightCannon
    .byte <ER_Laser
    .byte <ER_LeftCannon
    .byte <ER_Girder
    .byte <ER_Rex
    .byte <ER_Stalactite
    .byte <ER_SpiderWeb
    .byte <ER_Flame
    .byte <ER_PipeRight
    .byte <ER_PipeLeft
    .byte <ER_Return ; torch
    .byte <ER_Spike
    .byte <ER_Planet
    .byte <ER_Bullet
    .byte <ER_Explosion
    .byte <ER_Fruit ;cherry
    .byte <ER_Fruit ;strawberry
    .byte <ER_Fruit ;peach
    .byte <ER_Ball
    .byte <ER_RightCannonMoving
    .byte <ER_LeftCannonMoving
    .byte <ER_AirGenerator
    .byte <ER_Kiwi
    .byte <ER_EyeMonster
    .byte <ER_BigEye
    .byte <ER_Rock
    .byte <ER_Snake
    .byte <ER_SnakePause
    .byte <ER_DeadSnake
    .byte <ER_EnemyBullet
    .byte <ER_Robot
    .byte <ER_Bird
    .byte <ER_Egg
    .byte <ER_Sign
    .byte <ER_Worm ;right
    .byte <ER_Worm ;left
    .byte <ER_HiddenGem
    .byte <ER_Twibble
    .byte <ER_FarmMylo
    
entityRoutineHi:
    .byte >ER_Player
    .byte >ER_VerticalPlatform
    .byte >ER_HorizontalPlatform
    .byte >ER_Spider
    .byte >ER_Bat
    .byte >ER_PowerShot
    .byte >ER_Mimrock
    .byte >ER_Cart
    .byte >ER_CaterpillarHead
    .byte >ER_CaterpillarFront
    .byte >ER_CaterpillarBack
    .byte >ER_CaterpillarTail
    .byte >ER_SlimeHorizontal
    .byte >ER_SlimeVertical
    .byte >ER_Hammer
    .byte >ER_Faucet
    .byte >ER_Water
    .byte >ER_VerticalPlatformIdle
    .byte >ER_HorizontalPlatformIdle
    .byte >ER_RightCannon
    .byte >ER_Laser
    .byte >ER_LeftCannon
    .byte >ER_Girder
    .byte >ER_Rex
    .byte >ER_Stalactite
    .byte >ER_SpiderWeb
    .byte >ER_Flame
    .byte >ER_PipeRight
    .byte >ER_PipeLeft
    .byte >ER_Return ; torch
    .byte >ER_Spike
    .byte >ER_Planet
    .byte >ER_Bullet
    .byte >ER_Explosion
    .byte >ER_Fruit ;cherry
    .byte >ER_Fruit ;strawberry
    .byte >ER_Fruit ;peach
    .byte >ER_Ball
    .byte >ER_RightCannonMoving
    .byte >ER_LeftCannonMoving
    .byte >ER_AirGenerator
    .byte >ER_Kiwi
    .byte >ER_EyeMonster
    .byte >ER_BigEye
    .byte >ER_Rock
    .byte >ER_Snake
    .byte >ER_SnakePause
    .byte >ER_DeadSnake
    .byte >ER_EnemyBullet
    .byte >ER_Robot
    .byte >ER_Bird
    .byte >ER_Egg
    .byte >ER_Sign
    .byte >ER_Worm ;right
    .byte >ER_Worm ;left
    .byte >ER_HiddenGem
    .byte >ER_Twibble
    .byte >ER_FarmMylo
    
entityFlags:
    .byte ENT_F_SKIPYTEST | ENT_F_SKIPXTEST | 1 ; player
    .byte ENT_F_ISPLATFORM | ENT_F_SKIPYTEST | 2; vertical platform
    .byte ENT_F_ISPLATFORM | ENT_F_SKIPXTEST | 2; horizontal platform
    .byte [1<<ENT_F_CHILDREN_SHIFT] | 2 ; spider
    .byte 2 ; bat
    .byte ENT_F_ISTEMPORARY | 1; power shot
    .byte 2; rock
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
    .byte ENT_F_SKIPXTEST | 0 ; planet
    .byte ENT_F_ISTEMPORARY | 2; bullet
    .byte ENT_F_ISTEMPORARY | 1; explosion
    .byte 1 ; cherry
    .byte 1 ; strawberry
    .byte 1 ; peach
    .byte [1<<ENT_F_CHILDREN_SHIFT] | 2 ; ball
    .byte [1<<ENT_F_CHILDREN_SHIFT] | 2 ; right cannon
    .byte [1<<ENT_F_CHILDREN_SHIFT] | 2 ; left cannon
    .byte 2 ;air generator
    .byte ENT_F_SKIPYTEST | ENT_F_SKIPXTEST | 2 ; kiwi
    .byte [3<<ENT_F_CHILDREN_SHIFT] | 3 ;eyemonster
    .byte ENT_F_SKIPXTEST | 3 ;eyeball
    .byte ENT_F_SKIPXTEST | ENT_F_SKIPYTEST | 0 ; falling rock
    .byte 1 ;snake
    .byte 1 ;snake
    .byte 1 ;dead snake
    .byte 2 ;enemy bullet
    .byte 2 ; robot
    .byte [1<<ENT_F_CHILDREN_SHIFT] | 2 ; bird
    .byte 1 ; egg
    .byte 0 ; sign
    .byte 1 ;worm
    .byte 1 ;worm
    .byte 0 ;hidden gem
    .byte 1 ; twibble
    .byte ENT_F_SKIPYTEST | ENT_F_SKIPXTEST | 1 ; farm mylo
    
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
    .byte [11+32*3]*2 ; slime horizontal
    .byte [13+32*3]*2 ; slime vertical
    .byte 32*4 + 24 + 1;hammer
    .byte [9+32]*2 ; faucet
    .byte [8+32]*2 ; water
    .byte [0+32]*2 ; vertical platform
    .byte [0+32]*2 ; horizontal platform
    .byte [2+32]*2 ; right cannon
    .byte [10+32*3]*2 ; right laser
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
    .byte 32*4 + 28 + 1;planet
    .byte 14*2 ; bullet
    .byte 24*2 ; explosion
    .byte 28*2 ; cherry
    .byte 27*2 ; strawberry
    .byte 29*2 ; peach
    .byte [19+32*3]*2 ; ball
    .byte [2+32]*2 ; right cannon
    .byte [2+32]*2 ; left cannon
    .byte [17+32*2]*2 ; air generator
    .byte $85 ; kiwi
    .byte [2+32*3]*2 ; eyemonster
    .byte [0+32*3]*2 ; eyeball
    .byte [31+32*2]*2 ; falling rock
    .byte [0+32*2]*2 ; snake
    .byte [6+32*2]*2 ; snake
    .byte [4+32*1]*2 ; dead snake
    .byte [15+32*2]*2 ; enemy bullet
    .byte [4+32*3]*2 ;robot
    .byte [12+32*2]*2 ;bird
    .byte [16+32*2]*2 ;egg
    .byte 32*4 + 24 + 1 + 32;sign
    .byte [8+32*2]*2 ; worm
    .byte [8+32*2]*2 ; worm
    .byte [11+32*2]*2 ;hidden gem
    .byte [15+32*3]*2 ; twibble
    .byte 0 ; farm mylo
    
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
    .byte 1 ; right cannon
    .byte 1 ; left cannon
    .byte 0 ; air_generator
    .byte 0 ; kiwi
    .byte 1 ; eyemonster
    .byte 1 ; eyeball
    .byte 4 ; falling rock
    .byte 1 ; snake
    .byte 1 ; snake
    .byte 0 ; dead snake
    .byte 1 ; enemy bullet
    .byte 2 ; robot
    .byte 1 ; bird
    .byte 0 ; egg
    .byte 0 ;sign
    .byte 0 ;worm
    .byte 0 ;worm
    .byte 0 ;hidden gem
    .byte 0 ;twibble
    .byte 0 ; farm mylo
    
entityInitialAnims:
    .byte ANIM_SMALL_NONE ; player
    .byte ANIM_SPIDER ; vertical platform
    .byte ANIM_SPIDER ; horizontal platform
    .byte ANIM_SPIDER ; spider
    .byte ANIM_SYMMETRICAL_OSCILLATE ; bat
    .byte ANIM_POWERSHOT ; power shot
    .byte ANIM_PLAYER_WALK ; mimrock
    .byte ANIM_SYMMETRICAL_OSCILLATE ; cart
    .byte ANIM_SMALL_NONE ; caterpillar head
    .byte ANIM_SMALL_NONE ; caterpillar front
    .byte ANIM_SMALL_NONE ; caterpillar back
    .byte ANIM_SMALL_NONE ; caterpillar tail
    .byte ANIM_SLIME_RIGHT ; slime horizontal
    .byte ANIM_SLIME_DOWN ; slime vertical
    .byte ANIM_HAMMER ; hammer
    .byte ANIM_NULL ; faucet
    .byte ANIM_SPIKE ; water
    .byte ANIM_SPIDER ; vertical platform
    .byte ANIM_SPIDER ; horizontal platform
    .byte ANIM_SMALL_NONE ; right cannon
    .byte ANIM_LASER ; laser
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
    .byte ANIM_SMALL_NONE ; planet
    .byte ANIM_ROCKET ; bullet
    .byte ANIM_SYMMETRICAL_OSCILLATE ; explosion
    .byte ANIM_SYMMETRICAL_NONE ; cherry
    .byte ANIM_SYMMETRICAL_NONE ; strawberry
    .byte ANIM_SYMMETRICAL_NONE ; peach
    .byte ANIM_BALL_RIGHT
    .byte ANIM_SMALL_NONE ; right cannon
    .byte ANIM_SMALL_HFLIP_NONE ; left cannon
    .byte ANIM_AIR_GENERATOR
    .byte ANIM_SMALL_NONE ; kiwi
    .byte ANIM_SPIDER ; eyemonster
    .byte ANIM_SYMMETRICAL_NONE ; eyeball
    .byte ANIM_SYMMETRICAL_NONE ; falling rock
    .byte ANIM_SMALL_OSCILLATE ;snake
    .byte ANIM_SPIDER ;snake
    .byte ANIM_SYMMETRICAL_NONE ; dead snake
    .byte ANIM_SYMMETRICAL_NONE ; enemy bullet
    .byte ANIM_SMALL_OSCILLATE ; robot
    .byte ANIM_SYMMETRICAL_OSCILLATE ; bird
    .byte ANIM_TORCH ; egg
    .byte ANIM_WIDE_NONE ; sign
    .byte ANIM_SMALL_NONE_BG ; worm
    .byte ANIM_SMALL_NONE_HFLIP_BG ; worm
    .byte ANIM_NULL ; hidden gem
    .byte ANIM_SMALL_NONE ; twibble
    .byte ANIM_SMALL_NONE ; farm mylo
    
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
    
EntTallAwayFromPlayerY subroutine ; distance in arg 0-1, result in carry
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    SUB16I tmp, tmp, 8
    SUB16 tmp,tmp,playerY
    ABS16 tmp,tmp
    CMP16 tmp,arg
    rts

EntMoveHorizontally subroutine
    lda entityVelocity,x
    ASR65
    sta tmp
    EXTEND tmp, tmp
    lda frame
    and #1
    beq .noExtra
    lda entityVelocity,x
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
    
EntCheckPriority subroutine
    PUSH16 sav
    PUSH16 sav+2
    lda sav+4
    pha
    
    lda entityXLo,x
    sta sav
    lda entityXHi,x
    and #ENT_X_POS
    sta sav+1
    lda entityYLo,x
    sta sav+2
    lda entityYHi,x
    and #ENT_Y_POS
    sta sav+3
    ADD16I sav+2,sav+2,8
    ADD16I arg,sav,16

    REPEAT 4
    LSR16 arg
    LSR16 sav+2
    REPEND
    MOV16 arg+2,sav+2
    stx sav+4
    jsr GetTileBehavior
    ldx sav+4
    lda ret
    cmp #TB_FGPLATFORM
    beq .low
    cmp #TB_FOREGROUND
    bne .high
.low:
    lda entityXHi,x
    ora #ENT_X_PRIORITY
    sta entityXHi,x
    jmp .end
.high:
    MOV16 arg,sav
    REPEAT 4
    LSR16 arg
    REPEND
    MOV16 arg+2,sav+2
    stx sav+4
    jsr GetTileBehavior
    ldx sav+4
    lda ret
    cmp #TB_FGPLATFORM
    beq .low
    cmp #TB_FOREGROUND
    beq .low
.definitelyhigh:
    lda entityXHi,x
    and #~ENT_X_PRIORITY
    sta entityXHi,x
.end:
    pla
    sta sav+3
    POP16 sav+2
    POP16 sav
    rts
    
EntMoveVertically subroutine
    lda entityVelocity,x
    ASR65
    sta tmp
    EXTEND tmp, tmp
    lda frame
    and #1
    beq .noExtra
    lda entityVelocity,x
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
    
EntTestLandingCollision
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
    jmp TestCollisionTop


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

EntExplode subroutine
    lda entityYHi,x
    and #1
    ora #EXPLOSION_ID<<1
    sta entityYHi,x
    lda #ANIM_SYMMETRICAL_OSCILLATE
    sta entityAnim,x
    lda #0
    sta entityFrame,x
    rts

EntDieByPowerOnly subroutine
    jsr EntIsStrongPlayerNear
    bcs .Melee
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
    lda entityYHi
    lsr
    cmp #POWERSHOT_ID
    bne .alive
.Melee:
    jsr EntExplode
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
    jsr EntExplode
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

EntShootPlayer subroutine
    MOV16I arg, 8
    jsr EntAwayFromPlayerY
    bcs .cantshoot
    lda entityXHi+1,x
    bpl .cantshoot
    
    lda entityCount,x
    clc
    adc #1
    sta entityCount,x
    and #63
    cmp #63
    bne .noshoot

    
    stx sav
    ldx #SFX_LASER
    jsr PlaySound
    ldx sav
    
    lda entityXHi,x
    sta entityXHi+1,x
    lda entityXLo,x
    sta entityXLo+1,x
    lda entityYHi,x
    and #ENT_Y_POS
    ora #ENEMYBULLET_ID<<1
    sta entityYHi+1,x
    lda entityYLo,x
    sta entityYLo+1,x
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim+1,x
    
    lda #4
    sta entityVelocity+1,x
    
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    CMP16 tmp, playerX
    bcc .noshoot
    lda #-4
    sta entityVelocity+1,x
.cantshoot:
    lda entityCount,x
    and #~63
    sta entityCount,x
.noshoot:
    rts

EntUpdateFlash subroutine
    lda entityXHi,x
    and #ENT_X_FLASH
    beq .noFlash
    lda entityFrame,x
    cmp #16
    bcc .noFlash
    lda entityXHi,x
    and #~ENT_X_FLASH
    sta entityXHi,x
.noFlash:
    rts

EntFlash subroutine
    lda entityXHi,x
    ora #ENT_X_FLASH
    sta entityXHi,x
    lda #0
    sta entityFrame,x
    rts

ER_Twibble subroutine
    jmp ER_Return

ER_HiddenGem subroutine
    lda entityAnim,x
    bne .active ;0 = ANIM_NULL
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
    ;ADD16I arg,arg, 8
    ;ADD16I arg+2,arg+2,8
    REPEAT 4
    LSR16 arg
    LSR16 arg+2
    REPEND
    jsr GetTileBehavior
    lda ret
    ;don't activate unless behavior is less than girder left
    ;only switches and map doors are higher, it should never be hidden there
    cmp #TB_GIRDER_LEFT
    JCS ER_Return
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim,x
    lda #-4
    sta entityVelocity,x
.active:
    jsr EntFall
    jsr EntTestVerticalCollision
    bcs .hit
    jmp .nohit
.hit:
    lda #$80
    sta entityXHi,x
    lda #5
    sta arg+1
    lda #0
    sta arg
    sta arg+2
    jsr AddScore
    ldx #SFX_CRYSTAL
    jsr PlaySound
.nohit:
    jmp ER_Return

ER_Worm subroutine
    lda entityVelocity,x
    bne .ready
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    REPEAT 4
    LSR16 tmp
    REPEND
    lda tmp
    sta entityVelocity,x
.ready:
    lda entityCount,x
    beq .alert
    dec entityCount,x
    jmp .awake
.alert:
    MOV16I arg,8
    jsr EntAwayFromPlayerY
    bcs .JSleep
    MOV16I arg,32
    jsr EntAwayFromPlayerX
    bcs .JSleep
    lda #90
    sta entityCount,x
    jmp .awake
.JSleep
    jmp .sleep
.awake:
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    lda entityVelocity,x
    sta tmp+2
    lda #0
    sta tmp+3
    REPEAT 4
    ASL16 tmp+2
    REPEND
    lda entityYHi,x
    lsr
    cmp #WORM_LEFT_ID
    bne .awakeRight
.awakeLeft:
    CMP16 tmp,tmp+2
    bcc .biteLeft
    DEC16 tmp
    jmp .awakeFinish
.biteLeft:
    lda #ANIM_WORM_BITE_LEFT
    sta entityAnim,x
    jmp .awakeFinish
.awakeRight:
    CMP16 tmp,tmp+2
    bcs .biteRight
    INC16 tmp
    jmp .awakeFinish
.biteRight:
    lda #ANIM_WORM_BITE_RIGHT
    sta entityAnim,x
.awakeFinish:
    lda tmp
    sta entityXLo,x
    lda tmp+1
    sta entityXHi,x
    jmp .done
.sleep:
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    lda entityVelocity,x
    sta tmp+2
    lda #0
    sta tmp+3
    REPEAT 4
    ASL16 tmp+2
    REPEND
    lda entityYHi,x
    lsr
    cmp #WORM_LEFT_ID
    bne .sleepRight
.sleepLeft:
    ADD16I tmp+2,tmp+2,12
    CMP16 tmp,tmp+2
    bcs .done
    INC16 tmp
    lda #ANIM_SMALL_NONE_HFLIP_BG
    sta entityAnim,x
    jmp .sleepFinish
.sleepRight:
    SUB16I tmp+2,tmp+2,12
    CMP16 tmp,tmp+2
    bcc .done
    DEC16 tmp
    lda #ANIM_SMALL_NONE_BG
    sta entityAnim,x
.sleepFinish:
    lda tmp
    sta entityXLo,x
    lda tmp+1
    sta entityXHi,x
    jmp .done
.done:
    jsr EntTryMelee
    jsr EntDieByPowerOnly
    jmp ER_Return

ER_Bird subroutine
    jsr EntTestFlyingCollision
    bcc .nohit
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.nohit
    lda entityCount,x
    bne .notShoot
    lda entityYHi+1,x
    lsr
    cmp #DEADSNAKE_ID
    bne .noyolk
    lda #$80
    sta entityXHi+1,x
.noyolk

    MOV16I arg, 8
    jsr EntAwayFromPlayerX
    bcs .notShoot
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    ADD16I tmp, tmp, 16
    CMP16 playerY,tmp
    bcc .notShoot
    lda entityXHi+1,x
    bpl .notShoot
    lda tmp
    sta entityYLo+1,x
    lda tmp+1
    ora #EGG_ID<<1
    sta entityYHi+1,x
    lda entityXLo,x
    sta entityXLo+1,x
    lda entityXHi,x
    sta entityXHi+1,x
    lda #ANIM_TORCH
    sta entityAnim+1,x
    lda #2
    sta entityVelocity+1,x
    lda #60
    sta entityCount,x
.notShoot:
    lda entityCount,x
    beq .noDecrement
    bmi .noDecrement
    sec
    sbc #1
    sta entityCount,x
.noDecrement

    jsr EntTryMelee
    jsr EntMoveHorizontally
    jsr EntDieInOneShot
    jmp ER_Return

ER_Egg subroutine
    jsr EntMoveVertically
    jsr EntTestVerticalCollision
    JCC ER_Return
    jsr Randomize
    bmi .infertile
    lda entityYHi,x
    and #ENT_Y_POS
    ora #BIRD_ID<<1
    sta entityYHi,x
    lda #ANIM_SYMMETRICAL_OSCILLATE
    sta entityAnim,x
    lda #$80
    sta entityCount,x
    jmp ER_Return
.infertile:
    lda entityYHi,x
    and #ENT_Y_POS
    ora #DEADSNAKE_ID<<1
    sta entityYHi,x
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim,x
    jmp ER_Return

ER_Robot subroutine
    jsr EntUpdateFlash
    jsr EntIsStrongPlayerNear
    bcs .Melee
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
    lda entityYHi
    lsr
    cmp #POWERSHOT_ID
    beq .Melee
    lda entityAnim,x
    cmp #ANIM_ROBOT_FIRING_RIGHT
    beq .alive
    cmp #ANIM_ROBOT_FIRING_LEFT
    beq .alive
    lda entityCount,x
    and #$C0
    cmp #$80
    bcs .Melee
    lda entityCount,x
    clc
    adc #$40
    sta entityCount,x
    jsr EntFlash
    stx sav
    ldx #SFX_HURT
    jsr PlaySound
    ldx sav
    jmp .alive
.Melee:
    jsr EntExplode
    lda #10
    sta arg
    lda #0
    sta arg+1
    sta arg+2
    stx sav
    jsr AddScore
    ldx sav
    jmp ER_Return
.alive:

    MOV16I arg,4
    jsr EntAwayFromPlayerY
    JCS ER_Robot_NoChase
    MOV16I arg,24
    jsr EntAwayFromPlayerX
    JCS ER_Robot_NoChase
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    lda entityVelocity,x
    bmi .chaseLeft
.chaseRight:
    ADD16I tmp,tmp,16
    CMP16 playerX,tmp
    bcc ER_Robot_NoChase
    lda #ANIM_ROBOT_FIRING_RIGHT
    sta entityAnim,x
    ADD16I tmp,tmp,4
    CMP16 playerX,tmp
    JCC ER_Return
    jsr DamagePlayer
    jmp ER_Return
.chaseLeft:
    CMP16 playerX,tmp
    bcs ER_Robot_NoChase
    lda #ANIM_ROBOT_FIRING_LEFT
    sta entityAnim,x
    SUB16I tmp,tmp,4
    CMP16 playerX,tmp
    JCS ER_Return
    jsr DamagePlayer
    jmp ER_Return
ER_Robot_NoChase:

    lda #ANIM_SMALL_OSCILLATE
    sta entityAnim,x
    lda entityVelocity,x
    bpl .right
    lda #ANIM_SMALL_HFLIP_OSCILLATE
    sta entityAnim,x
.right:
    jsr EntTryMelee    
    jsr EntMoveHorizontally
    jsr EntTestWalkingCollision
    bcc .nohit
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.nohit:

    jmp ER_Return

ER_Snake subroutine
    jsr Randomize
    and #127
    bne .nopause
    lda entityYHi,x
    clc
    adc #2
    sta entityYHi,x
    lda #0
    sta entityFrame,x
    lda #ANIM_SLIME_DOWN
    sta entityAnim,x
    jmp ER_Return
.nopause:
    
    jsr EntMoveHorizontally
    jsr EntTestWalkingCollision
    bcc .nohit
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
    lda #ANIM_SMALL_OSCILLATE
    sta entityAnim,x
    lda entityVelocity,x
    bpl .nohit
    lda #ANIM_SMALL_HFLIP_OSCILLATE
    sta entityAnim,x
.nohit:
    jmp SnakeShared
    
ER_SnakePause subroutine
    lda entityFrame,x
    cmp #60
    bcc .noresume
    lda entityYHi,x
    sec
    sbc #2
    sta entityYHi,x
    lda #0
    sta entityFrame,x
    lda #ANIM_SMALL_OSCILLATE
    sta entityAnim,x
    lda #1
    sta entityVelocity,x
    jsr Randomize
    JMI ER_Return
    lda #ANIM_SMALL_HFLIP_OSCILLATE
    sta entityAnim,x
    lda #-1
    sta entityVelocity,x
    jmp ER_Return
.noresume:
SnakeShared subroutine
    jsr EntUpdateFlash
    jsr EntTryMelee
    jsr EntIsStrongPlayerNear
    bcs .Melee
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
    lda entityYHi
    lsr
    cmp #POWERSHOT_ID
    beq .Melee
    lda entityCount,x
    bne .Melee
    ora #1
    sta entityCount,x
    jsr EntFlash
    stx sav
    ldx #SFX_HURT
    jsr PlaySound
    ldx sav
    jmp .alive
.Melee:
    ;change to dead
    lda entityXHi,x
    and #~ENT_X_FLASH
    sta entityXHi,x
    lda entityYHi,x
    and #ENT_Y_POS
    ora #DEADSNAKE_ID<<1
    sta entityYHi,x
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim,x
    ;make explosion
    lda entityYHi
    and #ENT_Y_POS
    ora #EXPLOSION_ID<<1
    sta entityYHi
    lda #ANIM_SYMMETRICAL_OSCILLATE
    sta entityAnim
    lda #0
    sta entityFrame
    ;add points
    lda #10
    sta arg
    lda #0
    sta arg+1
    sta arg+2
    stx sav
    jsr AddScore
    ldx sav
.alive:
    jmp ER_Return

ER_DeadSnake subroutine
    jsr EntTryMelee
    jmp ER_Return


ER_EyeMonster subroutine ;invulnerable until blinded, then 2 hits
    lda entityCount,x
    bmi .InitDone
    lda entityYHi,x
    clc
    adc #2
    sta entityYHi+2,x
    sta entityYHi+3,x
    lda entityYLo,x
    sta entityYLo+2,x
    sta entityYLo+3,x
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim+2,x
    sta entityAnim+3,x
    lda #0
    sta entityXHi+2,x
    sta entityXHi+3,x
    sta entityFrame+2,x
    lda #128+8
    sta entityFrame+3,x
    lda #$80
    sta entityCount,x
.InitDone:
    jsr EntUpdateFlash
    jsr EntTryMelee
    jsr EntMoveHorizontally
    
    ;move eyes
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    SUB16I tmp,tmp,16
    lda entityXHi+2,x
    bmi .noleft
    lda tmp
    sta entityXLo+2,x
    lda entityXHi+2,x
    and #~ENT_X_POS
    ora tmp+1
    sta entityXHi+2,x
    
    lda entityYLo+2,x
    and #~1
    sta entityYLo+2,x
    lda entityFrame,x
    lsr
    lsr
    lsr
    and #1
    ora entityYLo+2,x
    sta entityYLo+2,x
.noleft:
    lda entityXHi+3,x
    bmi .noright
    ADD16I tmp,tmp,32
    lda tmp
    sta entityXLo+3,x
    lda entityXHi+3,x
    and #~ENT_X_POS
    ora tmp+1
    sta entityXHi+3,x
    
    lda entityYLo+3,x
    ora #1
    sta entityYLo+3,x
    lda entityFrame,x
    lsr
    lsr
    lsr
    and #1
    eor #$FF
    and entityYLo+3,x
    sta entityYLo+3,x

.noright:
    
    jsr EntTestWalkingCollision
    bcc .nohit
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.nohit:

    jsr EntShootPlayer

    lda entityXHi+2,x
    and entityXHi+3,x
    bpl .nomelee
    jsr EntIsStrongPlayerNear
    bcs .Melee
.nomelee:
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
    lda entityXHi+2,x
    and entityXHi+3,x
    bpl .alive
    lda entityYHi
    lsr
    cmp #POWERSHOT_ID
    beq .Melee
    lda entityCount,x
    and #$40
    bne .Melee
    lda entityCount,x
    ora #$40
    sta entityCount,x
    jsr EntFlash
    stx sav
    ldx #SFX_HURT
    jsr PlaySound
    ldx sav
    jmp ER_Return
.Melee:
    jsr EntExplode
    lda #5
    sta arg+1
    lda #0
    sta arg
    sta arg+2
    stx sav
    jsr AddScore
    ldx sav
.alive:

    jmp ER_Return

ER_BigEye subroutine ;2 hits
    jsr EntUpdateFlash
    jsr EntTryMelee
    
    jsr Randomize
    bne .NoChange
    lda entityAnim,x
    cmp #ANIM_SYMMETRICAL_NONE
    beq .close
    lda #ANIM_SYMMETRICAL_NONE
    sta entityAnim,x
    jmp .NoChange
.close
    lda #ANIM_SYMMETRICAL_NONE2
    sta entityAnim,x
.NoChange:
    
    lda entityAnim,x
    cmp #ANIM_SYMMETRICAL_NONE
    beq .noblink
    jsr EntIsBulletNear
    bcc .noBullet
    lda #$80
    sta entityXHi
.noBullet:
    jmp ER_Return
.noblink:
    jsr EntIsStrongPlayerNear
    bcs .Melee
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
    lda entityYHi
    lsr
    cmp #POWERSHOT_ID
    beq .Melee
    lda entityCount,x
    bne .Melee
    ora #1
    sta entityCount,x
    jsr EntFlash
    stx sav
    ldx #SFX_HURT
    jsr PlaySound
    ldx sav
    jmp ER_Return
.Melee:
    jsr EntExplode
.alive:

    jmp ER_Return

ER_AirGenerator subroutine
    jsr EntIsBulletNearTall
    bcc .noBullet
    lda #$80
    sta entityXHi
    jsr EntExplode
    stx sav
    MOV16I arg,airMsg
    jsr DisplayMessage
    ldx sav
    jsr KillPlayer
.noBullet:
    jmp ER_Return
    
ER_Ball subroutine
    jsr EntUpdateFlash
    jsr EntTryMelee
    jsr EntIsStrongPlayerNear
    bcs .Melee
    jsr EntIsBulletNear
    bcc .alive
    lda #$80
    sta entityXHi
    lda entityYHi
    lsr
    cmp #POWERSHOT_ID
    beq .Melee
    lda entityAnim,x
    cmp #ANIM_BALL_SLEEP
    bne .alive
    lda entityCount,x
    and #$C0
    cmp #$80
    bcs .Melee
    lda entityCount,x
    clc
    adc #$40
    sta entityCount,x
    jsr EntFlash
    stx sav
    ldx #SFX_HURT
    jsr PlaySound
    ldx sav
    jmp .alive
.Melee:
    jsr EntExplode
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
    lda entityAnim,x
    cmp #ANIM_BALL_SLEEP
    bne .rolling
    lda entityFrame,x
    cmp #128
    bne .sleep_end
    lda #ANIM_BALL_RIGHT
    sta entityAnim,x
    lda #0
    sta entityFrame,x
    lda entityVelocity,x
    bpl .sleep_end
    lda #ANIM_BALL_LEFT
    sta entityAnim,x
.sleep_end:
    jmp ER_Return
.rolling:
    lda entityFrame,x
    cmp #255
    bne .continue
    lda #ANIM_BALL_SLEEP
    sta entityAnim,x
    lda #0
    sta entityFrame,x
    jmp ER_Return
.continue:
    jsr EntMoveHorizontally
    jsr EntTestWalkingCollision
    bcc .nohit
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
    lda #ANIM_BALL_RIGHT
    sta entityAnim,x
    lda entityVelocity,x
    bpl .nohit
    lda #ANIM_BALL_LEFT
    sta entityAnim,x
.nohit:

    jsr EntShootPlayer

    jmp ER_Return


ER_Rock subroutine
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    SUB16I tmp, tmp, MT_VIEWPORT_HEIGHT*PX_MT_HEIGHT
    CMP16 tmp, shr_cameraY
    bmi .continue
    jsr Randomize
    sta tmp
    lda #0
    sta tmp+1
    ADD16 tmp, tmp, shr_cameraX
    lda tmp
    sta entityXLo,x
    lda tmp+1
    sta entityXHi,x
    lda shr_cameraY
    sta entityYLo,x
    lda entityYHi,x
    and #ENT_Y_INDEX
    ora shr_cameraY+1
    sta entityYHi,x
    
.continue:
    jsr EntTryMelee
    jsr EntMoveVertically
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
    ldx #SFX_FRUIT
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
    ldx #SFX_POINTS
    jsr PlaySound
    ldx sav
.DoNothing:
    jmp ER_Return

ER_Explosion subroutine
    lda entityFrame,x
    cmp #4<<2
    bcc .alive
    lda #$80
    sta entityXHi,x
.alive:
    jmp ER_Return

ER_Player subroutine
    jsr EntCheckPriority

;gravity
    lda playerFlags
    and #PLY_UPSIDEDOWN
    bne .reverseGravity
    CMP16I playerYVel, TERMINAL_VELOCITY
    bpl ApplyGravity_end
    ADD16I playerYVel, playerYVel, GRAVITY
    jmp ApplyGravity_end
.reverseGravity:
    CMP16I playerYVel, -TERMINAL_VELOCITY
    bmi ApplyGravity_end
    SUB16I playerYVel, playerYVel, GRAVITY
ApplyGravity_end:


;death sequence
    lda entityAnim,x
    cmp #ANIM_PLAYER_DEAD
    beq .verydead
    cmp #ANIM_PLAYER_DIE
    bne .alive
    lda entityFrame,x
    cmp #[16<<2]-1
    bcs .dead
    jmp ER_Return
.dead:
    lda #ANIM_PLAYER_DEAD
    sta entityAnim,x
    jmp ER_Return
.verydead:
    lda messageTime
    JNE ER_Return
    jmp EnterLevel
.alive:

;normal animations
    lda entityXHi,x
    and #~ENT_X_FLASH
    sta entityXHi,x
    lda powerType
    cmp #POWER_STRENGTH
    beq .invincible
    lda mercyTime
    beq .visible
.invincible:
    lda entityXHi,x
    ora #ENT_X_FLASH
    sta entityXHi,x
.visible:
    lda playerFlags
    and #7
    tay
    lda playerXVel
    beq .notmoving
    tya
    ora #8
    tay
.notmoving:
    lda playerAnims,y
    sta entityAnim,x
.noanim:

;exit sequence
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
    
ER_FarmMylo subroutine
    lda pressed
    beq .continue
    jmp .text
.continue:
    lda #PLY_LOCKED
    sta playerFlags
    lda entityFrame,x
    cmp #240
    bcc .wait
.text:
    stx sav
    jsr OpenTextBox
    MOV16I arg, farmText
    jsr PrintPages
    jsr CloseTextBox
    ldx sav
    jmp reset
.wait:
    lda #ANIM_SMALL_NONE
    sta entityAnim,x
    lda entityFrame,x
    and #$40
    bne .noflip
    lda #ANIM_SMALL_HFLIP_NONE
    sta entityAnim,x
.noflip:
    jmp ER_Return
    
introStates:
    .word IntroLog
    .word IntroSputter
    .word IntroCircle
    .word IntroSteering
    .word IntroSputter
    .word IntroMove
    .word IntroCrash
    .word IntroWhere
    .word IntroSwerve
    .word IntroMove
    .word IntroLand
    
ER_Kiwi subroutine
    lda pressed
    beq .continue
    inc exitTriggered
    jmp ER_Return
.continue:

    lda #PLY_LOCKED
    sta playerFlags
    lda entityCount,x
    asl
    tay
    lda currLevel
    cmp #END_LEVEL
    beq .ending
    lda introStates,y
    sta tmp
    lda introStates+1,y
    sta tmp+1
    jmp (tmp)
.ending:
    lda endStates,y
    sta tmp
    lda endStates+1,y
    sta tmp+1
    jmp (tmp)
    
IntroLog subroutine
    lda entityFrame,x
    cmp #60
    JCC ER_Return
    stx sav
    jsr OpenTextBox
    MOV16I arg,openingText
    jsr PrintPages
    jsr CloseTextBox
    ldx sav
    inc entityCount,x
    lda #0
    sta entityFrame,x
    jmp ER_Return
    
sputterTable:
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
    .byte 2
    .byte 2
    .byte 1
    .byte 2
    .byte 1
    .byte 2
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 0
    .byte 1
    .byte 0
    .byte 1
    .byte 0
    .byte 1
    .byte 0
    
sputterYTable:
    .byte 0
    .byte 1
    .byte 0
    .byte -1
    .byte 0
    .byte 1
    .byte 0
    .byte -1
    .byte 0
    .byte 1
    .byte 0
    .byte -1
    .byte 0
    .byte 1
    .byte 0
    .byte -1
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
    
IntroSputter subroutine
    lda entityFrame,x
    cmp #32*3
    bcc .continue
    
    MOV16 doorsX,playerX
    MOV16 doorsY,playerY
    
    inc entityCount,x
    lda #0
    sta entityFrame,x
    jmp ER_Return
.continue:
    lda entityFrame,x
    and #31
    tay
    lda sputterTable,y
    sta playerXVel
    lda sputterYTable,y
    sta playerYVel+1
    jmp ER_Return

sin:
    .byte	0
    .byte	6
    .byte	12
    .byte	19
    .byte	25
    .byte	31
    .byte	37
    .byte	43
    .byte	49
    .byte	54
    .byte	60
    .byte	65
    .byte	71
    .byte	76
    .byte	81
    .byte	85
    .byte	90
    .byte	94
    .byte	98
    .byte	102
    .byte	106
    .byte	109
    .byte	112
    .byte	115
    .byte	117
    .byte	120
    .byte	122
    .byte	123
    .byte	125
    .byte	126
    .byte	126
    .byte	127
    .byte	127
    .byte	127
    .byte	126
    .byte	126
    .byte	125
    .byte	123
    .byte	122
    .byte	120
    .byte	117
    .byte	115
    .byte	112
    .byte	109
    .byte	106
    .byte	102
    .byte	98
    .byte	94
    .byte	90
    .byte	85
    .byte	81
    .byte	76
    .byte	71
    .byte	65
    .byte	60
    .byte	54
    .byte	49
    .byte	43
    .byte	37
    .byte	31
    .byte	25
    .byte	19
    .byte	12
    .byte	6
    .byte	0
    .byte	-6
    .byte	-12
    .byte	-19
    .byte	-25
    .byte	-31
    .byte	-37
    .byte	-43
    .byte	-49
    .byte	-54
    .byte	-60
    .byte	-65
    .byte	-71
    .byte	-76
    .byte	-81
    .byte	-85
    .byte	-90
    .byte	-94
    .byte	-98
    .byte	-102
    .byte	-106
    .byte	-109
    .byte	-112
    .byte	-115
    .byte	-117
    .byte	-120
    .byte	-122
    .byte	-123
    .byte	-125
    .byte	-126
    .byte	-126
    .byte	-127
    .byte	-127
    .byte	-127
    .byte	-126
    .byte	-126
    .byte	-125
    .byte	-123
    .byte	-122
    .byte	-120
    .byte	-117
    .byte	-115
    .byte	-112
    .byte	-109
    .byte	-106
    .byte	-102
    .byte	-98
    .byte	-94
    .byte	-90
    .byte	-85
    .byte	-81
    .byte	-76
    .byte	-71
    .byte	-65
    .byte	-60
    .byte	-54
    .byte	-49
    .byte	-43
    .byte	-37
    .byte	-31
    .byte	-25
    .byte	-19
    .byte	-12
    .byte	-6

    
IntroCircle subroutine
    lda entityFrame,x
    asl
    and #127
    tay
    lda sin,y
    ASR65
    sta tmp
    EXTEND tmp,tmp
    ADD16 playerY, tmp, doorsY
    
    lda entityFrame,x
    asl
    clc
    adc #32;64
    and #127
    tay
    lda sin,y
    ASR65
    ASR65
    ASR65
    sta tmp
    EXTEND tmp,tmp
    SUB16I tmp,tmp,[127>>3]
    ADD16 playerX, tmp, doorsX
    
    lda entityFrame,x
    cmp #127
    bne .continue
    inc entityCount,x
    lda #0
    sta entityFrame,x
.continue
    jmp ER_Return
    
IntroSteering subroutine
    stx sav
    jsr OpenTextBox
    MOV16I arg, steeringText
    jsr PrintPages
    jsr CloseTextBox
    ldx sav
    inc entityCount,x
    lda #0
    sta entityFrame,x
    jmp ER_Return
    
IntroMove subroutine
    lda #0
    sta playerYVel+1
    lda #1
    sta playerXVel
    sta entityVelocity,x
    jsr EntTestFlyingCollision
    bcc .continue
    inc entityCount,x
    lda #0
    sta entityFrame,x
.continue    
    jmp ER_Return
    
IntroCrash subroutine
    lda #-1
    sta playerXVel
    lda entityFrame,x
    cmp #30
    bne .continue
    inc entityCount,x
    lda #0
    sta entityFrame,x
.continue    
    jmp ER_Return
    
IntroWhere subroutine
    stx sav
    jsr OpenTextBox
    MOV16I arg, whereText
    jsr PrintPages
    jsr CloseTextBox
    ldx sav
    inc entityCount,x
    lda #0
    sta entityFrame,x
    jmp ER_Return
    
IntroSwerve subroutine
    lda #1
    sta playerYVel+1
    lda #0
    lda entityFrame,x
    cmp #30
    bcc .continue
    inc entityCount,x
    lda #0
    sta entityFrame,x
.continue
    jmp ER_Return
    
    
IntroLand subroutine
    stx sav
    jsr OpenTextBox
    MOV16I arg, landText
    jsr PrintPages
    jsr CloseTextBox
    ldx sav
    inc exitTriggered
    jmp ER_Return
    
endStates:
    .word EndNextStop
    .word EndMove
    .word EndCount
    .word EndScore
    
EndNextStop subroutine
    stx sav
    jsr OpenTextBox
    MOV16I arg, nextStopText
    jsr PrintPages
    jsr CloseTextBox
    ldx sav
    inc entityCount,x
    lda #0
    sta entityFrame,x
    jmp ER_Return
    
EndMove subroutine
    lda #-1
    sta playerXVel
    sta entityVelocity,x
    lda #1
    sta playerYVel+1
    jsr EntTestFlyingCollision
    JCC ER_Return
    inc entityCount,x
    lda #0
    sta entityFrame,x
    MOV16I doorsX, 713
    jmp ER_Return
    
EndCount subroutine
    lda doorsX
    ora doorsX+1
    bne .countdown
    inc entityCount,x
    lda #0
    sta entityFrame,x
    jmp ER_Return
.countdown:
    lda entityFrame,x
    and #1
    JNE ER_Return
    DEC16 doorsX
    lda #10
    sta arg
    lda #0
    sta arg+1
    sta arg+2
    stx sav
    jsr AddScore
    ldx #SFX_POINTS
    jsr PlaySound
    ldx sav
    jmp ER_Return
    
EndScore subroutine
    lda entityFrame,x
    cmp #120
    bcc .end
    inc exitTriggered
.end:
    jmp ER_Return
    
    
ER_Planet subroutine
    lda entityCount,x
    bne .ready
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    REPEAT 4
    LSR16 tmp
    REPEND
    lda tmp
    sta entityCount,x
    lda entityYLo,x
    sec
    sbc #8
    sta entityYLo,x
    lda entityYHi,x
    sbc #0
    sta entityYHi,x
.ready:
    lda entityFrame,x
    lsr
    tay
    lda sin,y
    ASR65
    ASR65
    sta tmp
    EXTEND tmp,tmp
    lda entityCount,x
    sta tmp+2
    EXTEND tmp+2,tmp+2
    REPEAT 4
    ASL16 tmp+2,tmp+2
    REPEND
    ADD16 tmp,tmp,tmp+2
    ADD16I tmp,tmp,8
    lda tmp
    sta entityXLo,x
    lda tmp+1
    sta entityXHi,x
    cpy #96
    beq .goFront
    cpy #32
    beq .goBack
    jmp ER_Return
.goFront
    lda #ANIM_SMALL_NONE
    sta entityAnim,x
    jmp ER_Return
.goBack:
    lda #ANIM_SMALL_NONE_BG
    sta entityAnim,x
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

ER_Sign subroutine
    lda entityCount,x
    JEQ ER_Sign_notFalling
    MOV16I arg,8
    jsr EntAwayFromPlayerY
    bcs .NoMelee
    MOV16I arg,16
    jsr EntAwayFromPlayerX
    bcs .NoMelee
    jsr DamagePlayer
.NoMelee
    jsr EntFall
    jsr EntTestLandingCollision
    bcs .hit
    jmp .nohit
.hit:
    lda entityXLo,x
    sta sav
    lda entityXHi,x
    and #ENT_X_POS
    sta sav+1
    SUB16I sav,sav,8
    
    lda entityYLo,x
    sta sav+2
    REPEAT 4
    LSR16 sav
    REPEND
    lda entityYHi,x
    and #ENT_Y_POS
    sta sav+3
    REPEAT 4
    LSR16 sav+2
    REPEND
    MOV16 arg,sav
    MOV16 arg+2,sav+2
    lda #FALLEN_SIGN_TILE
    sta arg+4
    stx sav+5
    jsr SetTile
    ldx sav+5
    
    INC16 sav
    MOV16 arg,sav
    MOV16 arg+2,sav+2
    lda #FALLEN_SIGN_TILE+1
    sta arg+4
    stx sav+5
    jsr SetTile
    ldx sav+5
    
    lda #$80
    sta entityXHi,x
.nohit:
    jmp ER_Return

ER_Sign_notFalling:
    MOV16I arg, 16
    jsr EntAwayFromPlayerX
    bcs .noFall
    
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    CMP16 playerY,tmp
    bcc .noFall
    ADD16I tmp,tmp,16*6
    CMP16 playerY,tmp
    bcs .noFall
    lda #1
    sta entityCount,x
.noFall:
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
    CMP16 playerY,tmp
    bcc .noFall
    ADD16I tmp,tmp,16*6
    CMP16 playerY,tmp
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
    lda #ANIM_PLAYER_WALK
    sta entityAnim,x
    lda entityVelocity,x
    bpl .notLeft
    lda #ANIM_PLAYER_WALK_LEFT
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
ER_LeftCannon subroutine
    lda switches
    and #SWITCH_TURRETS
    JEQ ER_Return
    jmp ER_Cannon
ER_LeftCannonMoving subroutine
ER_RightCannonMoving subroutine
    jsr EntMoveVertically
    jsr EntTestVerticalCollision
    bcc .nohit
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
.nohit:
ER_Cannon subroutine
    MOV16I arg, 8
    jsr EntAwayFromPlayerY
    bcs .return
    lda entityXHi+1,x
    bpl .return
    lda entityCount,x
    clc
    adc #1
    sta entityCount,x
    cmp #$10
    bne .return
    
    stx sav
    ldx #SFX_LASER
    jsr PlaySound
    ldx sav
    
    lda #0
    sta entityCount,x
    lda entityXHi,x
    sta entityXHi+1,x
    lda entityXLo,x
    sta entityXLo+1,x
    lda entityYHi,x
    and #~ENT_Y_INDEX
    ora #LASER_ID<<1
    sta entityYHi+1,x
    lda entityYLo,x
    sta entityYLo+1,x
    lda #ANIM_LASER
    sta entityAnim+1,x
    lda #4
    sta entityVelocity+1,x
    lda entityYHi,x
    lsr
    cmp #LEFTCANNONMOVING_ID
    beq .left
    cmp #LEFTCANNON_ID
    bne .return
.left:
    lda #-4
    sta entityVelocity+1,x
.return:
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
    jsr EntExplode
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
    lda #3
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
    jsr EntUpdateFlash
    MOV16I arg,24
    jsr EntTallAwayFromPlayerY
    bcs .noChase
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
    lda entityVelocity,x
    bmi .chaseLeft
.chaseRight:
    CMP16 tmp, playerX
    bcs .noChase
    lda #2
    sta entityVelocity,x
    jmp .continue
.chaseLeft:
    CMP16 tmp, playerX
    bcc .noChase
    lda #-2
    sta entityVelocity,x
    jmp .continue
.noChase:

.continue:
    jsr EntTestWalkingCollision
    bcc .nohit
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    cmp #1
    beq .noshift
    cmp #-1
    beq .noshift
    ASR65
.noshift:
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
    jsr EntFlash
    
    stx sav
    ldx #SFX_HURT
    jsr PlaySound
    ldx sav
    
    lda entityXLo,x
    sta tmp
    lda entityXHi,x
    and #ENT_X_POS
    sta tmp+1
.VengeanceRight:
    CMP16 tmp, playerX
    bcs .VenganceLeft
    lda #2
    sta entityVelocity,x
    jmp .NoVengance
.VenganceLeft:
    lda #-2
    sta entityVelocity,x
.NoVengance:

    
    jmp .noBullet
.dead
    jsr EntExplode    
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
    lda entityYHi,x
    sta sav
    jsr EntExplode
    lda entityYHi+1,x
    lsr
    cmp #CATERPILLAR_ID
    bcc .lastOne
    cmp #CATERPILLAR_ID+4
    bcs .lastOne
    lda sav ;should be on same y coord, no need to extract
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
    lda #ANIM_SLIME_RIGHT
    sta entityAnim,x
    lda entityVelocity,x
    bpl .notLeft
    lda #ANIM_SLIME_LEFT
    sta entityAnim,x
.notLeft:
    jsr Randomize
    beq .hit
    
    jsr EntTestFlyingCollision
    bcs .hit
    jmp .nohit
.hit:
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
    
    jsr Randomize
    and #1
    bne .noRotate
    lda entityYHi,x
    clc
    adc #2
    sta entityYHi,x
    jmp .end
.noRotate:

.nohit:
    jsr EntMoveHorizontally
.end:
    jsr EntTryMelee
    jsr EntDieInOneShot
    jmp ER_Return
    
ER_SlimeVertical subroutine
    lda #ANIM_SLIME_DOWN
    sta entityAnim,x
    lda entityVelocity,x
    bpl .notUp
    lda #ANIM_SLIME_UP
    sta entityAnim,x
.notUp:
    jsr Randomize
    beq .hit
    
    jsr EntTestVerticalCollision
    bcs .hit
    jmp .nohit
.hit:
    lda entityVelocity,x
    eor #$FF
    clc
    adc #1
    sta entityVelocity,x
    jsr Randomize
    and #1
    bne .noRotate
    lda entityYHi,x
    sec
    sbc #2
    sta entityYHi,x
    jmp .end
.noRotate:

.nohit:
    jsr EntMoveVertically
.end:
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
    stx sav
    ldx #SFX_HAMMER
    jsr PlaySound
    ldx sav
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
    
ER_Faucet subroutine
    lda entityXHi+1,x
    bpl .return
    lda entityYLo,x
    sta tmp
    lda entityYHi,x
    and #ENT_Y_POS
    sta tmp+1
    CMP16 playerY,tmp
    bcc .return
    lda entityCount,x
    beq .drip
    dec entityCount,x
    jmp ER_Return
.drip:
    lda #15
    sta entityCount,x
    lda entityXHi,x
    sta entityXHi+1,x
    lda entityXLo,x
    sta entityXLo+1,x
    lda entityYHi,x
    and #ENT_Y_POS
    ora #WATER_ID<<1
    sta entityYHi+1,x
    lda entityYLo,x
    sta entityYLo+1,x
    lda #ANIM_SPIKE
    sta entityAnim+1,x
    lda #3
    sta entityVelocity+1,x
.return:
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
    ADD16I arg+2,arg+2,16
    jsr TestCollisionTop
    bcc .notDead
    stx sav
    ldx #SFX_DRIP
    jsr PlaySound
    ldx sav
    lda #$80
    sta entityXHi,x
    jmp ER_Return
.notDead:
    jsr EntMoveVertically
    jsr EntTryMelee
    jmp ER_Return
    
ER_EnemyBullet subroutine
    ;player can shoot it down
    jsr EntIsBulletNear
    bcc ER_Laser
    lda #$80
    sta entityXHi
    sta entityXHi,x
    jmp ER_Return
ER_Laser subroutine
    
    jsr EntTestFlyingCollision
    bcc .notDead
    lda #$80
    sta entityXHi,x
    jmp ER_Return
.notDead:
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
    
    SUB16 tmp+4, tmp, playerX
    ABS16 tmp+4, tmp+4
    CMP16I tmp+4, 12
    bcs .noMelee
    
    SUB16 tmp+4, tmp+2, playerY
    ABS16 tmp+4, tmp+4
    CMP16I tmp+4, 12
    bcs .noMelee
    
    jsr DamagePlayer
    lda #$80
    sta entityXHi,x
.noMelee:
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
    jsr EntMoveVertically
    MOV16I arg, 8
    jsr EntAwayFromPlayerX
    JCS ER_Return
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
    lda playerYVel+1
    bmi .noRider
    lda #0
    sta playerYVel
    sta playerYVel+1
    sta playerYFrac
    lda playerFlags
    and #~PLY_ISJUMPING
    sta playerFlags
    lda entityYLo,x
    sta playerY
    lda entityYHi,x
    and #ENT_Y_POS
    sta playerY+1
    SUB16I playerY,playerY,16
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
    JCS ER_Return
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
    lda playerYVel+1
    bmi .noRider
    lda #0
    sta playerYVel
    sta playerYVel+1
    sta playerYFrac
    lda playerFlags
    and #~PLY_ISJUMPING
    sta playerFlags
    lda entityYLo,x
    sta playerY
    lda entityYHi,x
    and #ENT_Y_POS
    sta playerY+1
    SUB16I playerY,playerY,16
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
