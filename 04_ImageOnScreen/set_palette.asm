SECTION "Entry", ROM0[$100]
    nop
    jp Start


SECTION "Header", ROM0
    REPT $150 - $104
        db 0
    ENDR


SECTION "Main", ROM0

Start:

.waitVBlank 
    ld a, [$FF44]
    cp 144
    jp c, .waitVBlank
    
    ; turn off lcd
    xor a
    ld [$FF40], a

    ; load sprite into VRAM
    ld hl, $8800
    ld de, SmileSpriteStart
    ld bc, SmileSpriteEnd - SmileSpriteStart
.copyToVram
    ld a, [de]
    ld [hli], a ; ld [hl], a ; inc hl
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .copyToVram

    ; copy to screen
    ; $9800 is the address of the first (upper left) tile
    ld hl, $9800
    ; we pass only tile number, instead of full VRAM address
    ld [hl], $80

    ; set palette
    ld a, %11100100 ; palette 1
    ;ld a, %01101100 ; palette 2
    ; $FF47 is the location of background palette (BGP) register
    ld [$FF47], a

    ; turn on lcd
    ld a, %10010001
    ld [$FF40], a

.lock
    jr .lock


SmileSpriteStart:
    INCBIN "smile.2bpp"
SmileSpriteEnd: