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
    ORG 16 + 0*$4000
    RORG $8000
    include bank0.asm
    
    ORG 16 + 1*$4000
    RORG $8000
    
    ORG 16 + 2*$4000
    RORG $8000
    
    ORG 16 + 3*$4000
    RORG $8000
    
    ORG 16 + 4*$4000
    RORG $8000
    
    ORG 16 + 5*$4000
    RORG $8000
    
    ORG 16 + 6*$4000
    RORG $8000
    
    ORG 16 + 7*$4000
    RORG $C000
    include main.asm
    include nmi.asm
    include prgdata.asm
    
irq subroutine
    rti
banktable:
    .byte $00, $01, $02, $03, $04, $05, $06
    
    ECHO "PRGROM left:",$10000-.-6
    IF . > $10000-6
    ECHO "Exceeded PRGROM size!"
    ERR
    ENDIF
;interrupt vectors
    ORG 16 + 8*$4000 - 6
    .word nmi
    .word reset
    .word irq
;------------------------------------------------------------------------------
; CHR ROM
;------------------------------------------------------------------------------
    ;ORG 16+32768
    ;incbin chrrom.bin