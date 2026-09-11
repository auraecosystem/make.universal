#include <stdint.h>
#include "crc32_table.h"

uint32_t crc32(const void *data, size_t length)
{
    const uint8_t *p = data;
    uint32_t crc = UINT32_C(0xFFFFFFFF);

    while (length--) {
        crc = crc32_table[(crc ^ *p++) & UINT32_C(0xFF)]
            ^ (crc >> 8);
    }

    return crc ^ UINT32_C(0xFFFFFFFF);
}
