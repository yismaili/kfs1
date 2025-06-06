CC = gcc  # tools
AS = nasm
LD = ld

CFLAGS = -m32 -ffreestanding -fno-builtin -fno-exceptions \
	-fno-stack-protector -nostdlib -nodefaultlibs \
	-Wall -Wextra -Ikernel/include

ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T linker.ld

BOOTDIR = boot
KERNELDIR = kernel
LIBDIR = $(KERNELDIR)/lib
OBJDIR = obj
ISODIR = iso

ASM_SOURCES = $(BOOTDIR)/bootloader_entry.asm # source files
C_SOURCES = $(KERNELDIR)/kernel_main.c $(KERNELDIR)/vga_screen.c

ASM_OBJECTS = $(ASM_SOURCES:$(BOOTDIR)/%.asm=$(OBJDIR)/%.o) # object files
C_OBJECTS = $(C_SOURCES:$(KERNELDIR)/%.c=$(OBJDIR)/kernel_%.o)

ALL_OBJECTS = $(ASM_OBJECTS) $(C_OBJECTS)

KERNEL = kernel.bin  # output
ISO = kernel.iso

.PHONY: all # def target
all: $(KERNEL)

$(KERNEL): $(ALL_OBJECTS) linker.ld # build kernel binary
	@echo "Linking kernel..."
	$(LD) $(LDFLAGS) -o $@ $(ALL_OBJECTS)
	@echo "Kernel built successfully!"

$(OBJDIR)/%.o: $(BOOTDIR)/%.asm | $(OBJDIR) # compile assembly files
	@echo "Assembling $<..."
	$(AS) $(ASFLAGS) $< -o $@

$(OBJDIR)/kernel_%.o: $(KERNELDIR)/%.c | $(OBJDIR) # compile C files
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/lib_%.o: $(LIBDIR)/%.c | $(OBJDIR)
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR): # to create object dir
	mkdir -p $(OBJDIR)

.PHONY: iso #to  create ISO image for testing
iso: $(KERNEL) $(ISODIR)/boot/grub/grub.cfg
	@echo "Creating bootable ISO..."
	cp $(KERNEL) $(ISODIR)/boot/
	grub-mkrescue -o $(ISO) $(ISODIR)
	@echo "ISO created: $(ISO)"

$(ISODIR)/boot/grub/grub.cfg: grub.cfg
	mkdir -p $(ISODIR)/boot/grub
	cp grub.cfg $(ISODIR)/boot/grub/

.PHONY: test # to test with QEMU
test: $(ISO)
	@echo "Starting QEMU (emulation mode)..."
	qemu-system-i386 -cdrom $(ISO) -m 512M

.PHONY: test-kvm # to test with QEMU and KVM
test-kvm: $(ISO)
	@echo "Starting QEMU with KVM acceleration..."
	qemu-system-i386 -cdrom $(ISO) -enable-kvm -m 512M; \

.PHONY: clean
clean:
	@echo "Cleaning..."
	rm -rf $(OBJDIR) $(KERNEL) $(ISO) $(ISODIR)
	@echo "Clean complete."

.PHONY: help # show help
help:
	@echo "KFS_1 Kernel Build System"
	@echo "========================="
	@echo "Build targets:"
	@echo "  all         - Build kernel binary (default)"
	@echo "  iso         - Create bootable ISO image"
	@echo "  clean       - Remove build files"
	@echo ""
	@echo "Testing targets:"
	@echo "  test        - Test with QEMU (pure emulation)"
	@echo "  test-kvm    - Test with QEMU + KVM (hardware acceleration)"
	@echo "  help        - Show this help"
	@echo ""
	
.PHONY: info  # show kernel info
info: $(KERNEL)
	@echo "Kernel Information:"
	@echo "=================="
	@echo "Size: $$(du -h $(KERNEL) | cut -f1)"
	@echo "Type: $$(file $(KERNEL))"
	@echo ""
	@echo "System Information:"
	@echo "=================="
	@echo -n "KVM Support: "
	@if [ -e /dev/kvm ]; then \
		echo "Available ✓"; \
	else \
		echo "Not available ✗"; \
	fi
	@echo -n "CPU Virtualization: "
	@if grep -q -E '(vmx|svm)' /proc/cpuinfo 2>/dev/null; then \
		echo "Supported ✓"; \
	else \
		echo "Not supported or unknown ✗"; \
	fi
	@echo ""
	@objdump -h $(KERNEL)