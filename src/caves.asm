;------------------------------------------------------------------------------
; QUEST
; NROM
; Output should be 41,104 bytes long
;------------------------------------------------------------------------------
    processor 6502
    include registers.asm
    include macros.asm
    include constants.asm
    include ram.asm

    SEG ROM_FILE
    ORG $0000,$FF
    include header.asm
;------------------------------------------------------------------------------
; PRG ROM
;------------------------------------------------------------------------------
    RORG $8000
    include main.asm
    include nmi.asm
    include prgdata.asm
irq subroutine
    rti
    ECHO "PRGROM left:",$10000-.-6
    IF . > $10000-6
    ECHO "Exceeded PRGROM size!"
    ERR
    ENDIF
;interrupt vectors
    ORG 16+$8000-6
    .word nmi
    .word reset
    .word irq
;------------------------------------------------------------------------------
; CHR ROM
;------------------------------------------------------------------------------
    ;ORG 16+32768
    incbin chrrom.bin
;------------------------------------------------------------------------------
; TITLE
;------------------------------------------------------------------------------
;    .byte "Untitled Quest",#$00
;    .align 128