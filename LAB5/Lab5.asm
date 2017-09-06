.include "m8535def.inc" 

.def Acc0 = r16 
.def number = r17 
.def Razr0 = r18 
.def Razr1 = r19 
.def Razr2 = r20 
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
.org 0x15
RESET: 
;????????????? ????? 
ldi Acc0, LOW(RAMEND) 
out SPL, Acc0 
ldi Acc0, HIGH(RAMEND) 
out SPH, Acc0 
;????????????? ?????? (??????) ?? ????? 
sbi DDRB,4 
sbi DDRB,5 
sbi DDRB,6 
;????????????? ?????? (???????) ?? ???? 
cbi DDRD,5 
cbi DDRD,6 
cbi DDRD,7 
;????????????? ????? ?????????? HL1 ?? ????? 
sbi DDRB,3 
sbi PORTB,3 
ldi Acc0, 0xE0
out PIND, Acc0
;-------------------------------------------------— 

Loop: 
;Row1: 
cbi PORTB,4 
sbi PORTB,5 
sbi PORTB,6  
inc number
sbis PIND, 5 
rjmp Signal
inc number
sbis PIND, 6 
rjmp Signal 
inc number
sbis PIND, 7 
rjmp Signal 
;Row2: 
sbi PORTB,4 
cbi PORTB,5 
sbi PORTB,6 
inc number
sbis PIND, 5 
rjmp Signal
inc number
sbis PIND, 6 
rjmp Signal 
inc number
sbis PIND, 7 
rjmp Signal 
;Row3
sbi PORTB,4 
sbi PORTB,5 
cbi PORTB,6 
inc number
sbis PIND, 5 
rjmp Signal
inc number
sbis PIND, 6 
rjmp Signal 
inc number
sbis PIND, 7 
rjmp Signal
clr  number
rjmp Loop 
;-----------------------------------------------— 
Signal: 
cbi PORTB, 3 
rcall Delay 
sbi PORTB, 3 
rcall Delay 
dec number 
brne Signal 
rjmp Loop


;------------DELAY--------------------------------— 

Delay:
	ldi Razr1, 10
delay_loop2:
	dec Razr1
	BREQ delay_loop1
	ldi Razr2, 100
delay_loop3:
	dec Razr2
	BREQ delay_loop2
	ldi Razr0, 255
delay_loop:
	dec Razr0
	BRNE delay_loop
	rjmp delay_loop3
delay_loop1:
	ret

