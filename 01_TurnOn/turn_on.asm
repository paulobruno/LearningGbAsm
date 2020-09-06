; nome da secao tanto faz
; ter essa section eh obrigatorio
; precisa comecar em $100
SECTION "Entry", ROM0[$100]

    ; precisa pular pra outra label 
    nop
    jp Start


; the header section is created by rgbfix
; but it expects that the header section is zeroed
; to ensure this, we just add zeros in it
; the "SECTION "Header", ROM0" line is optional;
;   but helps with code organization
SECTION "Header", ROM0

    ; we could also use "ds $150 - $104", which is common 
    ;   is many ROMs, since ds will be filled with the 
    ;   value of -p rgbfix argument
    ;   https://rednex.github.io/rgbds/rgbasm.5.html
    REPT $150 - $104
        db 0
    ENDR


; ter essa section eh obrigatorio
SECTION "Main", ROM0

; label pode ter qualquer nome
Start:
