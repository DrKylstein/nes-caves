;------------------------------------------------------------------------------
; SYSTEM RAM
;------------------------------------------------------------------------------
    SEG.U RAM
    ORG $0000
tmp            ds 8 ;MIPS-style $t#
arg            ds 6 ;MIPS-style $a#
sav            ds 6 ;MIPS-style $s#
ret            ds 4 ;MIPS-style $p#

nmi_tmp             ds 4
nmi_splitBits       ds 1
nmi_scrollY         ds 1
nmi_nametable       ds 1
nmi_scrollX         ds 1
nmi_sp              ds 1

shr_sleeping        ds 1
shr_doDma           ds 1
shr_doRegCopy       ds 1
shr_doTileCol       ds 1
shr_doAttrCol       ds 1
shr_tileCol         ds 1
shr_earlyExit       ds 1
shr_flashBg         ds 1
shr_copyIndex       ds 1

shr_sfxPtr ds 2
nmi_sfxBase:
nmi_sq1Patch     ds 2
nmi_sq1Freq      ds 2
nmi_sq2Patch     ds 2
nmi_sq2Freq      ds 2
nmi_triPatch     ds 2
nmi_triFreq      ds 2
nmi_noisePatch   ds 2
nmi_noiseFreq    ds 2

    ECHO $100-.," bytes left in page $000"

    ORG $0100
BUFFER_SEG:
shr_tileBuffer      ds TOP_HEIGHT+BOTTOM_HEIGHT           ;18+30 = 48 : 48
shr_attrBuffer      ds TOP_ATTR_HEIGHT+BOTTOM_ATTR_HEIGHT ; 5+ 8 = 13 : 61
shr_copyBuffer: ;163 bytes
    ORG $1E0
shr_copyBufferEnd:
shr_stack: ;32 bytes
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
shr_debugReg   ds 2
shr_cameraX    ds 2 
shr_cameraY    ds 2 
shr_cameraYMod ds 1 
shr_nameTable  ds 1 
nmi_frame      ds 1
frame          ds 1
ctrl           ds 1
oldCtrl        ds 1
pressed        ds 1
switches       ds 1
playerFlags    ds 1
playerFrame    ds 1
playerXVel     ds 1
playerYVel     ds 2
mercyTime      ds 1
bonusCount     ds 1
ammo           ds 1
powerType      ds 1
powerFrames    ds 1
powerSeconds   ds 1
hp             ds 1
score          ds 3
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
crystalsLeft   ds 1
playerYFrac    ds 1 
playerY        ds 2 
playerX        ds 2 
doorsX        ds 3
doorsY        ds 3


entityBlock:
entityXLo        ds MAX_ENTITIES
entityXHi        ds MAX_ENTITIES
entityYLo        ds MAX_ENTITIES
entityYHi        ds MAX_ENTITIES ; bottom bit
entityBlockEnd:
entityVelocity   ds MAX_ENTITIES ; 
entityAnim       ds MAX_ENTITIES
entityCount      ds MAX_ENTITIES
    ECHO $400-.," bytes left in page $300"

    ORG $0400
levelMap       ds 960
    ECHO $800-.,"bytes left in pages $400-$700"

