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
prgdata_levelTable
    .align 256
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
