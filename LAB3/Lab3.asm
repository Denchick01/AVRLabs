.include "m8535def.inc" 

.def Acc0    = r16 
.def Acc1    = r17 
.def Key     = r18 
.def number1 = r19 
.def number2 = r20
.org 0x00 
rjmp RESET 
reti 
reti
reti
reti
reti
reti
reti
rjmp INT_OF1 
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

;----------------������������� �����-----------------
ldi Acc0, LOW(RAMEND) 
out SPL, Acc0 
ldi Acc0, HIGH(RAMEND) 
out SPH, Acc0 

;----------------������������� ������----------------
ldi Acc1, 0xF0
out DDRB, Acc1
sbi DDRB,3 
sbi DDRD,4 
sbi PORTB,3
sbi	PORTD,4
;------------------������������� ������� ��������-----
ldi Acc0, 0b00000000 ;���������� ����� 
out TCCR1A, Acc0
ldi Acc1, 0b00000010 ; �������� 8
out TCCR1B, Acc1
ldi Acc1, 0b00000100
out TIMSK, Acc1
CLI

;-----------------����� ����������--------------------
Keysel:
cbi PORTB,7; ������ ���� �� ��� ������ ����������
cbi PORTB,6
cbi PORTB,5
cbi PORTB,4
sbi	PORTD,7
sbi	PORTD,6
sbi	PORTD,5
in Acc0,PIND       ; ������ ��������� �����
ori Acc0,0b00011111
CLC; 
cpi Acc0,0b11111111; 
BRLO Keysel      ; ����� ���� ������� ����� �� ������
Keyboard:
;---------------------������ 4---------------------------- 
	sbi PORTB,7
	sbi PORTB,6
	sbi PORTB,5
	cbi PORTB,4
nop
sbis PIND,6          
rjmp KeyFound
inc Key
;---------------------������ 1---------------------------- 
	cbi PORTB,7
	sbi PORTB,6
	sbi PORTB,5
	sbi PORTB,4
nop
sbis PIND,5          
rjmp KeyFound
inc Key
sbis PIND,6          
rjmp KeyFound
inc Key
sbis PIND,7          
rjmp Keyfound
inc Key
;---------------------������ 2----------------------------
	sbi PORTB,7
	cbi PORTB,6
	sbi PORTB,5
	sbi PORTB,4
nop
sbis PIND,5          
rjmp KeyFound
inc Key
sbis PIND,6          
rjmp KeyFound
inc Key
sbis PIND,7          
rjmp Keyfound
inc Key
;---------------------������ 3----------------------------
	sbi PORTB,7
	sbi PORTB,6
	cbi PORTB,5
	sbi PORTB,4
nop
sbis PIND,5          
rjmp KeyFound
inc Key
sbis PIND,6          
rjmp KeyFound
inc Key
sbis PIND,7          
rjmp Keyfound
clr  Key
rjmp Keyboard 

;--------------------������ � ����������------------------
KeyFound:
mov number2,Key
CLC
CP  number2,number1 ;��������� �����
BRLO condition_done
CLI
sbi PORTB,3
sbi	PORTD,4
mov number1,number2
rjmp Keysel
condition_done:
cbi PORTB,3
cbi	PORTD,4
mov number1,number2
SEI
rjmp Keysel

INT_OF1:
sbic PORTB,3          
rjmp LEDon
sbi PORTB,3
sbi	PORTD,4
rjmp end
LEDon:
cbi PORTB,3
cbi	PORTD,4
end:
reti
