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
    ECHO "PRGROM Bank 0 left:",[$C000-.]d
    IF . > $C000
    ECHO "Exceeded PRGROM Bank 0 size!"
    ERR
    ENDIF
    
    ORG 16 + 1*$4000
    RORG $8000
    include bank1.asm
    ECHO "PRGROM Bank 1 left:",[$C000-.]d
    IF . > $C000
    ECHO "Exceeded PRGROM Bank 0 size!"
    ERR
    ENDIF
    
    ORG 16 + 2*$4000
    RORG $8000
    include bank2.asm
    ECHO "PRGROM Bank 2 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 0 size!"
    ERR
    ENDIF
    
    ORG 16 + 3*$4000
    RORG $8000
    include bank3.asm
    ECHO "PRGROM Bank 3 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 0 size!"
    ERR
    ENDIF
    
    ORG 16 + 4*$4000
    RORG $8000
    ECHO "PRGROM Bank 4 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 0 size!"
    ERR
    ENDIF
    
    ORG 16 + 5*$4000
    RORG $8000
    ECHO "PRGROM Bank 5 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 0 size!"
    ERR
    ENDIF
    
    ORG 16 + 6*$4000
    RORG $8000
    ECHO "PRGROM Bank 6 left:",[$C000-.]d
    IF . > $C000-6
    ECHO "Exceeded PRGROM Bank 0 size!"
    ERR
    ENDIF
    
    ORG 16 + 7*$4000
    RORG $C000
    include bank7.asm
banktable:
    .byte $00, $01, $02, $03, $04, $05, $06
    
    ECHO "PRGROM Bank 7 left:",[$10000-.-6]d
    IF . > $10000-6
    ECHO "Exceeded PRGROM Bank 7 size!"
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