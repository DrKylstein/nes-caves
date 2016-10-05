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
    .byte 0
    .byte 0

levelPointers:
    .word level01
    .word level02
    .word level03
    .word level04
    .word level05
    .word level06
    .word level07
    .word level08
    .word level09
    .word level10
    .word level11
    .word level12
    .word level13
    .word level14
    .word level15
    .word level16
    .word mainMap
    .word introScene
    .word endScene

levelTilesets:
    .word caveTiles ;1
    .word techTiles ;2
    .word mineTiles ;3
    .word techTiles ;4
    .word caveTiles ;5
    .word worksTiles;6
    .word caveTiles ;7
    .word techTiles ;8
    .word worksTiles;9
    .word mineTiles ;10
    .word techTiles ;11
    .word techTiles ;12
    .word caveTiles ;13
    .word caveTiles ;14
    .word alphaTiles ;15
    .word worksTiles ;16
    .word mineTiles ;map
    .word introTiles;intro
    .word introTiles;end

levelPalettes:
    .word volcanoPal ;1
    .word cobaltPal  ;2
    .word minePal    ;3
    .word l04Pal  ;4
    .word l05Pal  ;5
    .word l06Pal    ;6
    .word l07Pal ;7
    .word l08Pal  ;8
    .word l09Pal ;9
    .word l10Pal ;10
    .word l11Pal ;11
    .word l12Pal ;12
    .word l14Pal ;13
    .word l14Pal ;14
    .word l15Pal ;15
    .word volcanoPal ;16
    .word mapPal     ;map
    .word introPal   ;intro
    .word introPal   ;end
    
levelMusic:
    .word nullSong ;1
    .word nullSong ;2
    .word nullSong ;3
    .word nullSong ;4
    .word nullSong ;5 
    .word nullSong ;6
    .word nullSong ;7
    .word nullSong ;8
    .word nullSong ;9
    .word nullSong ;10
    .word nullSong ;11
    .word nullSong ;12
    .word nullSong ;13
    .word nullSong ;14
    .word nullSong ;15
    .word nullSong ;16
    .word mineSong ;map
    .word nullSong ;intro
    .word nullSong ;end
