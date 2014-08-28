;------------------------------------------------------------------------------
; SYSTEM RAM
;------------------------------------------------------------------------------
    SEG.U RAM
    ORG $0000
main_tmp            ds 8 ;MIPS-style $t#

main_arg            ds 4 ;MIPS-style $a#

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
shr_stack           ds 256

    ORG $0200
shr_oamShadow:
shr_spriteY         ds 1
shr_spriteIndex     ds 1
shr_spriteFlags     ds 1
shr_spriteX         ds 1

    ORG $0300
main_playerXVel     ds 1 ;1
main_playerYFrac    ds 1 ;2
main_playerY        ds 2 ;4
main_playerYVel     ds 2 ;6
main_playerX        ds 2 ;8
shr_cameraX         ds 2 ;10
shr_cameraY         ds 2 ;12
shr_debugReg        ds 2 ;14
shr_cameraYMod      ds 1 ;15
shr_nameTable       ds 1 ;16
main_playerFlags    ds 1 ;17
main_playerFrame    ds 1 ;18
shr_tileBuffer      ds TOP_HEIGHT+BOTTOM_HEIGHT           ;18+30 = 48 : 66
shr_attrBuffer      ds TOP_ATTR_HEIGHT+BOTTOM_ATTR_HEIGHT ; 5+ 8 = 13 : 79

    ORG $0400
main_levelMap       ds 960
;64 bytes left
main_objectID       ds 12
main_objectX        ds 24 ;36
main_objectY        ds 24 ;60
