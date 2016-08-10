    include anims.asm
    include entities.asm
    include sounds.asm
        
pressAnyKey:
    .byte "Press Any Key^"
    
airMsg:
    .byte "You hit an air generator!",$0A
    .byte "The vacuum rushes in.","^@"
    
perfectHealthMsg:
    .byte "Perfect health! $50,000!","^@"
    
openingText:
    incbin opening.txt