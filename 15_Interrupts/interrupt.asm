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

; Scroll coords
; Top-left corner relative to the tilemap
rSCY        EQU $FF42 ; scroll y
rSCX        EQU $FF43 ; scroll x

rLY         EQU $FF44
rBGP        EQU $FF47
rOBP0       EQU $FF48
rOBP1       EQU $FF49

; variable to hold the current scroll values
; $C000 is the first address of Work RAM
scxValue    EQU $C000
scyValue    EQU $C001

vBlankFlag  EQU $C002


SECTION "VBlank Interrupt", ROM0[$0040]
    ld hl, vBlankFlag
    ld [hl], $01
    reti


SECTION "Entry", ROM0[$100]
    nop
    jp Start

REPT $150 - $104
    db 0
ENDR


SECTION "Main", ROM0

Start:
    call enableInterrupts
    call waitVBlank
    call turnOffLcd
    call setDefaultPalette
    
    ; initialize scroll variable
    ld a, $2E
    ld [scxValue], a
    ld [scyValue], a

    ; reset the scrolls
    xor a
    ld [rSCX], a
    ld [rSCY], a
    
    ; copy sprite to VRAM
    ld hl, $8800
    ld de, BlackTileStart
    ld bc, BlackTileEnd - BlackTileStart
    call copyToVram

    ld hl, $8300
    ld de, CursorSpriteStart
    ld bc, CursorSpriteEnd - CursorSpriteStart
    call copyToVram
    
    ld b, $80
    call fillScreen

    call clearOam

    ld a, [scxValue]
    ld [$FE00], a
    ld a, [scxValue]
    ld [$FE01], a
    ld a, $30
    ld [$FE02], a
    ld a, $00
    ld [$FE03], a

    call turnOnLcd

.mainLoop
    halt
    xor a
    cp a, [hl] ; hl = vBlankFlag after the interruption
    jr z, .mainLoop
    call waitVBlank
    call handleInput
    jr .mainLoop


SECTION "Sprites", ROM0

CursorSpriteStart:
    db $C3, $00, $E7, $00
    db $7E, $00, $3C, $00
    db $3C, $00, $7E, $00
    db $E7, $00, $C3, $00
CursorSpriteEnd:

BlackTileStart:
    db $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF
    db $FF, $FF, $FF, $FF
BlackTileEnd:


SECTION "Functions", ROM0

enableInterrupts:
    di
    ld a, %00000001  ; only vblank
    ld [$FFFF], a
    reti ; ei ; ret

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

incScrollX:
    ld a, [scxValue]
    ld [$FE01], a
    ld a, [scxValue]
    inc a
    ld [scxValue], a
    ret
    
decScrollX:
    ld a, [scxValue]
    ld [$FE01], a
    ld a, [scxValue]
    dec a
    ld [scxValue], a
    ret
    
incScrollY:
    ld a, [scyValue]
    ld [$FE00], a
    ld a, [scyValue] 
    inc a
    ld [scyValue], a
    ret
    
decScrollY:
    ld a, [scyValue]
    ld [$FE00], a
    ld a, [scyValue] 
    dec a
    ld [scyValue], a
    ret

; @param b contains the set directional button
getInput:
    ld a, %00100000
    ld [rINP], a
    ld a, [rINP]
    ld a, [rINP] ; debouncing
    ld a, [rINP] ; debouncing
    cpl
    and %00001111
    ld b, a
    ret

handleInput:
    call getInput

    ; check if right key was pressed
    ld a, b
    and %00000001 
    call nz, incScrollX
    
    ; check if left key was pressed
    ld a, b
    and %00000010 
    call nz, decScrollX

    ; check if up key was pressed
    ld a, b
    and %00000100 
    call nz, decScrollY

    ; check if down key was pressed
    ld a, b
    and %00001000 
    call nz, incScrollY
    
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
