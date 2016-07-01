;------------------------------------------------------------------------------
; PRG ROM DATA
;------------------------------------------------------------------------------

playerWalk:
    .byte $00
    .byte $04
    .byte $08
    .byte $04
    .byte $00
    .byte $0C
    .byte $10
    .byte $0C
    .byte $14
    .byte $08
    
entityFlags:
    .byte $92 ; bullet
    .byte $62 ; vertical platform
    .byte $42 ; horizontal platform
    .byte $3F ; spider
    .byte $0B ; bat
    .byte $90 ; power shot
    .byte $1B ; rock
    .byte ENT_F_ISDEADLY | ENT_F_ISMORTAL | $02 ; cart
    .byte ENT_F_ISDEADLY | ENT_F_ISMORTAL | $04 ; caterpillar head
    .byte ENT_F_ISDEADLY | $04 ; caterpillar front
    .byte ENT_F_ISDEADLY | $04 ; caterpillar back
    .byte ENT_F_ISDEADLY | $04 ; caterpillar tail
    .byte ENT_F_ISDEADLY | ENT_F_ISMORTAL | $04 ; slime horizontal
    .byte ENT_F_ISDEADLY | ENT_F_ISMORTAL | ENT_F_ISVERTICAL | $04 ; slime horizontal
    .byte ENT_F_ISDEADLY | ENT_F_ISVERTICAL | $02 ; hammer
    .byte $06 ; faucet
    .byte ENT_F_ISPROJECTILE | ENT_F_ISDEADLY | ENT_F_ISVERTICAL | $06 ; water
    .byte $62 ; vertical platform
    .byte $42 ; horizontal platform
    .byte $02 | ENT_F_ISVERTICAL ; right cannon
    .byte ENT_F_ISPROJECTILE | ENT_F_ISDEADLY | $00 ; right laser
    .byte $02 | ENT_F_ISVERTICAL ; left cannon
    .byte ENT_F_ISPROJECTILE | ENT_F_ISDEADLY | $00 ; left laser
    .byte ENT_F_ISMORTAL | ENT_F_ISDEADLY | $04 ; rex
    
entityFlags2:
    .byte 0 ; bullet
    .byte 0 ; vertical platform
    .byte 0 ; horizontal platform
    .byte ENT_F2_ISHITTABLE  ; spider
    .byte ENT_F2_ISHITTABLE  ; bat
    .byte ENT_F2_ISHITTABLE  ; power shot
    .byte ENT_F2_ISHITTABLE  | ENT_F2_ISGROUNDED | ENT_F2_NEEDPOWERSHOT ; rock
    .byte ENT_F2_ISHITTABLE | ENT_F2_ISGROUNDED | ENT_F2_NEEDPOWERSHOT ; cart
    .byte ENT_F2_ISHITTABLE  | ENT_F2_ISGROUNDED ;caterpillar head
    .byte ENT_F2_ISHITTABLE  | ENT_F2_ISGROUNDED ;caterpillar front
    .byte ENT_F2_ISHITTABLE  | ENT_F2_ISGROUNDED ;caterpillar back
    .byte ENT_F2_ISHITTABLE  | ENT_F2_ISGROUNDED ;caterpillar tail
    .byte ENT_F2_ISHITTABLE  ; slime horizontal
    .byte ENT_F2_ISHITTABLE  ; slime vertical
    .byte 0 ; hammer
    .byte 0 ; faucet
    .byte 0 ;water
    .byte 1 ; vertical platform
    .byte 2 ; horizontal platform
    .byte 0 ; right cannon
    .byte 3 ; right laser
    .byte 0 ; left cannon
    .byte 3 ; left laser
    .byte ENT_F2_ISHITTABLE | ENT_F2_ISGROUNDED ; rex
    
entityTiles:
    .byte 64 ; bullet
    .byte 80 ; vertical platform
    .byte 80 ; horizontal platform
    .byte 152 ; spider
    .byte 128 ; bat
    .byte 156 ; power shot
    .byte 140 ; rock
    .byte 84 ; cart
    .byte 120 ; caterpillar head
    .byte 116 ; caterpillar front
    .byte 116 ; caterpillar back
    .byte 112 ; caterpillar tail
    .byte 192 ; slime horizontal
    .byte 204 ; slime vertical
    .byte 100 ; hammer
    .byte 220 ; faucet
    .byte 216 ; water
    .byte 80 ; vertical platform
    .byte 80 ; horizontal platform
    .byte 224 ; right cannon
    .byte 228 ; right laser
    .byte 224 ; left cannon
    .byte 228 ; left laser
    .byte 168 ; rex
    
entityHPs:
    .byte 0 ; bullet
    .byte 0 ; vertical platform
    .byte 0 ; horizontal platform
    .byte 1 ; spider
    .byte 1 ; bat
    .byte 0 ; power shot
    .byte 1 ; rock
    .byte 1 ; cart
    .byte 1 ; caterpillar head
    .byte 1 ; caterpillar front
    .byte 1 ; caterpillar back
    .byte 1 ; caterpillar tail
    .byte 1 ; slime horizontal
    .byte 1 ; slime vertical
    .byte 0 ; hammer
    .byte 0 ; faucet
    .byte 0 ; water
    .byte 0 ; vertical platform
    .byte 0 ; horizontal platform
    .byte 0 ; right cannon
    .byte 0 ; right laser
    .byte 0 ; left cannon
    .byte 0 ; left laser
    .byte 4 ; rex
    
entityCounts:
    .byte 0 ; bullet
    .byte 0 ; vertical platform
    .byte 0 ; horizontal platform
    .byte 0 ; spider
    .byte 0 ; bat
    .byte 0 ; power shot
    .byte 0 ; rock
    .byte $60 ; cart
    .byte 0 ; caterpillar head
    .byte 0 ; caterpillar front
    .byte 0 ; caterpillar back
    .byte 0 ; caterpillar tail
    .byte 0 ; slime horizontal
    .byte 0 ; slime vertical
    .byte $20 ; hammer
    .byte 0 ; faucet
    .byte $20 ; water
    .byte 0 ; vertical platform
    .byte 0 ; horizontal platform
    .byte 0 ; right cannon
    .byte $20 ; right laser
    .byte 0 ; left cannon
    .byte $20 ; left laser
    .byte 0 ; rex
    
entitySpeeds:
    .byte 4 ; bullet
    .byte 1 ; vertical platform
    .byte 1 ; horizontal platform
    .byte 1 ; spider
    .byte 1 ; bat
    .byte 4 ; power shot
    .byte 0 ; rock
    .byte 2 ; cart
    .byte 1 ; caterpillar head
    .byte 1 ; caterpillar front
    .byte 1 ; caterpillar back
    .byte 1 ; caterpillar tail
    .byte 2 ; slime horizontal
    .byte 2 ; slime vertical
    .byte 6 ; hammer
    .byte 0 ; faucet
    .byte 4 ; water
    .byte 1 ; vertical platform
    .byte 1 ; horizontal platform
    .byte 0 ; right cannon
    .byte 4 ; right laser
    .byte 0 ; left cannon
    .byte -4 ; left laser
    .byte 1 ; rex

entityAnims:
    .byte ANIM_SMALL_LONG ; bullet
    .byte ANIM_SPIDER ; vertical platform
    .byte ANIM_SPIDER ; horizontal platform
    .byte ANIM_SPIDER ; spider
    .byte ANIM_SMALL_OSCILLATE ; bat
    .byte ANIM_SMALL_OSCILLATE ; power shot
    .byte ANIM_SMALL_OSCILLATE ; rock
    .byte ANIM_SMALL_LONG ; cart
    .byte ANIM_CATERPILLAR ; caterpillar head
    .byte ANIM_CATERPILLAR_2 ; caterpillar front
    .byte ANIM_CATERPILLAR ; caterpillar back
    .byte ANIM_CATERPILLAR_2 ; caterpillar tail
    .byte ANIM_SMALL_OSCILLATE ; slime horizontal
    .byte ANIM_SMALL_OSCILLATE ; slime vertical
    .byte ANIM_SMALL_NONE ; hammer
    .byte ANIM_SMALL_NONE ; faucet
    .byte ANIM_SMALL_NONE ; water
    .byte ANIM_SPIDER ; vertical platform
    .byte ANIM_SPIDER ; horizontal platform
    .byte ANIM_SMALL_NONE ; right cannon
    .byte ANIM_SMALL_NONE ; right laser
    .byte ANIM_SMALL_HFLIP_NONE ; left cannon
    .byte ANIM_SMALL_NONE ; left laser
    .byte ANIM_REX ;rex

animations:
    .word anim_null
    .word anim_smallNone
    .word anim_smallHFlipNone
    .word anim_smallOscillate
    .word anim_smallHFlipOscillate
    .word anim_smallVFlipOscillate
    .word anim_smallLong
    .word anim_smallHFlipLong
    .word anim_caterpillar
    .word anim_caterpillarHFlip
    .word anim_caterpillar2
    .word anim_caterpillarHFlip2
    .word anim_spider
    .word anim_spiderVFlip
    .word anim_rex
    
frame_small1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte 0
    .byte 16

frame_smallHFlip1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $40
    .byte 16


frame_small2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte 0
    .byte 16

frame_smallHFlip2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte $40
    .byte 16

frame_small3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 8
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 10
    .byte 0
    .byte 16

frame_smallHFlip3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 10
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 8
    .byte $40
    .byte 16

anim_null subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 0

anim_smallNone subroutine
    .byte 0
    .word frame_small1

anim_smallHFlipNone subroutine
    .byte 0
    .word frame_smallHFlip1

anim_smallOscillate subroutine
    .byte 3
    .word frame_small1
    .word frame_small2
    .word frame_small3
    .word frame_small2

anim_smallHFlipOscillate subroutine
    .byte 3
    .word frame_smallHFlip1
    .word frame_smallHFlip2
    .word frame_smallHFlip3
    .word frame_smallHFlip2

anim_smallVFlipOscillate subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $80
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $80
    .byte 16
.frame2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte $80
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte $80
    .byte 16
.frame3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 8
    .byte $80
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 10
    .byte $80
    .byte 16


anim_smallLong subroutine
    .byte 3
    .word frame_small1
    .word frame_small2
    .word frame_small3
    .word .frame4
.frame4:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 12
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 14
    .byte 0
    .byte 16
    
anim_smallHFlipLong subroutine
    .byte 3
    .word frame_smallHFlip1
    .word frame_smallHFlip2
    .word frame_smallHFlip3
    .word .frame4
.frame4:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 14
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 12
    .byte $40
    .byte 16
    
    
frame_caterpillar1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte 0
    .byte 16
frame_caterpillar2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-1
    .byte 0
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-1
    .byte 2
    .byte 0
    .byte 16
frame_caterpillar3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-2
    .byte 0
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-2
    .byte 2
    .byte 0
    .byte 16
    
frame_caterpillarHFlip1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $40
    .byte 16
frame_caterpillarHFlip2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-1
    .byte 2
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-1
    .byte 0
    .byte $40
    .byte 16
frame_caterpillarHFlip3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-2
    .byte 2
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-2
    .byte 0
    .byte $40
    .byte 16
    
anim_caterpillar subroutine
    .byte 3
    .word frame_caterpillar1
    .word frame_caterpillar2
    .word frame_caterpillar3
    .word frame_caterpillar2
    
anim_caterpillarHFlip subroutine
    .byte 3
    .word frame_caterpillarHFlip1
    .word frame_caterpillarHFlip2
    .word frame_caterpillarHFlip3
    .word frame_caterpillarHFlip2
    
anim_caterpillar2 subroutine
    .byte 3
    .word frame_caterpillar3
    .word frame_caterpillar2
    .word frame_caterpillar1
    .word frame_caterpillar2
    
anim_caterpillarHFlip2 subroutine
    .byte 3
    .word frame_caterpillarHFlip3
    .word frame_caterpillarHFlip2
    .word frame_caterpillarHFlip1
    .word frame_caterpillarHFlip2

anim_spider subroutine
    .byte 3
    .word frame_small1
    .word .frame2
    .word frame_smallHFlip1
    .word .frame2
.frame2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte 0
    .byte 16

anim_spiderVFlip subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
    
.frame1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $80
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $80
    .byte 16
    
.frame2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $C0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $80
    .byte 16
    
.frame3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $C0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $C0
    .byte 16
    
anim_rex subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame4
.frame1:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 0
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 2
    .byte 0
    .byte 16

    .byte PX_VIEWPORT_OFFSET
    .byte 64
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 66
    .byte 0
    .byte 16
.frame2:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 4
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 6
    .byte 0
    .byte 16

    .byte PX_VIEWPORT_OFFSET
    .byte 68
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 70
    .byte 0
    .byte 16
.frame3:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 8
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 10
    .byte 0
    .byte 16

    .byte PX_VIEWPORT_OFFSET
    .byte 72
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 74
    .byte 0
    .byte 16
.frame4:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 12
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 14
    .byte 0
    .byte 16

    .byte PX_VIEWPORT_OFFSET
    .byte 76
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 78
    .byte 0
    .byte 16

    
bits:
    .byte 0
    .byte 1
    .byte 2
    .byte 4
    .byte 8
    .byte 16
    .byte 32
    .byte 64
    .byte 128

points:
    .byte  0, 0, 0, 5;0
    .byte  0, 0, 1, 0;0
    .byte  0, 0, 0,80;0
    .byte  0, 0, 1, 0;0
    .byte  0, 0, 5, 0;0
    .byte  0, 0, 0,10;0
    .byte  0, 0,10, 0;0

palettes:
;global
    incbin palsp.pal

hud:
	incbin hud.bin
metatiles:
    incbin metatiles.bin

sfxJump subroutine
    .byte 0
    .word .sqJump
    .word $00F0
    .byte <-1
    
.sqJump:
    .byte DUTY_25 | $F, 0
    .byte DUTY_25 | $2, 1
    .byte DUTY_25 | $E, 1
    .byte DUTY_25 | $2, 2
    .byte DUTY_25 | $D, 2
    .byte DUTY_25 | $2, 3
    .byte DUTY_25 | $C, 3
    .byte DUTY_25 | $2, 4
    .byte DUTY_25 | $B, 4
    .byte DUTY_25 | $2, 5
    .byte DUTY_25 | $A, 5
    .byte DUTY_25 | $2, 6
    .byte DUTY_25 | $9, 6
    .byte DUTY_25 | $2, 7
    .byte DUTY_25 | $8, 7
    .byte DUTY_25 | $2, 8
    .byte DUTY_25 | $7, 8
    .byte DUTY_25 | $2, 9
    .byte DUTY_25 | $6, 9
    .byte DUTY_25 | $2,10
    .byte DUTY_25 | $5,10
    .byte DUTY_25 | $2,11
    .byte DUTY_25 | $4,11
    .byte DUTY_25 | $2,12
    .byte DUTY_25 | $3,12
    .byte DUTY_25 | $2,13
    .byte DUTY_25 | $2,13
    .byte DUTY_25 | $2,14
    .byte DUTY_25 | $1,14
    .byte DUTY_25 | $0,15
    .byte 0
    
sfxShoot subroutine
    .byte 0
    .word .sqShoot
    .word $0230
    .byte 3
    .word .noiseShoot
    .word $DEAD
    .byte <-1
.sqShoot:
    .byte DUTY_25 | $F, 0
    .byte DUTY_25 | $2, 1
    .byte DUTY_25 | $E, 1
    .byte DUTY_25 | $2, 2
    .byte DUTY_25 | $D, 2
    .byte DUTY_25 | $2, 3
    .byte DUTY_25 | $C, 3
    .byte DUTY_25 | $2, 4
    .byte DUTY_25 | $B, 4
    .byte DUTY_25 | $2, 5
    .byte DUTY_25 | $A, 5
    .byte DUTY_25 | $2, 6
    .byte DUTY_25 | $9, 6
    .byte DUTY_25 | $2, 7
    .byte DUTY_25 | $8, 7
    .byte DUTY_25 | $2, 8
    .byte DUTY_25 | $7, 8
    .byte DUTY_25 | $2, 9
    .byte DUTY_25 | $6, 9
    .byte DUTY_25 | $2,10
    .byte DUTY_25 | $5,10
    .byte DUTY_25 | $2,11
    .byte DUTY_25 | $4,11
    .byte DUTY_25 | $2,12
    .byte DUTY_25 | $3,12
    .byte DUTY_25 | $2,13
    .byte DUTY_25 | $2,13
    .byte DUTY_25 | $2,14
    .byte DUTY_25 | $1,14
    .byte DUTY_25 | $0,15
    .byte 0
.noiseShoot:
    .byte $3F, $0F
    .byte $3E, $0F
    .byte $3D, $0F
    .byte $3C, $0F
    .byte $3B, $0F
    .byte $3A, $0F
    .byte $39, $0F
    .byte $38, $0F
    .byte $37, $0F
    .byte $36, $0F
    .byte $35, $0F
    .byte $34, $0F
    .byte $33, $0F
    .byte $32, $0F
    .byte $31, $0F
    .byte $30, $0F
    .byte 0
levelBanks:
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
    .byte 1

levelPointers:
    .word level01
    .word level02
    .word level03
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word mainMap

levelTilesets:
    .word mineTiles
    .word techTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles
    .word mineTiles

levelPalettes:
    .word volcanoPal
    .word cobaltPal
    .word minePal
    .word minePal
    .word minePal
    .word minePal
    .word minePal
    .word minePal
    .word minePal
    .word minePal
    .word minePal
    .word minePal
    .word minePal
    .word minePal
    .word minePal
    .word minePal
    .word minePal