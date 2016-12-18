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
    .byte 0
    .byte 0
    .byte 2
    .byte -1
    .byte 2

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
    .word -1
    .word farmScene

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
    .word ghzTiles ;13
    .word caveTiles ;14
    .word alphaTiles ;15
    .word worksTiles ;16
    .word mineTiles ;map
    .word introTiles;intro
    .word introTiles;end
    .word -1
    .word ghzTiles;farm

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
    .word l13Pal ;13
    .word l14Pal ;14
    .word l15Pal ;15
    .word l16Pal ;16
    .word mapPal     ;map
    .word introPal   ;intro
    .word introPal   ;end
    .word -1
    .word l13Pal ;farm
levelMusic:
    .word song_party ;1
    .word song_industrial ;2
    .word song_party ;3
    .word song_industrial ;4
    .word song_party ;5 
    .word song_industrial ;6
    .word song_party ;7
    .word song_industrial ;8
    .word song_industrial ;9
    .word song_party ;10
    .word song_industrial ;11
    .word song_industrial ;12
    .word song_party ;13
    .word song_party ;14
    .word song_industrial ;15
    .word song_industrial ;16
    .word song_mine ;map
    .word song_null ;intro
    .word song_null ;end
    .word song_null;song_party ;title
    .word song_null ;farm scene
