;------------------------------------------------------------------------------
; QUEST
; NROM
; Output should be 41,104 bytes long
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
; PRG ROM
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
    incbin intro_scene.bin
endScene:
    incbin end_scene.bin
    ECHO "PRGROM Bank 0 left:",[$C000-.]d
    IF . > $C000
    ECHO "Exceeded PRGROM Bank 0 size!"
    ERR
    ENDIF
    
    ORG 16 + 1*$4000
    RORG $8000
level01:
    incbin level01.bin
level02:
    incbin level02.bin
level03:
    incbin level03.bin
level04:
    incbin level04.bin
level05:
    incbin level05.bin
level06:
    incbin level06.bin
level07:
    incbin level07.bin
level08:
    incbin level08.bin
level09:
    incbin level09.bin
level10:
    incbin level10.bin
level11:
    incbin level11.bin
level12:
    incbin level12.bin
level13:
level14:
    incbin level14.bin
level15:
level16:
    incbin level15.bin
mainMap:
    incbin main_map.bin

    ECHO "PRGROM Bank 1 left:",[$C000-.]d
    IF . > $C000
    ECHO "Exceeded PRGROM Bank 1 size!"
    ERR
    ENDIF
    
    ORG 16 + 2*$4000
    RORG $8000
    include patterns.asm
    ECHO "PRGROM Bank 2 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 2 size!"
    ERR
    ENDIF
    
    ORG 16 + 3*$4000
    RORG $8000
    include anims.asm
    include entities.asm
    include sounds.asm
    include messages.asm
    ECHO "PRGROM Bank 3 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 3 size!"
    ERR
    ENDIF
    
    ORG 16 + 4*$4000
    RORG $8000
    ECHO "PRGROM Bank 4 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 4 size!"
    ERR
    ENDIF
    
    ORG 16 + 5*$4000
    RORG $8000
    ECHO "PRGROM Bank 5 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 5 size!"
    ERR
    ENDIF
    
    ORG 16 + 6*$4000
    RORG $8000
    ECHO "PRGROM Bank 6 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 6 size!"
    ERR
    ENDIF
    
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