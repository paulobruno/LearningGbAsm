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
    jr c, .waitVBlank
    
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
    ld a, %10010001
    ld [$FF40], a

.lock
    jr .lock


; we can also use the INCBIN instruction to load the bytes from file
; the file should contain only the sprite bytes
BlackSpriteStart:
    INCBIN "black_sprite.bin"
BlackSpriteEnd: