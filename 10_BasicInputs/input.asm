vTiles0     EQU $8000
vTiles1     EQU $8800
vTiles2     EQU $9000

vBGMap0     EQU $9800
vBGMap1     EQU $9C00

; Input register
; https://youtu.be/ecTQVa42sJc?t=378
rINP        EQU $FF00

rLCDC       EQU $FF40

; Scroll coords
; Top-left corner relative to the tilemap
rSCY        EQU $FF42 ; scroll y
rSCX        EQU $FF43 ; scroll x

rLY         EQU $FF44
rBGP        EQU $FF47

; variable to hold the current scroll values
; $C000 is the first address of Work RAM
scxValue    EQU $C000
scyValue    EQU $C001


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
    call clearScreen
    
    ; initialize scroll variable
    xor a
    ld [scxValue], a
    ld [scyValue], a

    ; reset the scrolls
    ld [rSCX], a
    ld [rSCY], a
    
    ; copy sprite to VRAM
    ld hl, $8300
    ld de, BallSpriteStart
    ld bc, BallSpriteEnd - BallSpriteStart
    call copyToVram
    
    ld hl, $9909
    ld [hl], $30

    call turnOnLcd

.mainLoop
    call waitVBlank
    call handleInput
    jr .mainLoop


SECTION "Sprites", ROM0

BallSpriteStart:
    INCBIN "ball.bin"
BallSpriteEnd:


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

incScrollX:
    ld a, [scxValue]
    ld [rSCX], a
    ld a, [scxValue]
    inc a
    ld [scxValue], a
    ret
    
decScrollX:
    ld a, [scxValue]
    ld [rSCX], a
    ld a, [scxValue]
    dec a
    ld [scxValue], a
    ret
    
incScrollY:
    ld a, [scyValue]
    ld [rSCY], a
    ld a, [scyValue] 
    inc a
    ld [scyValue], a
    ret
    
decScrollY:
    ld a, [scyValue]
    ld [rSCY], a
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
    call nz, decScrollX
    
    ; check if left key was pressed
    ld a, b
    and %00000010 
    call nz, incScrollX

    ; check if up key was pressed
    ld a, b
    and %00000100 
    call nz, incScrollY

    ; check if down key was pressed
    ld a, b
    and %00001000 
    call nz, decScrollY
    
    ret