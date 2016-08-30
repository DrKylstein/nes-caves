;------------------------------------------------------------------------------
;in-game messages
;------------------------------------------------------------------------------

airMsg subroutine
.start:
    .byte "THERE G0ES THE AIR",$00
.end:

gotAllMsg subroutine
.start:
    .byte "LAST CRYSTAL  FIND EXIT",$00
.end:
        
perfectHealthMsg subroutine
.start:
    .byte "PERFECT HEALTH K50000",$00
.end:

switchMsg subroutine
.start:
    .byte "PRESS B T0 FLIP SWITCH",$00
.end:

gravityMsg subroutine
.start:
    .byte "REVERSE GRAVITY",$00
.end:

powershotMsg subroutine
.start:
    .byte "P0WER SH0T",$00
.end:

stopMsg subroutine
.start:
    .byte "ST0PPED ENEMIES",$00
.end:

strengthMsg subroutine
.start:
    .byte "INVINCIBLE",$00
.end:

keyMsg subroutine
.start:
    .byte "CAN 0PEN CHESTS N0W",$00
.end:

poisonMsg subroutine
.start:
    .byte "P0IS0NED",$00
.end:

;------------------------------------------------------------------------------
;opening text boxes
;------------------------------------------------------------------------------

pressAnyKey:
    .byte "Press Any Key^"

openingText:
    incbin opening.txt
    
steeringText:
    .byte "Uh oh... the steering system",$0A,"is failing again!","^@"
    
whereText:
    .byte "Whoa! Where'd that come from!","^@"
    
landText:
    .byte "Whew...made it!  Now I",$0A
    .byte "need to collect enough",$0A
    .byte "crystals to trade at the",$0A
    .byte "Galactic Trading Post.","^@"
