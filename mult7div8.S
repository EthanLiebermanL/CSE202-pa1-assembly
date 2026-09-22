.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
    movsbl %dil, %eax       #sign-extend %dil to %eax
    imull $7, %eax          #%eax = 7 * a
    movl %eax, %ecx         #%ecx = 7 * a (save result)
    movsbl %dil, %eax       #sign-extend %dil to %eax for comparison
    testl %eax, %eax        #test a
    jg .check_a_pos         #if a > 0, check if mult < 0
    jl .check_a_neg         #if a < 0, check if mult > 0
    jmp .no_overflow        #a == 0, no overflow
.check_a_pos:
    cmpl $0, %ecx           #compare mult to 0
    jl .set_overflow        #if mult < 0 it overflowed
    jmp .no_overflow        #else no overflow
.check_a_neg:
    cmpl $0, %ecx           #compare mult to 0
    jg .set_overflow        #if mult > 0 it overflowed
    jmp .no_overflow        #else no overflow
.set_overflow:
    movb $1, (%rsi)         #*overflow = 1
    jmp .do_divide          #go to divide
.no_overflow:
    movb $0, (%rsi)         #*overflow = 0
.do_divide:
    movl %ecx, %eax         #%eax = mult
    cltd                    #sign-extend %eax -> %edx:%eax
    movl $8, %r10d          #%r10d = 8
    idivl %r10d             #%eax = mult / 8
    retq


# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
