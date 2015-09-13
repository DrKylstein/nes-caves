name		:= caves
emulator	:= nestopia

srcdir		:= ../src
gfxdir		:= ../gfx
bindir		:= ..

romname		:= $(bindir)/$(name).nes

palettes	:= $(addsuffix .pal,$(basename $(notdir $(wildcard ../gfx/pal??.png))))
incbins		:= chrrom.bin title-patterns.bin title-names.bin
sources		:= $(wildcard ../src/*.*) 
asmflags	:= -I$(srcdir) -f3 -v0 -l$(name).lst -s$(name).sym


$(romname)		:	$(sources) $(incbins) $(palettes)
					dasm $(name).asm $(asmflags) -o$(romname) -l$(name).lst

chrrom.bin		:	$(gfxdir)/sprites.png $(gfxdir)/tiles.png
					tilestrip 8 16 <$(gfxdir)/sprites.png | planarbitmap 2 --interleave 8 >chrrom.bin
					tilestrip 8 8 <$(gfxdir)/tiles.png | planarbitmap 2 --interleave 8 >>chrrom.bin

title-patterns.bin		:	$(gfxdir)/title-gs.png
					tilestrip 8 8 <$(gfxdir)/title-gs.png | deduplicate --names title-names.txt | planarbitmap 2 --interleave 8 >title-patterns.bin
					
title-names.bin			: title-patterns.bin
					xxd -r -p title-names.txt title-names.bin

$(palettes):	%.pal:	$(gfxdir)/%.png
	packedpixels <$< >$@


.PHONY			:	run
run				:	$(romname)
					$(emulator) $(romname)

.PHONY			:	clean
clean			:	
					rm -f $(romname) *.lst *.sym *.bin *.pal title-names.txt