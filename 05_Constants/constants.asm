; The VRAM is divided into three sections
; Section 0: $8000 - $87FF
; Section 1: $8800 - $8FFF
; Section 2: $9000 - $9FFF
vTiles0     EQU $8000
vTiles1     EQU $8800
vTiles2     EQU $9000

; There are two BG maps
; Map 0: $9800 - $9BFF
; Map 0: $9C00 - $9FFF
vBGMap0     EQU $9800
vBGMap1     EQU $9C00

; LCD Control (LCDC) register
; One byte in order %7654321
; Bit 7 - LCD Display Enable             (0=Off, 1=On)
; Bit 6 - Window Tile Map Display Select (0=9800-9BFF, 1=9C00-9FFF)
; Bit 5 - Window Display Enable          (0=Off, 1=On)
; Bit 4 - BG & Window Tile Data Select   (0=8800-97FF, 1=8000-8FFF)
; Bit 3 - BG Tile Map Display Select     (0=9800-9BFF, 1=9C00-9FFF)
; Bit 2 - OBJ (Sprite) Size              (0=8x8, 1=8x16)
; Bit 1 - OBJ (Sprite) Display Enable    (0=Off, 1=On)
; Bit 0 - BG/Window Display/Priority     (0=Off, 1=On)
rLCDC       EQU $FF40

; LCDC Y Coordinate (LY) register
; LY Indicates which scanline the LCD is currently drawing
;   0-143: current scanline number
; 144-153: VBlank period
rLY         EQU $FF44

; Background Palette (BGP)
; Divided into four parts of 2 bits each: %33221100
; The lower two bits specify color #0
; The next two specify color #1, and so on...
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

    ; load sprite into VRAM
    ld hl, vTiles1
    ld de, MoustacheSpriteStart
    ld bc, MoustacheSpriteEnd - MoustacheSpriteStart
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
    ld [hl], $80

    ; set palette
    ld a, %11100100
    ld [rBGP], a

    ; turn on lcd
    ld a, %10010001
    ld [rLCDC], a

.lock
    jr .lock


SECTION "Moustache", ROM0

MoustacheSpriteStart:
    INCBIN "moustache.bin"
MoustacheSpriteEnd: