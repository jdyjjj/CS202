.data 0x0000				      		
	buf: .word 0x0000
.text 0x0000						
start: lui   $28,0xBFFF			
       ori   $28,$28,0xF000
switch:
	lw   $s1,0xC72($28)
	
	srl $s3, $s1, 5
	
	addi $t0, $s3, 0
	addi $t1, $s3, -1
	addi $t2, $s3, -2
	addi $t3, $s3, -3
	addi $t4, $s3, -4
	addi $t5, $s3, -5
	addi $t6, $s3, -6
	addi $t7, $s3, -7
	
	beq $t0, $0, zero
	beq $t1, $0, one
	beq $t2, $0, two
	beq $t3, $0, three
	beq $t4, $0, four
	beq $t5, $0, five
	beq $t6, $0, six
	beq $t7, $0, seven
	
zero:
	addi $a0, $0, 0 #xinjiade
	lw $v0, 0xC70($28)
	addi $a1, $v0, 0
	addi $a2, $v0, 0
	srl $a1, $a1, 8
	sll $a2, $a2, 24
	srl $a2, $a2, 24
	j show #gaiguode
	
one:
	add $a0, $a1, $a2
	j show
	
two:
	sub $a0, $a1, $a2
	j show
	
three:
	sllv $a0, $a1, $a2
	j show
	
four:
	srlv $a0, $a1, $a2
	j show

 five:
 	slt $a0, $a2, $a1
 	j show
 	
 six:
 	and $a0, $a1, $a2
 	j show
 	
 seven:
 	xor $a0, $a1, $a2
 	j show
 	
 show:
  	sw $a0, 0xC60($28)
  	j switch
 	