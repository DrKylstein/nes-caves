;------------------------------------------------------------------------------
; PRG ROM DATA
;------------------------------------------------------------------------------

prgdata_playerWalk:
    .byte $00
    .byte $04
    .byte $08
    .byte $04
    .byte $00
    .byte $0C
    .byte $10
    .byte $0C
    .byte $14
    .byte $08
    
prgdata_entityFlags:
    .byte $92 ; bullet
    .byte $62 ; vertical platform
    .byte $42 ; horizontal platform
    .byte $3F ; spider
    .byte $0B ; bat
    .byte $90 ; power shot
    .byte $1B ; rock
    .byte ENT_F_ISDEADLY | ENT_F_ISFACING | ENT_F_ISMORTAL | $02 ; cart
    .byte ENT_F_ISDEADLY | ENT_F_ISFACING | ENT_F_ISMORTAL | $04 ; caterpillar head
    .byte ENT_F_ISDEADLY | ENT_F_ISFACING | $04 ; caterpillar front
    .byte ENT_F_ISDEADLY | ENT_F_ISFACING | $04 ; caterpillar back
    .byte ENT_F_ISDEADLY | ENT_F_ISFACING | $04 ; caterpillar tail
    .byte ENT_F_ISDEADLY | ENT_F_ISFACING | ENT_F_ISMORTAL | $04 ; slime horizontal
    .byte ENT_F_ISDEADLY | ENT_F_ISFACING | ENT_F_ISMORTAL | ENT_F_ISVERTICAL | $04 ; slime horizontal
    .byte ENT_F_ISDEADLY | ENT_F_ISVERTICAL | $02 ; hammer
    .byte $06 ; faucet
    .byte ENT_F_ISPROJECTILE | ENT_F_ISDEADLY | ENT_F_ISVERTICAL | $06 ; water
    
prgdata_entityFlags2:
    .byte 0 ; bullet
    .byte 0 ; vertical platform
    .byte 0 ; horizontal platform
    .byte ENT_F2_ISHITTABLE | ENT_F2_SHORTANIM ; spider
    .byte ENT_F2_ISHITTABLE | ENT_F2_SHORTANIM ; bat
    .byte ENT_F2_ISHITTABLE | ENT_F2_SHORTANIM ; power shot
    .byte ENT_F2_ISHITTABLE | ENT_F2_SHORTANIM | ENT_F2_ISGROUNDED | ENT_F2_NEEDPOWERSHOT ; rock
    .byte ENT_F2_ISHITTABLE | ENT_F2_ISGROUNDED | ENT_F2_NEEDPOWERSHOT | ENT_F2_PAUSETURN ; cart
    .byte ENT_F2_ISHITTABLE | ENT_F2_NOANIM | ENT_F2_ISGROUNDED ;caterpillar head
    .byte ENT_F2_ISHITTABLE | ENT_F2_NOANIM | ENT_F2_ISGROUNDED ;caterpillar front
    .byte ENT_F2_ISHITTABLE |  ENT_F2_NOANIM | ENT_F2_ISGROUNDED ;caterpillar back
    .byte ENT_F2_ISHITTABLE | ENT_F2_NOANIM | ENT_F2_ISGROUNDED ;caterpillar tail
    .byte ENT_F2_ISHITTABLE | ENT_F2_SHORTANIM ; slime horizontal
    .byte ENT_F2_ISHITTABLE | ENT_F2_SHORTANIM ; slime vertical
    .byte ENT_F2_NOANIM | ENT_F2_PAUSETURN ; hammer
    .byte ENT_F2_NOANIM ; faucet
    .byte ENT_F2_NOANIM | ENT_F2_PAUSETURN ;water
    
prgdata_entityTiles:
    .byte 64 ; bullet
    .byte 80 ; vertical platform
    .byte 96 ; horizontal platform
    .byte 152 ; spider
    .byte 128 ; bat
    .byte 164 ; power shot
    .byte 140 ; rock
    .byte 176 ; cart
    .byte 120 ; caterpillar head
    .byte 116 ; caterpillar front
    .byte 116 ; caterpillar back
    .byte 112 ; caterpillar tail
    .byte 192 ; slime horizontal
    .byte 204 ; slime vertical
    .byte 124 ; hammer
    .byte 220 ; faucet
    .byte 216 ; water
    
prgdata_entityHPs:
    .byte 0 ; bullet
    .byte 0 ; vertical platform
    .byte 0 ; horizontal platform
    .byte 1 ; spider
    .byte 1 ; bat
    .byte 0 ; power shot
    .byte 1 ; rock
    .byte 1 ; cart
    .byte 1 ; caterpillar head
    .byte 1 ; caterpillar front
    .byte 1 ; caterpillar back
    .byte 1 ; caterpillar tail
    .byte 1 ; slime horizontal
    .byte 1 ; slime vertical
    .byte 0 ; hammer
    .byte 0 ; faucet
    .byte 0 ; water
    
prgdata_entityCounts:
    .byte 0 ; bullet
    .byte 0 ; vertical platform
    .byte 0 ; horizontal platform
    .byte 0 ; spider
    .byte 0 ; bat
    .byte 0 ; power shot
    .byte 0 ; rock
    .byte $60 ; cart
    .byte 0 ; caterpillar head
    .byte 0 ; caterpillar front
    .byte 0 ; caterpillar back
    .byte 0 ; caterpillar tail
    .byte 0 ; slime horizontal
    .byte 0 ; slime vertical
    .byte $20 ; hammer
    .byte 0 ; faucet
    .byte $20 ; water
prgdata_points:
    .byte 00,00,00,05;0
    .byte 00,00,01,00;0
    .byte 00,00,00,80;0
    .byte 00,00,01,00;0
    .byte 00,00,05,00;0
    .byte 00,00,00,10;0

prgdata_palettes:
;global
    incbin palsp.pal

prgdata_hud:
	incbin hud.bin
prgdata_metatiles:
    incbin metatiles.bin

prgdata_jumpSound:
    .byte 255
    .byte 250
    .byte 245
    .byte 240
    .byte 235
    .byte 230
    .byte 225
    .byte 220
    .byte 215
    .byte 210
    .byte 205
    .byte 200
    .byte 195
    .byte 190
    .byte 185
    .byte 180
    .byte 175
    .byte 170
    .byte 165
    .byte 160
    .byte 155
    .byte 150
    .byte 145
    .byte 140
    .byte 135
    .byte 130
    .byte 125
    .byte 120
prgdata_nullSound:
    .byte 0
    
prgdata_crystalSound:
    .byte 100
    .byte 110
    .byte 120
    .byte 130
    .byte 140
    .byte 150
    .byte 100
    .byte 110
    .byte 120
    .byte 130
    .byte 140
    .byte 150
    .byte 155
    
    .byte 0
    
prgdata_levelTable
    dc.w  prgdata_level01
    dc.w  prgdata_level02
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    dc.w  prgdata_level01
    
prgdata_mainMap:
    incbin main_map.bin
    incbin pal00.pal
prgdata_level01:
    incbin level01.bin
    incbin pal01.pal
prgdata_level02:
    incbin level02.bin
    incbin pal02.pal
