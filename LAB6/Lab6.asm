.include "m8535def.inc"

.def Acc0 = r16
.def Acc1 = r17
.def Buffer = r18
.def error = r19
.def temp = r20
.org 0x00
		rjmp RESET ; Reset Handler
		reti; rjmp EXT_INT0 ; IRQ0 Handler
		reti; rjmp EXT_INT1 ; IRQ1 Handler
		reti; rjmp TIM2_COMP ; Timer2 Compare Handler
		reti; rjmp TIM2_OVF ; Timer2 Overflow Handler
		reti; rjmp TIM1_CAPT ; Timer1 Capture Handler
		reti; rjmp TIM1_COMPA ; Timer1 Compare A Handler
		reti; rjmp TIM1_COMPB ; Timer1 Compare B Handler
		reti; rjmp TIM1_OVF ; Timer1 Overflow Handler
		reti; rjmp TIM0_OVF ; Timer0 Overflow Handler
		reti; rjmp SPI_STC ; SPI Transfer Complete Handler
		reti; rjmp USART_RXC ; USART RX Complete Handler
		reti; rjmp USART_UDRE ; UDR Empty Handler
		reti; rjmp USART_TXC ; USART TX Complete Handler
		reti; rjmp ADC ; ADC Conversion Complete Handler
		reti; rjmp EE_RDY ; EEPROM Ready Handler
		reti; rjmp ANA_COMP ; Analog Comparator Handler
		reti; rjmp TWSI ; Two-wire Serial Interface Handler
		reti; rjmp EXT_INT2 ; IRQ2 Handler
		reti; rjmp TIM0_COMP ; Timer0 Compare Handler
		reti; rjmp SPM_RDY ; Store Program Memory Ready Handler

RESET:
		ldi Acc0, LOW(RAMEND)
		out SPL, Acc0
		ldi Acc0, HIGH(RAMEND)
		out SPH, Acc0

; init ports
		sbi DDRD,4
	
;инициализация портов (строки) на выход 
		sbi DDRB,4 
		sbi DDRB,5 
		sbi DDRB,6
		sbi DDRB,7 
;инициализация портов (столбцы) на вход 
		cbi DDRD,5 
		cbi DDRD,6 
		cbi DDRD,7 
; init timer1

	
	
	;	ldi Acc1, HIGH(10000)
	;	out OCR1BH, Acc1
	;	ldi Acc1, LOW(10000)
	;	out OCR1BL, Acc1
	;	ldi Acc1, HIGH(25500)
	;	out ICR1H, acc1
	;	ldi Acc1, LOW(25500)
	;	out ICR1L, acc1
		ldi Acc1, 0b00110010 ; Fast PWM,10-bit 
		out TCCR1A, Acc1
		ldi Acc1, 0b00011010 ; clk/8
			
		out TCCR1B, Acc1
		
	;	LOOP:
	;	rjmp LOOP

;===========================MAIN=================================
keyboard:
clr ZL
clr ZH
; ROW 4
	sbi PORTB,7 
	sbi PORTB,4 
	sbi PORTB,5 
	cbi PORTB,6
; check button (*)
		sbis PIND, 5
		rjmp skvaghnost
	
; check button(0)
		ldi ZL, 20 
		sbis PIND,6          
		rjmp freq
		
; ROW 1
	cbi PORTB,7 
	sbi PORTB,4 
	sbi PORTB,5 
	sbi PORTB,6
; check buttons (1-3)
		ldi ZH, HIGH(1000)
		ldi ZL, LOW(1000)
		sbis PIND,5          
		rjmp freq
		ldi ZL, 250
		sbis PIND,6          
		rjmp freq	
		ldi ZL, 167	
		sbis PIND,7          
		rjmp freq
		
; ROW 2
	sbi PORTB,7 
	cbi PORTB,4 
	sbi PORTB,5
	sbi PORTB,6
; check buttons (4-6)
		ldi ZL, 125
		sbis PIND,5          
		rjmp freq
		ldi ZL, 100		
		sbis PIND,6          
		rjmp freq
		ldi ZL, 83	
		sbis PIND,7          
		rjmp freq
		
; ROW 3 
	sbi PORTB,7 
	sbi PORTB,4 
	cbi PORTB,5 
	sbi PORTB,6
; check buttons (7-9)
		ldi ZL, 71
		sbis PIND,5          
		rjmp freq
		ldi ZL, 63		
		sbis PIND,6          
		rjmp freq
		ldi ZL, 55	
		sbis PIND,7          
		rjmp freq	
		rjmp keyboard
; =====================subprogrammes=========================================
freq:
	out ICR1H, ZH
	out ICR1L, ZL
	rjmp keyboard

skvaghnost:
		inc temp
		sbrs temp, 0
		rjmp half
		sbrc temp, 0
		rjmp whole
half:
		ldi Acc1, HIGH(768)
		out OCR1BH, Acc1
		ldi Acc1, LOW(768)
		out OCR1BL, Acc1
		rjmp keyboard
whole: 
		ldi Acc1, HIGH(512)
		out OCR1BH, Acc1
		ldi Acc1, LOW(512)
		out OCR1BL, Acc1
		rjmp keyboard


					



		


































