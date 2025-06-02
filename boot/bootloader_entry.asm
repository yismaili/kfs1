
.set MAGIC,    0x1BADB002          
.set FLAGS,    0x00000003         
.set CHECKSUM, -(MAGIC + FLAGS) 

.section .multiboot
    .align 4
    .long MAGIC
    .long FLAGS
    .long CHECKSUM

.section .bss
    .align 16
stack_bottom:
    .skip 16384
stack_top:

.section .text
.global _start
.extern kernel_main

_start:
    mov $stack_top, %esp
    
    pushl $0
    popf
    
    call kernel_main
    
    cli
1:  hlt
    jmp 1b

.size _start, . - _start