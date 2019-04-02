.constant TERM 0x4000
.constant CR 0xD
.constant LF 0xA

.address 0x2000

!test
	MOVI r1 = 50
	MOVI r2 = 12
	ADD  r1 = r1+r2
	MOVI r41 = CR
	MOVI r42 = LF
	STOR [TERM] = r1
	STOR [TERM] = r41
	STOR [TERM] = r42  
