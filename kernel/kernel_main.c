#include "include/kernel.h"

void kernel_main(){
    _current_color = _vga_color(VGA_LIGHT_GREY, VGA_BLACK);
    _screen_clear();
    _screen_puts("42");
    _screen_putchar('\n');
    
}