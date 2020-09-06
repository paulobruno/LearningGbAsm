SECTION "Entry", ROM0[$100]

    nop
    jp Start


SECTION "Header", ROM0

    REPT $150 - $104
        db 0
    ENDR


SECTION "Main", ROM0

Start:
    ; $9000 is one of the VRAM addresses
    ld hl, $9000

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

.lock
    jr .lock
