; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=-bmi < %s | FileCheck %s --check-prefix=CHECK-NOBMI
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+bmi < %s | FileCheck %s --check-prefix=CHECK-BMI

; https://bugs.llvm.org/show_bug.cgi?id=37104

; X:           [bit 3210]
; Y: [bit 7654]

define i8 @out8_constmask(i8 %x, i8 %y) {
; CHECK-NOBMI-LABEL: out8_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NOBMI-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NOBMI-NEXT:    andb $15, %dil
; CHECK-NOBMI-NEXT:    andb $-16, %sil
; CHECK-NOBMI-NEXT:    leal (%rsi,%rdi), %eax
; CHECK-NOBMI-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out8_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-BMI-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-BMI-NEXT:    andb $15, %dil
; CHECK-BMI-NEXT:    andb $-16, %sil
; CHECK-BMI-NEXT:    leal (%rsi,%rdi), %eax
; CHECK-BMI-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-BMI-NEXT:    retq
  %mx = and i8 %x, 15
  %my = and i8 %y, -16
  %r = or i8 %mx, %my
  ret i8 %r
}

define i16 @out16_constmask(i16 %x, i16 %y) {
; CHECK-NOBMI-LABEL: out16_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NOBMI-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NOBMI-NEXT:    andl $3855, %edi # imm = 0xF0F
; CHECK-NOBMI-NEXT:    andl $-3856, %esi # imm = 0xF0F0
; CHECK-NOBMI-NEXT:    leal (%rsi,%rdi), %eax
; CHECK-NOBMI-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out16_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-BMI-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-BMI-NEXT:    andl $3855, %edi # imm = 0xF0F
; CHECK-BMI-NEXT:    andl $-3856, %esi # imm = 0xF0F0
; CHECK-BMI-NEXT:    leal (%rsi,%rdi), %eax
; CHECK-BMI-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-BMI-NEXT:    retq
  %mx = and i16 %x, 3855
  %my = and i16 %y, -3856
  %r = or i16 %mx, %my
  ret i16 %r
}

define i32 @out32_constmask(i32 %x, i32 %y) {
; CHECK-NOBMI-LABEL: out32_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NOBMI-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NOBMI-NEXT:    andl $252645135, %edi # imm = 0xF0F0F0F
; CHECK-NOBMI-NEXT:    andl $-252645136, %esi # imm = 0xF0F0F0F0
; CHECK-NOBMI-NEXT:    leal (%rsi,%rdi), %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out32_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-BMI-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-BMI-NEXT:    andl $252645135, %edi # imm = 0xF0F0F0F
; CHECK-BMI-NEXT:    andl $-252645136, %esi # imm = 0xF0F0F0F0
; CHECK-BMI-NEXT:    leal (%rsi,%rdi), %eax
; CHECK-BMI-NEXT:    retq
  %mx = and i32 %x, 252645135
  %my = and i32 %y, -252645136
  %r = or i32 %mx, %my
  ret i32 %r
}

define i64 @out64_constmask(i64 %x, i64 %y) {
; CHECK-NOBMI-LABEL: out64_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movabsq $1085102592571150095, %rcx # imm = 0xF0F0F0F0F0F0F0F
; CHECK-NOBMI-NEXT:    andq %rdi, %rcx
; CHECK-NOBMI-NEXT:    movabsq $-1085102592571150096, %rax # imm = 0xF0F0F0F0F0F0F0F0
; CHECK-NOBMI-NEXT:    andq %rsi, %rax
; CHECK-NOBMI-NEXT:    orq %rcx, %rax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out64_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movabsq $1085102592571150095, %rcx # imm = 0xF0F0F0F0F0F0F0F
; CHECK-BMI-NEXT:    andq %rdi, %rcx
; CHECK-BMI-NEXT:    movabsq $-1085102592571150096, %rax # imm = 0xF0F0F0F0F0F0F0F0
; CHECK-BMI-NEXT:    andq %rsi, %rax
; CHECK-BMI-NEXT:    orq %rcx, %rax
; CHECK-BMI-NEXT:    retq
  %mx = and i64 %x, 1085102592571150095
  %my = and i64 %y, -1085102592571150096
  %r = or i64 %mx, %my
  ret i64 %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Should be the same as the previous one.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i8 @in8_constmask(i8 %x, i8 %y) {
; CHECK-NOBMI-LABEL: in8_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %edi
; CHECK-NOBMI-NEXT:    andb $15, %dil
; CHECK-NOBMI-NEXT:    xorb %dil, %al
; CHECK-NOBMI-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in8_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %esi, %eax
; CHECK-BMI-NEXT:    xorl %esi, %edi
; CHECK-BMI-NEXT:    andb $15, %dil
; CHECK-BMI-NEXT:    xorb %dil, %al
; CHECK-BMI-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i8 %x, %y
  %n1 = and i8 %n0, 15
  %r = xor i8 %n1, %y
  ret i8 %r
}

define i16 @in16_constmask(i16 %x, i16 %y) {
; CHECK-NOBMI-LABEL: in16_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl $3855, %eax # imm = 0xF0F
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in16_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %edi, %eax
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    andl $3855, %eax # imm = 0xF0F
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i16 %x, %y
  %n1 = and i16 %n0, 3855
  %r = xor i16 %n1, %y
  ret i16 %r
}

define i32 @in32_constmask(i32 %x, i32 %y) {
; CHECK-NOBMI-LABEL: in32_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in32_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %edi, %eax
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, 252645135
  %r = xor i32 %n1, %y
  ret i32 %r
}

define i64 @in64_constmask(i64 %x, i64 %y) {
; CHECK-NOBMI-LABEL: in64_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    xorq %rsi, %rdi
; CHECK-NOBMI-NEXT:    movabsq $1085102592571150095, %rax # imm = 0xF0F0F0F0F0F0F0F
; CHECK-NOBMI-NEXT:    andq %rdi, %rax
; CHECK-NOBMI-NEXT:    xorq %rsi, %rax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in64_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    xorq %rsi, %rdi
; CHECK-BMI-NEXT:    movabsq $1085102592571150095, %rax # imm = 0xF0F0F0F0F0F0F0F
; CHECK-BMI-NEXT:    andq %rdi, %rax
; CHECK-BMI-NEXT:    xorq %rsi, %rax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i64 %x, %y
  %n1 = and i64 %n0, 1085102592571150095
  %r = xor i64 %n1, %y
  ret i64 %r
}

; ============================================================================ ;
; Constant Commutativity tests.
; ============================================================================ ;

define i32 @in_constmask_commutativity_0_1(i32 %x, i32 %y) {
; CHECK-NOBMI-LABEL: in_constmask_commutativity_0_1:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_constmask_commutativity_0_1:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %edi, %eax
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, 252645135
  %r = xor i32 %y, %n1 ; swapped
  ret i32 %r
}

define i32 @in_constmask_commutativity_1_0(i32 %x, i32 %y) {
; CHECK-NOBMI-LABEL: in_constmask_commutativity_1_0:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    xorl %edi, %eax
; CHECK-NOBMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-NOBMI-NEXT:    xorl %edi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_constmask_commutativity_1_0:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %esi, %eax
; CHECK-BMI-NEXT:    xorl %edi, %eax
; CHECK-BMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-BMI-NEXT:    xorl %edi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, 252645135
  %r = xor i32 %n1, %x ; %x instead of %y
  ret i32 %r
}

define i32 @in_constmask_commutativity_1_1(i32 %x, i32 %y) {
; CHECK-NOBMI-LABEL: in_constmask_commutativity_1_1:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    xorl %edi, %eax
; CHECK-NOBMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-NOBMI-NEXT:    xorl %edi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_constmask_commutativity_1_1:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %esi, %eax
; CHECK-BMI-NEXT:    xorl %edi, %eax
; CHECK-BMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-BMI-NEXT:    xorl %edi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, 252645135
  %r = xor i32 %x, %n1 ; swapped, %x instead of %y
  ret i32 %r
}

; ============================================================================ ;
; Y is an 'and' too.
; ============================================================================ ;

define i32 @in_complex_y0_constmask(i32 %x, i32 %y_hi, i32 %y_low) {
; CHECK-NOBMI-LABEL: in_complex_y0_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %esi
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_complex_y0_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %edi, %eax
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    retq
  %y = and i32 %y_hi, %y_low
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, 252645135
  %r = xor i32 %n1, %y
  ret i32 %r
}

define i32 @in_complex_y1_constmask(i32 %x, i32 %y_hi, i32 %y_low) {
; CHECK-NOBMI-LABEL: in_complex_y1_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %esi
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_complex_y1_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %edi, %eax
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    retq
  %y = and i32 %y_hi, %y_low
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, 252645135
  %r = xor i32 %y, %n1
  ret i32 %r
}

; ============================================================================ ;
; Negative tests. Should not be folded.
; ============================================================================ ;

; Multi-use tests.

declare void @use32(i32) nounwind

define i32 @in_multiuse_A_constmask(i32 %x, i32 %y, i32 %z) nounwind {
; CHECK-NOBMI-LABEL: in_multiuse_A_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    pushq %rbp
; CHECK-NOBMI-NEXT:    pushq %rbx
; CHECK-NOBMI-NEXT:    pushq %rax
; CHECK-NOBMI-NEXT:    movl %esi, %ebx
; CHECK-NOBMI-NEXT:    movl %edi, %ebp
; CHECK-NOBMI-NEXT:    xorl %esi, %ebp
; CHECK-NOBMI-NEXT:    andl $252645135, %ebp # imm = 0xF0F0F0F
; CHECK-NOBMI-NEXT:    movl %ebp, %edi
; CHECK-NOBMI-NEXT:    callq use32
; CHECK-NOBMI-NEXT:    xorl %ebx, %ebp
; CHECK-NOBMI-NEXT:    movl %ebp, %eax
; CHECK-NOBMI-NEXT:    addq $8, %rsp
; CHECK-NOBMI-NEXT:    popq %rbx
; CHECK-NOBMI-NEXT:    popq %rbp
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_multiuse_A_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    pushq %rbp
; CHECK-BMI-NEXT:    pushq %rbx
; CHECK-BMI-NEXT:    pushq %rax
; CHECK-BMI-NEXT:    movl %esi, %ebx
; CHECK-BMI-NEXT:    movl %edi, %ebp
; CHECK-BMI-NEXT:    xorl %esi, %ebp
; CHECK-BMI-NEXT:    andl $252645135, %ebp # imm = 0xF0F0F0F
; CHECK-BMI-NEXT:    movl %ebp, %edi
; CHECK-BMI-NEXT:    callq use32
; CHECK-BMI-NEXT:    xorl %ebx, %ebp
; CHECK-BMI-NEXT:    movl %ebp, %eax
; CHECK-BMI-NEXT:    addq $8, %rsp
; CHECK-BMI-NEXT:    popq %rbx
; CHECK-BMI-NEXT:    popq %rbp
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, 252645135
  call void @use32(i32 %n1)
  %r = xor i32 %n1, %y
  ret i32 %r
}

define i32 @in_multiuse_B_constmask(i32 %x, i32 %y, i32 %z) nounwind {
; CHECK-NOBMI-LABEL: in_multiuse_B_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    pushq %rbp
; CHECK-NOBMI-NEXT:    pushq %rbx
; CHECK-NOBMI-NEXT:    pushq %rax
; CHECK-NOBMI-NEXT:    movl %esi, %ebx
; CHECK-NOBMI-NEXT:    xorl %esi, %edi
; CHECK-NOBMI-NEXT:    movl %edi, %ebp
; CHECK-NOBMI-NEXT:    andl $252645135, %ebp # imm = 0xF0F0F0F
; CHECK-NOBMI-NEXT:    callq use32
; CHECK-NOBMI-NEXT:    xorl %ebx, %ebp
; CHECK-NOBMI-NEXT:    movl %ebp, %eax
; CHECK-NOBMI-NEXT:    addq $8, %rsp
; CHECK-NOBMI-NEXT:    popq %rbx
; CHECK-NOBMI-NEXT:    popq %rbp
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_multiuse_B_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    pushq %rbp
; CHECK-BMI-NEXT:    pushq %rbx
; CHECK-BMI-NEXT:    pushq %rax
; CHECK-BMI-NEXT:    movl %esi, %ebx
; CHECK-BMI-NEXT:    xorl %esi, %edi
; CHECK-BMI-NEXT:    movl %edi, %ebp
; CHECK-BMI-NEXT:    andl $252645135, %ebp # imm = 0xF0F0F0F
; CHECK-BMI-NEXT:    callq use32
; CHECK-BMI-NEXT:    xorl %ebx, %ebp
; CHECK-BMI-NEXT:    movl %ebp, %eax
; CHECK-BMI-NEXT:    addq $8, %rsp
; CHECK-BMI-NEXT:    popq %rbx
; CHECK-BMI-NEXT:    popq %rbp
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, 252645135
  call void @use32(i32 %n0)
  %r = xor i32 %n1, %y
  ret i32 %r
}

; Various bad variants

define i32 @n0_badconstmask(i32 %x, i32 %y) {
; CHECK-NOBMI-LABEL: n0_badconstmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    andl $252645135, %edi # imm = 0xF0F0F0F
; CHECK-NOBMI-NEXT:    andl $-252645135, %eax # imm = 0xF0F0F0F1
; CHECK-NOBMI-NEXT:    orl %edi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: n0_badconstmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %esi, %eax
; CHECK-BMI-NEXT:    andl $252645135, %edi # imm = 0xF0F0F0F
; CHECK-BMI-NEXT:    andl $-252645135, %eax # imm = 0xF0F0F0F1
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    retq
  %mx = and i32 %x, 252645135
  %my = and i32 %y, -252645135 ; instead of -252645136
  %r = or i32 %mx, %my
  ret i32 %r
}

define i32 @n1_thirdvar_constmask(i32 %x, i32 %y, i32 %z) {
; CHECK-NOBMI-LABEL: n1_thirdvar_constmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-NOBMI-NEXT:    xorl %edx, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: n1_thirdvar_constmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %edi, %eax
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    andl $252645135, %eax # imm = 0xF0F0F0F
; CHECK-BMI-NEXT:    xorl %edx, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, 252645135
  %r = xor i32 %n1, %z ; instead of %y
  ret i32 %r
}
