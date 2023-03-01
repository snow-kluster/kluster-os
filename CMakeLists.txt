cmake_minimum_required(VERSION 3.15)

set(CMAKE_C_COMPILER "gcc")
set(CMAKE_CXX_COMPILER "g++")

project(kluster-os VERSION 1.0 LANGUAGES C ASM CXX)

include_directories( include )

# Compile bootloader.asm to build/bootloader.bin
add_custom_command(
	OUTPUT build/bootloader.bin
	COMMAND nasm -f bin ${CMAKE_SOURCE_DIR}/src/bootloader.asm -o ${CMAKE_BINARY_DIR}/build/bootloader.bin
	DEPENDS src/bootloader.asm
)

# Run QEMU to load boot.bin from build/boot.bin
add_custom_target(bootloader.bin
	COMMAND qemu-system-x86_64 -drive file=${CMAKE_BINARY_DIR}/build/bootloader.bin,format=raw
	DEPENDS build/bootloader.bin
)

# Define an "all" target that depends on boot.bin
# add_custom_target(all DEPENDS boot.bin)
