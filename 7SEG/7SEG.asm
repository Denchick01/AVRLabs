.include "m8535def.inc"
;инициализация РОН
.def Acc0   = r16
.def Acc1   = r17
.def cicl   = r18
.def cicl1  = r20
.def cicl2  = r21
.def cicl3  = r22
.def cicl4  = r23
.def button = r24

;Вектора прерывания 
.org 0x0
	rjmp Reset

.org 0x15
Data:
.DB 0b11111001,0b11000000
;.DB 0x9F,0x3

Reset:
;инициализация стека
	ldi Acc0, LOW(Ramend)
	out SPL, Acc0
	ldi Acc1, HIGH(Ramend)
	out SPH, Acc1
;инициализация РОН
	ldi Acc0, 0xD0
	out DDRB, Acc0  ;пины 4...7 порта B открыты на выход
	ldi Acc1, 0x3
	out DDRC, Acc1 ;пины 1...2 порта С открыты на выход
	ldi ZL, LOW(Data*2)
	ldi ZH, HIGH(Data*2) ;загрузка символов для семисегментного идикатора
	ldi Acc0, 0x70
	out PORTB, Acc0
	LDI cicl1,2

Point1:
    sbis PIND,7
	rcall Delay
    rcall Delay
	LPM r19, Z+ ;загрузка данных цифры в r18
	LDI cicl,8
LOOP:
	CBI PORTC,0	
	CBI PORTC,1
	SBRC r19,0 ;проверяет нулевой бит, если он равен 0 то следущая команда пропускается
	SBI PORTC,1 ;подает на первый пин порта C логический 1
	NOP
	SBI PORTC,0 ;подает фронт на CLK
	LSR r19   ;смещение вправо на 1 бит
	DEC cicl
	BRNE LOOP
	DEC cicl1
	BRNE Point1 ;Ввод следующий цифры
    rjmp Reset



;Подпрограмма задержки
Delay:
	ldi cicl3, 20
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
