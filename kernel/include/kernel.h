#ifndef KERNEL_H
#define KERNEL_H

#include "types.h"

#define VGA_MEMORY 0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_SIZE (VGA_WIDTH * VGA_HEIGHT)

typedef struct vga_entry{
    char character;
    char attribute;
};

static unsigned int _cursor_x = 0;
static unsigned int _cursor_y = 0;
static char _current_color = 0x07;
static vga_entry_t* _vga_buffer = (vga_entry_t*)VGA_MEMORY;

void _screen_putchar(char c);
void _screen_puts(const char* str);
void _screen_update();

#endif