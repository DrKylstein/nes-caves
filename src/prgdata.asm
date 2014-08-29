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

    .align 256
prgdata_mainMap:
    incbin main_map.bin
    
    .align 256
prgdata_level01:
    incbin level01.bin
