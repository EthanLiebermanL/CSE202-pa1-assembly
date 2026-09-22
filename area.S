.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    movl %edx, %r8d          #%r8d = c (save before it gets overridden by division later)
    movl %edi, %eax          #%eax = a
    addl %esi, %eax          #%eax = a + b
    addl %r8d, %eax          #%eax = a + b + c
    cltd                     #prep 64 bit division
    movl $2, %r9d            #%r9d = 2
    idivl %r9d               #%eax = (a+b+c) / 2 = p
    movl %eax, %r9d          #%r9d = p
    movl %r9d, %r10d         #%r10d = p
    subl %edi, %r10d         #%r10d = p - a
    movl %r9d, %r11d         #%r11d = p
    subl %esi, %r11d         #%r11d = p - b
    movl %r9d, %ecx          #%ecx = p
    subl %r8d, %ecx          #%ecx = p - c
    movl %r9d, %eax          #%eax = p
    imull %r10d, %eax        #%eax = p * (p-a)
    imull %r11d, %eax        #%eax = p * (p-a) * (p-b)
    imull %ecx, %eax         #%eax = p * (p-a) * (p-b) * (p-c)
    movl %eax, %edi          #%edi = p * (p-a) * (p-b) * (p-c) //(arg for r_sqt)
    call r_sqt               #%eax = r_sqt(p)
    retq

# x in %edi; result in %eax
r_sqt:
    testl %edi, %edi          #set flags for x
    jns .nonneg               #if (x >= 0) skip
    movl $-1, %eax            #%eax = -1
    retq
.nonneg:
    cmpl $2, %edi             #set flags for x - 2
    jge .recurse              #if (x >= 2) recurse else:
    movl %edi, %eax           #%eax = x
    retq                      #return x (x is 0 or 1)
.recurse:
    pushq %rdi                #save x across the recursive call
    sarl $2, %edi             #%edi = x >> 2
    call r_sqt                #%eax = r_sqt(x >> 2)
    popq %rdi                 #restore x into %edi
    sall $1, %eax             #%eax = small_cand = r_sqt(x>>2) << 1
    movl %eax, %ecx           #%ecx = small_cand
    leal 1(%eax), %edx        #%edx = large_cand = small_cand + 1
    movl %edx, %r8d           #%r8d = large_cand (save before mult overrides it)
    imull %edx, %edx          #%edx = large_cand * large_cand
    movl %r8d, %eax           #%eax = large_cand
    cmpl %edi, %edx           #compare large_cand*large_cand to x
    cmovg %ecx, %eax          #if (large_cand*large_cand > x), %eax = small_cand
    retq

# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }