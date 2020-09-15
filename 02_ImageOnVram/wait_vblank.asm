SECTION "Entry", ROM0[$100]

    nop
    jp Start

REPT $150 - $104
    db 0
ENDR


SECTION "Main", ROM0

Start:

.waitVBlank 
    ; $FF44 is the address of LY register
    ; it holds the current column being drawn
    ld a, [$FF44]
    ; compare with 144, the num of pixels on screen
    ; 0-143 = drawing/notVBlanking
    ; 144-153 = not drawing/vblaking
    cp 144
    ; while < 144, keep running
    jr c, .waitVBlank
    
    ; turn off lcd
    xor a
    ld [$FF40], a ; $FF40 is the location of LCDC register

    ; $8800 is one of the VRAM addresses
    ld hl, $8800

    ; copy sprite to VRAM

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
    ld [$FF40], a ; $FF40 is the location of LCDC register

.lock
    jr .lock
