.init_heap_size	0

	addi	%g3, %g0, 0
	addi	%g4, %g0, 1
	addi	%g5, %g0, 0
	addi	%g6, %g0, 10
	nop
Iter:
	add		%g5, %g5, %g4
	nop
	nop
	nop
	add		%g3, %g5, %g3
	jeq		%g5, %g6, End
	nop
	jmp Iter
	nop
End:
	nop
	output %g3
	halt