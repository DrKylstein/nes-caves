;------------------------------------------------------------------------------
; Animation Data
;------------------------------------------------------------------------------
    SEG.U ANIMS
    ORG $0000
ANIM_NULL:                  ds 1
ANIM_SMALL_NONE:            ds 1
ANIM_SMALL_HFLIP_NONE:      ds 1
ANIM_SMALL_OSCILLATE:       ds 1
ANIM_SMALL_HFLIP_OSCILLATE: ds 1
ANIM_SMALL_VFLIP_OSCILLATE: ds 1
ANIM_SPIDER:                ds 1
ANIM_SPIDER_VFLIP:          ds 1
ANIM_REX                    ds 1
ANIM_REX_HFLIP              ds 1
ANIM_ROCK_HIDING            ds 1
ANIM_SYMMETRICAL_NONE       ds 1
ANIM_SYMMETRICAL_OSCILLATE  ds 1
ANIM_ROCKET                 ds 1
ANIM_ROCKET_HFLIP           ds 1
ANIM_SLIME_DOWN             ds 1
ANIM_SLIME_UP               ds 1
ANIM_SLIME_RIGHT            ds 1
ANIM_SLIME_LEFT             ds 1
ANIM_POWERSHOT              ds 1
ANIM_POWERSHOT_HFLIP        ds 1
ANIM_STALACTITE             ds 1
ANIM_FLAME                  ds 1
ANIM_PIPE_RIGHT             ds 1
ANIM_PIPE_LEFT              ds 1
ANIM_TORCH                  ds 1
ANIM_GIRDER_LEFT            ds 1
ANIM_GIRDER_MIDDLE          ds 1
ANIM_GIRDER_RIGHT           ds 1
ANIM_SPIKE                  ds 1
ANIM_PLANET                 ds 1
ANIM_PLAYER_WALK            ds 1
ANIM_PLAYER_WALK_LEFT       ds 1
ANIM_PLAYER_JUMP            ds 1
ANIM_PLAYER_JUMP_LEFT       ds 1
ANIM_PLAYER_WALKV           ds 1
ANIM_PLAYER_WALK_LEFTV      ds 1
ANIM_PLAYER_JUMPV           ds 1
ANIM_PLAYER_JUMP_LEFTV      ds 1
ANIM_SMALL_VFLIP_NONE       ds 1
ANIM_SMALL_HV_NONE          ds 1
ANIM_HAMMER                 ds 1
ANIM_BALL_RIGHT             ds 1
ANIM_BALL_LEFT              ds 1
ANIM_BALL_SLEEP             ds 1
ANIM_AIR_GENERATOR          ds 1
ANIM_PLAYER_DIE             ds 1
ANIM_SYMMETRICAL_NONE2      ds 1
ANIM_PLAYER_DEAD            ds 1
ANIM_LASER                  ds 1
ANIM_ROBOT_FIRING_RIGHT     ds 1
ANIM_ROBOT_FIRING_LEFT      ds 1
ANIM_WIDE_NONE              ds 1
ANIM_WORM_BITE_RIGHT        ds 1
ANIM_WORM_BITE_LEFT         ds 1
ANIM_SMALL_NONE_BG          ds 1
ANIM_SMALL_NONE_HFLIP_BG    ds 1

    SEG ROM_FILE

animsLo:
    .byte <anim_null
    .byte <anim_smallNone
    .byte <anim_smallHFlipNone
    .byte <anim_smallOscillate
    .byte <anim_smallHFlipOscillate
    .byte <anim_smallVFlipOscillate
    .byte <anim_spider
    .byte <anim_spiderVFlip
    .byte <anim_rex
    .byte <anim_rex_hflip
    .byte <anim_rock_hiding
    .byte <anim_symmetrical_none
    .byte <anim_symmetrical_oscillate
    .byte <anim_rocket
    .byte <anim_rocket_hflip
    .byte <anim_slime_down
    .byte <anim_slime_up
    .byte <anim_slime_right
    .byte <anim_slime_left
    .byte <anim_powershot
    .byte <anim_powershot_hflip
    .byte <anim_stalactite
    .byte <anim_flame
    .byte <anim_pipe_right
    .byte <anim_pipe_left
    .byte <anim_torch
    .byte <anim_girder_left
    .byte <anim_girder_middle
    .byte <anim_girder_right
    .byte <anim_spike
    .byte <anim_planet
    .byte <anim_player_walk
    .byte <anim_player_walk_left
    .byte <anim_player_jump
    .byte <anim_player_jump_left
    .byte <anim_player_walkv
    .byte <anim_player_walk_leftv
    .byte <anim_player_jumpv
    .byte <anim_player_jump_leftv
    .byte <anim_smallVFlipNone
    .byte <anim_smallHVNone
    .byte <anim_hammer
    .byte <anim_ball_right
    .byte <anim_ball_left
    .byte <anim_ball_sleep
    .byte <anim_air_generator
    .byte <anim_player_die
    .byte <anim_symmetrical_none2
    .byte <anim_player_dead
    .byte <anim_laser
    .byte <anim_robot_firing_right
    .byte <anim_robot_firing_left
    .byte <anim_wide_none
    .byte <anim_worm_bite_right
    .byte <anim_worm_bite_left
    .byte <anim_small_none_bg
    .byte <anim_small_none_hflip_bg
    
animsHi:
    .byte >anim_null
    .byte >anim_smallNone
    .byte >anim_smallHFlipNone
    .byte >anim_smallOscillate
    .byte >anim_smallHFlipOscillate
    .byte >anim_smallVFlipOscillate
    .byte >anim_spider
    .byte >anim_spiderVFlip
    .byte >anim_rex
    .byte >anim_rex_hflip
    .byte >anim_rock_hiding
    .byte >anim_symmetrical_none
    .byte >anim_symmetrical_oscillate
    .byte >anim_rocket
    .byte >anim_rocket_hflip
    .byte >anim_slime_down
    .byte >anim_slime_up
    .byte >anim_slime_right
    .byte >anim_slime_left
    .byte >anim_powershot
    .byte >anim_powershot_hflip
    .byte >anim_stalactite
    .byte >anim_flame
    .byte >anim_pipe_right
    .byte >anim_pipe_left
    .byte >anim_torch
    .byte >anim_girder_left
    .byte >anim_girder_middle
    .byte >anim_girder_right
    .byte >anim_spike
    .byte >anim_planet
    .byte >anim_player_walk
    .byte >anim_player_walk_left
    .byte >anim_player_jump
    .byte >anim_player_jump_left
    .byte >anim_player_walkv
    .byte >anim_player_walk_leftv
    .byte >anim_player_jumpv
    .byte >anim_player_jump_leftv
    .byte >anim_smallVFlipNone
    .byte >anim_smallHVNone
    .byte >anim_hammer
    .byte >anim_ball_right
    .byte >anim_ball_left
    .byte >anim_ball_sleep
    .byte >anim_air_generator
    .byte >anim_player_die
    .byte >anim_symmetrical_none2
    .byte >anim_player_dead
    .byte >anim_laser
    .byte >anim_robot_firing_right
    .byte >anim_robot_firing_left
    .byte >anim_wide_none
    .byte >anim_worm_bite_right
    .byte >anim_worm_bite_left
    .byte >anim_small_none_bg
    .byte >anim_small_none_hflip_bg

playerAnims:
    .byte ANIM_SMALL_NONE
    .byte ANIM_SMALL_HFLIP_NONE
    .byte ANIM_SMALL_VFLIP_NONE
    .byte ANIM_SMALL_HV_NONE
    
    .byte ANIM_PLAYER_JUMP
    .byte ANIM_PLAYER_JUMP_LEFT
    .byte ANIM_PLAYER_JUMPV
    .byte ANIM_PLAYER_JUMP_LEFTV
    
    .byte ANIM_PLAYER_WALK
    .byte ANIM_PLAYER_WALK_LEFT
    .byte ANIM_PLAYER_WALKV
    .byte ANIM_PLAYER_WALK_LEFTV

    .byte ANIM_PLAYER_JUMP
    .byte ANIM_PLAYER_JUMP_LEFT
    .byte ANIM_PLAYER_JUMPV
    .byte ANIM_PLAYER_JUMP_LEFTV


    
frame_small1:
    .byte 8
    .byte   0,  0,  0,  0
    .byte   0,  2,  0,  8

frame_small1_hflip:
    .byte 8
    .byte   0,  2,$40,  0
    .byte   0,  0,$40,  8
    
frame_small2:
    .byte 8
    .byte   0,  4,  0,  0
    .byte   0,  6,  0,  8

frame_small2_hflip:
    .byte 8
    .byte   0,  6,$40,  0
    .byte   0,  4,$40,  8

frame_small3:
    .byte 8
    .byte   0,  8,  0,  0
    .byte   0, 10,  0,  8

frame_small3_hflip:
    .byte 8
    .byte   0, 10,$40,  0
    .byte   0,  8,$40,  8

frame_small1_vflip:
    .byte 8
    .byte   0,  0,$80,  0
    .byte   0,  2,$80,  8

frame_small1_hvflip:
    .byte 8
    .byte   0,  2,$C0,  0
    .byte   0,  0,$C0,  8

frame_symmetrical1:
    .byte 8
    .byte   0,  0,  0,  0
    .byte   0,  0,$40,  8

anim_null subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 0

anim_smallNone subroutine
    .byte 0
    .word frame_small1

anim_small_none_bg subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    .byte   0,  0,$20,  0
    .byte   0,  2,$20,  8


anim_small_none_hflip_bg subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    .byte   0,  2,$60,  0
    .byte   0,  0,$60,  8


anim_smallVFlipNone subroutine
    .byte 0
    .word frame_small1_vflip
    
anim_smallHVNone subroutine
    .byte 0
    .word frame_small1_hvflip
    

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
    .byte   0,  2,  0,  0
    .byte   0,  2,$40,  8
    
.frame3
    .byte 8
    .byte   0,  4,  0,  0
    .byte   0,  4,$40,  8

anim_smallHFlipNone subroutine
    .byte 0
    .word frame_small1_hflip

anim_smallOscillate subroutine
    .byte 3
    .word frame_small1
    .word frame_small2
    .word frame_small3
    .word frame_small2

anim_smallHFlipOscillate subroutine
    .byte 3
    .word frame_small1_hflip
    .word frame_small2_hflip
    .word frame_small3_hflip
    .word frame_small2_hflip

anim_slime_up subroutine
    .byte 1
    .word frame_small1_vflip
    .word frame_small1_hvflip
    
anim_slime_down subroutine
    .byte 1
    .word frame_small1
    .word frame_small1_hflip
    
anim_slime_right subroutine
    .byte 1
    .word frame_small1
    .word frame_small1_vflip
    
anim_slime_left subroutine
    .byte 1
    .word frame_small1_hflip
    .word frame_small1_hvflip


anim_smallVFlipOscillate subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 8
    .byte   0,  0,$80,  0
    .byte   0,  2,$80,  8
.frame2:
    .byte 8
    .byte   0,  4,$80,  0
    .byte   0,  6,$80,  8
.frame3:
    .byte 8
    .byte   0,  8,$80,  0
    .byte   0, 10,$80,  8
    
anim_spider subroutine
    .byte 3
    .word frame_small1
    .word frame_symmetrical1
    .word frame_small1_hflip
    .word frame_symmetrical1

anim_spiderVFlip subroutine
    .byte 3
    .word frame_small1_vflip
    .word .frame2
    .word frame_small1_hvflip
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
    .byte -16,  0,  0,  0
    .byte -16,  2,  0,  8
    .byte   0, 64,  0,  0
    .byte   0, 66,  0,  8
.frame2:
    .byte 16
    .byte -16,  4,  0,  0
    .byte -16,  6,  0,  8
    .byte   0, 68,  0,  0
    .byte   0, 70,  0,  8
.frame3:
    .byte 16
    .byte -16,  8,  0,  0
    .byte -16, 10,  0,  8
    .byte   0, 72,  0,  0
    .byte   0, 74,  0,  8

anim_rex_hflip subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 16
    .byte -16,  0,$40,  8
    .byte -16,  2,$40,  0
    .byte   0, 64,$40,  8
    .byte   0, 66,$40,  0
.frame2:
    .byte 16
    .byte -16,  4,$40,  8
    .byte -16,  6,$40,  0
    .byte   0, 68,$40,  8
    .byte   0, 70,$40,  0
.frame3:
    .byte 16
    .byte -16,  8,$40,  8
    .byte -16, 10,$40,  0
    .byte   0, 72,$40,  8
    .byte   0, 74,$40,  0
    
anim_rock_hiding subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    .byte   6,  0,$20,  0
    .byte   6,  2,$20,  8    
    
anim_rocket subroutine
    .byte 3
    .word frame_small1
    .word frame_small2
    .word frame_small3
    .word .frame4
.frame4:
    .byte 8
    .byte   0,  4,$80,  0
    .byte   0,  6,$80,  8
    
anim_rocket_hflip subroutine
    .byte 3
    .word frame_small1_hflip
    .word frame_small2_hflip
    .word frame_small3_hflip
    .word .frame4
.frame4:
    .byte 8
    .byte   0,  6,$C0,  0
    .byte   0,  4,$C0,  8

anim_powershot subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 8
    .byte   0,  0,  0,  0
    .byte   0,  6,  0,  8
.frame2:
    .byte 8
    .byte   0,  2,  0,  0
    .byte   0,  6,  0,  8
.frame3:
    .byte 8
    .byte   0,  4,  0,  0
    .byte   0,  6,  0,  8

anim_powershot_hflip subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 8
    .byte   0,  6,$40,  0
    .byte   0,  0,$40,  8
.frame2:
    .byte 8
    .byte   0,  6,$40,  0
    .byte   0,  2,$40,  8
.frame3:
    .byte 8
    .byte   0,  6,$40,  0
    .byte   0,  4,$40,  8

anim_stalactite subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    .byte  0,  0,$20,  0
    .byte  0,  0,$20,  8
    
anim_girder_middle subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    .byte   0,  2,  0,  0
    .byte   0,  2,  0,  8
    
anim_girder_left subroutine
    .byte 0
    .word frame_small1
    
anim_girder_right subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8
    .byte   0,  2,  0,  0
    .byte   0,  4,  0,  8

anim_flame subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte 8
    .byte   0,  0,$20,  0
    .byte   0,  2,$20,  8
.frame2:
    .byte 8
    .byte   0,  2,$60,  0
    .byte   0,  0,$60,  8

anim_pipe_right subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte 16
    .byte   0,  0,  0,  0
    .byte   0,  2,  0,  8
    .byte   0,  4,  0, 16
    .byte   0,  6,  0, 24

.frame2:
    .byte 12
    .byte   0,  0,  0,  0
    .byte   0,  2,  0,  8
    .byte   0,  6,  0, 16

anim_pipe_left subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte 16
    .byte   0,  2,$C0,  0
    .byte   0,  0,$C0,  8
    .byte   0,  4,$C0, -8
    .byte   0,  6,$C0,-16

.frame2:
    .byte 12
    .byte   0,  2,$C0,  0
    .byte   0,  0,$C0,  8
    .byte   0,  6,$C0, -8

anim_torch subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte 4
    .byte   0,  0,$40,  4
.frame2:
    .byte 4
    .byte   0,  0,  0,  4

anim_spike subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 4
    .byte   0,  0,$20,  4

anim_planet subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 8*OAM_SIZE
    .byte   0,  0,$20,  0   
    .byte  16,  2,$20,  0    
    .byte   0,  4,$20,  8
    .byte  16,  6,$20,  8
    .byte   0, 32,$20, 16
    .byte  16, 34,$20, 16
    .byte   0, 36,$20, 24
    .byte  16, 38,$20, 24
    
anim_player_walk subroutine
    .byte 7
    .word frame_small1
    .word frame_small2
    .word frame_small3
    .word frame_small2
    .word frame_small1
    .word .frame4
    .word .frame5
    .word .frame4
.frame4:
    .byte 2*OAM_SIZE
    .byte   0, 12,  0,  0
    .byte   0, 14,  0,  8
.frame5:
    .byte 2*OAM_SIZE
    .byte   0, 16,  0,  0
    .byte   0, 18,  0,  8
    
anim_player_walk_left subroutine
    .byte 7
    .word frame_small1_hflip
    .word frame_small2_hflip
    .word frame_small3_hflip
    .word frame_small2_hflip
    .word frame_small1_hflip
    .word .frame4
    .word .frame5
    .word .frame4
.frame4:
    .byte 2*OAM_SIZE
    .byte   0, 14,$40,  0
    .byte   0, 12,$40,  8
.frame5:
    .byte 2*OAM_SIZE
    .byte   0, 18,$40,  0
    .byte   0, 16,$40,  8

anim_player_jump subroutine
    .byte 0
    .word frame_small3
anim_player_jump_left subroutine
    .byte 0
    .word frame_small3_hflip
    
anim_player_walkv subroutine
    .byte 7
    .word frame_small1_vflip
    .word .frame2
    .word .frame3
    .word .frame2
    .word frame_small1_vflip
    .word .frame4
    .word .frame5
    .word .frame4
.frame2:
    .byte 2*OAM_SIZE
    .byte   0,  4,$80,  0
    .byte   0,  6,$80,  8
.frame3:
    .byte 2*OAM_SIZE
    .byte   0,  8,$80,  0
    .byte   0, 10,$80,  8
.frame4:
    .byte 2*OAM_SIZE
    .byte   0, 12,$80,  0
    .byte   0, 14,$80,  8
.frame5:
    .byte 2*OAM_SIZE
    .byte   0, 16,$80,  0
    .byte   0, 18,$80,  8
    
anim_player_walk_leftv subroutine
    .byte 7
    .word frame_small1_hvflip
    .word .frame2
    .word .frame3
    .word .frame2
    .word frame_small1_hvflip
    .word .frame4
    .word .frame5
    .word .frame4
.frame2:
    .byte 2*OAM_SIZE
    .byte   0,  6,$C0,  0
    .byte   0,  4,$C0,  8
.frame3:
    .byte 2*OAM_SIZE
    .byte   0, 10,$C0,  0
    .byte   0,  8,$C0,  8
.frame4:
    .byte 2*OAM_SIZE
    .byte   0, 14,$C0,  0
    .byte   0, 12,$C0,  8
.frame5:
    .byte 2*OAM_SIZE
    .byte   0, 18,$C0,  0
    .byte   0, 16,$C0,  8

anim_player_jumpv subroutine
    .byte 0
    .word .frame
.frame:
    .byte 2*OAM_SIZE
    .byte   0,  8,$80,  0
    .byte   0, 10,$80,  8
    
anim_player_jump_leftv subroutine
    .byte 0
    .word .frame
.frame:
    .byte 2*OAM_SIZE
    .byte   0, 10,$C0,  0
    .byte   0,  8,$C0,  8

anim_hammer subroutine
    .byte 0
    .word .frame
.frame:
    .byte 6*OAM_SIZE
    .byte -16,  0,  0, -4
    .byte -16,  2,  0,  4
    .byte -16,  0,$40, 12
    .byte   0,  4,  0, -4
    .byte   0,  6,  0,  4
    .byte   0,  4,$40, 12
    
anim_ball_right subroutine
    .byte 3
    .word frame_small1
    .word frame_small2
    .word frame_small1_hvflip
    .word .frame4
.frame4:
    .byte 2*OAM_SIZE
    .byte   0,  6,$C0,  0
    .byte   0,  4,$C0,  8
    
anim_ball_left subroutine
    .byte 3
    .word frame_small1_hflip
    .word frame_small2_hflip
    .word frame_small1_vflip
    .word .frame4
.frame4:
    .byte 2*OAM_SIZE
    .byte   0,  4,$80,  0
    .byte   0,  6,$80,  8
    
anim_ball_sleep subroutine
    .byte 0
    .word .frame
.frame:
    .byte 3*OAM_SIZE
    .byte   0,  8,  0,  0
    .byte   0,  8,$40,  8
    .byte -16, 10,  0,  4

anim_air_generator subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte 16
    .byte -16,  0,  0,  0
    .byte -16,  2,  0,  8
    .byte   0, 64,  0,  0
    .byte   0, 66,  0,  8
.frame2:
    .byte 16
    .byte -16,  2,$40,  0
    .byte -16,  0,$40,  8
    .byte   0, 64,  0,  0
    .byte   0, 66,  0,  8

anim_player_dead subroutine
    .byte 0
    .word frame_player_dead
frame_player_dead:
    .byte 2*OAM_SIZE
    .byte   0, 26,  0,  0
    .byte   0, 26,$40,  8

anim_player_die subroutine
    .byte 15
    .word .frame1
    .word .frame1
    .word .frame2
    .word .frame2
    .word .frame1
    .word .frame1
    .word .frame2
    .word .frame2
    .word .frame1
    .word .frame1
    .word .frame2
    .word .frame2
    .word .frame3
    .word .frame3
    .word frame_player_dead
    .word frame_player_dead
.frame1:
    .byte 2*OAM_SIZE
    .byte   0, 20,  0,  0
    .byte   0, 20,$40,  8
.frame2:
    .byte 2*OAM_SIZE
    .byte   0, 22,  0,  0
    .byte   0, 22,$40,  8
.frame3:
    .byte 2*OAM_SIZE
    .byte   0, 24,  0,  0
    .byte   0, 24,$40,  8

anim_symmetrical_none2 subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte OAM_SIZE*2
    .byte   0,  2,  0,  0
    .byte   0,  2,$40,  8

anim_laser subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte OAM_SIZE*2
    .byte   0,  0,  0,  0
    .byte   0,  0,  0,  8
.frame2:
    .byte OAM_SIZE*2
    .byte   0,  0,$C0,  0
    .byte   0,  0,$C0,  8
    
anim_robot_firing_right subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte OAM_SIZE*4
    .byte   0,  0,  0,  0
    .byte   0,  2,  0,  8
    .byte   0, 12,  3, 16
    .byte   0, 12,  3, 24
.frame2:
    .byte OAM_SIZE*4
    .byte   0,  0,  0,  0
    .byte   0,  2,  0,  8
    .byte   0, 12,$C3, 16
    .byte   0, 12,$C3, 24
    
anim_robot_firing_left subroutine
    .byte 1
    .word .frame1
    .word .frame2
.frame1:
    .byte OAM_SIZE*4
    .byte   0,  2,$40,  0
    .byte   0,  0,$40,  8
    .byte   0, 12,  3,-16
    .byte   0, 12,  3, -8
.frame2:
    .byte OAM_SIZE*4
    .byte   0,  2,$40,  0
    .byte   0,  0,$40,  8
    .byte   0, 12,$C3,-16
    .byte   0, 12,$C3, -8

anim_wide_none subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte OAM_SIZE*4
    .byte   0,  0,  0, -8
    .byte   0,  2,  0,  0
    .byte   0,  4,  0,  8
    .byte   0,  6,  0, 16
    
anim_worm_bite_right subroutine
    .byte 3
    .word frame_small1
    .word frame_small1
    .word .frame2
    .word .frame2
.frame2:
    .byte OAM_SIZE*2
    .byte   0,  0,  0,  0
    .byte   0,  4,  0,  8
    
anim_worm_bite_left subroutine
    .byte 3
    .word frame_small1_hflip
    .word frame_small1_hflip
    .word .frame2
    .word .frame2
.frame2:
    .byte OAM_SIZE*2
    .byte   0,  4,$40,  0
    .byte   0,  0,$40,  8
    