# Variables
TARGET      = my_app
SRC         = main.c
OBJ_DIR     = obj
BIN_DIR     = bin

# Compiler flags for macOS targets
CC          = clang
CFLAGS      = -Wall -Wextra -O2

# Architectures
ARCH_X86    = x86_64
ARCH_ARM    = arm64

# Output locations
BIN_X86     = $(BIN_DIR)/$(TARGET).x86_64
BIN_ARM     = $(BIN_DIR)/$(TARGET).arm64
BIN_UNI     = $(BIN_DIR)/$(TARGET).universal

# Default target creates the universal binary
all: $(BIN_UNI)

# Rule to build the Universal Binary using lipo
$(BIN_UNI): $(BIN_X86) $(BIN_ARM)
	@mkdir -p $(BIN_DIR)
	lipo -create -output $(BIN_UNI) $(BIN_X86) $(BIN_ARM)
	@echo "Successfully built Universal Binary: $(BIN_UNI)"
	@file $(BIN_UNI)

# Rule to compile Intel slice (x86_64)
$(BIN_X86): $(SRC)
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -target $(ARCH_X86)-apple-macos11.0 $(SRC) -o $(BIN_X86)

# Rule to compile Apple Silicon slice (arm64)
$(BIN_ARM): $(SRC)
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -target $(ARCH_ARM)-apple-macos11.0 $(SRC) -o $(BIN_ARM)

# Clean up build files
clean:
	rm -rf $(BIN_DIR)

.PHONY: all clean
