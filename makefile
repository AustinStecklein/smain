.DELETE_ON_ERROR:
CC = gcc
CC_FLAGS = -Wall -MMD -MP
LD_FLAGS = -lm
DEBUG = -ggdb3
ASM = nasm
ASM_FLAGS = -felf64 -g
LD = ld

BUILD_DIR := build

SRCS := $(shell find . -name '*.c' -or -name '*.s')
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)
TERM_CALC_DEPS := $(BUILD_DIR)/term_calc.o
CTEST_DEPS := $(BUILD_DIR)/basic.o
CTEST_DEPS += $(BUILD_DIR)/main.o
CTEST_DEPS += $(BUILD_DIR)/arena.o

# build allocator for valgrind testing
ctest_mem: DEBUG += -DVALGRIND

# executables definitions
term_calc: $(TERM_CALC_DEPS)
	$(LD) $(TERM_CALC_DEPS) -o $(BUILD_DIR)/$@

ctest: $(CTEST_DEPS)
	$(CC) $(LD_FLAGS) $(CTEST_DEPS) -o $(BUILD_DIR)/$@

ctest_mem: $(CTEST_DEPS)
	$(CC) $(LD_FLAGS) $(CTEST_DEPS) -o $(BUILD_DIR)/$@
	valgrind --leak-check=full $(BUILD_DIR)/$@

# file specific build definitions
# imported from cmain
build/arena.o: ../cmain/arena.h ../cmain/arena.c
	$(CC) $(CC_FLAGS) $(DEBUG) -c ../cmain/arena.c -o build/arena.o

# written in gcc format not nasm format
build/basic.o: basic.s
	$(CC) $(DEBUG) -c basic.s -o build/basic.o

# Build step for general asm sources
$(BUILD_DIR)/%.o: %.s
	$(ASM) $(ASM_FLAGS) $< -o $@

# Build step for general C sources
$(BUILD_DIR)/%.o: %.c
	$(CC) $(CC_FLAGS) $(DEBUG) -c $< -o $@


.PHONY: clean
clean:
	-rm ./build/*

-include $(DEPS)
