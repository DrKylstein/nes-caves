    include anims.asm
    include entities.asm
    include sounds.asm
    
openingHeader:
    .byte "SHIP'S LOG - STARDATE 2121.04",$0A
    .byte "-----------------------------",$0A,$0A,"^"
    
pressAnyKey:
    .byte "Press Any Key^"
    
openingText:
    incbin opening.txt