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
    .byte ENT_F_ISDEADLY | ENT_F_ISMORTAL | $02 ; cart
    .byte ENT_F_ISDEADLY | ENT_F_ISMORTAL | $04 ; caterpillar head
    .byte ENT_F_ISDEADLY | $04 ; caterpillar front
    .byte ENT_F_ISDEADLY | $04 ; caterpillar back
    .byte ENT_F_ISDEADLY | $04 ; caterpillar tail
    .byte ENT_F_ISDEADLY | ENT_F_ISMORTAL | $04 ; slime horizontal
    .byte ENT_F_ISDEADLY | ENT_F_ISMORTAL | ENT_F_ISVERTICAL | $04 ; slime horizontal
    .byte ENT_F_ISDEADLY | ENT_F_ISVERTICAL | $02 ; hammer
    .byte $06 ; faucet
    .byte ENT_F_ISPROJECTILE | ENT_F_ISDEADLY | ENT_F_ISVERTICAL | $06 ; water
    .byte $62 ; vertical platform
    .byte $42 ; horizontal platform
    .byte $02 | ENT_F_ISVERTICAL ; right cannon
    .byte ENT_F_ISPROJECTILE | ENT_F_ISDEADLY | $00 ; right laser
    .byte $02 | ENT_F_ISVERTICAL ; left cannon
    .byte ENT_F_ISPROJECTILE | ENT_F_ISDEADLY | $00 ; left laser
    .byte ENT_F_ISMORTAL | ENT_F_ISDEADLY | $04 ; rex
    
prgdata_entityFlags2:
    .byte 0 ; bullet
    .byte 0 ; vertical platform
    .byte 0 ; horizontal platform
    .byte ENT_F2_ISHITTABLE  ; spider
    .byte ENT_F2_ISHITTABLE  ; bat
    .byte ENT_F2_ISHITTABLE  ; power shot
    .byte ENT_F2_ISHITTABLE  | ENT_F2_ISGROUNDED | ENT_F2_NEEDPOWERSHOT ; rock
    .byte ENT_F2_ISHITTABLE | ENT_F2_ISGROUNDED | ENT_F2_NEEDPOWERSHOT ; cart
    .byte ENT_F2_ISHITTABLE  | ENT_F2_ISGROUNDED ;caterpillar head
    .byte ENT_F2_ISHITTABLE  | ENT_F2_ISGROUNDED ;caterpillar front
    .byte ENT_F2_ISHITTABLE  | ENT_F2_ISGROUNDED ;caterpillar back
    .byte ENT_F2_ISHITTABLE  | ENT_F2_ISGROUNDED ;caterpillar tail
    .byte ENT_F2_ISHITTABLE  ; slime horizontal
    .byte ENT_F2_ISHITTABLE  ; slime vertical
    .byte 0 ; hammer
    .byte 0 ; faucet
    .byte 0 ;water
    .byte 1 ; vertical platform
    .byte 2 ; horizontal platform
    .byte 0 ; right cannon
    .byte 3 ; right laser
    .byte 0 ; left cannon
    .byte 3 ; left laser
    .byte ENT_F2_ISHITTABLE | ENT_F2_ISGROUNDED ; rex
    
prgdata_entityTiles:
    .byte 64 ; bullet
    .byte 80 ; vertical platform
    .byte 80 ; horizontal platform
    .byte 152 ; spider
    .byte 128 ; bat
    .byte 156 ; power shot
    .byte 140 ; rock
    .byte 84 ; cart
    .byte 120 ; caterpillar head
    .byte 116 ; caterpillar front
    .byte 116 ; caterpillar back
    .byte 112 ; caterpillar tail
    .byte 192 ; slime horizontal
    .byte 204 ; slime vertical
    .byte 100 ; hammer
    .byte 220 ; faucet
    .byte 216 ; water
    .byte 80 ; vertical platform
    .byte 80 ; horizontal platform
    .byte 224 ; right cannon
    .byte 228 ; right laser
    .byte 224 ; left cannon
    .byte 228 ; left laser
    .byte 168 ; rex
    
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
    .byte 4 ; rex
    
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
    .byte 0 ; rex
    
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
    .byte 1 ; rex

prgdata_entityAnims:
    .byte ANIM_SMALL_LONG ; bullet
    .byte ANIM_SPIDER ; vertical platform
    .byte ANIM_SPIDER ; horizontal platform
    .byte ANIM_SPIDER ; spider
    .byte ANIM_SMALL_OSCILLATE ; bat
    .byte ANIM_SMALL_OSCILLATE ; power shot
    .byte ANIM_SMALL_OSCILLATE ; rock
    .byte ANIM_SMALL_LONG ; cart
    .byte ANIM_CATERPILLAR ; caterpillar head
    .byte ANIM_CATERPILLAR_2 ; caterpillar front
    .byte ANIM_CATERPILLAR ; caterpillar back
    .byte ANIM_CATERPILLAR_2 ; caterpillar tail
    .byte ANIM_SMALL_OSCILLATE ; slime horizontal
    .byte ANIM_SMALL_OSCILLATE ; slime vertical
    .byte ANIM_SMALL_NONE ; hammer
    .byte ANIM_SMALL_NONE ; faucet
    .byte ANIM_SMALL_NONE ; water
    .byte ANIM_SPIDER ; vertical platform
    .byte ANIM_SPIDER ; horizontal platform
    .byte ANIM_SMALL_NONE ; right cannon
    .byte ANIM_SMALL_NONE ; right laser
    .byte ANIM_SMALL_HFLIP_NONE ; left cannon
    .byte ANIM_SMALL_NONE ; left laser
    .byte ANIM_REX ;rex

prgdata_animations:
    .word prgdata_anim_null
    .word prgdata_anim_smallNone
    .word prgdata_anim_smallHFlipNone
    .word prgdata_anim_smallOscillate
    .word prgdata_anim_smallHFlipOscillate
    .word prgdata_anim_smallVFlipOscillate
    .word prgdata_anim_smallLong
    .word prgdata_anim_smallHFlipLong
    .word prgdata_anim_caterpillar
    .word prgdata_anim_caterpillarHFlip
    .word prgdata_anim_caterpillar2
    .word prgdata_anim_caterpillarHFlip2
    .word prgdata_anim_spider
    .word prgdata_anim_spiderVFlip
    .word prgdata_anim_rex
    
prgdata_frame_small1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte 0
    .byte 16

prgdata_frame_smallHFlip1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $40
    .byte 16


prgdata_frame_small2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte 0
    .byte 16

prgdata_frame_smallHFlip2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte $40
    .byte 16

prgdata_frame_small3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 8
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 10
    .byte 0
    .byte 16

prgdata_frame_smallHFlip3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 10
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 8
    .byte $40
    .byte 16

prgdata_anim_null subroutine
    .byte 0
    .word .frame1
.frame1:
    .byte 0

prgdata_anim_smallNone subroutine
    .byte 0
    .word prgdata_frame_small1

prgdata_anim_smallHFlipNone subroutine
    .byte 0
    .word prgdata_frame_smallHFlip1

prgdata_anim_smallOscillate subroutine
    .byte 3
    .word prgdata_frame_small1
    .word prgdata_frame_small2
    .word prgdata_frame_small3
    .word prgdata_frame_small2

prgdata_anim_smallHFlipOscillate subroutine
    .byte 3
    .word prgdata_frame_smallHFlip1
    .word prgdata_frame_smallHFlip2
    .word prgdata_frame_smallHFlip3
    .word prgdata_frame_smallHFlip2

prgdata_anim_smallVFlipOscillate subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
.frame1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $80
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $80
    .byte 16
.frame2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 4
    .byte $80
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 6
    .byte $80
    .byte 16
.frame3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 8
    .byte $80
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 10
    .byte $80
    .byte 16


prgdata_anim_smallLong subroutine
    .byte 3
    .word prgdata_frame_small1
    .word prgdata_frame_small2
    .word prgdata_frame_small3
    .word .frame4
.frame4:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 12
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 14
    .byte 0
    .byte 16
    
prgdata_anim_smallHFlipLong subroutine
    .byte 3
    .word prgdata_frame_smallHFlip1
    .word prgdata_frame_smallHFlip2
    .word prgdata_frame_smallHFlip3
    .word .frame4
.frame4:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 14
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 12
    .byte $40
    .byte 16
    
    
prgdata_frame_caterpillar1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte 0
    .byte 16
prgdata_frame_caterpillar2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-1
    .byte 0
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-1
    .byte 2
    .byte 0
    .byte 16
prgdata_frame_caterpillar3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-2
    .byte 0
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-2
    .byte 2
    .byte 0
    .byte 16
    
prgdata_frame_caterpillarHFlip1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $40
    .byte 16
prgdata_frame_caterpillarHFlip2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-1
    .byte 2
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-1
    .byte 0
    .byte $40
    .byte 16
prgdata_frame_caterpillarHFlip3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-2
    .byte 2
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-2
    .byte 0
    .byte $40
    .byte 16
    
prgdata_anim_caterpillar subroutine
    .byte 3
    .word prgdata_frame_caterpillar1
    .word prgdata_frame_caterpillar2
    .word prgdata_frame_caterpillar3
    .word prgdata_frame_caterpillar2
    
prgdata_anim_caterpillarHFlip subroutine
    .byte 3
    .word prgdata_frame_caterpillarHFlip1
    .word prgdata_frame_caterpillarHFlip2
    .word prgdata_frame_caterpillarHFlip3
    .word prgdata_frame_caterpillarHFlip2
    
prgdata_anim_caterpillar2 subroutine
    .byte 3
    .word prgdata_frame_caterpillar3
    .word prgdata_frame_caterpillar2
    .word prgdata_frame_caterpillar1
    .word prgdata_frame_caterpillar2
    
prgdata_anim_caterpillarHFlip2 subroutine
    .byte 3
    .word prgdata_frame_caterpillarHFlip3
    .word prgdata_frame_caterpillarHFlip2
    .word prgdata_frame_caterpillarHFlip1
    .word prgdata_frame_caterpillarHFlip2

prgdata_anim_spider subroutine
    .byte 3
    .word prgdata_frame_small1
    .word .frame2
    .word prgdata_frame_smallHFlip1
    .word .frame2
.frame2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $40
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte 0
    .byte 16

prgdata_anim_spiderVFlip subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame2
    
.frame1:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $80
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $80
    .byte 16
    
.frame2:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $C0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $80
    .byte 16
    
.frame3:
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 2
    .byte $C0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 0
    .byte $C0
    .byte 16
    
prgdata_anim_rex subroutine
    .byte 3
    .word .frame1
    .word .frame2
    .word .frame3
    .word .frame4
.frame1:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 0
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 2
    .byte 0
    .byte 16

    .byte PX_VIEWPORT_OFFSET
    .byte 64
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 66
    .byte 0
    .byte 16
.frame2:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 4
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 6
    .byte 0
    .byte 16

    .byte PX_VIEWPORT_OFFSET
    .byte 68
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 70
    .byte 0
    .byte 16
.frame3:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 8
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 10
    .byte 0
    .byte 16

    .byte PX_VIEWPORT_OFFSET
    .byte 72
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 74
    .byte 0
    .byte 16
.frame4:
    .byte 16
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 12
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET-16
    .byte 14
    .byte 0
    .byte 16

    .byte PX_VIEWPORT_OFFSET
    .byte 76
    .byte 0
    .byte 8
    
    .byte PX_VIEWPORT_OFFSET
    .byte 78
    .byte 0
    .byte 16

    
prgdata_bits:
    .byte 1
    .byte 2
    .byte 4
    .byte 8
    .byte 16
    .byte 32
    .byte 64
    .byte 128

prgdata_points:
    .byte 00,00,00,05;0
    .byte 00,00,01,00;0
    .byte 00,00,00,80;0
    .byte 00,00,01,00;0
    .byte 00,00,05,00;0
    .byte 00,00,00,10;0
    .byte 00,00,10,00;0

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
