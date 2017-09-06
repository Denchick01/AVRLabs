.include "m8535def.inc"

.def Acc0 = r16
.def Acc1 = r17
.def clock = r18
.def ad = r19
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
;������������� ���
	ldi clock, 0x00
	ldi ad, 0x19
;������������� ������
	sbi DDRB,3
	ldi Acc1, 0xF0
	out DDRB, Acc1
	ldi Acc1, 0xE0
	out PIND, Acc1
;������������� ������� ��������
	ldi Acc0, 0b01101001 ; Fast PWM
	out TCCR0, Acc0
	ldi Acc1, 0xA
	out OCR0, Acc1
;����� ����������
keyboard:
clr clock
; ������ ������ 
	cbi PORTB,7
	sbi PORTB,6
	sbi PORTB,5
	sbi PORTB,4
;�������� ������� ������ (1-3)
		sbis PIND,5          
		rjmp duty_cycle
		ADC clock, ad
		sbis PIND,6          
		rjmp duty_cycle
		ADC clock, ad
		sbis PIND,7          
		rjmp duty_cycle
		ADC clock, ad
; ������ ������ 
	sbi PORTB,7
	cbi PORTB,6
	sbi PORTB,5
	sbi PORTB,4
;�������� ������� ������ (4-6)
		sbis PIND,5          
		rjmp duty_cycle
		ADC clock, ad
		sbis PIND,6          
		rjmp duty_cycle
		ADC clock, ad
		sbis PIND,7          
		rjmp duty_cycle
		ADC clock, ad
; ������ ������ 
	sbi PORTB,7
	sbi PORTB,6
	cbi PORTB,5
	sbi PORTB,4
;�������� ������� ������ (7-9)
		sbis PIND,5          
		rjmp duty_cycle
		ADC clock, ad
		sbis PIND,6          
		rjmp duty_cycle
		ADC clock, ad
		sbis PIND,7          
		rjmp duty_cycle
		ADC clock, ad
; ��������� ������ 
	sbi PORTB,7
	sbi PORTB,6
	sbi PORTB,5
	cbi PORTB,4
;�������� ������� ������ (0)          
		sbis PIND,6          
		rjmp duty_cycle
		ADC clock, ad
		rjmp keyboard
;������������� �������� ���������
duty_cycle:
	out OCR0, clock
	rjmp keyboard
