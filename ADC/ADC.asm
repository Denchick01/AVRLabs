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

;---------------------������������� �����-------------
ldi Acc0, LOW(RAMEND) 
out SPL, Acc0 
ldi Acc0, HIGH(RAMEND) 
out SPH, Acc0 

;---------------------������������� ���---------------------
ldi seladmux,0b01100100

;---------------------������������� ������------------------
sbi DDRC,0 
sbi DDRC,1 

;---------------------������������� ������� ��������--------
ldi Acc0, 0b00000000 
out TCCR1A, Acc0
ldi Acc0, 0b00000001;4MHz 0,1��
out TCCR1B, Acc0
ldi Acc0, LOW(40000)
out TCNT1L, Acc0
ldi Acc0, HIGH(40000)
out TCNT1H, Acc0
ldi Acc0, 0b00000100
out TIMSK, Acc0

;---------------------������������� ���---------------------
out ADMUX, seladmux
ldi Acc0,0b10101011; 500�Hz 2���
out ADCSRA,Acc0
ldi Acc0,0b11000000
out SFIOR,Acc0
sei

;---------------------�������� ����-------------------------
LOOP:
rjmp LOOP

;---------------------���������� �� �������-----------------
Timer_Overflow:
ldi Acc0, LOW(40000)
out TCNT1L, Acc0
ldi Acc0, HIGH(40000)
out TCNT1H, Acc0
reti

;---------------------���������� �� ���---------------------
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
;---------------------������ �������� � ����� ADC4 � ���----	
mov adc4,sam2
clr sam2
inc cycl1
rcall compare
rcall Change_Admux
rjmp END_ADC_Complete
;---------------------������ �������� � ����� ADC5 � ���----
setadc5:
mov adc5,sam2
clr sam2
dec cycl1
rcall compare
rcall Change_Admux

END_ADC_Complete:
SEI
reti

;---------------------����� �����---------------------------
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


;---------------------C�������� ������� �������� -----------
compare:
CLC
CP adc5,adc4
BRLO ADC4on7SEG ;���� ������� adc4>adc5, �� ����� "ADC4"
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


;---------------------����� �� �������������� ���������-----
indicator:
CLI
clz
ldi cycl2,4
CICL2:
nop
LPM numdata, Z+
LDI cycl,8
CICL1:
CBI PORTC,0	;������ 0 �� CLK
CBI PORTC,1
SBRC numdata,0 ;��������� ������� ���, ���� �� ����� 0 �� �������� ������� ������������
SBI PORTC,1 ;������ �� ������ ��� ����� C ���������� 1
NOP
SBI PORTC,0 ;������ ����� �� CLK
LSR numdata ;�������� ������ �� 1 ���
DEC cycl
BRNE CICL1
DEC cycl2
BRNE CICL2 ;���� ��������� �����
SEI
ret

;---------------------����� ������������ ���������----------
sampling:
in sam1,ADCH
CLC
CP sam1,sam2
BRLO end_sampling
mov sam2,sam1
end_sampling:
ret
