.include "m8535def.inc"

.def Acc0 = r16

.org 0x0
	rjmp Reset

.org 0x006 
	rjmp Timer1CompA

.org 0x007
	rjmp Timer1CompB

.org 0x15

;==========================
Reset:
	;инициализация стека
	ldi Acc0, LOW(Ramend)
	out SPL, Acc0
	ldi Acc0, HIGH(Ramend)
	out SPH, Acc0
	rcall Init_ports
	rcall Init_Timer1

;==========================

Timer1CompA:
	cbi PORTD,4
	reti
;==========================

Timer1CompB:
	sbi PORTD,4
	reti
;==========================
Loop:
	rcall Proverka
	cpi Acc0, 34 ;если регистр равен 34,то звучит нота си
	rjmp C
	cpi Acc0, 36
	rjmp C_sharp
	cpi Acc0, 38
	rjmp D
	cpi Acc0, 40
	rjmp D_sharp
	cpi Acc0, 44
	rjmp E
	cpi Acc0, 46
	rjmp F
	cpi Acc0, 48
	rjmp F_sharp
	cpi Acc0, 50
	rjmp G
	cpi Acc0, 54
	rjmp G_sharp
	cpi Acc0, 58
	rjmp A
	cpi Acc0, 60
	rjmp A_sharp
	cpi Acc0, 64
	rjmp H
	clr Acc0
	rjmp Loop   
	

;==========================
;запись в регитры конкретных значений частоты , для конкретной ноты
C:

	out OCR1AL, Acc0 ;задаём частоту
	ldi Acc0, 17  
	out OCR1BL, Acc0  ;задаём громкость
	ret

C_sharp:

	out OCR1AL, Acc0 ;задаём частоту
	ldi Acc0, 18
	out OCR1BL, Acc0  ;задаём громкость
	ret

D:
	
	out OCR1AL, Acc0 ;задаём частоту
	ldi Acc0, 19
	out OCR1BL, Acc0  ;задаём громкость
	ret

D_sharp:

	out OCR1AL, Acc0 ;задаём частоту
	ldi Acc0, 20
	out OCR1BL, Acc0  ;задаём громкость
	ret

E:
	
	out OCR1AL, Acc0 ;задаём частоту
	ldi Acc0, 22
	out OCR1BL, Acc0  ;задаём громкость
	ret

F:

	out OCR1AL, Acc0 ;задаём частоту
	ldi Acc0, 23
	out OCR1BL, Acc0  ;задаём громкость
	ret

F_sharp:

	out OCR1AL, Acc0 ;задаём частоту
	ldi Acc0, 24
	out OCR1BL, Acc0  ;задаём громкость
	ret
G:

	out OCR1AL, Acc0 ;задаём частоту
	ldi Acc0, 25
	out OCR1BL, Acc0  ;задаём громкость
	ret

G_sharp:
	
	out OCR1AL, Acc0 ;задаём частоту
	ldi Acc0, 27
	out OCR1BL, Acc0  ;задаём громкость
	ret

A:
	
	out OCR1AL, Acc0 ;задаём частоту
	ldi Acc0, 29
	out OCR1BL, Acc0  ;задаём громкость
	ret
A_sharp:
	
	out OCR1AL, Acc0 ;задаём частоту
	ldi Acc0, 30
	out OCR1BL, Acc0  ;задаём громкость
	ret

H:
	
	out OCR1AL, Acc0 ;задаём частоту
	ldi Acc0, 32
	out OCR1BL, Acc0  ;задаём громкость
	ret


;==========================
	
Init_Timer1:
	ldi Acc0, 0b00000000 ;задаём режим CTC
	out TCCR1A, Acc0
	ldi Acc0, 0b00001010 ;0,1и2  бит задаём делитель восьмёрку
	out TCCR1B, Acc0
	ldi Acc0, 0b00000000
	out TCNT1H, Acc0       ;регистр счёта
	ldi Acc0, 0b00000000
	out TCNT1L, Acc0
	ldi Acc0, 0b00011000
	out TIMSK, Acc0
	ret

;==========================


Init_Ports:	
	
	;инициализfция порта динамика на вывод
	sbi DDRD,5
	;инициализация портов (под строки) на вывод
	sbi DDRB,7
	sbi DDRB,4
	sbi DDRB,5
	sbi DDRB,6
	;инициализация портов (под столбцы) на ввод
	cbi DDRD,5
	cbi DDRD,6
	cbi DDRD,7


;==========================


Proverka:
		;проверяем первую строку
		;активируем первую строку
		cbi PORTB,7
		sbi PORTB,4
		sbi PORTB,5
		sbi PORTB,6
		
		nop
		;читаем значение столбцов
		sbis PIND,5
		ldi Acc0,34
		sbis PIND,6
		ldi Acc0,36
		sbis PIND,7
		ldi Acc0,38
;============		
		;проверяем вторую строку
		;активируем вторуюю строку
		sbi PORTB,7
		cbi PORTB,4
		sbi PORTB,5
		sbi PORTB,6
		
		nop
		;читаем значение столбцов
		sbis PIND,5
		ldi Acc0,40
		sbis PIND,6
		ldi Acc0,44
		sbis PIND,7
		ldi Acc0,46
		
;============
		;проверяем третью строку
		;активируем третью строку
		sbi PORTB,7
		sbi PORTB,4
		cbi PORTB,5
		sbi PORTB,6

		nop
		;читаем значение столбцов
		sbis PIND,5
		ldi Acc0,48
		sbis PIND,6
		ldi Acc0,50
		sbis PIND,7
		ldi Acc0,54
	
;============
		;проверяем четвертую строку
		;активируем четвертую строку
		sbi PORTB,7
		sbi PORTB,4
		sbi PORTB,5
		cbi PORTB,6

		nop
		;читаем значение столбцов
		sbis PIND,5
		ldi Acc0,58
		sbis PIND,6
		ldi Acc0,60
		sbis PIND,7
		ldi Acc0,64
		ret	

;=============================
