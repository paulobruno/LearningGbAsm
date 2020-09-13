vTiles0     EQU $8000
vTiles1     EQU $8800
vTiles2     EQU $9000

vBGMap0     EQU $9800
vBGMap1     EQU $9C00

rLCDC       EQU $FF40
rLY         EQU $FF44
rBGP        EQU $FF47


; the file included will be processed and 
; then added to the current file
; this will effectively copy the content of 
; the included file into the current one
INCLUDE "charmap.asm"


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
    ld de, TextString
.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a ; copy until find 0
    jr nz, .copyString

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
    INCBIN "fonts/alphanum_compact.bin"
FontEnd:


SECTION "TextString", ROM0

; we use 0 as the 'end of string' character
TextString:
    db "HELLOWORLD123", 0