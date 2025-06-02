
.set MAGIC,    0x1BADB002     // multiboot header     
.set FLAGS,    0x00000003         
.set CHECKSUM, -(MAGIC + FLAGS) 

.section .multiboot // multiboot header section
    .align 4
    .long MAGIC
    .long FLAGS
    .long CHECKSUM

.section .bss //reserve stack space
    .align 16
stack_bottom:
    .skip 16384
stack_top:

.section .text // code section start
.global _start
.extern kernel_main

_start:
    mov $stack_top, %esp // setup the stack
    
    pushl $0 // clean old flags
    popf
    
    call kernel_main
    
    cli // loop 
1:  hlt
    jmp 1b

.size _start, . - _start