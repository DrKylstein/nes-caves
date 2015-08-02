;------------------------------------------------------------------------------
; PRG ROM DATA
;------------------------------------------------------------------------------

prgdata_palettes:
;global
    incbin pal.bin

	.align 256
prgdata_hud:
	incbin hud.bin
    .align 256
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
    
    .align 256
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
    
    .align 256
prgdata_mainMap:
    incbin main_map.bin
    .align 256
prgdata_level01:
    incbin level01.bin
    .align 256
prgdata_level02:
    incbin level02.bin
