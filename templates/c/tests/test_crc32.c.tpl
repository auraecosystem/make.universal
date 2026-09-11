#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "crc32.h"

int main(void)
{
    static const char input[] = "123456789";

    const uint32_t expected = UINT32_C(0xCBF43926);
    const uint32_t actual = crc32(input, strlen(input));

    printf("Input:    %s\n", input);
    printf("Expected: %08" PRIX32 "\n", expected);
    printf("Actual:   %08" PRIX32 "\n", actual);

    if (actual != expected) {
        printf("CRC-32 TEST: FAIL\n");
        return 1;
    }

    printf("CRC-32 TEST: PASS\n");

    return 0;
}

One fix: because the test uses PRIX32, add this include:

#include <inttypes.h>

So the complete include section is:

#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

For C++, the equivalent
