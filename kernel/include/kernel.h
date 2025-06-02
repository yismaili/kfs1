#ifndef KERNEL_H
#define KERNEL_H

#include "types.h"

#define VGA_MEMORY 0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_SIZE (VGA_WIDTH * VGA_HEIGHT)

typedef struct __attribute__((packed)) vga_entry {
    char character;
    char attribute;
} vga_entry;

static unsigned int _cursor_x = 0;
static unsigned int _cursor_y = 0;
static char _current_color = 0x07;
static vga_entry* _vga_buffer = (vga_entry*)VGA_MEMORY;

void _screen_putchar(char c);
void _screen_puts(char* str);
void _screen_update();
int8_t _vga_color(uint8_t fg, uint8_t bg);

#endif