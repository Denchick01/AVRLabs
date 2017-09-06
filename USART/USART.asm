.include "m8535def.inc"
.def Acc0   = r16
.def Acc1   = r17
.def cicl   = r18
.def cicl1  = r20
.def cicl2  = r21
.def cicl3  = r22
.def cicl4  = r23
.def cicl5  = r24
;Вектора прерывания 
.org 0x0
	rjmp Reset
	reti	
	reti	
	reti	
	reti
	reti	
	reti	
	reti	
	reti	
	reti
	reti	
	reti	
	reti	
	reti	
	reti	
	reti	
	reti	
	reti	
	reti	
	reti	
	reti
.org 0x15

Reset:
	;Инициализация стека
	ldi Acc0, LOW(Ramend)
	out SPL, Acc0
	ldi Acc1, HIGH(Ramend)
	out SPH, Acc1
	rcall Init_ports
;	rcall Clear
LOOP:
	;Установливаем на PB4 "0", на всех остальных 1
	ldi Acc0, 0b11101111
	out PORTB, Acc0
	in Acc0, PIND			;Считываем значения с порта D
	ldi Acc1, 0b11011111
	cp Acc1, Acc0	    	;Проверяем 0 в 5 бите, если да, то переходим на подпрограмму One
	breq One

	ldi Acc1, 0b10111111
	cp Acc1, Acc0 			;Аналогично с 6 и 7 битами
	breq Two

	ldi Acc1, 0b01111111
	cp Acc1, Acc0
	breq Three

	;Установливаем на PB5 "0", на всех остальных 1
	ldi Acc0, 0b11011111
	out PORTB, Acc0
	in Acc0, PIND			;Считываем значения с порта D	
	ldi Acc1, 0b11011111
	cp Acc1, Acc0
	breq Four

rjmp LOOP
rjmp Reset
;--------------------------------------
Init_ports: 
	ldi Acc0, 0b00110000
	out DDRB, Acc0 			; Конфигурируем PB4, PB5 на выход
	ldi Acc0, 0b11100000
	out DDRD, Acc0 			; Конфигурируем PD7, PD6, PD5 на вход
	ldi Acc0, 0b11100000
	out PORTD, Acc0			; Конфигурируем PD7, PD6, PD5  pull-up activated
	ldi Acc0, 0b00000011
	out DDRC, Acc0			; Конфигурируем PC0, PC1 на выход
	ret
;--------------------------------------
Clear:
	ldi cicl5, 8
clear_loop:
	sbi PORTC, 2
	dec cicl5
	brne clear_loop
	ret
	
;--------------------------------------
One:
;metka:
	
	sbi PORTC, 1
	cbi PORTC, 1
	ret
;--------------------------------------
Two:
	ret
;--------------------------------------
Three:
	ret
;--------------------------------------
Four:
	ret
;--------------------------------------
;Подпрограмма задержки
Delay:
	ldi cicl3, 10
delay_loop2:
	dec cicl3
	BREQ delay_loop1
	ldi cicl4, 100
delay_loop3:
	dec cicl4
	BREQ delay_loop2
	ldi cicl2, 255
delay_loop:
	dec cicl2
	BRNE delay_loop
	rjmp delay_loop3
delay_loop1:
	ret
;--------------------------------------
