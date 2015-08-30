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

nmi_scrollY         ds 1
nmi_nametable       ds 1
nmi_scrollX         ds 1
nmi_sfxPtr         ds 2
shr_sfxPtr         ds 2
shr_doSfx           ds 1
shr_sleeping        ds 1
shr_doDma           ds 1
shr_doRegCopy       ds 1
shr_ppuMask         ds 1
shr_ppuCtrl         ds 1
shr_doPalCopy       ds 1
shr_palAddr         ds 2
shr_palDest         ds 1
shr_doTileCol       ds 1
shr_doAttrCol       ds 1
shr_tileCol         ds 1
shr_earlyExit       ds 1
shr_flashBg         ds 1
    ECHO $100-.," bytes left in page $000"

    ORG $0100
shr_tileBuffer      ds TOP_HEIGHT+BOTTOM_HEIGHT           ;18+30 = 48 : 48
shr_attrBuffer      ds TOP_ATTR_HEIGHT+BOTTOM_ATTR_HEIGHT ; 5+ 8 = 13 : 61
shr_stack:
    ECHO $200-.," bytes left in page $100"
    
    ORG $0200
shr_oamShadow:
shr_spriteY         ds 1
shr_spriteIndex     ds 1
shr_spriteFlags     ds 1
shr_spriteX         ds 1
shr_hudCurtain      ds OAM_SIZE*7
shr_playerSprites   ds OAM_SIZE*2
shr_entitySprites:

    ORG $0300
shr_debugReg        ds 2
nmi_frame           ds 1
main_frame           ds 1
main_ctrl           ds 1
main_oldCtrl        ds 1
main_pressed        ds 1
main_switches       ds 1
main_playerFlags    ds 1 ;jumping,flipped,in air,behind,0000
main_playerFrame    ds 1
main_playerXVel     ds 1
main_playerYVel     ds 2
main_mercyTime      ds 1
shr_ammo            ds 1
shr_powerTime       ds 2
shr_hp              ds 1
shr_score           ds 3
main_caterpillarNext ds 1
main_mapPX          ds 2
main_mapPY          ds 2
main_mapCamX        ds 2
main_mapCamY        ds 2
main_mapCamYMod     ds 1
main_currLevel      ds 1
main_cleared        ds 2
main_currPlatform   ds 1
main_paused         ds 1

main_entityBlock:
main_entityXLo        ds MAX_ENTITIES
main_entityXHi        ds MAX_ENTITIES
main_entityYLo        ds MAX_ENTITIES
main_entityYHi        ds MAX_ENTITIES ; bottom bit
main_entityBlockEnd:
main_entityXVel       ds MAX_ENTITIES ; 
    ECHO $400-.," bytes left in page $300"

    ORG $0400
main_levelMap       ds 960
main_playerYFrac    ds 1 
main_playerY        ds 2 
main_playerX        ds 2 
shr_cameraX         ds 2 
shr_cameraY         ds 2 
shr_cameraYMod      ds 1 
shr_nameTable       ds 1 
main_crystalsLeft   ds 1
main_doorsLo        ds 3
main_doorsHi        ds 3
main_levelDataEnd:

    ECHO $800-.,"bytes left in pages $400-$700"

