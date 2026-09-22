.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    testl %esi, %esi         #set flags for b
    je .break                #if (b == 0) return a
    movl %edi, %eax          #%eax = a
    cltd                     #prep 64 bit division
    idivl %esi               #%eax = a / b, %edx = a % b
    movl %esi, %edi          #%edi = b (a = b)
    movl %edx, %esi          #%esi = a % b (b = a % b)
    call gcd                 #invoke gcd with a = b and b = a % b
    retq
.break:
    movl %edi, %eax          #%eax = a
    retq


# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
