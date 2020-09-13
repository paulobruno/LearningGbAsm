vTiles0     EQU $8000
vTiles1     EQU $8800
vTiles2     EQU $9000

vBGMap0     EQU $9800
vBGMap1     EQU $9C00

rLCDC       EQU $FF40
rLY         EQU $FF44
rBGP        EQU $FF47


SECTION "Entry", ROM0[$100]
    nop
    jp Start

REPT $150 - $104
    db 0
ENDR


SECTION "Main", ROM0

Start:

.waitVBlank
    ld a, [rLY]
    cp 144
    jr c, .waitVBlank
    
    ; turn off lcd
    xor a ; ld a, 0
    ld [rLCDC], a

    ; since we are mapping the chars using their ascii codes
    ; we need to consider the correct VRAM address
    ; our custom font starts with '0', which have address $30
    ld hl, $8300
    ld de, FontStart
    ld bc, FontEnd - FontStart
.copyToVram
    ld a, [de]
    ld [hli], a ; ld [hl], a ; inc hl
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .copyToVram

    ; copy to screen
    ld hl, vBGMap0
    ld [hl], "H"
    inc hl
    ld [hl], "E"
    inc hl
    ld [hl], "L"
    inc hl
    ld [hl], "L"
    inc hl
    ld [hl], "O"
    inc hl
    ld [hl], "W"
    inc hl
    ld [hl], "O"
    inc hl
    ld [hl], "R"
    inc hl
    ld [hl], "L"
    inc hl
    ld [hl], "D"
    inc hl
    ld [hl], "1"
    inc hl
    ld [hl], "2"
    inc hl
    ld [hl], "3"

    ; set palette
    ld a, %11100100
    ld [rBGP], a

    ; turn on lcd
    ld a, %10010001
    ld [rLCDC], a

.lock
    jr .lock


SECTION "Font", ROM0

FontStart:
    INCBIN "fonts/alphanum_ascii.bin"
FontEnd: