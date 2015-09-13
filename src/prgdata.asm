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
    .byte $62 ; vertical platform
    .byte $42 ; horizontal platform
    .byte $02 | ENT_F_ISVERTICAL ; right cannon
    .byte ENT_F_ISPROJECTILE | ENT_F_ISDEADLY | $00 ; right laser
    .byte $02 | ENT_F_ISVERTICAL ; left cannon
    .byte ENT_F_ISPROJECTILE | ENT_F_ISDEADLY | $00 ; left laser
    
    
prgdata_entityFlags2:
    .byte 0 ; bullet
    .byte 0 ; vertical platform
    .byte 0 ; horizontal platform
    .byte ENT_F2_ISHITTABLE | ENT_F2_SHORTANIM ; spider
    .byte ENT_F2_ISHITTABLE | ENT_F2_SHORTANIM ; bat
    .byte ENT_F2_ISHITTABLE | ENT_F2_SHORTANIM ; power shot
    .byte ENT_F2_ISHITTABLE | ENT_F2_SHORTANIM | ENT_F2_ISGROUNDED | ENT_F2_NEEDPOWERSHOT ; rock
    .byte ENT_F2_ISHITTABLE | ENT_F2_ISGROUNDED | ENT_F2_NEEDPOWERSHOT ; cart
    .byte ENT_F2_ISHITTABLE | ENT_F2_NOANIM | ENT_F2_ISGROUNDED ;caterpillar head
    .byte ENT_F2_ISHITTABLE | ENT_F2_NOANIM | ENT_F2_ISGROUNDED ;caterpillar front
    .byte ENT_F2_ISHITTABLE |  ENT_F2_NOANIM | ENT_F2_ISGROUNDED ;caterpillar back
    .byte ENT_F2_ISHITTABLE | ENT_F2_NOANIM | ENT_F2_ISGROUNDED ;caterpillar tail
    .byte ENT_F2_ISHITTABLE | ENT_F2_SHORTANIM ; slime horizontal
    .byte ENT_F2_ISHITTABLE | ENT_F2_SHORTANIM ; slime vertical
    .byte ENT_F2_NOANIM ; hammer
    .byte ENT_F2_NOANIM ; faucet
    .byte ENT_F2_NOANIM ;water
    .byte 1 ; vertical platform
    .byte 2 ; horizontal platform
    .byte ENT_F2_NOANIM ; right cannon
    .byte ENT_F2_NOANIM | 3 ; right laser
    .byte ENT_F2_ISXFLIPPED | ENT_F2_NOANIM ; left cannon
    .byte ENT_F2_NOANIM | 3 ; left laser
    
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
    .byte 80 ; vertical platform
    .byte 96 ; horizontal platform
    .byte 224 ; right cannon
    .byte 228 ; right laser
    .byte 224 ; left cannon
    .byte 228 ; left laser
    
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
    .byte 0 ; vertical platform
    .byte 0 ; horizontal platform
    .byte 0 ; right cannon
    .byte 0 ; right laser
    .byte 0 ; left cannon
    .byte 0 ; left laser
    
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
    .byte 0 ; vertical platform
    .byte 0 ; horizontal platform
    .byte 0 ; right cannon
    .byte $20 ; right laser
    .byte 0 ; left cannon
    .byte $20 ; left laser
    
prgdata_entitySpeeds:
    .byte 4 ; bullet
    .byte 1 ; vertical platform
    .byte 1 ; horizontal platform
    .byte 1 ; spider
    .byte 1 ; bat
    .byte 4 ; power shot
    .byte 0 ; rock
    .byte 2 ; cart
    .byte 1 ; caterpillar head
    .byte 1 ; caterpillar front
    .byte 1 ; caterpillar back
    .byte 1 ; caterpillar tail
    .byte 2 ; slime horizontal
    .byte 2 ; slime vertical
    .byte 6 ; hammer
    .byte 0 ; faucet
    .byte 4 ; water
    .byte 1 ; vertical platform
    .byte 1 ; horizontal platform
    .byte 0 ; right cannon
    .byte 2 ; right laser
    .byte 0 ; left cannon
    .byte -2 ; left laser
    
prgdata_bits:
    .byte 1
    .byte 2
    .byte 4
    .byte 8

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

prgdata_sfx:
    .word prgdata_nullSound
    .word prgdata_jumpSound
    .word prgdata_crystalSound
    .word prgdata_crystalSound

prgdata_jumpSound:
    .word 50
    .word 48
    .word 45
    .word 43
    .word 40
    .word 40
    .word 37
    .word 37
    .word 37
    .word 37
    .word 37
    .word 37
    .word 40
    .word 43
    .word 50
    .word 55
    .word 58
    .word 70
    .word 75
    .word 80
    .word 86
    .word 93
    .word 98
    .word 103
    .word 113
    .word 124
    .word 131
    .word 144
    .word 215
prgdata_nullSound:
    .word $FFFF
    
prgdata_crystalSound:
    .word 101
    .word 98
    .word 98
    .word 96
    .word 0
    .word 0
    .word 101
    .word 101
    .word 98
    .word 91
    .word 0
    .word 88
    .word 86
    .word 80
    .word 0
    .word 75
    .word 0
    .word 70
    .word 0
    .word 65
    .word 0
    .word 0
    .word 60
    .word 0
    .word 55
    .word 0
    .word 0
    .word 50
    .word 0
    .word 45
    .word 0
    .word 0
    .word 40
    .word 0
    .word 37
    .word 0
    .word 32
    .word 0
    .word 0
    .word 27
    .word 0
    .word 25
    .word 22
    .word 0
    .word 20
    .word 0
    .word 20
    .word 17
    .word 15
    .word 0
    .word $FFFF
    
prgdata_titleNames:
    incbin title-names.bin
    incbin title-attr.bin
prgdata_titlePalette:
    incbin paltl.pal
    
prgdata_levelTable
    dc.w  prgdata_level01
    dc.w  prgdata_level02
    dc.w  prgdata_level03
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
prgdata_level03:
    incbin level03.bin
    incbin pal00.pal
