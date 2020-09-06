; the name of the section doesn't matter
; this section is mandatory
; it needs to start at address $100
SECTION "Entry", ROM0[$100]

    ; this jump is also mandatory
    nop
    jp Start


; the header section is actually created by rgbfix
; but it expects the header section to be filled with zeros
; the "SECTION "Header", ROM0" line is optional
SECTION "Header", ROM0

    ; we could also use "ds $150 - $104", which is common
    ;   in many ROMs, since ds will be filled with the
    ;   value of -p rgbfix argument
    ;   https://rednex.github.io/rgbds/rgbasm.5.html
    REPT $150 - $104
        db 0
    ENDR


; having a section before the start label is mandatory
SECTION "Main", ROM0

; the name of the label doesn't matter 
Start:
