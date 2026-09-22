.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
    movsbl %dil, %eax       #sign-extend %dil to %eax
    imull $7, %eax          #%eax = 7 * a
    movl %eax, %r10d        #save full product
    movsbl %al, %ecx        #%ecx = mult as signed char
    cmpl %ecx, %r10d        #compare full product with truncated value
    jne .set_overflow       #different values mean overflow
    jmp .no_overflow
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
