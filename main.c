#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

extern uint64_t add_values64(const uint64_t a, const uint64_t b);
extern int add_values32(const int a, const int b);
extern int *two_sum_n2(int *nums, int numsSize, int target, int *returnSize);

int *two_sum_n2_c(int *nums, int numsSize, int target, int *returnSize) {
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
/*
 * This is what gcc 14.2.1 20240910 generated for the function above.
 * what... this is so over built. I have 15 instructions less then this
 * and I was using a cheat sheet to write it. Now the c function took
 * me no time at all compared to the assembly but still.
 *   1179:       55                      push   rbp
 *   117a:       48 89 e5                mov    rbp,rsp
 *   117d:       48 83 ec 40             sub    rsp,0x40
 *   1181:       48 89 7d d8             mov    QWORD PTR [rbp-0x28],rdi
 *   1185:       89 75 d4                mov    DWORD PTR [rbp-0x2c],esi
 *   1188:       89 55 d0                mov    DWORD PTR [rbp-0x30],edx
 *   118b:       48 89 4d c8             mov    QWORD PTR [rbp-0x38],rcx
 *   118f:       48 8b 45 c8             mov    rax,QWORD PTR [rbp-0x38]
 *   1193:       c7 00 00 00 00 00       mov    DWORD PTR [rax],0x0
 *   1199:       c7 45 ec 00 00 00 00    mov    DWORD PTR [rbp-0x14],0x0
 *   11a0:       e9 88 00 00 00          jmp    122d <two_sum_n2_c+0xb4>
 *   11a5:       8b 45 ec                mov    eax,DWORD PTR [rbp-0x14]
 *   11a8:       83 c0 01                add    eax,0x1
 *   11ab:       89 45 f0                mov    DWORD PTR [rbp-0x10],eax
 *   11ae:       eb 71                   jmp    1221 <two_sum_n2_c+0xa8>
 *   11b0:       8b 45 ec                mov    eax,DWORD PTR [rbp-0x14]
 *   11b3:       48 98                   cdqe
 *   11b5:       48 8d 14 85 00 00 00    lea    rdx,[rax*4+0x0]
 *   11bc:       00
 *   11bd:       48 8b 45 d8             mov    rax,QWORD PTR [rbp-0x28]
 *   11c1:       48 01 d0                add    rax,rdx
 *   11c4:       8b 10                   mov    edx,DWORD PTR [rax]
 *   11c6:       8b 45 f0                mov    eax,DWORD PTR [rbp-0x10]
 *   11c9:       48 98                   cdqe
 *   11cb:       48 8d 0c 85 00 00 00    lea    rcx,[rax*4+0x0]
 *   11d2:       00
 *   11d3:       48 8b 45 d8             mov    rax,QWORD PTR [rbp-0x28]
 *   11d7:       48 01 c8                add    rax,rcx
 *   11da:       8b 00                   mov    eax,DWORD PTR [rax]
 *   11dc:       01 d0                   add    eax,edx
 *   11de:       89 45 f4                mov    DWORD PTR [rbp-0xc],eax
 *   11e1:       8b 45 f4                mov    eax,DWORD PTR [rbp-0xc]
 *   11e4:       3b 45 d0                cmp    eax,DWORD PTR [rbp-0x30]
 *   11e7:       75 34                   jne    121d <two_sum_n2_c+0xa4>
 *   11e9:       48 8b 45 c8             mov    rax,QWORD PTR [rbp-0x38]
 *   11ed:       c7 00 02 00 00 00       mov    DWORD PTR [rax],0x2
 *   11f3:       bf 04 00 00 00          mov    edi,0x4
 *   11f8:       e8 73 fe ff ff          call   1070 <malloc@plt>
 *   11fd:       48 89 45 f8             mov    QWORD PTR [rbp-0x8],rax
 *   1201:       48 8b 45 f8             mov    rax,QWORD PTR [rbp-0x8]
 *   1205:       8b 55 ec                mov    edx,DWORD PTR [rbp-0x14]
 *   1208:       89 10                   mov    DWORD PTR [rax],edx
 *   120a:       48 8b 45 f8             mov    rax,QWORD PTR [rbp-0x8]
 *   120e:       48 8d 50 04             lea    rdx,[rax+0x4]
 *   1212:       8b 45 f0                mov    eax,DWORD PTR [rbp-0x10]
 *   1215:       89 02                   mov    DWORD PTR [rdx],eax
 *   1217:       48 8b 45 f8             mov    rax,QWORD PTR [rbp-0x8]
 *   121b:       eb 21                   jmp    123e <two_sum_n2_c+0xc5>
 *   121d:       83 45 f0 01             add    DWORD PTR [rbp-0x10],0x1
 *   1221:       8b 45 f0                mov    eax,DWORD PTR [rbp-0x10]
 *   1224:       3b 45 d4                cmp    eax,DWORD PTR [rbp-0x2c]
 *   1227:       7c 87                   jl     11b0 <two_sum_n2_c+0x37>
 *   1229:       83 45 ec 01             add    DWORD PTR [rbp-0x14],0x1
 *   122d:       8b 45 ec                mov    eax,DWORD PTR [rbp-0x14]
 *   1230:       3b 45 d4                cmp    eax,DWORD PTR [rbp-0x2c]
 *   1233:       0f 8c 6c ff ff ff       jl     11a5 <two_sum_n2_c+0x2c>
 *   1239:       b8 00 00 00 00          mov    eax,0x0
 *   123e:       c9                      leave
 *   123f:       c3                      ret
 */

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

    // c version
    printf("C version of the same function\n");
    int nums_3[4] = {1, 2, 3, 5};
    int numsSize_3 = 4;
    int target_3 = 5;
    int *returnSize_3 = malloc(sizeof(int));
    int *return_nums_3 =
        two_sum_n2_c(nums_3, numsSize_3, target_3, returnSize_3);

    if (return_nums_3 == NULL || *returnSize_3 == 0) {
        printf("two_sum_n2 failed\n");
        return -1;
    }
    printf("the returned indexs are %d,%d and return size %d\n",
           return_nums_3[0], return_nums_3[1], *returnSize_3);
    free(returnSize_3);
    return 0;
}
