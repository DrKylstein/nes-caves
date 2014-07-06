;------------------------------------------------------------------------------
; PRG ROM DATA
;------------------------------------------------------------------------------

prgdata_palettes:
;global
    dc.b $1D
    incbin pal.bin

	.align 256
prgdata_hud:
	incbin hud.bin
    .align 256
prgdata_metatiles:
    incbin metatiles.bin

    .align 256
prgdata_mainMap:
    incbin main_map.bin
