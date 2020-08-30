; VRAM start address
_VRAM       EQU $8000 ; $8000->$9FFF

; %7654321
; bit 7: LCD on/off
rLCDC       EQU $FF40

; Scroll coords
; Top-left corner relative to the tilemap
rSCY        EQU $FF42 ; scroll y
rSCX        EQU $FF43 ; scroll x

; LY address indicates which scanline the LCD is currently drawing
;   0-143: current scanline number
; 144-153: VBlank period
rLY         EQU $FF44 

; Background palette
; Divided into four parts of 2 bits each: %33 22 11 00
; The lower two bits specify color #0
; the next two specify color #1, and so on...
rBGP        EQU $FF47

; Writing 0 in NR52 disables sound
rNR52       EQU $FF26


SECTION "Header", ROM0[$100]

EntryPoint:
    di ; disable interrupts
    jp Start

REPT $150 - $104
    db 0
ENDR


SECTION "Game code", ROM0

Start:
    ; turn off the LCD
.waitVBlank
    ld a, [rLY] ; LY register address
    cp 144 ; compare with 144 (0-143 = drawing/notVBlanking, 144-153 = not drawing/vblaking
    jr c, .waitVBlank ; if less than 144 keep checking

    xor a ; ld a, 0
    ld [rLCDC], a

    ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles
.copyFont
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .copyFont

    ld hl, $9800
    ld de, HelloWorldStr
.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a
    jr nz, .copyString

    ld a, %11100100
    ld [rBGP], a
    
    xor a
    ld [rSCY], a
    ld [rSCX], a

    ld [rNR52], a

    ld a, %10000001
    ld [rLCDC], a
.lockup
    jr .lockup


SECTION "Font", rom0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:


SECTION "HelloWorld string", rom0

HelloWorldStr:
    db "Hello World!", 0