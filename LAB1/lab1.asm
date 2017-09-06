.include "m8535def.inc" 

.def Acc0   =r16 
.def Acc1   =r17 
.def count  =r18 
.def cycl1  =r19
.def cycl2  =r20
.def cycl3  =r21
.def cycl4  =r22
.org 0x00 
rjmp RESET 
.org 0x15
RESET: 

;Инициализация стека
ldi Acc0, LOW(RAMEND) 
out SPL, Acc0 
ldi Acc0, HIGH(RAMEND) 
out SPH, Acc0 

;Инициализация портов
sbi DDRB,6
sbi DDRB,3 
sbi DDRD,4 
sbi PORTB,3
sbi	PORTD,4
sbi	PORTD,6

;Ожидание нажатия клавиши
LOOP:
cbi PORTB,6
sbis PIND,6          
rcall key5_is_pressed
rjmp LOOP

;Клавиша пять была нажата
key5_is_pressed:
inc count
sbrs count,1
rjmp end_key5_is_pressed
rcall flashing
clr count
end_key5_is_pressed:
rcall waiting
ret

;Зажечь диоды
flashing:
CLZ
ldi cycl1,3
cycl:
cbi PORTB,3
cbi	PORTD,4
rcall Delay
sbi PORTB,3
sbi	PORTD,4
rcall Delay
dec cycl1
BRNE cycl
ret

;Ждать пока кнопка не будет отпущена
waiting:
sbis PIND,6
rjmp waiting
ret

;Подпрограмма задержки
Delay:
CLC
ldi cycl4, 5
ldi cycl3, 100
D1:
ldi cycl2, 255
D2:
subi cycl2,1
BRCC D2
sbci cycl3,0
BRCC D1
sbci cycl4,0
BRCC D1
CLC
ret


