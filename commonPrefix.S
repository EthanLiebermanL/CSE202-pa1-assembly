.global commonPrefix
# a in %rdi, b in %rsi; result (prefix length) in %eax
commonPrefix:
  xorl %eax, %eax       #%eax = 0
.loop:
  cmpb $0, (%rdi)
  je .done              #if a == null return
  movb (%rdi), %dl      #%dl = *a
  cmpb %dl, (%rsi)
  jne .done             #if *a != *b return
  incl %eax             #%eax (total) += 1
  incq %rdi             #%rdi (a) += 1 //move pointer to next element
  incq %rsi             #%rsi (b) += 1 //move pointer to next element
  jmp .loop             #continue loop
.done:
  ret


# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }
