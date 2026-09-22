.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)
isPrime:
  cmpl $2, %edi           #set flags for n-2
  jl .is_not_prime        #n < 2 -> not prime
  # if n % 2 == 0 -> return (n == 2)
  movl %edi, %eax         #%eax = n
  cltd                    #prep 64 bit signed division %edx:%eax
  movl $2, %ecx           #%ecx = 2
  idivl %ecx              #edx = n % 2
  testl %edx, %edx        #set flags for n % 2
  jne .is_check_loop      #odd -> jump
  cmpl $2, %edi           #n - 2
  je .is_prime            #n == 2
  jmp .is_not_prime       #n == 1
.is_check_loop:
  movl $3, %r10d          #%r10d (i) = 3
.is_loop:
  movl %r10d, %eax        #%eax = i
  imull %r10d, %eax       #%eax = i * i
  cmpl %edi, %eax         #set flags for i*i - n
  jg .is_prime            #if i*i > n -> done, prime
  movl %edi, %eax         #%eax = n
  cltd                    #prep for 64 bit signed division
  idivl %r10d             #%edx = n % i
  testl %edx, %edx        #set flags for n % i
  je .is_not_prime        #if (n % i == 0) -> not prime
  addl $2, %r10d          #%r10d (i) += 2
  jmp .is_loop            #continue loop
.is_prime:
  movl $1, %eax           #%eax = 1
  retq
.is_not_prime:
  xorl %eax, %eax         #%eax = 0
  retq


# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
