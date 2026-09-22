.global binsearch
# arr in %rdi, n in %esi, target in %edx
binsearch:
  xorl %r8d, %r8d            #%r8d (lo) = 0
  movl %esi, %r9d            #%r9d (hi) = n
  decl %r9d                  #%r9d (hi) = n - 1
.loop:
  cmpl %r9d, %r8d
  jg .not_found              #if lo > hi break
  movl %r9d, %r10d           #%r10d (mid) = hi
  subl %r8d, %r10d           #%r10d (mid) = hi - lo
  sarl $1, %r10d             #%r10d (mid) = (hi - lo) / 2
  addl %r8d, %r10d           #%r10d (mid) = lo + (hi - lo) / 2
  movl (%rdi,%r10,4), %eax   #%eax = arr[mid]
  cmpl %edx, %eax            #compare arr[mid] and target
  je .found                  #arr[mid] == target done
  jl .search_right           #if arr[mid] < target search right
  leal -1(%r10), %r9d        #%r9d (hi) = mid - 1 //search left
  jmp .loop
.search_right:
  leal 1(%r10), %r8d         #%r8d (lo) = mid + 1 //search right
  jmp .loop
.found:
  movl %r10d, %eax           #%eax = mid
  ret
.not_found:
  movl $-1, %eax             #%eax = -1
  ret


# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
