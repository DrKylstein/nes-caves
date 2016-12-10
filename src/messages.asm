;------------------------------------------------------------------------------
;in-game messages
;------------------------------------------------------------------------------

airMsg: .byte "THERE G0ES THE AIR",$00

gotAllMsg: .byte "LAST CRYSTAL  FIND EXIT",$00

perfectHealthMsg: .byte "PERFECT HEALTH K50000",$00

switchMsg: .byte "PRESS B T0 FLIP SWITCH",$00

leverMsg: .byte "PRESS B T0 MOVE LEVER",$00

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
    .byte "  Please select an option",$0A
    .byte "  -----------------------",$0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte "   ",$10,"New Game",$0A
    .byte $0A
    .byte "    Restore Game",$0A
    .byte $0A
    .byte "    Instructions",$0A
    .byte $0A
    .byte "    Story",$0A
    .byte "^";"  About Apogee","^"

passwordText:
    .byte "      Enter Password",$0A
    .byte "  -----------------------",$0A
    .byte $0A
    .byte $0A
    .byte "       ____________",$0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte "         ",$10,"1 2 3 A",$0A
    .byte $0A
    .byte       "          4 5 6 B",$0A
    .byte $0A
    .byte       "          7 8 9 C",$0A
    .byte $0A
    .byte       "          # 0 * D",$0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte " ",$11,"Delete ",$12,"Enter  ",$13,"Back ",$14,"OK","^"

failText:
    .byte "    Incorrect. Try again.","^"

pauseText:
    .byte "          Paused",$0A
    .byte "  -----------------------",$0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte "          Password:",$0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte "    ",$13,"Exit level   ",$14,"Resume","^"
    
mapPauseText:
    .byte "          Paused",$0A
    .byte "  -----------------------",$0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte "          Password:",$0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte "  ",$14,"Resume","^"
    
storyText:
    incbin story.txt
helpText:
    incbin instructions.txt
;------------------------------------------------------------------------------
;opening text boxes
;------------------------------------------------------------------------------

pressAnyKey:
    .byte "Press Any Key^"

openingText:
    incbin opening.txt
    
steeringText:
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $22,"Uh oh... the steering",$0A,"system is failing again!",$22,"^@"
    
whereText:
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $22,"Whoa!",$0A,"Where'd that come from!",$22,"^@"
    
landText:
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $0A
    .byte $22,"Whew...made it!  Now I",$0A
    .byte "need to collect enough",$0A
    .byte "crystals to trade at the",$0A
    .byte "Galactic Trading Post.",$22,"^@"

;------------------------------------------------------------------------------
;ending text boxes
;------------------------------------------------------------------------------

nextStopText:
    .byte "You collect what you",$0A
    .byte "consider to be a fortune in",$0A
    .byte "precious crystals--enough",$0A
    .byte "to buy you everything",$0A
    .byte "necessary to start a",$0A
    .byte "twibble farm.",$0A
    .byte $0A
    .byte "Your next stop is the local",$0A
    .byte "Galactic Trading Post!","^@"
    
farmText:
    incbin ending.txt