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

BG_PAL = 0
SPRITE_PAL = $10

PAL_OFFSET = 1060

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
ENT_F2_PAUSETURN = $10
ENT_F2_NOANIM = $08

PLR_F_BG = $10
PLR_F_KEY = $08

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



GRAVITY = 10
JUMP_VELOCITY = -420



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
