name		:= caves
emulator	:= nestopia

srcdir		:= ../src
gfxdir		:= ../gfx
lvldir		:= ../levels
bindir		:= ..

romname		:= $(bindir)/$(name).nes

palettes	:= $(addsuffix .pal,$(basename $(notdir $(wildcard ../gfx/palette-*.png))))
incbins		:= sprites.pat title-patterns.pat title-names.bin title-attr.bin metatiles.bin palette-title.pal
tilesets	:= $(addsuffix .pat,$(basename $(notdir $(wildcard ../gfx/tileset-*.png))))
levels	:= $(addsuffix .lvl,$(basename $(notdir $(wildcard ../levels/*.tmx))))
sources		:= $(wildcard ../src/*.*) 
asmflags	:= -I$(srcdir) -f3 -v0 -l$(name).lst -s$(name).sym

rom_depenencies		:= $(sources) $(incbins) $(palettes) $(tilesets) $(levels) Makefile

$(romname)		:	$(rom_depenencies)
					dasm $(name).asm $(asmflags) -o$(romname)

debug			: $(rom_depenencies)
					dasm $(name).asm $(asmflags) -o$(romname) -DDEBUG
					
heavydebug			: $(rom_depenencies)
					dasm $(name).asm $(asmflags) -o$(romname) -DDEBUG -DDEBUG_PC

sprites.pat		:	$(gfxdir)/sprites.png
					tilestrip 8 16 <$< | planarbitmap 2 --interleave 8 >$@

metatiles.bin	:	$(gfxdir)/metatiles.tmx
					python3 $(srcdir)/convertmetatiles.py $< -o $@

$(tilesets)		:	%.pat:	$(gfxdir)/%.png
					tilestrip 8 8 <$< | planarbitmap 2 --interleave 8 >$@
					
$(levels)		:	%.lvl:	$(lvldir)/%.tmx
					python3 $(srcdir)/convertlevels.py $< -o $@

palette-title.pal title-patterns.pat title-names.bin title-attr.bin		&:	$(gfxdir)/title-auto.png
					nesimage $< palette-title.pal title-patterns.pat title-names.bin title-attr.bin

$(palettes):	%.pal:	$(gfxdir)/%.png
	packedpixels <$< >$@

.PHONY			:	run
run				:	$(romname)
					$(emulator) $(romname)

.PHONY			:	clean
clean			:	
					rm -f $(romname) *.lst *.sym *.bin *.pal *.pat *.lvl