ENTRY(_start) /*first instruction to execute*/

SECTIONS
{
    . = 0x100000;  /* starting memory address */
    
    .multiboot ALIGN(4K) : {  /* header must be early in the file */
        *(.multiboot)
    }
    
    .text ALIGN(4K) : {  /* read-only code and data */
        *(.text)
    }
    
    .rodata ALIGN(4K) : {   /* read-only data */
        *(.rodata)
    }
    
    .data ALIGN(4K) : {   /* init data  */
        *(.data)
    }
    
    .bss ALIGN(4K) : {    /* Uninit data and stack */
        *(COMMON)
        *(.bss)
    }
    
    _kernel_end = .; /* Define end of kernel for future use */
}