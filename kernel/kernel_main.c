#include "include/kernel.h"

void kernel_main(){
    _current_color = _vga_color(VGA_LIGHT_GREY, VGA_BLUE);
    _screen_clear();
    _screen_puts("42");
    _screen_putchar('\n');

    int i = 0;
    while (i < 30){
        _screen_puts("stuntman stuntman ...");
        
        char num_str[4];
        num_str[0] = '0' + (i / 10);
        num_str[1] = '0' + (i % 10);
        num_str[2] = '\0';

        _screen_puts(num_str);
        _screen_putchar('\n');
        i++;
    }

    while (1){
        __asm__ volatile ("hlt");
    }
    
}