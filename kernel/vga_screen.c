#include "include/kernel.h"

void _screen_puts(char *str){
    int i = 0;
    while (str[i] != NULL)
    {
        _screen_putchar(str[i]);
        i++;
    }
}

void _screen_putchar(char c){
    if (c == '\n'){
        _cursor_x = 0;
        _cursor_y++;
    }
    else if (c == '\r'){
        _cursor_x = 0;
    }else if (c == '\t'){
        _cursor_x = (_cursor_x + 8) & ~(8 - 1);
    }else if (c == '\b' && _cursor_x > 0){
        _cursor_x--;
    }
    else{
        const uint32_t index = _cursor_y * VGA_WIDTH + _cursor_x;
        
        _vga_buffer[index].character = c;
        _vga_buffer[index].attribute = _current_color;
        _cursor_x++;
    }

    if (_cursor_x >= VGA_WIDTH) {
        _cursor_x = 0;
        _cursor_y++;
    }
    _screen_update();
}

void _screen_update(){
    unsigned int position = _cursor_y * VGA_WIDTH + _cursor_x;

     __asm__ volatile (
        "outb %1, %0\n\t"
        "outb %2, %0"
        :
        : "dN" (0x3D4), "a" (0x0F), "a" ((uint8_t)(position & 0xFF))
    );
    
    __asm__ volatile (
        "outb %1, %0\n\t"
        "outb %2, %0"
        :
        : "dN" (0x3D5), "a" (0x0E), "a" ((uint8_t)((position >> 8) & 0xFF))
    );
}