.data 0x0000				      		
	buf: .word 0x0000
.text 0x0000						
start: lui   $28,0xFFFF			
       ori   $28,$28,0xF000
switled1:
	addi $a2, $0, 10000
	addi $t8, $0, 750
	addi $s6, $0, 0
	addi $s7, $0, 21845
									
switled:								
	lw   $s1,0xC72($28)
	
	srl $s3, $s1, 5
	
	addi $t0, $s3, 0
	addi $t1, $s3, -1
	addi $t2, $s3, -2
	addi $t3, $s3, -3
	addi $t4, $s3, -4
	addi $t5, $s3, -5
	addi $t6, $s3, -6
	
	beq $t0, $0, zero
	beq $t1, $0, one
	beq $t2, $0, two
	beq $t3, $0, three
	beq $t4, $0, four
	beq $t5, $0, five
	beq $t6, $0, six
	
zero:
     j judge
	
one:
     addi $a0, $v1, 0
     lw   $s2,0xC70($28)
     addi $a0, $s2, 0
     addi $v1, $a0, 0
     addi $a3, $0, 0
     jal leds

two:
     addi $a0, $v1, 0
     addi $a0,$a0,1
     addi $v1, $a0, 0
     addi $a3, $0, 0
     jal delay

three:
     addi $a0, $v1, 0
     addi $a0,$a0,-1
     addi $v1, $a0, 0
     addi $a3, $0, 0
     jal delay

four:
     addi $a0, $v1, 0
     sll $a0,$a0,1
     addi $v1, $a0, 0
     addi $a3, $0, 0
     jal delay

five:
     addi $a0, $v1, 0
     srl $a0,$a0,1
     addi $v1, $a0, 0
     addi $a3, $0, 0
     jal delay

six:
     addi $a0, $v1, 0
     addi $v0, $a0, 0
     srl $v0, $v0, 15
     beq $v0, $0, six_not_need_one
     bne $v0, $0, six_need_one
six_not_need_one:
     srl $a0,$a0,1
     addi $v1, $a0, 0
     addi $a3, $0, 0
     jal delay
six_need_one:
     srl $a0, $a0, 1
     addi $a0, $a0, 32760
     addi $a0, $a0, 8
     addi $v1, $a0, 0
     addi $a3, $0, 0
     jal delay

 
subdelay:
    	addi $t9, $t9, 1
    	bne $t9, $t8, subdelay
delay:
 	addi $a3, $a3, 1
 	addi $t9, $0, 0
	beq $a3, $a2, leds
 	j subdelay
 	bne $a3, $a2, delay
        
leds:
 	sw $a0, 0xC60($28)
        j switled
        
judge:
	beq $s6, $0, shiftleft
	bne $s6, $0, shiftright
	
shiftleft:
	sll $a0, $s7, 1
	addi $s6, $0, 1
        addi $a3, $0, 0
        jal delay
shiftright:
        addi $a0, $s7, 0
	addi $s6, $0, 0
	addi $a3, $0, 0
	jal delay