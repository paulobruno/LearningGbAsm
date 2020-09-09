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

    ; $8800 is one of the VRAM addresses
    ld hl, $8800

    ; copy to VRAM

    ld [hl], $FF
    inc hl
    ld [hl], $FF
    inc hl
    ld [hl], $FF
    inc hl
    ld [hl], $FF
    inc hl

    ld [hl], $FF
    inc hl
    ld [hl], $FF
    inc hl
    ld [hl], $FF
    inc hl
    ld [hl], $FF
    inc hl

    ld [hl], $FF
    inc hl
    ld [hl], $FF
    inc hl
    ld [hl], $FF
    inc hl
    ld [hl], $FF
    inc hl

    ld [hl], $FF
    inc hl
    ld [hl], $FF
    inc hl
    ld [hl], $FF
    inc hl
    ld [hl], $FF

    ; turn on lcd
    ld a, %10010001
    ld [$FF40], a

.lock
    jr .lock
