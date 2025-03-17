#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern uint64_t add_values64(const uint64_t a, const uint64_t b);
extern int add_values32(const int a, const int b);
extern int *two_sum_n2(int *nums, int numsSize, int target, int *returnSize);

int main() {
    // Test assembly here by calling the function and printing the results
    printf("Welcome to the shit show. Lets test some assembly.\n");
    printf("printing from assembly!");
    int first_value = add_values32(5, 10);
    printf("Lets try 32 bit add 5+10 %d\n", first_value);
    uint64_t second_value = add_values64(205, 10);
    printf("Lets try 64 bit add 205+10 %ld\n", (long)second_value);

    printf("Lets do something harder... two_sum\n");
    int nums[4] = {1, 2, 3, 5};
    int numsSize = 4;
    int target = 5;
    int *returnSize = malloc(sizeof(int));
    int *return_nums = two_sum_n2(nums, numsSize, target, returnSize);

    if (return_nums == NULL || *returnSize == 0) {
        printf("two_sum_n2 failed\n");
        return -1;
    }
    printf("the returned indexs are %d,%d and return size %d\n", return_nums[0],
           return_nums[1], *returnSize);
    free(returnSize);

    printf("What if there is no answer?\n");
    int nums_2[4] = {1, 2, 3, 5};
    int numsSize_2 = 4;
    int target_2 = 10;
    int *returnSize_2 = malloc(sizeof(int));
    int *return_nums_2 = two_sum_n2(nums_2, numsSize_2, target_2, returnSize_2);
    if (return_nums_2 == NULL) {
        printf("two_sum_n2 failed\n");
        return -1;
    }
    printf("The returned size is %d\n", *returnSize_2);
    free(returnSize_2);

    return 0;
}
