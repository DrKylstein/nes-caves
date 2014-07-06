;------------------------------------------------------------------------------
; HEADER
;------------------------------------------------------------------------------
    .byte "NES",#$1A
    .byte #2 ;PRG ROM size x16KB
    .byte #1 ;CHR ROM size x8KB
    .byte #%00000000
    ;       ||||||||
    ;       ||||+||+- 0xx0: vertical arrangement/horizontal mirroring (CIRAM A10 = PPU A11)
    ;       |||| ||   0xx1: horizontal arrangement/vertical mirroring (CIRAM A10 = PPU A10)
    ;       |||| ||   1xxx: four-screen VRAM
    ;       |||| |+-- 1: SRAM in CPU $6000-$7FFF, if present, is battery backed
    ;       |||| +--- 1: 512-byte trainer at $7000-$71FF (stored before PRG data)
    ;       ++++----- Lower nybble of mapper number
    .byte #%00000000
    ;       ||||||||
    ;       |||||||+- VS Unisystem
    ;       ||||||+-- PlayChoice-10 (8KB of Hint Screen data stored after CHR data)
    ;       ||||++--- If equal to 2, flags 8-15 are in NES 2.0 format
    ;       ++++----- Upper nybble of mapper number
    .byte #0 ; PRG RAM x8KB
    .byte #%00000000
    ;       ||||||||
    ;       |||||||+- TV system (0: NTSC; 1: PAL)
    ;       +++++++-- Reserved, set to zero
    .byte #%00000000
    ;         ||  ||
    ;         ||  ++- TV system (0: NTSC; 2: PAL; 1/3: dual compatible)
    ;         |+----- SRAM in CPU $6000-$7FFF is 0: present; 1: not present
    ;         +------ 0: Board has no bus conflicts; 1: Board has bus conflicts
    .byte #$00
    .byte #$00
    .byte #$00
    .byte #$00
    .byte #$00
    
