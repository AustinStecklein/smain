CC = gcc
CC_FLAGS = -Wall
LD_FLAGS = -lm
DEBUG = -ggdb3

ASM = nasm
ASM_FLAGS = -felf64
ASM_DEGUG = -g

LD = ld

clean:
	rm ./build/*

./build/arena.o: ../cmain/arena.h ../cmain/arena.c
	$(CC) $(CC_FLAGS) -c ../cmain/arena.c -o ./build/arena.o

./build/main.o:  main.c
	$(CC) $(CC_FLAGS) $(DEBUG) -c main.c -o ./build/main.o

./build/basic.o: basic.s
	$(CC) $(DEBUG) -c basic.s -o ./build/basic.o

./build/term_calc.o: term_calc.s
	$(ASM) $(ASM_FLAGS) $(ASM_DEGUG) term_calc.s -o ./build/term_calc.o

term_calc: ./build/term_calc.o
	$(LD) ./build/term_calc.o -o ./build/term_calc

ctest: ./build/basic.o ./build/main.o ./build/arena.o
	$(CC) $(LD_FLAGS) $(DEBUG) ./build/main.o ./build/basic.o ./build/arena.o -o ./build/ctest


