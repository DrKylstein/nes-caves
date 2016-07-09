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
    .byte $00
    .byte $08
        

animations:
    .word anim_null
    .word anim_smallNone
    .word anim_smallHFlipNone
    .word anim_smallOscillate
    .word anim_smallHFlipOscillate
    .word anim_smallVFlipOscillate
    .word -1
    .word -1
    .word anim_caterpillar
    .word anim_caterpillarHFlip
    .word anim_caterpillar2
    .word anim_caterpillarHFlip2
    .word anim_spider
    .word anim_spiderVFlip
    .word anim_rex
    .word anim_rex_hflip
    .word anim_rock_hiding
    .word anim_symmetrical_none
    .word anim_symmetrical_oscillate
    .word anim_rocket
    .word anim_rocket_hflip
    .word anim_slime_down
    .word anim_slime_up
    .word anim_slime_right
    .word anim_slime_left
    .word anim_powershot
    .word anim_powershot_hflip
    .word anim_stalactite
    .word anim_flame
    .word anim_pipe_right
    .word anim_pipe_left
    
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

frame_smallVFlip1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $80
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $80
    .byte 16

frame_smallHV1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $C0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $C0
    .byte 16

frame_symmetrical1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte 0
    .byte 8

    .byte PX_VIEWPORT_OFFSET
    .byte 0
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

anim_symmetrical_none subroutine
    .byte 0
    .word frame_symmetrical1

anim_symmetrical_oscillate subroutine
    .byte 3
    .word frame_symmetrical1
    .word .frame2
    .word .frame3
    .word .frame2
    
.frame2
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte 0
    .byte 8

    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $40
    .byte 16
    
.frame3
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte 0
    .byte 8

    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte $40
    .byte 16

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

anim_slime_up subroutine
    .byte 1
    .word frame_smallVFlip1
    .word frame_smallHV1
    
anim_slime_down subroutine
    .byte 1
    .word frame_small1
    .word frame_smallHFlip1
    
anim_slime_left subroutine
    .byte 1
    .word frame_small1
    .word frame_smallVFlip1
    
anim_slime_right subroutine
    .byte 1
    .word frame_smallHFlip1
    .word frame_smallHV1


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
    .word frame_symmetrical1
    .word frame_smallHFlip1
    .word frame_symmetrical1

anim_spiderVFlip subroutine
    .byte 3
    .word frame_smallVFlip1
    .word .frame2
    .word frame_smallHV1
    .word .frame2
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
            
anim_rex subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
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

anim_rex_hflip subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 0
    .byte $40
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 2
    .byte $40
    .byte 8

    .byte PX_VIEWPORT_OFFSET
    .byte 64
    .byte $40
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET
    .byte 66
    .byte $40
    .byte 8
.frame2:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 4
    .byte $40
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 6
    .byte $40
    .byte 8

    .byte PX_VIEWPORT_OFFSET
    .byte 68
    .byte $40
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET
    .byte 70
    .byte $40
    .byte 8
.frame3:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 8
    .byte $40
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 10
    .byte $40
    .byte 8

    .byte PX_VIEWPORT_OFFSET
    .byte 72
    .byte $40
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET
    .byte 74
    .byte $40
    .byte 8
    
anim_rock_hiding subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET+8
    .byte 0
    .byte $20
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET+8
    .byte 2
    .byte $20
    .byte 16    
    
anim_rocket subroutine
    .byte 3
    .word frame_small1
    .word frame_small2
    .word frame_small3
    .word .frame4
.frame4:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte $80
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte $80
    .byte 16
    
anim_rocket_hflip subroutine
    .byte 3
    .word frame_smallHFlip1
    .word frame_smallHFlip2
    .word frame_smallHFlip3
    .word .frame4
.frame4:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte $C0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte $C0
    .byte 16

anim_powershot subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte 0
    .byte 16
.frame2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte 0
    .byte 16
.frame3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte 0
    .byte 16

anim_powershot_hflip subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $40
    .byte 16
.frame2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $40
    .byte 16
.frame3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte $40
    .byte 16

anim_stalactite subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-1
    .byte 0
    .byte $20
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-1
    .byte 0
    .byte $20
    .byte 16

anim_flame subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $20
    .byte 8

    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $20
    .byte 16
.frame2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $60
    .byte 8

    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $60
    .byte 16

anim_pipe_right subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte 0
    .byte 8

    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte 0
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte 0
    .byte 24

    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte 0
    .byte 32

.frame2:
    .byte 12
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte 0
    .byte 8

    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte 0
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte 0
    .byte 24

anim_pipe_left subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $C0
    .byte 8

    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $C0
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte $C0
    .byte 0

    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte $C0
    .byte -8

.frame2:
    .byte 12
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $C0
    .byte 8

    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $C0
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte $C0
    .byte 0

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

sfxLaser subroutine
    .byte 3
    .word .noise
    .word 0
    .byte <-1
.noise:
    .byte $31, $8D
    .byte $32, $8D
    .byte $34, $8D
    .byte $38, $8D
    .byte $3F, $8D
    .byte $3E, $8D
    .byte $3D, $8C
    .byte $3C, $8B
    .byte $3B, $8A
    .byte $3A, $89
    .byte $39, $88
    .byte $38, $87
    .byte $37, $86
    .byte $36, $85
    .byte $30, $84
    .byte 0
    
sfxCrystal subroutine
    .byte 0
    .word .sq
    .word $060
    .byte <-1

.sq:
    .byte DUTY_50 | $8, 0
    .byte DUTY_50 | $F, 0
    .byte DUTY_50 | $F, 0
    .byte DUTY_50 | $F, 0
    .byte DUTY_50 | $F, 8
    .byte DUTY_50 | $F, 8
    .byte DUTY_50 | $F, 8
    .byte DUTY_50 | $F, 8
    .byte DUTY_50 | $F, 8
    .byte DUTY_50 | $F, 8
    .byte DUTY_50 | $D, 8
    .byte DUTY_50 | $B, 8
    .byte DUTY_50 | $9, 8
    .byte DUTY_50 | $7, 8
    .byte DUTY_50 | $5, 8
    .byte DUTY_50 | $3, 8
    .byte DUTY_50 | $2, 8
    .byte DUTY_50 | $1, 8
    .byte DUTY_50 | $0, 8
    .byte 0

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
    .word 0
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
    .word caveTiles
    .word techTiles
    .word mineTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word mineTiles

levelPalettes:
    .word volcanoPal
    .word cobaltPal
    .word minePal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word minePal