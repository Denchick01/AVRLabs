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
	;������������� �����
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
	cpi Acc0, 34 ;���� ������� ����� 34,�� ������ ���� ��
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
;������ � ������� ���������� �������� ������� , ��� ���������� ����
C:

	out OCR1AL, Acc0 ;����� �������
	ldi Acc0, 17  
	out OCR1BL, Acc0  ;����� ���������
	ret

C_sharp:

	out OCR1AL, Acc0 ;����� �������
	ldi Acc0, 18
	out OCR1BL, Acc0  ;����� ���������
	ret

D:
	
	out OCR1AL, Acc0 ;����� �������
	ldi Acc0, 19
	out OCR1BL, Acc0  ;����� ���������
	ret

D_sharp:

	out OCR1AL, Acc0 ;����� �������
	ldi Acc0, 20
	out OCR1BL, Acc0  ;����� ���������
	ret

E:
	
	out OCR1AL, Acc0 ;����� �������
	ldi Acc0, 22
	out OCR1BL, Acc0  ;����� ���������
	ret

F:

	out OCR1AL, Acc0 ;����� �������
	ldi Acc0, 23
	out OCR1BL, Acc0  ;����� ���������
	ret

F_sharp:

	out OCR1AL, Acc0 ;����� �������
	ldi Acc0, 24
	out OCR1BL, Acc0  ;����� ���������
	ret
G:

	out OCR1AL, Acc0 ;����� �������
	ldi Acc0, 25
	out OCR1BL, Acc0  ;����� ���������
	ret

G_sharp:
	
	out OCR1AL, Acc0 ;����� �������
	ldi Acc0, 27
	out OCR1BL, Acc0  ;����� ���������
	ret

A:
	
	out OCR1AL, Acc0 ;����� �������
	ldi Acc0, 29
	out OCR1BL, Acc0  ;����� ���������
	ret
A_sharp:
	
	out OCR1AL, Acc0 ;����� �������
	ldi Acc0, 30
	out OCR1BL, Acc0  ;����� ���������
	ret

H:
	
	out OCR1AL, Acc0 ;����� �������
	ldi Acc0, 32
	out OCR1BL, Acc0  ;����� ���������
	ret


;==========================
	
Init_Timer1:
	ldi Acc0, 0b00000000 ;����� ����� CTC
	out TCCR1A, Acc0
	ldi Acc0, 0b00001010 ;0,1�2  ��� ����� �������� ��������
	out TCCR1B, Acc0
	ldi Acc0, 0b00000000
	out TCNT1H, Acc0       ;������� �����
	ldi Acc0, 0b00000000
	out TCNT1L, Acc0
	ldi Acc0, 0b00011000
	out TIMSK, Acc0
	ret

;==========================


Init_Ports:	
	
	;���������f��� ����� �������� �� �����
	sbi DDRD,5
	;������������� ������ (��� ������) �� �����
	sbi DDRB,7
	sbi DDRB,4
	sbi DDRB,5
	sbi DDRB,6
	;������������� ������ (��� �������) �� ����
	cbi DDRD,5
	cbi DDRD,6
	cbi DDRD,7


;==========================


Proverka:
		;��������� ������ ������
		;���������� ������ ������
		cbi PORTB,7
		sbi PORTB,4
		sbi PORTB,5
		sbi PORTB,6
		
		nop
		;������ �������� ��������
		sbis PIND,5
		ldi Acc0,34
		sbis PIND,6
		ldi Acc0,36
		sbis PIND,7
		ldi Acc0,38
;============		
		;��������� ������ ������
		;���������� ������� ������
		sbi PORTB,7
		cbi PORTB,4
		sbi PORTB,5
		sbi PORTB,6
		
		nop
		;������ �������� ��������
		sbis PIND,5
		ldi Acc0,40
		sbis PIND,6
		ldi Acc0,44
		sbis PIND,7
		ldi Acc0,46
		
;============
		;��������� ������ ������
		;���������� ������ ������
		sbi PORTB,7
		sbi PORTB,4
		cbi PORTB,5
		sbi PORTB,6

		nop
		;������ �������� ��������
		sbis PIND,5
		ldi Acc0,48
		sbis PIND,6
		ldi Acc0,50
		sbis PIND,7
		ldi Acc0,54
	
;============
		;��������� ��������� ������
		;���������� ��������� ������
		sbi PORTB,7
		sbi PORTB,4
		sbi PORTB,5
		cbi PORTB,6

		nop
		;������ �������� ��������
		sbis PIND,5
		ldi Acc0,58
		sbis PIND,6
		ldi Acc0,60
		sbis PIND,7
		ldi Acc0,64
		ret	

;=============================
