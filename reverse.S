.global reverse
# list in %rdi (array of char*), n in %esi
reverse:
    testl %esi, %esi            #test whether n == 0
    je .done                    #if n == 0, return immediately
    movl $0, %eax               #i = 0
    movl %esi, %ecx             #%ecx = n
    shrl $1, %ecx               #%ecx = n / 2
.loop:
    cmpl %ecx, %eax             #compare i to n / 2
    jge .done                   #if i >= n / 2, stop
    movq (%rdi,%rax,8), %r8     #%r8 (temp) = list[i]
    movl %esi, %edx             #%edx = n
    subl %eax, %edx             #%edx = n - i
    decl %edx                   #%edx = n - i - 1
    movl %edx, %r9d             #%r9 = n - i - 1
    movq (%rdi,%r9,8), %r10     #%r10 = list[n - i - 1]
    movq %r10, (%rdi,%rax,8)    #list[i] = list[n - i - 1]
    movq %r8, (%rdi,%r9,8)      #list[n - i - 1] = temp
    incl %eax                   #i++
    jmp .loop                   #continue looping
.done:
    ret

# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
