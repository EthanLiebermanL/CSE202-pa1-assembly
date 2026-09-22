.global product
# a in %rdi, b in %rsi, c in %rdx, size in %ecx
product:
    testl %ecx, %ecx        #test size
    jne .loop               #if size != 0 continue, else:
    ret
.loop:
    movss (%rdi), %xmm0     #load float a[i] into xmm0, I had to use the internet to help with this since we didnt cover floats in class yet
    mulss (%rsi), %xmm0     #multiply xmm0 by float b[i]
    movss %xmm0, (%rdx)     #store result into c[i]
    addq $4, %rdi           #advance a pointer by 4 bytes
    addq $4, %rsi           #advance b pointer by 4 bytes
    addq $4, %rdx           #advance c pointer by 4 bytes
    decl %ecx               #decrement loop counter (size--)
    jne .loop               #if size != 0, continue loop
    ret

# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
