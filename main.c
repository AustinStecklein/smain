#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "../cmain/unittest.h"
#include "../cmain/arena.h"

extern uint64_t addValues64(const uint64_t a, const uint64_t b);
extern int addValues32(const int a, const int b);
extern int *twoSumN2(int *nums, int numsSize, int target, int *returnSize);

int *twoSumN2C(int *nums, int numsSize, int target, int *returnSize) {
    // This is the same function as the two_sum_n2 but in c.
    // This allows me to compare my implementation and gcc's
    (*returnSize) = 0;
    for (int i = 0; i < numsSize; i++) {
        for (int j = i + 1; j < numsSize; j++) {
            int guess = nums[i] + nums[j];
            if (guess == target) {
                (*returnSize) = 2;
                int *indexs = malloc(sizeof(int));
                indexs[0] = i;
                indexs[1] = j;
                return indexs;
            }
        }
    }
    return NULL;
}

void testAddValues(struct Arena *) {
    // super basic assembly just to test that linking is working
    ASSERT_TRUE(addValues32(5, 10), "testing add 32 bit numbers");
    ASSERT_TRUE(addValues64(205, 10), "testing add 64 bit numbers");
}

void testTwoSumn2(struct Arena * arena) {
    int nums[4] = {1, 2, 3, 5};
    int *returnSize1 = mallocArena(&arena, sizeof(int));
    int *returnNums1 = twoSumN2(nums, 4, 5, returnSize1);
    ASSERT_TRUE(*returnSize1 == 2, "Check returned size");
    ASSERT_TRUE(returnNums1[0] == 1, "check first index");
    ASSERT_TRUE(returnNums1[1] == 2, "check second index");

    int nums2[7] = {1, 20, 3, 5, 11, 14, 11};
    int *returnSize2 = mallocArena(&arena, sizeof(int));
    int *returnNums2 = twoSumN2(nums2, 7, 10, returnSize2);
    ASSERT_TRUE(*returnSize2 == 0, "Check returned size");
    // safe to assume that this unit test is not running
    // on a system where 0 is not the null prt
    ASSERT_TRUE(returnNums2 == 0, "check that zero was returned");

    int nums3[6] = {100, 562, 689, 654, 1000, 56};
    int *returnSize3 = mallocArena(&arena, sizeof(int));
    int *returnNums3 = twoSumN2(nums3, 6, 1654, returnSize3);
    ASSERT_TRUE(*returnSize3 == 2, "Check returned size");
    ASSERT_TRUE(returnNums3[0] == 3, "check first index");
    ASSERT_TRUE(returnNums3[1] == 4, "check second index");
}

void testTwoSumC(struct Arena * arena) {
    int nums[4] = {1, 2, 3, 5};
    int *returnSize1 = mallocArena(&arena, sizeof(int));
    int *returnNums1 = twoSumN2C(nums, 4, 5, returnSize1);
    ASSERT_TRUE(*returnSize1 == 2, "Check returned size");
    ASSERT_TRUE(returnNums1[0] == 1, "check first index");
    ASSERT_TRUE(returnNums1[1] == 2, "check second index");

    int nums2[7] = {1, 20, 3, 5, 11, 14, 11};
    int *returnSize2 = mallocArena(&arena, sizeof(int));
    int *returnNums2 = twoSumN2C(nums2, 7, 10, returnSize2);
    ASSERT_TRUE(*returnSize2 == 0, "Check returned size");
    // safe to assume that this unit test is not running
    // on a system where 0 is not the null prt
    ASSERT_TRUE(returnNums2 == 0, "check that zero was returned");

    int nums3[6] = {100, 562, 689, 654, 1000, 56};
    int *returnSize3 = mallocArena(&arena, sizeof(int));
    int *returnNums3 = twoSumN2C(nums3, 6, 1654, returnSize3);
    ASSERT_TRUE(*returnSize3 == 2, "Check returned size");
    ASSERT_TRUE(returnNums3[0] == 3, "check first index");
    ASSERT_TRUE(returnNums3[1] == 4, "check second index");
}

int main() {
    struct Arena *memory = createArena();
    setUp(memory);
    ADD_TEST(testAddValues);
    ADD_TEST(testTwoSumn2);
    ADD_TEST(testTwoSumC);
    return runTest();
}
