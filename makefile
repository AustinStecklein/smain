CC = gcc
CC_FLAGS = -Wall
LD_FLAGS = -lm
DEBUG = -ggdb3

clean:
	rm ./build/*

arena.o: ../cmain/arena.h ../cmain/arena.c
	$(CC) $(CC_FLAGS) -c ../cmain/arena.c -o ./build/arena.o

main.o:  main.c
	$(CC) $(CC_FLAGS) $(DEBUG) -c main.c -o ./build/main.o

basic.o: basic.s
	$(CC) $(DEBUG) -c basic.s -o ./build/basic.o

ctest: basic.o main.o arena.o
	$(CC) $(LD_FLAGS) $(DEBUG) ./build/main.o ./build/basic.o ./build/arena.o -o ./build/ctest
