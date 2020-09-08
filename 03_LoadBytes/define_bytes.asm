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

    ; we use 'de' to point to the start of the data
    ld de, BlackSpriteStart

    ; we use 'bc' to store the size of the data
    ld bc, BlackSpriteEnd - BlackSpriteStart

; we loop through the data, loading the value into 'hl'
.copyToVram
    ld a, [de]
    ld [hli], a ; ld [hl], a ; inc hl
    inc de
    dec bc
    
    ; while bc != 0, keep copying
    ld a, b
    or c
    jr nz, .copyToVram

    ; turn on lcd
    ld a, %10000001
    ld [$FF40], a

.lock
    jr .lock


; we define the sprite between two labels
; the first one gives us the start address
; the second one gives us the end address 
BlackSpriteStart
    db $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF
BlackSpriteEnd