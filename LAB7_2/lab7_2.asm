.include "m8535def.inc"
.def Acc0=R20
.def Acc1 = R19
.def Acc2 = R18
.def Acc3 = R17

.org 0
  	rjmp Reset
.org 6
	rjmp Timer
.org 20

Reset:
	ldi Acc0, HIGH(RAMEND)
	out SPH, Acc0
	ldi Acc0, LOW(RAMEND)
	out SPL, Acc0

	rcall Init_ADC
	rcall Init_timer
	rcall Init_indicator
	sei
;------------------------------

Loop:
	rjmp Loop


Timer:
in R16,ADCH 
ldi Acc3,0
ldi R22, 5.54
mul R16, R22
mov r21,r0
mov r23,r1
ldi Acc2, 0b11000000
rcall Send_indicator
ldi Acc2, 0b11111000
rcall Send_indicator
clc
subi r21,0b10111100
sbci r23,0b00000010


;L1:
; r21, 100
;brlo L2
;subi r21, 100
;inc Acc3
;rjmp L1

;L2:
;rcall L5
;ldi R17, 0

L3: 
cpi R21, 10
brlo L4
subi R21, 10
inc Acc3
rjmp L3

L4:
rcall L5
ldi Acc3, 0
mov Acc3, R21
rcall L5
reti


L5: 
nine:
cpi Acc3,9
brne eight
ldi Acc2, 0b10010000
rcall Send_indicator
ret

eight:
cpi Acc3,8
brne seven
ldi Acc2, 0b10000000
rcall Send_indicator
ret

seven:
cpi Acc3,7
brne six
ldi Acc2, 0b11111000
rcall Send_indicator
ret

six:
cpi Acc3,6
brne five
ldi Acc2, 0b10000010
rcall Send_indicator
ret

five:
cpi Acc3,5
brne four
ldi Acc2, 0b10010010
rcall Send_indicator
ret

four:
cpi Acc3,4
brne three
ldi Acc2, 0b10011001
rcall Send_indicator
ret

three:
cpi Acc3,3
brne two
ldi R18, 0b10110000
rcall Send_indicator
ret

two:
cpi Acc3,2
brne one
ldi Acc2, 0b10100100
rcall Send_indicator
ret

one:
cpi Acc3,1
brne zero
ldi Acc2, 0b11111001
rcall Send_indicator
ret

zero:
ldi Acc2, 0b11000000
rcall Send_indicator
ret

;------------------------------------


Send_indicator:
	ldi Acc0, 0
Send_loop:
	inc Acc0
	lsl Acc2
	brcc Send_zero
Send_one:
	sbi PORTC,1
	rjmp Strobe
Send_zero:
	cbi PORTC,1
Strobe:
	cbi PORTC,0
	nop
	sbi PORTC,0
	nop
	cpi Acc0, 8
	brne Send_loop
	ret



;--------------------------------------------

Init_timer:
	ldi Acc0, 0b00000000
	out TCCR1A, Acc0
	ldi Acc0, 0b00001101 
	out TCCR1B, Acc0
	ldi Acc0, 0b00000010
	out OCR1AH, Acc0 
	ldi Acc0, 0b10001011
	out OCR1AL, Acc0 
	ldi Acc0, 0b00010000
	out TIMSK, Acc0 
	ret


Init_indicator:
	clr Acc0
	ldi Acc0, 0b00000011
	out DDRC, Acc0
	ret

Init_ADC:
	clr Acc0
	ldi Acc0,0b00100001
	out	ADMUX, Acc0		
	ldi	Acc0, 0b11101000
	out ADCSRA, Acc0
	in 	Acc1, SFIOR
	ldi Acc0, 0b00000000
	and Acc0, Acc1
	out SFIOR, Acc0
	ret
