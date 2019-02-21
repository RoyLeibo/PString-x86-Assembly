  #311400485 Roy Leibovitz

.section .rodata

length1: .string " %d"
str1: .string " %s"
length2: .string " %d"
str2: .string " %s"
functionSelect: .string " %d"

.text
.global main
.type main, @function

main:

  pushq %rbp
  movq %rsp, %rbp

  # protect callee save register that used in functions from main

  pushq %rbx
  pushq %r12
  pushq %r13
  pushq %r14
  pushq %r15

# reset the register I used

  xorq %r12, %r12
  xorq %r13, %r13
  xorq %r14, %r14
  xorq %rbx, %rbx

  # input for length str1

  movq $length1, %rdi     # format for input
  subq $16, %rsp          # memory for str1.length
  movq $0, (%rsp)
  movq %rsp, %rsi         # argument for scanf
  xorq %rax, %rax
  call scanf

  movq (%rsp), %r12       # r12 = str1.length

  # input for str1 string

  movq $str1, %rdi
  subq %r12, %rsp         # memory for str1 string
  leaq -16(%rsp), %rsp    # this way I assure memory multiplies of 16
  movq $0, (%rsp)
  movq %rsp, %rsi         # argument for scanf
  xorq %rax, %rax
  call scanf

  # insert the length after the string and save apointer to pstring1

  leaq -1(%rsp), %rsp     # move rsp to the end of str1
  movb $0, (%rsp)
  movb %r12b, (%rsp)      # insert str1.length
  movq %rsp, %rbx         # rbx =  pointer to str1

  # input for length str2

  movq $length2, %rdi     # format for input
  subq $16, %rsp          # memory for str1.length
  movq $0, (%rsp)
  movq %rsp, %rsi         # argument for scanf
  xorq %rax, %rax
  call scanf

  movq (%rsp), %r14       # r14 = str2.length

  # input for str2 string

  movq $str1, %rdi
  subq %r14, %rsp         # memory for str1 string
  leaq -16(%rsp), %rsp    # this way I assure memory multiplies of 16
  movq $0, (%rsp)
  movq %rsp, %rsi         # argument for scanf
  xorq %rax, %rax
  call scanf

  # insert the length after the string and save apointer to pstring1

  leaq -1(%rsp), %rsp     # move rsp to the end of str2
  movb $0, (%rsp)
  movb %r14b, (%rsp)      # insert str1.length
  movq %rsp, %r13         # r13 = pointer to str2

  movq $functionSelect, %rdi   # format for input
  subq $16, %rsp               # memory for str2.length
  movq $0, (%rsp)
  movq %rsp, %rsi              # argument for scanf
  xorq %rax, %rax
  call scanf

  movq (%rsp), %rdi       # rdi = function select
  movq %rbx, %rsi         # rsi = pointer to str1
  movq %r13, %rdx         # rdx = pointer to str2

  xorq %rax, %rax
  call run_func

  addq $80, %rsp          # return rsp into the spot in the stuck that it was
  addq %r12, %rsp         # before the main called
  addq %r14, %rsp

  pop %r15                # pop back all 5 saved callee save registers
  pop %r14                # that were in use
  pop %r13
  pop %r12
  pop %rbx

  movq %rbp, %rsp
  pop %rbp
  ret
