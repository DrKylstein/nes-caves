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

HUD_BLANK = $18
HUD_GUN = $13
HUD_DOLLAR = $14
HUD_HEART = $1A

BONUS_TILES = 235
HIDDEN_TILE = 1
CLEARED_DOOR_TILE = 128
FALLEN_SIGN_TILE = 129

MAX_ENTITIES = 34
RESERVED_ENTITIES = 4
BULLET_INDEX = 0
GIRDER_INDEX = 1
PLAYER_INDEX = 2
FRUIT_INDEX = 3

FRUIT_IN_TIME = 20*60
FRUIT_OUT_TIME = 10*60

MAP_LEVEL = $10
INTRO_LEVEL = $11
END_LEVEL = $12
TITLE_LEVEL = $13


PLAYER_HTOP = 4
PLAYER_HBOTTOM = 12
PLAYER_HLEFT = 3
PLAYER_HRIGHT = 13
PLAYER_HCENTER = 7

TEXT_MARGIN = 1

FADE_DELAY = 4

MESSAGE_TIME = 60*3

RECOIL13 = 6
RECOIL14 = 3


;sound
SQ1_CH = 0
SQ2_CH = 1
TRI_CH = 2
NOISE_CH = 3
DUTY_12 = %00110000
DUTY_25 = %01110000
DUTY_50 = %10110000
DUTY_75 = %11110000
TRI_ON = $C0
TRI_OFF = $80
NOISE_VOL = $30
NOISE_LOOP = $80


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
ENT_X_DEAD =      %10000000
ENT_X_OFFSCREEN = %01000000
ENT_X_PRIORITY =  %00100000
ENT_X_FLASH =     %00010000
ENT_X_POS =       %00000011


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
PLY_RESERVED =     %00100000
PLY_HASKEY =       %00010000
PLY_ONFLOOR =      %00001000
PLY_ISJUMPING =    %00000100
PLY_UPSIDEDOWN =   %00000010
PLY_ISFLIPPED =    %00000001

OAM_SIZE = 4
SPR_Y = 0
SPR_INDEX = 1
SPR_FLAGS = 2
SPR_X = 3

SWITCH_TURRETS = 4


GRAVITY = 13
JUMP_VELOCITY = -520
TERMINAL_VELOCITY = $0300
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
TB_FOREGROUND: ds 1
TB_FGPLATFORM: ds 1
TB_DEATH:      ds 1
TB_HIDDEN:     ds 1
TB_EXIT:       ds 1
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
TB_HAZARD:     ds 1
               ds 1
TB_GIRDER_LEFT ds 1
TB_GIRDER_MIDDLE ds 1
TB_GIRDER_RIGHT ds 1
TB_LOCK:       ds 3
               ds 1
               ds 1
TB_OFF:        ds 4
TB_ON:         ds 4
TB_MAPDOOR     ds 16
