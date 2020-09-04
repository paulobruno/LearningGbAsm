; VRAM start address
_VRAM       EQU $8000 ; $8000->$9FFF

; Input register
; https://youtu.be/ecTQVa42sJc?t=377
rINP        EQU $FF00

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

vSCX        EQU $C000
vSCY        EQU $C100


SECTION "Header", ROM0[$100]

EntryPoint:
    di ; disable interrupts
    jp Start

REPT $150 - $104
    db 0
ENDR


SECTION "Game code", ROM0

Start:
    call waitVBlank    
    call turnOffLcd
    call copyFontToVRam

    ; initialize SCX
    xor a
    ld [vSCX], a

    call copyStringToWindow
    call initializePalette
    
    call turnOffSound

    xor a
    ld [rSCY], a
    ld [rSCX], a
    
    call turnOnLcd

.mainLoop
    call waitVBlank
    call handleInput

    jr .mainLoop


SECTION "Font", rom0

FontTiles:
INCBIN "font2.chr"
FontTilesEnd:


SECTION "HelloWorld string", rom0

HelloWorldStr:
    db "", 0


waitVBlank:
    ld a, [rLY] ; LY register address
    cp 144 ; compare with 144 (0-143 = drawing/notVBlanking, 144-153 = not drawing/vblaking
    jr c, waitVBlank ; if less than 144 keep checking
    ret

turnOffLcd:
    xor a ; ld a, 0
    ld [rLCDC], a ; turn off LCD
    ret

turnOnLcd:
    ld a, %10000001
    ld [rLCDC], a
    ret

copyFontToVRam:
    ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles
.copyFont
    ld a, [de]
    ld [hli], a ; ld [hl], a ; inc hl
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .copyFont
    ret

copyStringToWindow:
    ld hl, $9800
    ld de, HelloWorldStr
.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a
    jr nz, .copyString
    ret

turnOffSound:
    xor a
    ld [rNR52], a
    ret
    
initializePalette:
    ld a, %11100100
    ld [rBGP], a
    ret

incScrollX:
    ld a, [vSCX]
    ld [rSCX], a
    ld a, [vSCX] 
    inc a
    ld [vSCX], a
    ret
    
decScrollX:
    ld a, [vSCX]
    ld [rSCX], a
    ld a, [vSCX] 
    dec a
    ld [vSCX], a
    ret
    
incScrollY:
    ld a, [vSCY]
    ld [rSCY], a
    ld a, [vSCY] 
    inc a
    ld [vSCY], a
    ret
    
decScrollY:
    ld a, [vSCY]
    ld [rSCY], a
    ld a, [vSCY] 
    dec a
    ld [vSCY], a
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