;------------------------------------------------------------------------------
; SYSTEM RAM
;------------------------------------------------------------------------------
    SEG.U RAM
    ORG $0000
main_tmp            ds 8 ;MIPS-style $t#

main_arg            ds 6 ;MIPS-style $a#

main_sav            ds 2 ;MIPS-style $s#
main_dst            ds 2
main_src            ds 2

main_ret            ds 2 ;MIPS-style $p#

nmi_tmp:
nmi_scratch         ds 1
nmi_len             ds 1
nmi_src             ds 2

nmi_scrollY         ds 2
nmi_scrollX         ds 1
shr_sleeping        ds 1
shr_doDma           ds 1
shr_doRegCopy       ds 1
shr_ppuMask         ds 1
shr_ppuCtrl         ds 1
shr_doPalCopy       ds 1
shr_palAddr         ds 2
shr_doTileCol       ds 1
shr_doAttrCol       ds 1
shr_tileCol         ds 1

    ORG $0100
shr_tileBuffer      ds TOP_HEIGHT+BOTTOM_HEIGHT           ;18+30 = 48 : 48
shr_attrBuffer      ds TOP_ATTR_HEIGHT+BOTTOM_ATTR_HEIGHT ; 5+ 8 = 13 : 61
shr_stack:

    ORG $0200
OAM_SIZE = 4
SY = 0
SI = 1
SF = 2
SX = 3
shr_oamShadow:
shr_spriteY         ds 1
shr_spriteIndex     ds 1
shr_spriteFlags     ds 1
shr_spriteX         ds 1
shr_blankSprite     ds 4
shr_playerSprites   ds 8
shr_entitySprites:

    ORG $0300
shr_cameraX         ds 2 ;2
shr_cameraY         ds 2 ;4
shr_debugReg        ds 2 ;6
shr_cameraYMod      ds 1 ;7
shr_nameTable       ds 1 ;8
main_ctrl        ds 1 ;9
main_oldCtrl        ds 1 ;9
main_pressed      ds 1 ;
main_switches       ds 1 ;
main_playerFlags    ds 1 ; ;jumping,flipped,in air,00000
main_playerFrame    ds 1 ;
main_playerXVel     ds 1 ;
main_playerYFrac    ds 1 ;
main_playerY        ds 2 ;
main_playerYVel     ds 2 ;
main_playerX        ds 2 ;

MAX_ENTITIES = 16
;main_entityFrame    ds MAX_ENTITIES
main_entityX        ds MAX_ENTITIES*2
main_entityY        ds MAX_ENTITIES*2
;main_entityType     ds MAX_ENTITIES

    ORG $0400
main_levelMap       ds 960
;64 bytes left
