;------------------------------------------------------------------------------
; Crystal Caves
; UNROM
;------------------------------------------------------------------------------
    processor 6502
    include registers.asm
    include macros.asm
    include constants.asm
    include ram.asm

    SEG ROM_FILE
    ORG $0000,$FF
    include header.asm
;------------------------------------------------------------------------------
; PRG ROM Bank 0
;------------------------------------------------------------------------------
    ORG 16 + 0*$4000
    RORG $8000
    include titledata.asm
textTiles:
    incbin tileset-font.pat
globalTiles:
    incbin sprites.pat
globalBgTiles:
    incbin tileset-shared.pat
cloudsTiles:
    incbin tileset-clouds.pat
    include palettes.asm
introScene:
    incbin intro_scene.lvl
mainMap:
    incbin main_map.lvl
    ECHO "PRGROM Bank 0 left:",[$C000-.]d
    IF . > $C000
    ECHO "Exceeded PRGROM Bank 0 size!"
    ERR
    ENDIF
;------------------------------------------------------------------------------
; PRG ROM Bank 1
;------------------------------------------------------------------------------
    ORG 16 + 1*$4000
    RORG $8000
level01:
    incbin level01.lvl
level02:
    incbin level02.lvl
level03:
    incbin level03.lvl
level04:
    incbin level04.lvl
level05:
    incbin level05.lvl
level06:
    incbin level06.lvl
level07:
    incbin level07.lvl
level08:
    incbin level08.lvl
level09:
    incbin level09.lvl
level10:
    incbin level10.lvl
level11:
    incbin level11.lvl
level12:
    incbin level12.lvl
level13:
    incbin level13.lvl
level14:
    incbin level14.lvl
level15:
    incbin level15.lvl
level16:
    incbin level16.lvl

    ECHO "PRGROM Bank 1 left:",[$C000-.]d
    IF . > $C000
    ECHO "Exceeded PRGROM Bank 1 size!"
    ERR
    ENDIF
;------------------------------------------------------------------------------
; PRG ROM Bank 2
;------------------------------------------------------------------------------
    ORG 16 + 2*$4000
    RORG $8000
    include patterns.asm
endScene:
    incbin end_scene.lvl
farmScene:
    incbin farm_scene.lvl
    ECHO "PRGROM Bank 2 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 2 size!"
    ERR
    ENDIF
;------------------------------------------------------------------------------
; PRG ROM Bank 3
;------------------------------------------------------------------------------
    ORG 16 + 3*$4000
    RORG $8000
ANIMS_BANK = 3
    include anims.asm
ENTITIES_BANK = 3
    include entities.asm
SOUNDS_BANK = 3
    include sounds.asm

    ECHO "PRGROM Bank 3 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 3 size!"
    ERR
    ENDIF
;------------------------------------------------------------------------------
; PRG ROM Bank 4
;------------------------------------------------------------------------------
    ORG 16 + 4*$4000
    RORG $8000
    
TEXT_BANK = 4
    include messages.asm

    ECHO "PRGROM Bank 4 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 4 size!"
    ERR
    ENDIF
;------------------------------------------------------------------------------
; PRG ROM Bank 5
;------------------------------------------------------------------------------
    ORG 16 + 5*$4000
    RORG $8000
    ECHO "PRGROM Bank 5 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 5 size!"
    ERR
    ENDIF
;------------------------------------------------------------------------------
; PRG ROM Bank 6
;------------------------------------------------------------------------------
    ORG 16 + 6*$4000
    RORG $8000
    ECHO "PRGROM Bank 6 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 6 size!"
    ERR
    ENDIF
;------------------------------------------------------------------------------
; PRG ROM Bank 7 (fixed bank)
;------------------------------------------------------------------------------
    ORG 16 + 7*$4000
    RORG $C000
    include main.asm
    include nmi.asm
    include debug.asm
    include tables.asm
banktable:
    .byte $00, $01, $02, $03, $04, $05, $06
    
    ECHO "PRGROM Bank 7 left:",[$10000-.-6]d
    IF . > $10000-6
    ECHO "Exceeded PRGROM Bank 7 size!"
    ERR
    ENDIF
;interrupt vectors
    ORG 16 + 8*$4000 - 6
    .word nmi
    .word reset
    .word irq
;------------------------------------------------------------------------------
; CHR ROM
;------------------------------------------------------------------------------
    ;ORG 16+32768
    ;incbin chrrom.bin