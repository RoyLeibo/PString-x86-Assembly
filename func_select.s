  #311400485 Roy Leibovitz

.section .rodata

.align 8
.Case:
  .quad .L50
  .quad .L51
  .quad .L52
  .quad .L53
  .quad .L54
  .quad .L55

oldChar: .string " %c"
newChar: .string " %c"
firstIndex: .string " %d"
secondIndex: .string " %d"
pstrlenPRINT: .string "first pstring length: %d, second pstring length: %d\n"
replaceCharPRINT: .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
pstrijcpyPRINT: .string "length: %d, string: %s\nlength: %d, string: %s\n"
swapCasePRINT: .string "length: %d, string: %s\nlength: %d, string: %s\n"
pstrijcmpPRINT: .string "compare result: %d\n"
invalid: .string "invalid option!\n"

.section .text
.global run_func
.type run_func, @function

run_func:

  pushq %rbp
  movq %rsp, %rbp

  # protect callee save register that used in functions from main

  pushq %rbx
  pushq %r12
  pushq %r13
  pushq %r14
  pushq %r15

  movq %rsi, %r13     # r13 = pstr1
  movq %rdx, %r14     # r14 = pstr2

  cmpq $50, %rdi
  jl .L55                 # if input less than 50, move to the end
  cmpq $54, %rdi
  jg .L55                 # if input more than 54, move to the end
  subq $50, %rdi          # sub input-50
  jmp *.Case(,%rdi,8)     # jump to the result of the upper line times 4,because each case is in size 4

    .L50: # pstrlen

      movq $0, %rax
      movq %r13, %rdi
      call pstrlen            # call function with rdi = pointer to str1
      movq %rax, %r13         # r13 = str1.length

      movq %r14, %rdi         # call function with rdi = pointer to str2
      call pstrlen
      movq %rax, %r14         # r14 = str2.length

      movq $pstrlenPRINT, %rdi # output
      movq %r13, %rsi          # rsi = str1.length
      movq %r14, %rdx          # rdx = str2.length
      xorq %rax, %rax
      call printf

      jmp .End

   .L51:  # replace char
          # %r12 = old char, %r15 = new char

      movq $oldChar, %rdi           # format for Input
      subq $16, %rsp                # memory for old char
      movq $0, (%rsp)
      movq %rsp, %rsi               # argument for scanf
      xorq %rax, %rax
      call scanf

      movq (%rsp), %r12             # r12 = old char

      movq $newChar, %rdi           # format for Input
      subq $16, %rsp                # memory for old char
      movq $0, (%rsp)
      movq %rsp, %rsi               # argument for scanf
      xorq %rax, %rax
      call scanf

      movq (%rsp), %r15             # r15 = new char

      movq %r15, %rdx               # rdx = new char
      movq %r12, %rsi               # rsi = old char
      movq %r13, %rdi               # rdi = pointer to str1
      xorq %rax, %rax
      call replaceChar

      movq %rax, %r13               # r13 = str1 after replace

      movq %r14, %rdi               # rdi = pointer to str2
      xorq %rax, %rax
      call replaceChar

      movq %rax, %r14               # r14 = str2 after replace

      movq $replaceCharPRINT, %rdi  # format for output
      movq %r12, %rsi               # rsi = old char
      movq %r15, %rdx               # rdx = new char
      leaq 1(%r13), %rcx            # rcx = pointer to str1 string
      leaq 1(%r14), %r8             # r8 = pointer to str2 string
      xorq %rax, %rax
      call printf

      addq $32, %rsp                # move rsp back to the spot it was before
                                    # the function has been called

      jmp .End

   .L52:    # pstrijcpy
            # %r12 = first index, %r15 = second index

      movq $firstIndex, %rdi     # format for Input
      subq $16, %rsp             # memory for old char
      movq $0, (%rsp)
      movq %rsp, %rsi            # argument for scanf
      xorq %rax, %rax
      call scanf
      movq (%rsp), %r12          # move the first index into r12

      movq $secondIndex, %rdi    # format for Input
      subq $16, %rsp             # memory for old char
      movq $0, (%rsp)
      movq %rsp, %rsi            # argument for scanf
      xorq %rax, %rax
      call scanf
      movq (%rsp), %r15          # move the index into r15

      movq %r12, %rdx            # rdx = i
      movq %r15, %rcx            # rcx = j
      movq %r13, %rdi            # rdi = pointer to str1
      movq %r14, %rsi            # rsi = pointer to str2
      xorq %rax, %rax
      call pstrijcpy
      movq %rax, %r13            # str1 after change

      movq $pstrijcpyPRINT, %rdi # format for output
      movb (%r13), %r15b
      movq %r15, %rsi            # move str1.length into function argument
      leaq 1(%r13), %rdx         # move str1 string into function argument
      movb (%r14), %r15b
      movq %r15, %rcx            # move str2.length into function argument
      leaq 1(%r14), %r8          # move str2 string into function argument
      xorq %rax, %rax
      call printf

      addq $32, %rsp                # move rsp back to the spot it was before
                                    # the function has been called

      jmp .End

   .L53:    # swapCase

      movq %r13, %rdi             # rdi = pointer to str1
      call swapCase               # call function with rdi = pointer to str1
      movq %rax, %r13             # save pointer to str1 after chnage

      movq %r14, %rdi             # r14 = pointer to str2
      call swapCase               # call function with rdi = pointer to str2
      movq %rax, %r14             #  save pointer to str2 after chnage

      movq $swapCasePRINT, %rdi   # format for output
      movb (%r13), %r15b
      movq %r15, %rsi             # move str1.length into function argument
      leaq 1(%r13), %rdx          # move str1 string into function argument
      movb (%r14), %cl            # move str2.length into function argument
      leaq 1(%r14), %r8           # move str2 string into function argument
      xorq %rax, %rax
      call printf

      jmp .End

   .L54:    # pstrijcmp
            # %r12 = first index, %r15 = second index

      movq $firstIndex, %rdi      # format for Input
      subq $16, %rsp              # memory for first index
      movq $0, (%rsp)
      movq %rsp, %rsi             # argument for scanf
      xorq %rax, %rax
      call scanf
      movq (%rsp), %r12           # move the first index into r12

      movq $secondIndex, %rdi     # format for Input
      subq $16, %rsp              # memory for second index
      movq $0, (%rsp)
      movq %rsp, %rsi             # argument for scanf
      xorq %rax, %rax
      call scanf
      movq (%rsp), %r15           # move the first index into r15

      movq %r12, %rdx             # rdx = i
      movq %r15, %rcx             # rcx = j
      movq %r13, %rdi             # rdi = pointer to str1
      movq %r14, %rsi             # rsi = pointer to str2
      xorq %rax, %rax
      call pstrijcmp

      movq %rax, %rsi             # compare result
      movq $pstrijcmpPRINT, %rdi  # format for output
      xorq %rax, %rax
      call printf

      addq $32, %rsp                # move rsp back to the spot it was before
                                    # the function has been called

      jmp .End

   .L55:

      movq $invalid, %rdi
      xorq %rax, %rax
      call printf                 # print invalid

.End:

    pop %r15                # pop back all 5 saved callee save registers
    pop %r14                # that were in use
    pop %r13
    pop %r12
    pop %rbx

    movq %rbp, %rsp
    pop %rbp
    ret
