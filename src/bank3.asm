    include anims.asm
    include entities.asm
    include sounds.asm
        
pressAnyKey:
    .byte "Press Any Key^"
    
airMsg subroutine
.start:
    .byte <[.end-.start-1],"EXPLOSIVE DECOMPRESSION"
.end:
    
cheatMsg subroutine
.start:
    .byte <[.end-.start-1],"CHEATER"
.end:
    
perfectHealthMsg subroutine
.start:
    .byte <[.end-.start-1],"PERFECT HEALTH K50000"
.end:
    
openingText:
    incbin opening.txt