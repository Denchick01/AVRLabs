.include "m8535def.inc"

.def Acc0   = r16
.def Acc1   = r17
.def clockl = r18
.def clockh = r19
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
;Инициализация портов
	sbi DDRD,4
	sbi 	DDRB,7
	sbi 	DDRB,4
	sbi 	DDRB,5
	sbi 	DDRB,6
	ldi Acc1, 0xE0
	out PIND, Acc1
;Инициализация таймера счетчика
	ldi Acc0, 0b00110010 ; Fast PWM,10-bit 
	out TCCR1A, Acc0
	ldi Acc1, 0b00001001 ; 
	out TCCR1B, Acc1
	ldi Acc1, HIGH(50)
	out OCR1BH, Acc1
	ldi Acc1, LOW(50)
	out OCR1BL, Acc1
;Опрос клавиатуры
keyboard:
clr ZL
clr ZH
; Четвертая строка 
	sbi 	PORTB,7
	sbi 	PORTB,4
	sbi 	PORTB,5
	cbi 	PORTB,6
;Проверка нажатия кнопки (0) 
		sbis PIND,6          
		rjmp duty_cycle
		ADIW ZL,51
; Первая строка 
	cbi 	PORTB,7
	sbi 	PORTB,4
	sbi 	PORTB,5
	sbi 	PORTB,6
;Проверка нажатия кнопки (1-3)
		sbis PIND,5          
		rjmp duty_cycle
		ADIW ZL,51
		sbis PIND,6          
		rjmp duty_cycle
		ADIW ZL,51
		sbis PIND,7          
		rjmp duty_cycle
		ADIW ZL,51
; Вторая строка 
	sbi 	PORTB,7
	cbi 	PORTB,4
	sbi 	PORTB,5
	sbi 	PORTB,6
;Проверка нажатия кнопки (4-6)
		sbis PIND,5          
		rjmp duty_cycle
		ADIW ZL,51
		sbis PIND,6          
		rjmp duty_cycle
		ADIW ZL,51
		sbis PIND,7          
		rjmp duty_cycle
		ADIW ZL,51
; Третья строка 
	sbi 	PORTB,7
	sbi 	PORTB,4
	cbi 	PORTB,5
	sbi 	PORTB,6
;Проверка нажатия кнопки (7-9)
		sbis PIND,5          
		rjmp duty_cycle
		ADIW ZL,51
		sbis PIND,6          
		rjmp duty_cycle
		ADIW ZL,51
		sbis PIND,7          
		rjmp duty_cycle
		ADIW ZL,51
		rjmp keyboard
;Инициализация регистра сравнения
duty_cycle:
	out OCR1BH, ZH
	out OCR1BL, ZL
	rjmp keyboard
