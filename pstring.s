  #311400485 Roy Leibovitz

.section .rodata

invalid1: .string "invalid input!\n"

.section .text

.global pstrlen
.type pstrlen, @function

# check the length of a string

pstrlen:

# using the registers rdi, which already has the pointer to
# byte of str which stores the length of them

    pushq %rbp
    movq %rsp, %rbp

    movb (%rdi), %al

    movq %rbp, %rsp
    popq %rbp
    ret

.global replaceChar
.type replaceChar, @function

# replace old char saved in %rsi with new char saved in %rdx.
# rdi = pointer to the pstring

replaceChar:

    pushq %rbp
    movq %rsp, %rbp

    xorq %r9, %r9

# for loop that runs through all the chars int the string,
# checks if a char equal to old char and replace them

    .Loop:
        incq %r9
        cmpb (%rdi), %r9b           # if pstr.length >= i, continue
        jg .Finish
        leaq (%r9, %rdi), %r11
        cmpb (%r11), %sil           # check if pstr[i] = old char
        jne .Loop                   # if not equal, no change
        movb %dl, (%r11)            # pstr[i] = new char
        jmp .Loop

    .Finish:

        movq %rdi, %rax             # return str after change
        movq %rbp, %rsp
        popq %rbp
        ret

.global pstrijcpy
.type pstrijcpy, @function

# copies a range recived by input from str2 into the same range into str1
# rdi = pointer to str1, rsi = pointer to str2,
# rdx = i, rcx = j

pstrijcpy:

    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rax

# checks if the indexes are valid (above 0 and not if in boundries of the string)
# if not valid, jump to the valid label

    cmpb %dl, %cl
    jl .Invalid              # if i>j invalid input
    cmpq $0, %rdx
    jl .Invalid              # if i<0 invalid input
    cmpb %cl, (%rax)
    jle .Invalid             # if j>=str1.length invalid input
    cmpb %cl, (%rsi)
    jle .Invalid             # if if j>=str2.length invalid input

    incq %rcx                # j++

# for loop run through the range of indexes required and copy every char
# from str2 into str1
# %r11 = str1[i], %r12 = str2[i]

    .Loop1:                  # for loop

        incq %rdx            # i++
        cmpb %dl, %cl        # if j<i loop is finish
        jl .Done
        leaq (%rdx, %rsi), %r11     # r11 = pointer to str1[i]
        leaq (%rdx, %rax), %r12     # r12 = pointer to str2[i]
        movq (%r11), %r8            # r8 = str2[i]
        movb %r8b, (%r12)           # str1[i] = str2[i]
        jmp .Loop1                  # continue looping

    .Invalid:

        movq %rdi, %rbx
        movq $invalid1, %rdi         # print invalid
        xorq %rax, %rax
        call printf                 # print invalid input
        movq %rbx, %rax

    .Done:

        movq %rbp, %rsp
        popq %rbp
        ret

.global swapCase
.type swapCase, @function

# function which switch big letter in small letter and small letter to big
# letter.
# rdi = pointer to string

swapCase:

    pushq %rbp
    movq %rsp, %rbp

    movq %rdi, %rax
    movq $1, %rcx
    movq $0, %r10

# the loop checks the range of a specific char, check it's range:
# if it between 65-90: add 32
# if it between 65-90: sub 32
# and run through all string.

    .Loop2:

      leaq (%rcx, %rax), %r11
      cmpb $65, (%r11)
      jl .endOfLoop               # if 65>r11[rcx] no  change
      cmpb $90, (%r11)
      jg .SmallLetters            # if 90<r11[rcx] check if it small letter
      movq %r11, %r10             # else, r10 = r11[rcx]
      addq $32, (%r10)            # make 10 a small letter (ASCII)
      movq %r10, %r11             # r11[rcx] = r10
      jmp .endOfLoop

    .SmallLetters:
      cmpb $97, (%r11)
      jl .endOfLoop               #  if 97>r1[rcx] no  change
      cmpb $122, (%r11)
      jg .endOfLoop               # if 122<r1[rcx] no change
      movq %r11, %r10             # else, r10 = r1[rcx]
      subq $32, (%r10)            # make r10 a big letter (ASCII)
      movq %r10, %r11             # r1[rcx] = r10

    .endOfLoop:

      incq %rcx
      xorq %r10, %r10
      cmpb %cl, (%rax)            # check if i<str.length run throw all string
      jge .Loop2

      movq %rbp, %rsp
      popq %rbp
      ret

.global pstrijcmp
.type pstrijcmp, @function

# the function run through a range that recived in input in both strings,
# sums up all ASCII values of chars and check which sum is greater.
# rdi = pointer to str1, rsi = pointer to str2,
# rdx = i, rcx = j

pstrijcmp:

    pushq %rbp
    movq %rsp, %rbp

# checks if the indexes are valid (above 0 and not if in boundries of the string)
# if not valid, jump to the valid label and return -2

    cmpb %dl, %cl
    jl .Invalid2          # if i>j invalid input
    cmpq $0, %rdx
    jl .Invalid2          # if i<0 invalid input
    cmpb %cl, (%rdi)
    jle .Invalid2         # if j>=str1.length invalid input
    cmpb %cl, (%rsi)
    jle .Invalid2         # if j>=str2.length invalid input

    incq %rcx
    movq $0, %r8
    movq $0, %r9
    xorq %rax, %rax

  # for loop run through the range of indexes required and sum every char
  # of every string into it's sum register.
  # %r8 = sum string 1, %r9 = sum string 2

    .Loop3:

      incq %rdx                  # i++
      cmpb %dl, %cl              # if i>j, move to the end of the loop
      jl .EndOfLoop
      leaq (%rdx, %rdi), %r10    # r10 = pointer to rdi[rdx]
      movb (%r10), %r10b         # insert rdi[rdx] into r10b
      movzbq %r10b, %r10         # complete r10 with zeroes
      addq %r10, %r8             # r8 += %r10
      leaq (%rdx, %rsi), %r11    # r11 = pointer to rsi[rdx]
      movb (%r11), %r11b         # insert rsi[rdx] into r11b
      movzbq %r11b, %r11         # complete r11 with zeroes
      addq %r11, %r9             # r9 += %r11
      jmp .Loop3

# check which sum is greater and change rax (return register) to the values
# specified in the EX3 pdf.

    .EndOfLoop:

      cmpq %r8, %r9
      jl .Sum1Greater           # if sum1>sum2

      cmpq %r8, %r9             # if sum1<sum2
      jg .Sum2Greater

      cmpq %r8, %r9             # if sum1=sum2
      je .End                   # return 0

    .Sum1Greater:
      movq $1, %rax             # if sum1>sum2 return 1
      jmp .End

    .Sum2Greater:               # if sum1<sum2 return -1
      movq $-1, %rax
      jmp .End

    .Invalid2:                  # if i/j illigal rax=-2

      movq $invalid1, %rdi       # print invalid
      xorq %rax, %rax
      call printf
      movq $-2, %rax             # return -2

    .End:

      movq %rbp, %rsp
      popq %rbp
      ret
