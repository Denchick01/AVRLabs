.include "m8535def.inc"
;������������� ���
.def Acc0   = r16
.def Acc1   = r17
.def cicl   = r18
.def cicl1  = r20
.def cicl2  = r21
.def cicl3  = r22
.def cicl4  = r23
.def button = r24

;������� ���������� 
.org 0x0
	rjmp Reset

.org 0x15
Data:
.DB 0b11111001,0b11000000
;.DB 0x9F,0x3

Reset:
;������������� �����
	ldi Acc0, LOW(Ramend)
	out SPL, Acc0
	ldi Acc1, HIGH(Ramend)
	out SPH, Acc1
;������������� ���
	ldi Acc0, 0xD0
	out DDRB, Acc0  ;���� 4...7 ����� B ������� �� �����
	ldi Acc1, 0x3
	out DDRC, Acc1 ;���� 1...2 ����� � ������� �� �����
	ldi ZL, LOW(Data*2)
	ldi ZH, HIGH(Data*2) ;�������� �������� ��� ��������������� ���������
	ldi Acc0, 0x70
	out PORTB, Acc0
	LDI cicl1,2

Point1:
    sbis PIND,7
	rcall Delay
    rcall Delay
	LPM r19, Z+ ;�������� ������ ����� � r18
	LDI cicl,8
LOOP:
	CBI PORTC,0	
	CBI PORTC,1
	SBRC r19,0 ;��������� ������� ���, ���� �� ����� 0 �� �������� ������� ������������
	SBI PORTC,1 ;������ �� ������ ��� ����� C ���������� 1
	NOP
	SBI PORTC,0 ;������ ����� �� CLK
	LSR r19   ;�������� ������ �� 1 ���
	DEC cicl
	BRNE LOOP
	DEC cicl1
	BRNE Point1 ;���� ��������� �����
    rjmp Reset



;������������ ��������
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
