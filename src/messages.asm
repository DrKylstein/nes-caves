;------------------------------------------------------------------------------
;in-game messages
;------------------------------------------------------------------------------

airMsg: .byte "THERE G0ES THE AIR",$00


gotAllMsg: .byte "LAST CRYSTAL  FIND EXIT",$00

        
perfectHealthMsg: .byte "PERFECT HEALTH K50000",$00


switchMsg: .byte "PRESS B T0 FLIP SWITCH",$00


gravityMsg: .byte "REVERSE GRAVITY",$00


powershotMsg: .byte "P0WER SH0T",$00


stopMsg: .byte "ST0PPED ENEMIES",$00


strengthMsg: .byte "INVINCIBLE",$00


keyMsg: .byte "CAN 0PEN CHESTS N0W",$00


poisonMsg: .byte "P0IS0NED",$00

;------------------------------------------------------------------------------
;menu text boxes
;------------------------------------------------------------------------------

menuText:
    .byte "   Please select an option",$0A
    .byte "   -----------------------",$0A
    .byte $0A
    .byte "  ",$10,"New Game",$0A
    .byte $0A
    .byte "   Restore Game",$0A
    .byte $0A
    .byte "   Instructions",$0A
    .byte $0A
    .byte "   Story",$0A
    .byte "^";"  About Apogee","^"

passwordText:
    .byte "        Enter Password",$0A
    .byte "   -----------------------",$0A
    .byte $0A
    .byte "       _ _ _ _ _ _ _ _",$0A
    .byte $0A
    .byte "      ",$10,"1 2 3 B C D F G",$0A
    .byte $0A
    .byte "       4 5 6 H J K L M",$0A
    .byte $0A
    .byte "       7 8 9 N P Q R S",$0A
    .byte $0A
    .byte "       # 0 * T V W X Z",$0A
    .byte $0A
    .byte "  ",$11,"Delete ",$12,"Enter ",$13,"Back ",$14,"OK","^"

failText:
    .byte "    Incorrect. Try again.","^"

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

;------------------------------------------------------------------------------
;ending text boxes
;------------------------------------------------------------------------------

nextStopText:
    .byte "I've collected a fortune in",$0A
    .byte "precious crystals. This",$0A
    .byte "should be enough to buy",$0A
    .byte "everything needed to start a",$0A
    .byte "twibble farm!",$0A
    .byte $0A
    .byte "Next stop, the local",$0A
    .byte "Galactic Trading Post!","^@"