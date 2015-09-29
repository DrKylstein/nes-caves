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

HEXFONT_BASE = $D9

BONUS_TILES = 235

BG_PAL = 0
SPRITE_PAL = $10

MAX_ENTITIES = 24

MAP_LEVEL = $FF

;nametable info
TOP_HEIGHT = 18
BOTTOM_HEIGHT = 30
TOP_OFFSET = $180
TOP_ATTR_HEIGHT = 5
BOTTOM_ATTR_HEIGHT = 8
TOP_ATTR_OFFSET = $23C0+[3*8]
BOTTOM_ATTR_OFFSET = $2BC0

;contents of main_entityYHi
ENT_Y_POS = $01
ENT_Y_INDEX = $FE

;contents of main_entityXHi
ENT_X_POS = $03
ENT_X_HP = %00001100
ENT_X_COUNT = $F0

;contents of prgdata_entityFlags
ENT_F_ISPROJECTILE = $80
ENT_F_ISPLATFORM = $40
ENT_F_ISVERTICAL = $20
ENT_F_ISFACING = $10
ENT_F_ISDEADLY = $08
ENT_F_COLOR = $06
ENT_F_ISMORTAL = $01
ENT_F2_ISGROUNDED = $80
ENT_F2_NEEDPOWERSHOT = $40
ENT_F2_SHORTANIM = $20
ENT_F2_ISXFLIPPED = $10
ENT_F2_NOANIM = $08
ENT_F2_ISHITTABLE = $04
ENT_F2_SWITCHID = $03

PLY_ISJUMPING =    %10000000
PLY_ISFLIPPED =    %01000000
PLY_ISBEHIND =     %00100000
PLY_HASKEY =       %00010000
PLY_ISUPSIDEDOWN = %00001000
PLY_ONFLOOR =      %00000100
PLY_ONCIELING =    %00000010


POWERSHOT_ID = 5
ROCK_ID = 6
CATERPILLAR_ID = 8
SLIME_ID = 12
HAMMER_ID = 14

;ENT2_SHOOTSDOWN
;ENT2_SHOOTSRIGHT
;ENT2_SHOOTSLEFT
;ENT2_THINKS
;laser
;egg
;web
;eyeball
;ball
;biped bullet
;stalactite
;water
;1-6 normal shots
;power shot
;switch to lookup? 5 bits table index, 2 bits hp?

OAM_SIZE = 4
SPR_Y = 0
SPR_INDEX = 1
SPR_FLAGS = 2
SPR_X = 3



GRAVITY = 10
JUMP_VELOCITY = -420


    SEG.U SOUNDS
    ORG $0000
SFX_NULL:       ds 2
SFX_JUMP:       ds 2
SFX_CRYSTAL:    ds 2
SFX_ROCKET:     ds 2
    
    SEG.U BEHAVIORS
    ORG $0000
TB_EMPTY:      ds 1
TB_SOLID:      ds 1
TB_PLATFORM:   ds 1
TB_EXIT:       ds 1
TB_HAZARD:     ds 1
TB_DEATH:      ds 1
TB_LIGHTSON:   ds 1
TB_LIGHTSOFF:  ds 1
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
TB_DOOR:       ds 3
TB_LOCK:       ds 3
               ds 1
               ds 1
TB_AIR:        ds 1
TB_FOREGROUND  ds 1
TB_BACKGROUND  ds 1
               ds 1
               ds 1
               ds 1
               ds 1
               ds 1
TB_MAPDOOR     ds 16
TB_OFF:        ds 4
TB_ON:         ds 4
