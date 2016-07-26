    include main.asm
    include nmi.asm
    include debug.asm
    
    include sounds.asm
;------------------------------------------------------------------------------
; Misc Data
;------------------------------------------------------------------------------

bits:
    .byte 0
    .byte 1
    .byte 2
    .byte 4
    .byte 8
    .byte 16
    .byte 32
    .byte 64
    .byte 128

points:
    .byte  0, 0, 0, 5;0
    .byte  0, 0, 1, 0;0
    .byte  0, 0, 0,80;0
    .byte  0, 0, 1, 0;0
    .byte  0, 0, 5, 0;0
    .byte  0, 0, 0,10;0
    .byte  0, 0,10, 0;0

metatiles:
    incbin metatiles.bin    
    
levelBanks:
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1
    .byte 1

levelPointers:
    .word level01
    .word level02
    .word level03
    .word level04
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word level01
    .word mainMap
    .word introScene

levelTilesets:
    .word caveTiles
    .word techTiles
    .word mineTiles
    .word techTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word caveTiles
    .word mineTiles
    .word introTiles

levelPalettes:
    .word volcanoPal
    .word cobaltPal
    .word minePal
    .word cobaltPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word volcanoPal
    .word minePal
    .word minePal