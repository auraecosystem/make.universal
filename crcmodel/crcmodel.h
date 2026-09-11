/*
 * crc_table_gen.c
 *
 * Modern CRC-32 lookup-table generator.
 *
 * Default configuration:
 *   Width : 32 bits
 *   Poly  : 0x04C11DB7
 *   RefIn : true
 *
 * This generates a 256-entry lookup table suitable for
 * reflected CRC-32 implementations.
 *
 * Compatible conceptually with the Rocksoft CRC model,
 * but written using modern portable C.
 */

#include <errno.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DEFAULT_OUTPUT "crctable.h"
#define CRC32_POLY      UINT32_C(0xEDB88320)

/*
 * 0xEDB88320 is the reflected representation of
 * the conventional CRC-32 polynomial:
 *
 *     0x04C11DB7
 *
 * For a reflected implementation, this is the polynomial
 * used directly by the right-shifting algorithm.
 */

/* ------------------------------------------------------------------------- */
/* CRC-32 table generation                                                   */
/* ------------------------------------------------------------------------- */

static uint32_t
crc32_table_entry(uint32_t index)
{
    uint32_t crc = index;

    for (unsigned bit = 0; bit < 8; ++bit) {
        if (crc & UINT32_C(1)) {
            crc = (crc >> 1) ^ CRC32_POLY;
        } else {
            crc >>= 1;
        }
    }

    return crc;
}

static void
generate_table(uint32_t table[256])
{
    for (uint32_t i = 0; i < 256; ++i) {
        table[i] = crc32_table_entry(i);
    }
}

/* ------------------------------------------------------------------------- */
/* Output                                                                    */
/* ------------------------------------------------------------------------- */

static int
write_header(FILE *out, const uint32_t table[256])
{
    if (fprintf(out,
        "/*\n"
        " * Automatically generated CRC-32 lookup table.\n"
        " *\n"
        " * Polynomial : 0x04C11DB7\n"
        " * Reflected  : true\n"
        " * Width      : 32 bits\n"
        " * Entries    : 256\n"
        " *\n"
        " * DO NOT EDIT MANUALLY.\n"
        " */\n\n"
        "#ifndef CRC32_TABLE_H\n"
        "#define CRC32_TABLE_H\n\n"
        "#include <stdint.h>\n\n"
        "static const uint32_t crc32_table[256] = {\n"
    ) < 0) {
        return -1;
    }

    for (unsigned i = 0; i < 256; ++i) {
        if (fprintf(
                out,
                "    UINT32_C(0x%08" PRIX32 ")%s",
                table[i],
                (i == 255) ? "" : ","
            ) < 0) {
            return -1;
        }

        if ((i + 1) % 4 == 0) {
            if (fputc('\n', out) == EOF) {
                return -1;
            }
        } else {
            if (fputc(' ', out) == EOF) {
                return -1;
            }
        }
    }

    if (fprintf(out,
        "\n"
        "};\n\n"
        "#endif /* CRC32_TABLE_H */\n"
    ) < 0) {
        return -1;
    }

    return 0;
}

/* ------------------------------------------------------------------------- */
/* File handling                                                              */
/* ------------------------------------------------------------------------- */

static int
generate_file(const char *filename)
{
    uint32_t table[256];

    generate_table(table);

    FILE *out = fopen(filename, "wb");

    if (out == NULL) {
        fprintf(
            stderr,
            "error: cannot open '%s': %s\n",
            filename,
            strerror(errno)
        );
        return EXIT_FAILURE;
    }

    const int result = write_header(out, table);

    if (fclose(out) != 0) {
        fprintf(
            stderr,
            "error: failed closing '%s': %s\n",
            filename,
            strerror(errno)
        );
        return EXIT_FAILURE;
    }

    if (result != 0) {
        fprintf(
            stderr,
            "error: failed writing '%s'\n",
            filename
        );
        return EXIT_FAILURE;
    }

    printf(
        "CRC-32 lookup table generated successfully.\n"
        "Output: %s\n"
        "Polynomial: 0x04C11DB7\n"
        "Reflected polynomial: 0x%08" PRIX32 "\n"
        "Entries: 256\n",
        filename,
        CRC32_POLY
    );

    return EXIT_SUCCESS;
}

/* ------------------------------------------------------------------------- */
/* Main                                                                      */
/* ------------------------------------------------------------------------- */

int
main(int argc, char **argv)
{
    const char *output = DEFAULT_OUTPUT;

    if (argc > 2) {
        fprintf(
            stderr,
            "usage: %s [output-file]\n",
            argv[0]
        );
        return EXIT_FAILURE;
    }

    if (argc == 2) {
        output = argv[1];
    }

    return generate_file(output);
}
```
