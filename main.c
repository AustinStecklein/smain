#include <stdint.h>
#include <stdio.h>

extern uint64_t add_values64(const uint64_t a, const uint64_t b);
extern int add_values32(const int a, const int b);

int main() {
    // Test assembly here by calling the function and printing the results
    printf("Welcome to the shit show. Lets test some assembly.\n");
    printf("printing from assembly!");
    int first_value = add_values32(5, 10); 
    printf("Lets try 32 bit add 5+10 %d\n",
         first_value);
    uint64_t second_value = add_values64(205, 10);
    printf("Lets try 64 bit add 205+10 %ld\n",
         (long)second_value);

    return 0;
}
