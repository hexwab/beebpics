ULA_MODE_0 = &9C
ULA_MODE_1 = &D8
ULA_MODE_2 = &F4
ULA_MODE_3 = &9C
ULA_MODE_4 = &88
ULA_MODE_5 = &C4
ULA_MODE_6 = &88
ULA_MODE_7 = &4B
ULA_MODE_8 = &E0

BPP=2
WIDTH=416
HEIGHT=288
WIDTH_CHARS=WIDTH*BPP/8
HEIGHT_CHARS=(HEIGHT+7)/8
SCREEN=$7C00-WIDTH*HEIGHT*BPP/8
;	COL0=7-0
;	COL1=7-4
;	COL2=7-1
;	COL3=7-2
	
	org $6b0 ;SCREEN-$60
.start
	lda #19
	jsr $fff4
	ldx #ULA_MODE_1
	stx $fe20
	; clear ACCON; disables shadow screen on both B+ and Master
	lda #0
	sta $fe34
	ldx #15
.loop
	lda crtc,X
	stx $fe00
	cpx #8
	bne notv
	lda $291
.notv
	sta $fe01
	lda pal,X
	sta $fe21
	dex
	bpl loop
.q	bne q
	
.crtc
	equb $7F                                                ; R0 horiz total
	equb WIDTH_CHARS                                        ; R1 horiz displayed
	equb $62+(WIDTH_CHARS-80)/2                             ; R2 horiz sync pos
	equb $28                                                ; R3 horiz sync width
	equb $26                                                ; R4 vert total
	equb $00                                                ; R5 vert total adjust
	equb HEIGHT/8                                           ; R6 vert displayed
	equb $25                                                ; R7 vert sync pos
	equb $00			 			; R8 
	equb $07                                                ; R9 scanlines/char
	equb $20                                                ; R10 cursor start/blink
	equb $08                                                ; R11 cursor end
	equb HI(SCREEN/8)              				; R12 screen address hi
	equb LO(SCREEN/8)              				; R13 screen address lo

.pal
	equb $00+7-COL0
	equb $10+7-COL0
	equb $20+7-COL1
	equb $30+7-COL1
	equb $40+7-COL0
	equb $50+7-COL0
	equb $60+7-COL1
	equb $70+7-COL1
	equb $80+7-COL2
	equb $90+7-COL2
	equb $a0+7-COL3
	equb $b0+7-COL3
	equb $c0+7-COL2
	equb $d0+7-COL2
	equb $e0+7-COL3
	equb $f0+7-COL3
	org SCREEN
	INCBIN "pic.bin"
.end

SAVE "pic", start, end
