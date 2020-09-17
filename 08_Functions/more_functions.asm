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
    call waitVBlank
    call turnOffLcd

    ; copy first sprites to VRAM
    ld hl, $8300
    ld de, HeroSpriteStart
    ld bc, HeroSpriteEnd - HeroSpriteStart
    call copyToVram

    ; copy second sprite to VRAM
    ld hl, $8300+16
    ld de, SkullSpriteStart
    ld bc, SkullSpriteEnd - SkullSpriteStart
    call copyToVram

    call clearScreen

    ; copy first sprite to screen
    ld hl, vBGMap0
    ld [hl], $30
    
    ; copyt second sprite to screen
    ld hl, vBGMap0+3
    ld [hl], $30+1

    call setDefaultPalette
    call turnOnLcd

.lock
    jr .lock


SECTION "Sprites", ROM0

HeroSpriteStart:
    db $38, $00, $7C, $28
    db $7C, $00, $38, $00
    db $38, $7C, $BA, $BA
    db $00, $28, $28, $28
HeroSpriteEnd:

SkullSpriteStart:
    db $3C, $00, $7E, $00
    db $B7, $6C, $FF, $6C
    db $FF, $00, $FE, $00
    db $7C, $28, $7C, $28
SkullSpriteEnd:


SECTION "Functions", ROM0

waitVBlank:
    ld a, [rLY]
    cp 144
    jr c, waitVBlank
    ret

turnOffLcd:
    xor a ; ld a, 0
    ld [rLCDC], a
    ret
    
turnOnLcd:
    ld a, %10010001
    ld [rLCDC], a
    ret

; this function expects that the starting address
;   is on de and the num of bytes is on bc, and 
;   hl contains the VRAM address to put it
copyToVram:
    ld a, [de]
    ld [hli], a ; ld [hl], a ; inc hl
    inc de
    dec bc
    ld a, b
    or c
    jr nz, copyToVram
    ret

clearScreen:
    ld hl, vBGMap0
.clear
    xor a
    ld [hli], a
    ld a, h
    cp $9C ; screen ends at $9C00
    jr nz, .clear
    ret

setDefaultPalette:
    ld a, %11100100
    ld [rBGP], a
    ret