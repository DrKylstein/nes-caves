    include anims.asm
    include entities.asm
    include sounds.asm
        
pressAnyKey:
    .byte "Press Any Key^"
    
airMsg:
    .byte "You hit an air generator!",$0A
    .byte "The vacuum rushes in.","^@"
    
openingText:
    incbin opening.txt