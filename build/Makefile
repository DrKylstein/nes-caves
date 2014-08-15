name		:= caves
emulator	:= nestopia

srcdir		:= ../src
gfxdir		:= ../gfx
bindir		:= ..

romname		:= $(bindir)/$(name).nes

incbins		:= chrrom.bin pal.bin
sources		:= $(wildcard ../src/*.*)
asmflags	:= -I$(srcdir) -f3 -v0 -l$(name).lst -s$(name).sym

$(romname)		:	$(sources) $(incbins)
					dasm $(name).asm $(asmflags) -o$(romname) -l$(name).lst

chrrom.bin		:	$(gfxdir)/sprites.png $(gfxdir)/tiles.png
					tilestrip 8 16 <$(gfxdir)/sprites.png | planarbitmap 2 --interleave 8 >chrrom.bin
					tilestrip 8 8 <$(gfxdir)/tiles.png | planarbitmap 2 --interleave 8 >>chrrom.bin

pal.bin			:	$(gfxdir)/pal.png
					packedpixels <$(gfxdir)/pal.png >pal.bin

.PHONY			:	run
run				:	$(romname)
					$(emulator) $(romname)

.PHONY			:	clean
clean			:	
					rm -f $(romname) *.lst *.sym *.bin