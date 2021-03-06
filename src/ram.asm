;------------------------------------------------------------------------------
; SYSTEM RAM
;------------------------------------------------------------------------------
    SEG.U RAM
    ORG $0000
tmp            ds 8 ;MIPS-style $t#
arg            ds 6 ;MIPS-style $a#
ret            ds 4 ;MIPS-style $p#
sav            ds 8 ;MIPS-style $s#

nmi_tmp             ds 4
nmi_splitBits       ds 1
nmi_scrollY         ds 1
nmi_nametable       ds 1
nmi_scrollX         ds 1
nmi_sp              ds 1

shr_sleeping        ds 1
shr_doTileCol       ds 1
shr_doAttrCol       ds 1
shr_tileCol         ds 1
shr_earlyExit       ds 1
shr_copyIndex       ds 1

sfxPriority ds 1 ;4x3 bytes unused
            ds 15
            
sfxPatch    ds 2
sfxHi       ds 1
sfxNote     ds 1
            ds 12 ;repeats
         
musicSequence ds 8
musicSequenceIndex ds 8 ;only even bytes used
musicPatternPtr ds 8
instrument ds 8

messagePtr     ds 2

currBank    ds 1

entityXLo        ds MAX_ENTITIES
entityXHi        ds MAX_ENTITIES ;active bit/off screen bit/unused 4 bits/hi x 2 bits
entityYLo        ds MAX_ENTITIES
entityYHi        ds MAX_ENTITIES ;index/hi y bit

    ECHO [$100-.]d," bytes left in page $000"

    ORG $0100
BUFFER_SEG:
shr_tileBuffer      ds TOP_HEIGHT+BOTTOM_HEIGHT           ;18+30 = 48 : 48
shr_attrBuffer      ds TOP_ATTR_HEIGHT+BOTTOM_ATTR_HEIGHT ; 5+ 8 = 13 : 61
shr_copyBuffer: ;163 bytes
    ECHO [$1E0-.]d," bytes left for copy buffer"
    ORG $1E0
shr_copyBufferEnd:
shr_stack: ;32 bytes
    ECHO [$200-.]d," bytes left for stack"
    
    ORG $0200
shr_oamShadow:
shr_spriteY         ds 1
shr_spriteIndex     ds 1
shr_spriteFlags     ds 1
shr_spriteX         ds 1
shr_hudCurtain      ds OAM_SIZE*7
shr_playerSprites   ds OAM_SIZE*2
girderSprite        ds OAM_SIZE*2
    ECHO [[$280-.]/OAM_SIZE]d," sprites left in upper table"
    ORG $0280
shr_entitySprites:

    ORG $0300
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
playerYFrac    ds 1 
playerY        ds 2 
playerX        ds 2 
playerXVel     ds 1
playerYVel     ds 2
mercyTime      ds 1
bonusCount     ds 1
powerType      ds 1
powerFrames    ds 1
powerSeconds   ds 1
score          ds 3
ammo           ds 1
hp             ds 1
mapPX          ds 2
mapPY          ds 2
;save these
savedStats: ;6
mapScore       ds 3 ;999995 = 18 bits
mapAmmo        ds 1 ;99 = 7 bits
cleared        ds 2 ;16 bits
                    ;41 bits

currLevel      ds 1
startSprite    ds 2
crystalsLeft   ds 1

doorsX         ds 4
doorsY         ds 4

exitTriggered  ds 1
random         ds 2
fruitTime      ds 2
messageTime    ds 1
messageCursor  ds 1
tempo ds 1
beatTimer ds 1
shr_debugReg   ds 2
levelMap       ds 960

entityVelocity   ds MAX_ENTITIES 
entityCount      ds MAX_ENTITIES
entityAnim       ds MAX_ENTITIES
entityFrame      ds MAX_ENTITIES

password        ds 12
    ECHO [$800-.]d,"bytes left in pages $300-$700"

