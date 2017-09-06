.include "m8535def.inc" 

.def Acc0      = r16 
.def Acc1      = r17 
.def Key       = r18 
.def number1   = r19 
.def number2   = r20
.def cycl      =r21
.def firstpress=r22
.def cicl2     =r23
.def cicl3     =r24
.def cicl4     =r25
.org 0x00 
rjmp RESET 
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
RESET: 

;----------------Инициализация стека-----------------
ldi Acc0, LOW(RAMEND) 
out SPL, Acc0 
ldi Acc0, HIGH(RAMEND) 
out SPH, Acc0 

;----------------Инициализация портов----------------
ldi Acc1, 0xF0
out DDRB, Acc1
sbi DDRB,3 
sbi DDRD,4 
sbi PORTB,3
sbi	PORTD,4
sbi	PORTD,5
sbi	PORTD,6
sbi	PORTD,7


LOOP:
rcall Keyboard
rjmp LOOP

;-----------------Опрос клавиатуры--------------------

Keyboard:
;---------------------Строка 4---------------------------- 
	sbi PORTB,7
	sbi PORTB,6
	sbi PORTB,5
	cbi PORTB,4
nop
sbis PIND,6          
rcall KeyFound
inc Key
;---------------------Строка 1---------------------------- 
	cbi PORTB,7
	sbi PORTB,6
	sbi PORTB,5
	sbi PORTB,4
nop
sbis PIND,5          
rcall KeyFound
inc Key
sbis PIND,6          
rcall KeyFound
inc Key
sbis PIND,7          
rcall Keyfound
inc Key
;---------------------Строка 2----------------------------
	sbi PORTB,7
	cbi PORTB,6
	sbi PORTB,5
	sbi PORTB,4
nop
sbis PIND,5          
rcall KeyFound
inc Key
sbis PIND,6          
rcall KeyFound
inc Key
sbis PIND,7          
rcall Keyfound
inc Key
;---------------------Строка 3----------------------------
	sbi PORTB,7
	sbi PORTB,6
	cbi PORTB,5
	sbi PORTB,4
nop
sbis PIND,5          
rcall KeyFound
inc Key
sbis PIND,6          
rcall KeyFound
inc Key
sbis PIND,7          
rcall Keyfound
clr  Key
ret

;--------------------Чтение с клавиатуры------------------
KeyFound:
mov number1,number2
mov number2,Key
rcall comparison
ret

;-----------Сравнение чисел--------------
comparison:
CLC
CP  number1,number2 
BRLO condition_done
;------------------Потушить диод------------
sbi PORTB,3
sbi	PORTD,4
rjmp end_comparison
;--------------------Зажечь диод------------------
condition_done:
rcall LEDon
end_comparison:
ret


;------------------------Мигать диодом--------------
LEDon:
CLZ
ldi cycl,3
CICL1:
cbi PORTB,3
cbi	PORTD,4
rcall Delay
sbi PORTB,3
sbi	PORTD,4
rcall Delay
dec cycl
BRNE CICL1
ret

;------------------Подпрограмма задержки---------------
Delay:
CLZ
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

