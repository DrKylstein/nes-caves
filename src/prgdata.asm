;------------------------------------------------------------------------------
; PRG ROM DATA
;------------------------------------------------------------------------------

prgdata_entityFlags:
    .byte $80 ; bullet
    .byte $62 ; vertical platform
    .byte $42 ; horizontal platform
    .byte $3E ; spider
    .byte $0A ; bat
    
prgdata_entityTiles:
    .byte 64 ; bullet
    .byte 80 ; vertical platform
    .byte 96 ; horizontal platform
    .byte 112 ;spider
    .byte 128 ;bat
    
prgdata_points:
    .byte 00,00,00,05;0
    .byte 00,00,01,00;0
    .byte 00,00,00,80;0
    .byte 00,00,01,00;0
    .byte 00,00,05,00;0
    .byte 00,00,00,10;0

prgdata_palettes:
;global
    incbin palsp.pal

prgdata_hud:
	incbin hud.bin
prgdata_metatiles:
    incbin metatiles.bin

prgdata_jumpSound:
    .byte 255
    .byte 250
    .byte 245
    .byte 240
    .byte 235
    .byte 230
    .byte 225
    .byte 220
    .byte 215
    .byte 210
    .byte 205
    .byte 200
    .byte 195
    .byte 190
    .byte 185
    .byte 180
    .byte 175
    .byte 170
    .byte 165
    .byte 160
    .byte 155
    .byte 150
    .byte 145
    .byte 140
    .byte 135
    .byte 130
    .byte 125
    .byte 120
prgdata_nullSound:
    .byte 0
    
prgdata_crystalSound:
    .byte 100
    .byte 110
    .byte 120
    .byte 130
    .byte 140
    .byte 150
    .byte 100
    .byte 110
    .byte 120
    .byte 130
    .byte 140
    .byte 150
    .byte 155
    
    .byte 0
    
prgdata_levelTable
    dc.w  prgdata_level01
    dc.w  prgdata_level02
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    
prgdata_mainMap:
    incbin main_map.bin
    incbin pal00.pal
prgdata_level01:
    incbin level01.bin
    incbin pal01.pal
prgdata_level02:
    incbin level02.bin
    incbin pal02.pal
