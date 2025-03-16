CC = gcc
CC_FLAGS = -Wall
LD_FLAGS = -lm
DEBUG = -ggdb3

clean:
	rm -s *.o
	rm -s ./build/*
	rm -s *.gch

main.o:  main.c
	$(CC) $(CC_FLAGS) -c main.c -o ./build/main.o

basic.o: basic.s
	$(CC) -c basic.s -o ./build/basic.o

ctest: basic.o main.o
	$(CC) $(LD_FLAGS) ./build/main.o ./build/basic.o -o ./build/ctest
