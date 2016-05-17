;------------------------------------------------------------------------------
; SYSTEM RAM
;------------------------------------------------------------------------------
    SEG.U RAM
    ORG $0000
tmp            ds 8 ;MIPS-style $t#

arg            ds 6 ;MIPS-style $a#

sav            ds 2 ;MIPS-style $s#
dst            ds 2
src            ds 2

ret            ds 2 ;MIPS-style $p#

nmi_tmp             ds 1
nmi_len             ds 1
nmi_src             ds 2
nmi_sfxPeriod       ds 2
nmi_scrollY         ds 1
nmi_nametable       ds 1
nmi_scrollX         ds 1
nmi_sfxPtr          ds 2

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
shr_doTile          ds 1
shr_tileAddr        ds 2
shr_tileMeta        ds 1
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
frame           ds 1
ctrl           ds 1
oldCtrl        ds 1
pressed        ds 1
switches       ds 1
playerFlags    ds 1 ;jumping,flipped,in air,behind,reverse gravity,000
playerFrame    ds 1
playerXVel     ds 1
playerYVel     ds 2
mercyTime      ds 1
bonusCount     ds 1
shr_ammo            ds 1
shr_powerTime       ds 2
shr_hp              ds 1
shr_score           ds 3
caterpillarNext ds 1
mapPX          ds 2
mapPY          ds 2
mapCamX        ds 2
mapCamY        ds 2
mapCamYMod     ds 1
currLevel      ds 1
cleared        ds 2
currPlatform   ds 1
paused         ds 1
startSprite    ds 2

entityBlock:
entityXLo        ds MAX_ENTITIES
entityXHi        ds MAX_ENTITIES
entityYLo        ds MAX_ENTITIES
entityYHi        ds MAX_ENTITIES ; bottom bit
entityBlockEnd:
entityXVel       ds MAX_ENTITIES ; 
entityAnim       ds MAX_ENTITIES
    ECHO $400-.," bytes left in page $300"

    ORG $0400
levelMap       ds 960
playerYFrac    ds 1 
playerY        ds 2 
playerX        ds 2 
shr_cameraX         ds 2 
shr_cameraY         ds 2 
shr_cameraYMod      ds 1 
shr_nameTable       ds 1 
crystalsLeft   ds 1
doorsLo        ds 3
doorsHi        ds 3
levelDataEnd:

    ECHO $800-.,"bytes left in pages $400-$700"

