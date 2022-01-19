.data 0x0000				      		
	buf: .word 0x0000
.text 0x0000						
start: lui   $28,0xFFFF			
       ori   $28,$28,0xF000
main:
	lw $s1, 0XC70($28)
	sw $s1, 0XC60($28)
	lw $s1, 0XC72($28)
	sw $s1, 0XC62($28)
