.include "m8535def.inc"

.def Acc0    = r16
.def Acc1    = r17
.def Acc2    = r18
.def Acc3    = r19
.def Acc4	 = r20
.def Acc5	 = r21
.def Acc6	 = r22
.def Key	 = r23

.org 0x0
	rjmp 	Reset 
	reti	;INT0
	reti	;INT1
	reti	;TIMER2_COMP
	reti    ;TIMER2_OVF
	reti	;TIMER1_CAPT
	reti	;TIMER1_COMPA
	reti	;TIMER1_COMPB
	reti	;TIMER1_OVF
	rjmp	TIMER0_OVF
	reti	;SPI(STC)
	reti	;USART_RXC
	reti	;USART_UDRE
	reti	;USART_TXC
	reti	;ADC_Conversion_Complete
	reti	;EE_RDY
	reti	;ANA_COMP
	reti	;TWI
	reti	;INT2
	reti	;TIMER0_COMP
	reti	;SPM_RDY
.org 0x15

Data:
.DB	"0123456789"
Compl:                 
.DB	"1.Complexity",13
Start:
.DB	"2.Start Game",13
Y_N:
.DB	"1.Yes 2.No",13
Notes:
.DB	"0.C 1.C# 2.D 3.D# 4.F 5.F# 6.G 7.G# 8.A 9.A#",13	
Victory:
.DB	"Victory",13                                         
Losing:
.DB	"Losing",13                                             
Right:
.DB	"Right",13                                                 
Wrong:
.DB	"Wrong",13 		                                          
Not:
.DB 0xDE,0xC3,0xAA,0x92,0x66,0x52,0x3F,0x2D,0x1D,0x0D                     ;478,451,426,402,358,338,319,301,285,269  
;.DB 48,49,50,51,52,53,54,55,56,57 
CR:
.DB 13	                                                                  ;carriage return													                 
.MACRO LDIZ		
    ldi 	@1, LOW(@0)
	ldi 	@2, HIGH(@0)
	ldi 	@3,@4	
.ENDM  
.MACRO LDIX		
    ldi 	@1, LOW(@0)
	ldi 	@2, HIGH(@0)	
.ENDM  
                     	
Reset:
;------------------------------------Инициализация стека---------------------------

	ldi 	Acc0, LOW(RAMEND) 
	out 	SPL, Acc0 
	ldi 	Acc0, HIGH(RAMEND) 
	out 	SPH, Acc0 
;------------------------------------Инициализация портов--------------------------

	sbi 	DDRD,4
	cbi 	DDRD,5
	cbi 	DDRD,6
	cbi 	DDRD,7 
	sbi 	DDRD,0              ;RxD
	cbi 	DDRD,1              ;TxD
	ldi 	Acc0, 0xF0
	out 	DDRB, Acc0
;------------------------------------Инициализация USART---------------------------	

	ldi 	Acc0, 0b00011000
	out 	UCSRB, Acc0	
	ldi 	Acc0, 0b10000110    ;Асинхронный режим 8N1
	out 	UCSRC, Acc0	
	ldi 	Acc0, LOW(25)	    ;4MHz,9600
	out 	UBRRL,Acc0
	ldi 	Acc0, HIGH(25)
	out 	UBRRH,Acc0
;------------------------------------Инициализация таймера счетчика 1 (16-бит)-----

	ldi 	Acc0, 0b00000000    ;CTC  
	out 	TCCR1A, Acc0
	ldi 	Acc0, 0b00001001 
	out 	TCCR1B, Acc0
;------------------------------------Инициализация таймера счетчика 0 (8-бит)------

	ldi 	Acc0, 0b00000101    ;Normal 1024
	out 	TCCR0, Acc0
	ldi 	Acc0, 0b00000001 
	out 	TIMSK, Acc0
	CLI

;************************************Основной цикл*********************************

LOOP:
	rcall 	Menu
	rcall 	Melody
	rcall 	GAME
	rjmp 	LOOP
;------------------------------------Меню-----------------------------------------

Menu:
LDIZ Compl*2,ZL,ZH,Acc6,27
	rcall 	Display 
M1:
	rcall 	Keyboard
	clz 
	cpi 	Key,1
	BRNE 	M2
	rcall 	Complexity
M2:
	clz 
	cpi 	Key,2
	BRNE 	M1
	rcall 	Start_Game
	sbrs 	Acc1,0
	rjmp 	M1
	ret

;------------------------------------Сложность игры-------------------------------

Complexity:
LDIZ Compl*2+2,ZL,ZH,Acc6,11
	rcall 	Display
C1:
	rcall 	Keyboard
	clc 
	CPI 	Key,3		        ;Проверка на нажатие 3-7.
	BRLO 	C1
	clc
	CPI 	Key,8
	BRCC 	C1
LDIX 0x200,XL,XH					;Адрес в ОЗУ
	ST 		X,Key				;Сохраняем сложность
LDIZ Data*2,ZL,ZH,Acc6,1	    ;Выводем выбранное число на экран
	add 	ZL,Key          	
	rcall 	Display
LDIZ CR*2,ZL,ZH,Acc6,1			;Смещение на строку
	rcall 	Display
LDIZ Compl*2,ZL,ZH,Acc6,27
	rcall 	Display
	ret
;-----------------------------------Начать Игру-----------------------------------

Start_Game:
LDIZ Y_N*2,ZL,ZH,Acc6,11
	rcall 	Display
S1:
	rcall 	Keyboard
	clz
	cpi 	Key,2			    ;Да или Нет
	breq 	S2
	cpi 	Key,1
	breq 	S3
	rjmp 	S1
S2:
LDIZ Compl*2,ZL,ZH,Acc6,27
	rcall 	Display
	rjmp 	END_Start_Game 
S3:
	ldi 	Acc1,1
END_Start_Game:
	ret
;-----------------------------------Воспроизведение мелодии------------------------

Melody:
LDIX Not*2,ZL,ZH				;Загрузит ноту
LDIX 0x200,XL,XH 				;Сложность
	LD		Acc1,X
	inc		Acc1
LDIX 0x100,XL,XH   
	in 		Acc5,TCNT0
	andi	Acc5,0b00001111     			    
	ldi		Acc2,1				;Регистр выхода
MM1:
	add    	Acc5,Acc1
	clc
	cpi 	Acc5,10			   	;Проверка номера ноты, если>9, то из регистр смещения вычитается 10
	BRLO 	MM2
	subi  	Acc5,10
	clc
	cpi 	Acc5,10			   	;Проверка номера ноты, если>9, то из регистр смещения вычитается 5
	BRLO 	MM2
	subi  	Acc5,5
MM2:
	rcall 	Melody_On
	clz
	cpi 	Acc2,1
	brne 	END_Melody
	rjmp 	MM1
END_Melody:
	rcall 	Sound_off
	ret
;-----------------------------------Запустить музыку-------------------------------

Melody_On:
	clr		Acc4
	clr 	Acc3
	clr		Acc2
	clz
	dec 	Acc1
	breq   	End_Melody_On
	ST 		X+,Acc5
	add		ZL,Acc5
	;rcall   DDD
	rcall	Soundd
	ldi		Acc2,1
	OUT		TCNT0,Acc4
	SEI
MMM3:             	
	sbrs 	Acc3,0				;Ждем 1 секунду
	rjmp 	MMM3
	CLI
End_Melody_On:
	sub     ZL,Acc5
	ret
;-----------------------------------Игра-------------------------------------------

GAME:
LDIX 0x200,XL,XH				;Адрес в ОЗУ
	LD 		Acc1,X
	inc     Acc1
LDIX 0x100,XL,XH	
	clr		Acc4
	clr     Acc5
LDIZ Notes*2,ZL,ZH,Acc6,46
	rcall 	Display
G1:
	rcall 	Keyboard
LDIZ Not*2,ZL,ZH,Acc3,0			;Воспроизведения выбранной ноты
	add  	ZL, Key
	sei
G2:
	sbrs 	Acc3,0			  	;Ждем 1 секунду
	rjmp 	G2
	rcall	Soundd
	clr 	Acc3
G3:             	
	sbrs 	Acc3,0				;Ждем 1 секунду
	rjmp 	G3
	rcall 	Sound_off
	rcall	Check_nots
	clz
	cpi 	Acc5,8
	breq 	END_GAME_Losing
	cpi 	Acc1,1
	breq 	END_GAME_Victory
	rjmp 	G1
END_GAME_Losing:
LDIZ Losing*2,ZL,ZH,Acc6,7
	rcall 	Display
	rjmp 	END_GAME
END_GAME_Victory:
LDIZ Victory*2,ZL,ZH,Acc6,8
	rcall 	Display
END_GAME:
	ret
;-----------------------------------Проверка Нот-----------------------------------

Check_nots:
	LD		Acc2,X
	clz
	cp		Acc2,Key
	breq 	Right_I
LDIZ Wrong*2,ZL,ZH,Acc6,6
	rcall 	Display	
	inc		Acc5				;Кол-во ошибок
	rjmp	end_check_nots
Right_I:
LDIZ Right*2,ZL,ZH,Acc6,6
	rcall 	Display
	inc     XL
	dec 	Acc1		
end_check_nots:
	ret
;-----------------------------------Воспроизведение мелодии------------------------

Soundd:
	;ldi		Acc0,1		
	;out 	OCR1AH, Acc0	
	;clr		Acc0
	;out		OCR1BH,Acc0
	;LPM 	
	;out 	OCR1AL, r0
	;mov		Acc0,r0
	;LSR		Acc0	
	;ori		Acc0,0b10000000
	;LSR		Acc0
	;LSR		Acc0
	;LSR		Acc0
	;out		OCR1BL,Acc0	

		ldi Acc0, HIGH(10000)
		out OCR1BH, Acc0
		ldi Acc0, LOW(10000)
		out OCR1BL, Acc0
		ldi Acc0, HIGH(25500)
		out ICR1H, acc0
		ldi Acc0, LOW(25500)
		out ICR1L, acc0

	ldi 	Acc0, 0b00010000	;Подать сигнал на пин порта B			
	out 	TCCR1A, Acc0
	ldi 	Acc0, 0b00001101
	out 	TCCR1B, Acc0
	sei
	ret
;-----------------------------------Вывод через интерфейс USART--------------------

Display:
	CLC
	CLZ
	LPM 	Acc0,Z+
uart_txd:
	sbis 	UCSRA,UDRE			;Флага готовности
	rjmp 	uart_txd 
	out	 	UDR, Acc0
	dec  	Acc6
	BRNE 	Display	
	ret			
;-----------------------------------Опрос клавиатуры-------------------------------

Keyboard:
	cbi 	PORTB,7				;Подача нуля на все строки клавиатуры
	cbi 	PORTB,6
	cbi 	PORTB,5
	cbi 	PORTB,4
	sbi		PORTD,7
	sbi		PORTD,6
	sbi		PORTD,5
	in 		Acc0,PIND       	;Чтение состояния строк
	ori 	Acc0,0b00011111
	CLC; 
	cpi 	Acc0,0b11111111 
	BRLO 	Keyboard      		;Ждать пока клавиша будет не нажата
Keysel:
;-----------------------------------Строка 4--------------------------------------- 

	clr  	Key
	sbi 	PORTB,7
	sbi 	PORTB,4
	sbi 	PORTB,5
	cbi 	PORTB,6
	nop
	sbis 	PIND,6          
	rjmp 	END_Keyboard
	inc 	Key
;-----------------------------------Строка 1---------------------------------------

	cbi 	PORTB,7
	sbi 	PORTB,4
	sbi 	PORTB,5
	sbi 	PORTB,6
	nop
	sbis 	PIND,5          
	rjmp 	END_Keyboard
	inc 	Key
	sbis 	PIND,6          
	rjmp 	END_Keyboard
	inc 	Key
	sbis 	PIND,7          
	rjmp 	END_Keyboard
	inc 	Key
;-----------------------------------Строка 2---------------------------------------

	sbi 	PORTB,7
	cbi 	PORTB,4
	sbi 	PORTB,5
	sbi 	PORTB,6
	nop
	sbis 	PIND,5          
	rjmp 	END_Keyboard
	inc 	Key
	sbis 	PIND,6          
	rjmp 	END_Keyboard
	inc 	Key
	sbis 	PIND,7          
	rjmp 	END_Keyboard
	inc 	Key
;-----------------------------------Строка 3---------------------------------------

	sbi 	PORTB,7
	sbi 	PORTB,4
	cbi 	PORTB,5
	sbi 	PORTB,6
	nop
	sbis 	PIND,5          
	rjmp 	END_Keyboard
	inc 	Key
	sbis 	PIND,6          
	rjmp 	END_Keyboard
	inc 	Key
	sbis 	PIND,7          
	rjmp 	END_Keyboard
	clr  	Key
	rjmp 	Keysel
END_Keyboard:
	ret
;-----------------------------------Таймер счетчик 1,2s----------------------------

TIMER0_OVF:
	clz
	inc 	Acc4
	cpi		Acc4,20
	brne	END_TIMER0_OVF
	clr 	Acc4
	ldi 	Acc3,1
END_TIMER0_OVF:
	reti
;-----------------------------------Отключить звук---------------------------------

Sound_off:
	CLI
	ldi 	Acc0, 0b00000000 	;Отклюить порт B
	out 	TCCR1A, Acc0
	ret



;DDD:
;	lpm Acc0, Z
;uart_txd22:
;	sbis UCSRA,UDRE	;			;Флага готовности
;	rjmp uart_txd22 
	;out	 UDR, Acc0	
	;ret	
