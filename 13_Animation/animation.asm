vTiles0     EQU $8000
vTiles1     EQU $8800
vTiles2     EQU $9000

vBGMap0     EQU $9800
vBGMap1     EQU $9C00

; OAM address
OAMRAM      EQU $FE00 ; $FE00 -> $FE9F

; Input register
rINP        EQU $FF00

rLCDC       EQU $FF40

rLY         EQU $FF44
rBGP        EQU $FF47
rOBP0       EQU $FF48
rOBP1       EQU $FF49


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
    call setDefaultPalette
    
    ; copy sprite to VRAM
    ld hl, $8800
    ld de, BgTileStart
    ld bc, BgTileEnd - BgTileStart
    call copyToVram

    ld hl, $8300
    ld de, SpriteStart
    ld bc, SpriteEnd - SpriteStart
    call copyToVram
    
    ld b, $80
    call fillScreen

    call clearOam

    ld a, $48
    ld [$FE00], a ; $FE00 = sprite X position
    ld a, $54
    ld [$FE01], a ; $FE01 = sprite X position
    ld a, $30
    ld [$FE02], a ; $FE02 = sprite index (tile number)
    ld a, $00
    ld [$FE03], a ; $FE00 = attribute flags byte

    call turnOnLcd

.mainLoop
    call waitVBlank

    ; update sprite index
    ; note that the index range is ($30..$35)
    ld a, [$FE02]
    inc a
    cp $36
    jr nz, .updateSpriteIndex ; if still in the range, continue
    ld a, $30 ; else, i.e. is past the last index, restart
.updateSpriteIndex
    ld [$FE02], a

    ld bc, $5FFF
.delay
    ld a, b
    or c
    dec bc
    jr nz, .delay

    jr .mainLoop


SECTION "Sprites", ROM0

SpriteStart:
    INCBIN "coin.bin"
SpriteEnd:

BgTileStart:
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
    db $00, $00, $00, $00
BgTileEnd:


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
    ld a, %10010011
    ld [rLCDC], a
    ret

setDefaultPalette:
    ld a, %11100100
    ld [rBGP], a
    ld [rOBP0], a
    ret

copyToVram:
    ld a, [de]
    ld [hli], a ; ld [hl], a ; inc hl
    inc de
    dec bc
    ld a, b
    or c
    jr nz, copyToVram
    ret

; fill the screen with the tile at address in register b
fillScreen:
    ld hl, vBGMap0
.clear
    ld a, b
    ld [hli], a
    ld a, h
    cp $9C ; screen ends at $9C00
    jr nz, .clear
    ret

clearOam:
    ld hl, OAMRAM
.clear
    xor a
    ld [hli], a
    ld a, h
    cp $FF ; OAMRAM ends at $FF00
    jr nz, .clear
    ret
