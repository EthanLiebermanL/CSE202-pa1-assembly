.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
secondMax:
  movw %di, %r8w             #%r8w (first) = v1
  movw %si, %r9w             #%r9w (second) = v2
  cmpw %si, %di
  cmovl %si, %r8w            #if v1 < v2, first = v2
  cmovl %di, %r9w            #if v1 < v2, second = v1
  cmpw %r9w, %dx
  cmovg %dx, %r9w            #if v3 > second, second = v3 (must come first so next one will override it since the next one is the first statement)
  cmpw %r8w, %dx
  cmovg %r8w, %r9w           #if v3 > first, second = first
  cmovg %dx, %r8w            #if v3 > first, first = v3
  cmpw %r9w, %cx
  cmovg %cx, %r9w            #if v4 > second, second = v4
  cmpw %r8w, %cx
  cmovg %r8w, %r9w           #if v4 > first, second = first
  cmovg %cx, %r8w            #if v4 > first, first = v4
  movw %r9w, %ax
  ret
#had to pick between condition moves which evaluate flags more but look cleaner vs jumps, I picked cleaner option

# short secondMax(short v1, short v2, short v3, short v4){
#     short first, second;
#     if(v1 >= v2){ first = v1; second = v2; }
#     else        { first = v2; second = v1; }
#     if(v3 > first)       { second = first; first = v3; }
#     else if(v3 > second) { second = v3; }
#     if(v4 > first)       { second = first; first = v4; }
#     else if(v4 > second) { second = v4; }
#     return second;
# }
