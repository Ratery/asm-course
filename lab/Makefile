CC = gcc
ASM = nasm
CFLAGS = -m32 -Wall -Wextra -std=c11
ASMFLAGS = -f elf32
LDFLAGS = -m32

SRC_DIR = .
BUILD_DIR = build

# Targets
TARGET = integral
TEST_TARGET = tests

# Sources
MAIN_SRC = $(SRC_DIR)/main.c
TESTS_SRC = $(SRC_DIR)/tests.c
ASM_SRC = $(SRC_DIR)/functions.asm

# Object files
MAIN_OBJ = $(BUILD_DIR)/main.o
TESTS_OBJ = $(BUILD_DIR)/tests.o
ASM_OBJ = $(BUILD_DIR)/functions.o
METHODS_OBJ = $(BUILD_DIR)/methods.o

all: $(TARGET)

test: $(TEST_TARGET)
	./$(TEST_TARGET)

# Main
$(TARGET): $(MAIN_OBJ) $(ASM_OBJ) $(METHODS_OBJ)
	$(CC) $(LDFLAGS) -o $@ $^

# Tests
$(TEST_TARGET): $(TESTS_OBJ) $(ASM_OBJ) $(METHODS_OBJ)
	$(CC) $(LDFLAGS) -o $@ $^

# Compiling C-files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# ASM
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm | $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all test clean
