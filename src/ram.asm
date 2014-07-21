;------------------------------------------------------------------------------
; SYSTEM RAM
;------------------------------------------------------------------------------
    SEG.U RAM
    ORG $0000
main_scratch:
main_tmp            ds 8 ;MIPS-style $t#

main_arg            ds 4 ;MIPS-style $a#

main_sav            ds 2 ;MIPS-style $s#
main_dst            ds 2
main_src            ds 2

main_ret            ds 2 ;MIPS-style $p#

nmi_scratch         ds 1
nmi_len             ds 1
nmi_src             ds 2
nmi_scrollY         ds 2
nmi_scrollX         ds 1
shr_sleeping        ds 1
shr_doDma           ds 1
shr_doVramCopy      ds 1
shr_doRegCopy       ds 1
shr_ppuMask         ds 1
shr_ppuCtrl         ds 1

    ORG $0400
shr_vramBuffer:
shr_vramBuffer_length  ds 1
shr_vramBuffer_flags   ds 1 ;1xxxxxxx = load from ram, xxxxxnxx = PPUCTRL inc
shr_vramBuffer_ppuHigh ds 1
shr_vramBuffer_ppuLow  ds 1
shr_vramBuffer_romAddr:
shr_vramBuffer_data ds 160

    ORG $0200
shr_oamShadow:
shr_spriteY         ds 1
shr_spriteIndex     ds 1
shr_spriteFlags     ds 1
shr_spriteX         ds 1
                    ds 252
    ORG $0300
main_scratchBuffer  ds 64
main_playerY        ds 2
main_playerX        ds 2
shr_cameraX         ds 2
shr_cameraY         ds 2
shr_cameraYMod      ds 1
shr_nameTable       ds 1
main_camMetaTileX   ds 2
main_playerMoved    ds 1
main_playerFrame    ds 1
shr_debugReg        ds 2
