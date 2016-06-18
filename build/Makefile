name		:= caves
emulator	:= nestopia

srcdir		:= ../src
gfxdir		:= ../gfx
bindir		:= ..

romname		:= $(bindir)/$(name).nes

palettes	:= $(addsuffix .pal,$(basename $(notdir $(wildcard ../gfx/pal??.png))))
incbins		:= sprites.pat tiles.pat title-patterns.pat title-names.bin
tilesets	:= $(addsuffix .pat,$(basename $(notdir $(wildcard ../gfx/tileset??.png))))
sources		:= $(wildcard ../src/*.*) 
asmflags	:= -I$(srcdir) -f3 -v0 -l$(name).lst -s$(name).sym


$(romname)		:	$(sources) $(incbins) $(palettes) $(tilesets) Makefile
					dasm $(name).asm $(asmflags) -o$(romname) -l$(name).lst

sprites.pat		:	$(gfxdir)/sprites.png
					tilestrip 8 16 <$< | planarbitmap 2 --interleave 8 >$@
tiles.pat		:	$(gfxdir)/tiles.png
					tilestrip 8 8 <$< | planarbitmap 2 --interleave 8 >$@

$(tilesets)		:	%.pat:	$(gfxdir)/%.png
					tilestrip 8 8 <$< | planarbitmap 2 --interleave 8 >$@

title-patterns.pat		:	$(gfxdir)/title-gs.png
					tilestrip 8 8 <$< | deduplicate --names title-names.txt | planarbitmap 2 --interleave 8 >$@
					
title-names.bin			: title-patterns.pat
					xxd -r -p title-names.txt title-names.bin

$(palettes):	%.pal:	$(gfxdir)/%.png
	packedpixels <$< >$@


.PHONY			:	run
run				:	$(romname)
					$(emulator) $(romname)

.PHONY			:	clean
clean			:	
					rm -f $(romname) *.lst *.sym *.bin *.pal *.pat title-names.txt