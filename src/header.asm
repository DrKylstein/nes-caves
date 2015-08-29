;------------------------------------------------------------------------------
; HEADER
;------------------------------------------------------------------------------
    .byte "NES",#$1A
    .byte #8 ;PRG ROM size x16KB
    .byte #0 ;CHR ROM size x8KB
    .byte #%00100000
    ;       ||||||||
    ;       ||||+||+- 0xx0: vertical arrangement/horizontal mirroring (CIRAM A10 = PPU A11)
    ;       |||| ||   0xx1: horizontal arrangement/vertical mirroring (CIRAM A10 = PPU A10)
    ;       |||| ||   1xxx: four-screen VRAM
    ;       |||| |+-- 1: SRAM in CPU $6000-$7FFF, if present, is battery backed
    ;       |||| +--- 1: 512-byte trainer at $7000-$71FF (stored before PRG data)
    ;       ++++----- Lower nybble of mapper number
    .byte #%00001000
    ;       ||||||||
    ;       |||||||+- VS Unisystem
    ;       ||||||+-- PlayChoice-10 (8KB of Hint Screen data stored after CHR data)
    ;       ||||++--- If equal to 2, flags 8-15 are in NES 2.0 format
    ;       ++++----- Upper nybble of mapper number
    .byte #%00000000
    ;       ||||||||
    ;       ||||++++- bits 11-8 of mapper number
    ;       ++++----- Submapper number
    .byte #%00000000
    ;       ||||||||
    ;       ||||++++- 4 more PRG ROM bits
    ;       ++++----- 4 more CHR ROM size bits
    .byte #%00000000
    ;       ||||||||
    ;       ||||++++- amount of PRG RAM without battery
    ;       ++++----- amount of PRG RAM with battery
    .byte #%00000111
    ;       ||||||||
    ;       ||||++++- amount of CHR RAM without battery
    ;       ++++----- amount of CHR RAM with battery
    .byte #%00000000
    ;       ||||||||
    ;       |||||||+- TV Type (0 : NTSC, 1 : PAL)
    ;       ||||||+-- adjusts to PAL or NTSC automatically
    ;       ++++++--- reserved
    .byte #$00 ;VS System options
    .byte #$00 ;reserved
    .byte #$00 ;reserved
    
