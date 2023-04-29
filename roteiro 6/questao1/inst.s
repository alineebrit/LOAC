.section .text
.globl main
main:
        addi  s0,  zero,  1
        addi  s1,  zero,  0
        addi  t0,  zero,  64
loop:
        beq   s0,  t0,  salto
        slli  s0,  s0,  1
        addi  s1,  s1,  1
        j     loop
salto:  nop