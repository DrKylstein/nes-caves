;------------------------------------------------------------------------------
; Animation Data
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
    .word anim_torch
    .word anim_girder_left
    .word anim_girder_middle
    .word anim_girder_right
    .word anim_spike
    .word anim_planet
    
frame_small1:
    .byte 8
    
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    
    .byte 0
    .byte 2
    .byte 0
    .byte 8

frame_smallHFlip1:
    .byte 8
    
    .byte 0
    .byte 2
    .byte $40
    .byte 0
    
    .byte 0
    .byte 0
    .byte $40
    .byte 8


frame_small2:
    .byte 8
    
    .byte 0
    .byte 4
    .byte 0
    .byte 0
    
    .byte 0
    .byte 6
    .byte 0
    .byte 8

frame_smallHFlip2:
    .byte 8
    
    .byte 0
    .byte 6
    .byte $40
    .byte 0
    
    .byte 0
    .byte 4
    .byte $40
    .byte 8

frame_small3:
    .byte 8
    
    .byte 0
    .byte 8
    .byte 0
    .byte 0
    
    .byte 0
    .byte 10
    .byte 0
    .byte 8

frame_smallHFlip3:
    .byte 8
    
    .byte 0
    .byte 10
    .byte $40
    .byte 0
    
    .byte 0
    .byte 8
    .byte $40
    .byte 8

frame_smallVFlip1:
    .byte 8
    
    .byte 0
    .byte 0
    .byte $80
    .byte 0
    
    .byte 0
    .byte 2
    .byte $80
    .byte 8

frame_smallHV1:
    .byte 8
    
    .byte 0
    .byte 2
    .byte $C0
    .byte 0
    
    .byte 0
    .byte 0
    .byte $C0
    .byte 8

frame_symmetrical1:
    .byte 8
    
    .byte 0
    .byte 0
    .byte 0
    .byte 0

    .byte 0
    .byte 0
    .byte $40
    .byte 8

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
    
    .byte 0
    .byte 2
    .byte 0
    .byte 0

    .byte 0
    .byte 2
    .byte $40
    .byte 8
    
.frame3
    .byte 8
    
    .byte 0
    .byte 4
    .byte 0
    .byte 0

    .byte 0
    .byte 4
    .byte $40
    .byte 8

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
    
    .byte 0
    .byte 0
    .byte $80
    .byte 0
    
    .byte 0
    .byte 2
    .byte $80
    .byte 8
.frame2:
    .byte 8
    
    .byte 0
    .byte 4
    .byte $80
    .byte 0
    
    .byte 0
    .byte 6
    .byte $80
    .byte 8
.frame3:
    .byte 8
    
    .byte 0
    .byte 8
    .byte $80
    .byte 0
    
    .byte 0
    .byte 10
    .byte $80
    .byte 8
    
frame_caterpillar1:
    .byte 8
    
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    
    .byte 0
    .byte 2
    .byte 0
    .byte 8
frame_caterpillar2:
    .byte 8
    
    .byte 0-1
    .byte 0
    .byte 0
    .byte 0
    
    .byte 0-1
    .byte 2
    .byte 0
    .byte 8
frame_caterpillar3:
    .byte 8
    
    .byte 0-2
    .byte 0
    .byte 0
    .byte 0
    
    .byte 0-2
    .byte 2
    .byte 0
    .byte 8
    
frame_caterpillarHFlip1:
    .byte 8
    
    .byte 0
    .byte 2
    .byte $40
    .byte 0
    
    .byte 0
    .byte 0
    .byte $40
    .byte 8
frame_caterpillarHFlip2:
    .byte 8
    
    .byte 0-1
    .byte 2
    .byte $40
    .byte 0
    
    .byte 0-1
    .byte 0
    .byte $40
    .byte 8
frame_caterpillarHFlip3:
    .byte 8
    
    .byte 0-2
    .byte 2
    .byte $40
    .byte 0
    
    .byte 0-2
    .byte 0
    .byte $40
    .byte 8
    
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
    
    .byte 0
    .byte 2
    .byte $C0
    .byte 0
    
    .byte 0
    .byte 2
    .byte $80
    .byte 8
            
anim_rex subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 16
    
    .byte 0-16
    .byte 0
    .byte 0
    .byte 0
    
    .byte 0-16
    .byte 2
    .byte 0
    .byte 8

    .byte 0
    .byte 64
    .byte 0
    .byte 0
    
    .byte 0
    .byte 66
    .byte 0
    .byte 8
.frame2:
    .byte 16
    
    .byte 0-16
    .byte 4
    .byte 0
    .byte 0
    
    .byte 0-16
    .byte 6
    .byte 0
    .byte 8

    .byte 0
    .byte 68
    .byte 0
    .byte 0
    
    .byte 0
    .byte 70
    .byte 0
    .byte 8
.frame3:
    .byte 16
    
    .byte 0-16
    .byte 8
    .byte 0
    .byte 0
    
    .byte 0-16
    .byte 10
    .byte 0
    .byte 8

    .byte 0
    .byte 72
    .byte 0
    .byte 0
    
    .byte 0
    .byte 74
    .byte 0
    .byte 8

anim_rex_hflip subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 16
    
    .byte 0-16
    .byte 0
    .byte $40
    .byte 8
    
    .byte 0-16
    .byte 2
    .byte $40
    .byte 0

    .byte 0
    .byte 64
    .byte $40
    .byte 8
    
    .byte 0
    .byte 66
    .byte $40
    .byte 0
.frame2:
    .byte 16
    
    .byte 0-16
    .byte 4
    .byte $40
    .byte 8
    
    .byte 0-16
    .byte 6
    .byte $40
    .byte 0

    .byte 0
    .byte 68
    .byte $40
    .byte 8
    
    .byte 0
    .byte 70
    .byte $40
    .byte 0
.frame3:
    .byte 16
    
    .byte 0-16
    .byte 8
    .byte $40
    .byte 8
    
    .byte 0-16
    .byte 10
    .byte $40
    .byte 0

    .byte 0
    .byte 72
    .byte $40
    .byte 8
    
    .byte 0
    .byte 74
    .byte $40
    .byte 0
    
anim_rock_hiding subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    
    .byte 0+8
    .byte 0
    .byte $20
    .byte 0
    
    .byte 0+8
    .byte 2
    .byte $20
    .byte 8    
    
anim_rocket subroutine
    .byte 3
    .word frame_small1
    .word frame_small2
    .word frame_small3
    .word .frame4
.frame4:
    .byte 8
    
    .byte 0
    .byte 4
    .byte $80
    .byte 0
    
    .byte 0
    .byte 6
    .byte $80
    .byte 8
    
anim_rocket_hflip subroutine
    .byte 3
    .word frame_smallHFlip1
    .word frame_smallHFlip2
    .word frame_smallHFlip3
    .word .frame4
.frame4:
    .byte 8
    
    .byte 0
    .byte 6
    .byte $C0
    .byte 0
    
    .byte 0
    .byte 4
    .byte $C0
    .byte 8

anim_powershot subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 8
    
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    
    .byte 0
    .byte 6
    .byte 0
    .byte 8
.frame2:
    .byte 8
    
    .byte 0
    .byte 2
    .byte 0
    .byte 0
    
    .byte 0
    .byte 6
    .byte 0
    .byte 8
.frame3:
    .byte 8
    
    .byte 0
    .byte 4
    .byte 0
    .byte 0
    
    .byte 0
    .byte 6
    .byte 0
    .byte 8

anim_powershot_hflip subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 8
    
    .byte 0
    .byte 6
    .byte $40
    .byte 0
    
    .byte 0
    .byte 0
    .byte $40
    .byte 8
.frame2:
    .byte 8
    
    .byte 0
    .byte 6
    .byte $40
    .byte 0
    
    .byte 0
    .byte 2
    .byte $40
    .byte 8
.frame3:
    .byte 8
    
    .byte 0
    .byte 6
    .byte $40
    .byte 0
    
    .byte 0
    .byte 4
    .byte $40
    .byte 8

anim_stalactite subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    
    .byte 0-1
    .byte 0
    .byte $20
    .byte 0
    
    .byte 0-1
    .byte 0
    .byte $20
    .byte 8
    
anim_girder_middle subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    
    .byte 0-1
    .byte 2
    .byte $00
    .byte 0
    
    .byte 0-1
    .byte 2
    .byte $00
    .byte 8
    
anim_girder_left subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    
    .byte 0-1
    .byte 0
    .byte $00
    .byte 0
    
    .byte 0-1
    .byte 2
    .byte $00
    .byte 8
    
anim_girder_right subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    
    .byte 0-1
    .byte 2
    .byte $00
    .byte 0
    
    .byte 0-1
    .byte 4
    .byte $00
    .byte 8

anim_flame subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte 8
    
    .byte 0
    .byte 0
    .byte $20
    .byte 0

    .byte 0
    .byte 2
    .byte $20
    .byte 8
.frame2:
    .byte 8
    
    .byte 0
    .byte 2
    .byte $60
    .byte 0

    .byte 0
    .byte 0
    .byte $60
    .byte 8

anim_pipe_right subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte 16
    
    .byte 0
    .byte 0
    .byte 0
    .byte 0

    .byte 0
    .byte 2
    .byte 0
    .byte 8
    
    .byte 0
    .byte 4
    .byte 0
    .byte 16

    .byte 0
    .byte 6
    .byte 0
    .byte 24

.frame2:
    .byte 12
    
    .byte 0
    .byte 0
    .byte 0
    .byte 0

    .byte 0
    .byte 2
    .byte 0
    .byte 8
    
    .byte 0
    .byte 6
    .byte 0
    .byte 16

anim_pipe_left subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte 16
    
    .byte 0
    .byte 2
    .byte $C0
    .byte 0

    .byte 0
    .byte 0
    .byte $C0
    .byte 8
    
    .byte 0
    .byte 4
    .byte $C0
    .byte -8

    .byte 0
    .byte 6
    .byte $C0
    .byte -16

.frame2:
    .byte 12
    
    .byte 0
    .byte 2
    .byte $C0
    .byte 0

    .byte 0
    .byte 0
    .byte $C0
    .byte 8
    
    .byte 0
    .byte 6
    .byte $C0
    .byte -8

anim_torch subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte 4
    
    .byte 0
    .byte 0
    .byte $40
    .byte 4
.frame2:
    .byte 4
    
    .byte 0
    .byte 0
    .byte 0
    .byte 4

anim_spike subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 4
    
    .byte 0
    .byte 0
    .byte $20
    .byte 4

anim_planet subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8*OAM_SIZE
    
    .byte 0
    .byte 0
    .byte $20
    .byte 0   
    
    .byte 0+16
    .byte 2
    .byte $20
    .byte 0    
    
    .byte 0
    .byte 4
    .byte $20
    .byte 8
    
    .byte 16
    .byte 6
    .byte $20
    .byte 8
    
    .byte 0
    .byte 32
    .byte $20
    .byte 16
    
    .byte 0+16
    .byte 32+2
    .byte $20
    .byte 16
    
    .byte 0
    .byte 32+4
    .byte $20
    .byte 24
    
    .byte 0+16
    .byte 32+6
    .byte $20
    .byte 24