vTiles0     EQU $8000
vTiles1     EQU $8800
vTiles2     EQU $9000

vBGMap0     EQU $9800
vBGMap1     EQU $9C00

rLCDC       EQU $FF40

; Scroll coords
; Top-left corner relative to the tilemap
rSCY        EQU $FF42 ; scroll y
rSCX        EQU $FF43 ; scroll x

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
    call setDefaultPalette
    
    xor a
    ld [rSCX], a
    
    call turnOnLcd

.loop
    call waitVBlank
    ld bc, $00FF
.delay
    ld a, b
    or c
    dec bc
    jr nz, .delay

    call incScrollX
    jr .loop


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

setDefaultPalette:
    ld a, %11100100
    ld [rBGP], a
    ret

incScrollX:
    ld a, [rSCX]
    inc a
    ld [rSCX], a
    ret