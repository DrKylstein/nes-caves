PPU_CTRL_SETTING = %10110000
PPU_MASK_SETTING = %00011000

MT_MAP_WIDTH = 40
MT_MAP_HEIGHT = 24
MT_VIEWPORT_WIDTH = 15
MT_VIEWPORT_HEIGHT = 13
MT_NAMETABLE_WIDTH = 16
MT_NAMETABLE_HEIGHT = 15
MT_HSCROLL_MARGIN = 6
MT_VSCROLL_MARGIN = 5

PX_MT_WIDTH = 16
PX_MT_HEIGHT = 16

PX_VIEWPORT_OFFSET = [MT_NAMETABLE_HEIGHT - MT_VIEWPORT_HEIGHT]*PX_MT_HEIGHT

BONUS_TILES = 235
HIDDEN_TILE = $01

MAX_ENTITIES = 26
RESERVED_ENTITIES = 3

MAP_LEVEL = $10
INTRO_LEVEL = $11


PLAYER_HTOP = 1
PLAYER_HBOTTOM = 15
PLAYER_HLEFT = 3
PLAYER_HRIGHT = 13
PLAYER_HCENTER = 7

TEXT_MARGIN = 1

FADE_DELAY = 4

;sound
SQ1_CH = 0
SQ2_CH = 1
TRI_CH = 2
NOISE_CH = 3
DUTY_12 = %00110000
DUTY_25 = %01110000
DUTY_50 = %10110000
DUTY_75 = %11110000
TRI_END = $800


INVALID_MAP_STAT = $FF

ALL_CRYSTALS_EFFECT = $40

;nametable info
TOP_HEIGHT = 18
BOTTOM_HEIGHT = 30
TOP_OFFSET = $180
TOP_ATTR_HEIGHT = 5
BOTTOM_ATTR_HEIGHT = 8
TOP_ATTR_OFFSET = $23C0+[3*8]
BOTTOM_ATTR_OFFSET = $2BC0

;contents of entityYHi
ENT_Y_POS = $01
ENT_Y_INDEX = $FE
;contents of entityXHi
ENT_X_DEAD = %10000000
ENT_X_OFFSCREEN = %01000000
ENT_X_POS =  %00000011


;contents of prgdata_entityFlags
ENT_F_SKIPYTEST = $80
ENT_F_SKIPXTEST = $40
ENT_F_ISTEMPORARY = $20 ;deleted when off screen
ENT_F_ISPLATFORM = $10 ; player collides with top
ENT_F_CHILDREN  = $0C
ENT_F_CHILDREN_SHIFT = 2
ENT_F_COLOR = $03 ;for sprite rendering

PLY_ONCIELING =    %10000000
PLY_LOCKED =       %01000000
PLY_ISBEHIND =     %00100000
PLY_HASKEY =       %00010000
PLY_ONFLOOR =      %00001000
PLY_ISJUMPING =    %00000100
PLY_UPSIDEDOWN =   %00000010
PLY_ISFLIPPED =    %00000001

BULLET_ID = 32
POWERSHOT_ID = 5
CATERPILLAR_ID = 8
SLIME_ID = 12
HAMMER_ID = 14
SPIDERWEB_ID = 25
GIRDER_ID = 22

OAM_SIZE = 4
SPR_Y = 0
SPR_INDEX = 1
SPR_FLAGS = 2
SPR_X = 3

SWITCH_TURRETS = 4


GRAVITY = 13
JUMP_VELOCITY = -520
TERMINAL_VELOCITY = $0400
STALACTITE_GRAVITY = 15

MN____ = $FF
MC____ = $FF
MC_LOP = $FE
MC_SLP = $FE

    SEG.U POWERS
    ORG $0000
                ds 1
POWER_SHOT      ds 1
POWER_GRAVITY   ds 1
POWER_STRENGTH  ds 1
POWER_STOP      ds 1
    
    SEG.U BEHAVIORS
    ORG $0000
TB_EMPTY:      ds 1
TB_SOLID:      ds 1
TB_PLATFORM:   ds 1
TB_EXIT:       ds 1
TB_HAZARD:     ds 1
TB_DEATH:      ds 1
               ds 1
               ds 1
TB_WEAKBLOCK:  ds 1
TB_AMMO:       ds 1
TB_STRENGTH:   ds 1
TB_POWERSHOT:  ds 1
TB_GRAVITY:    ds 1
TB_KEY:        ds 1
TB_STOP:       ds 1
TB_CHEST:      ds 1
TB_POINTS:
TB_CRYSTAL:    ds 1
TB_EGG:        ds 1
TB_800:        ds 1
TB_1000:       ds 1
TB_5000:       ds 1
TB_BONUS:      ds 1
               ds 1
               ds 1
               ds 1
               ds 1
               ds 1
TB_LOCK:       ds 3
               ds 1
               ds 1
TB_AIR:        ds 1
TB_FOREGROUND  ds 1
TB_GIRDER_LEFT ds 1
TB_GIRDER_MIDDLE ds 1
TB_GIRDER_RIGHT ds 1
               ds 1
               ds 1
               ds 1
TB_MAPDOOR     ds 16
TB_OFF:        ds 4
TB_ON:         ds 4

    SEG.U NOTES
    ORG $0000
MN_A0_  ds 1
MN_A0S  ds 1
MN_B0_  ds 1
MN_C1_  ds 1
MN_C1S  ds 1
MN_D1_  ds 1
MN_D1S  ds 1
MN_E1_  ds 1
MN_F1_  ds 1
MN_F1S  ds 1
MN_G1_  ds 1
MN_G1S  ds 1
MN_A1_  ds 1
MN_A1S  ds 1
MN_B1_  ds 1
MN_C2_  ds 1
MN_C2S  ds 1
MN_D2_  ds 1
MN_D2S  ds 1
MN_E2_  ds 1
MN_F2_  ds 1
MN_F2S  ds 1
MN_G2_  ds 1
MN_G2S  ds 1
MN_A2_  ds 1
MN_A2S  ds 1
MN_B2_  ds 1
MN_C3_  ds 1
MN_C3S  ds 1
MN_D3_  ds 1
MN_D3S  ds 1
MN_E3_  ds 1
MN_F3_  ds 1
MN_F3S  ds 1
MN_G3_  ds 1
MN_G3S  ds 1
MN_A3_  ds 1
MN_A3S  ds 1
MN_B3_  ds 1
MN_C4_  ds 1
MN_C4S  ds 1
MN_D4_  ds 1
MN_D4S  ds 1
MN_E4_  ds 1
MN_F4_  ds 1
MN_F4S  ds 1
MN_G4_  ds 1
MN_G4S  ds 1
MN_A4_  ds 1
MN_A4S  ds 1
MN_B4_  ds 1
MN_C5_  ds 1
MN_C5S  ds 1
MN_D5_  ds 1
MN_D5S  ds 1
MN_E5_  ds 1
MN_F5_  ds 1
MN_F5S  ds 1
MN_G5_  ds 1
MN_G5S  ds 1
MN_A5_  ds 1
MN_A5S  ds 1
MN_B5_  ds 1
MN_C6_  ds 1
MN_C6S  ds 1
MN_D6_  ds 1
MN_D6S  ds 1
MN_E6_  ds 1
MN_F6_  ds 1
MN_F6S  ds 1
MN_G6_  ds 1
MN_G6S  ds 1
MN_A6_  ds 1
MN_A6S  ds 1
MN_B6_  ds 1
MN_C7_  ds 1
MN_C7S  ds 1
MN_D7_  ds 1
MN_D7S  ds 1
MN_E7_  ds 1
MN_F7_  ds 1
MN_F7S  ds 1
MN_G7_  ds 1
MN_G7S  ds 1
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
ANIM_KIWI                   ds 1