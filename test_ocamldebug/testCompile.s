	.file ""
	.section .rodata.cst8,"a",@progbits
	.align	16
caml_negf_mask:
	.quad	0x8000000000000000
	.quad	0
	.align	16
caml_absf_mask:
	.quad	0x7fffffffffffffff
	.quad	-1
	.data
	.globl	camlTestCompile__data_begin
camlTestCompile__data_begin:
	.text
	.globl	camlTestCompile__code_begin
camlTestCompile__code_begin:
	.data
	.quad	768
	.globl	camlTestCompile
camlTestCompile:
	.data
	.globl	camlTestCompile__gc_roots
camlTestCompile__gc_roots:
	.quad	camlTestCompile
	.quad	0
	.data
	.quad	3068
camlTestCompile__1:
	.ascii	"hello world\12"
	.space	3
	.byte	3
	.text
	.align	16
	.globl	camlTestCompile__entry
camlTestCompile__entry:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_adjust_cfa_offset 8
.L101:
	movq	camlTestCompile__1@GOTPCREL(%rip), %rbx
	movq	camlPervasives@GOTPCREL(%rip), %rax
	movq	208(%rax), %rax
	call	camlPervasives__output_string_1213@PLT
.L100:
	movq	$1, %rax
	addq	$8, %rsp
	.cfi_adjust_cfa_offset -8
	ret
	.cfi_adjust_cfa_offset 8
	.cfi_adjust_cfa_offset -8
	.cfi_endproc
	.type camlTestCompile__entry,@function
	.size camlTestCompile__entry,. - camlTestCompile__entry
	.data
	.text
	.globl	camlTestCompile__code_end
camlTestCompile__code_end:
	.data
				/* relocation table start */
	.align	8
				/* relocation table end */
	.data
	.globl	camlTestCompile__data_end
camlTestCompile__data_end:
	.long	0
	.globl	camlTestCompile__frametable
camlTestCompile__frametable:
	.quad	1
	.quad	.L100
	.word	17
	.word	0
	.align	8
	.quad	.L102
	.align	8
.L102:
	.long	(.L103 - .) + -1409286144
	.long	1913168
	.quad	0
.L103:
	.ascii	"pervasives.ml\0"
	.align	8
	.section .note.GNU-stack,"",%progbits
