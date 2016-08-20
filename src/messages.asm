pressAnyKey:
    .byte "Press Any Key^"
    
airMsg subroutine
.start:
    .byte <[.end-.start-1],"THERE G0ES THE AIR"
.end:

gotAllMsg subroutine
.start:
    .byte <[.end-.start-1],"LAST CRYSTAL  FIND EXIT"
.end:
        
perfectHealthMsg subroutine
.start:
    .byte <[.end-.start-1],"PERFECT HEALTH K50000"
.end:

switchMsg subroutine
.start:
    .byte <[.end-.start-1],"PRESS B T0 FLIP SWITCH"
.end:

gravityMsg subroutine
.start:
    .byte <[.end-.start-1],"REVERSE GRAVITY"
.end:

powershotMsg subroutine
.start:
    .byte <[.end-.start-1],"P0WER SH0T"
.end:

stopMsg subroutine
.start:
    .byte <[.end-.start-1],"ST0PPED ENEMIES"
.end:

strengthMsg subroutine
.start:
    .byte <[.end-.start-1],"INVINCIBLE"
.end:

keyMsg subroutine
.start:
    .byte <[.end-.start-1],"CAN 0PEN CHESTS N0W"
.end:

poisonMsg subroutine
.start:
    .byte <[.end-.start-1],"P0IS0NED"
.end:

openingText:
    incbin opening.txt