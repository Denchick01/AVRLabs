.include "m8535def.inc"
.def Acc0=r16
.def adc4=r17
.def adc5=r18
.def seladmux=r19
.def cycl=r20
.def cycl1=r21
.def cycl2=r22
.def numdata=r23
.def sam1=r24
.def sam2=r25
.def cycl3=r26
.org 0x0
	rjmp Reset
	reti	
	reti	
	reti	
	reti
	reti	
	reti	
	reti	
	rjmp Timer_Overflow
	reti
	reti	
	reti	
	reti	
	reti	
	rjmp ADC_Complete	
	reti	
	reti	
	reti	
	reti	
	reti	
	reti
	.org 0x15
Data:
;.DB 0b10001000,0b11000000,0b11000110,0b10001000;ADC4
;.DB 0b10001000,0b11000000,0b11000110,0b10001000;ADC5
.DB 0b10001000,0b11000000,0b11000110,0b10011001 ;ADC4
.DB 0b10001000,0b11000000,0b11000110,0b10010010 ;ADC5
RESET: 

;---------------------Инициализация стека-------------
ldi Acc0, LOW(RAMEND) 
out SPL, Acc0 
ldi Acc0, HIGH(RAMEND) 
out SPH, Acc0 

;---------------------Инициализация РОН---------------------
ldi seladmux,0b01100100

;---------------------Инициализация портов------------------
sbi DDRC,0 
sbi DDRC,1 

;---------------------Инициализация таймера счетчика--------
ldi Acc0, 0b00000000 
out TCCR1A, Acc0
ldi Acc0, 0b00000001;4MHz 0,1мс
out TCCR1B, Acc0
ldi Acc0, LOW(40000)
out TCNT1L, Acc0
ldi Acc0, HIGH(40000)
out TCNT1H, Acc0
ldi Acc0, 0b00000100
out TIMSK, Acc0

;---------------------Инициализация АЦП---------------------
out ADMUX, seladmux
ldi Acc0,0b10101011; 500КHz 2мкс
out ADCSRA,Acc0
ldi Acc0,0b11000000
out SFIOR,Acc0
sei

;---------------------Основной цикл-------------------------
LOOP:
rjmp LOOP

;---------------------Прерывание по таймеру-----------------
Timer_Overflow:
ldi Acc0, LOW(40000)
out TCNT1L, Acc0
ldi Acc0, HIGH(40000)
out TCNT1H, Acc0
reti

;---------------------Прерывание по АЦП---------------------
ADC_Complete:
CLI
rcall sampling
inc cycl3
CLC
CPI cycl3,100
BRLO END_ADC_Complete
clr cycl3

CLC
CPI cycl1,1	
BRCC setadc5
;---------------------Запись занчения с порта ADC4 в ОЗУ----	
mov adc4,sam2
clr sam2
inc cycl1
rcall compare
rcall Change_Admux
rjmp END_ADC_Complete
;---------------------Запись занчения с порта ADC5 в ОЗУ----
setadc5:
mov adc5,sam2
clr sam2
dec cycl1
rcall compare
rcall Change_Admux

END_ADC_Complete:
SEI
reti

;---------------------Смена линии---------------------------
Change_Admux:
CLC
CPI seladmux,0b01100101
BRCC clradmux
inc seladmux
out ADMUX, seladmux
rjmp end
clradmux:
dec seladmux
out ADMUX, seladmux
end:
ret


;---------------------Cравнение входных сигналов -----------
compare:
CLC
CP adc5,adc4
BRLO ADC4on7SEG ;если знаение adc4>adc5, то вывод "ADC4"
ldi ZL, LOW(Data*2+4)
ldi ZH, HIGH(Data*2+4)
rcall indicator
rjmp END_compare
ADC4on7SEG:
ldi ZL, LOW(Data*2)
ldi ZH, HIGH(Data*2)
rcall indicator
END_compare:
ret


;---------------------Вывод на семисегментный индикатор-----
indicator:
CLI
clz
ldi cycl2,4
CICL2:
nop
LPM numdata, Z+
LDI cycl,8
CICL1:
CBI PORTC,0	;подает 0 на CLK
CBI PORTC,1
SBRC numdata,0 ;проверяет нулевой бит, если он равен 0 то следущая команда пропускается
SBI PORTC,1 ;подает на первый пин порта C логический 1
NOP
SBI PORTC,0 ;подает фронт на CLK
LSR numdata ;смещение вправо на 1 бит
DEC cycl
BRNE CICL1
DEC cycl2
BRNE CICL2 ;Ввод следующий цифры
SEI
ret

;---------------------Выбор максимальной амплитуды----------
sampling:
in sam1,ADCH
CLC
CP sam1,sam2
BRLO end_sampling
mov sam2,sam1
end_sampling:
ret
