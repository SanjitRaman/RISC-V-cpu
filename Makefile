# Makefile
NAME = sign_extend
INCLUDE_DIRS = design/$(NAME)/


# Set the Verilator executable
VERILATOR = verilator

# Set Verilator flags
VERILATOR_FLAGS = -Wall --coverage --cc
VERILATOR_COVERAGE_FLAGS = --annotate logs/annotate --annotate-all --annotate-min 1



# Set source files and include directories
SOURCES = design/$(NAME)/$(NAME).sv

# Set testbench source and testbench executable
TB_SOURCE = testbench/$(NAME)/$(NAME)_tb.cpp
TB_EXECUTABLE = $(NAME)_tb

# Set additional flags for compiling C++ files
CXX_FLAGS = -std=c++11

# Set Google Test library paths
GTEST_LIB_DIR = ../../googletest/build/lib
GTEST_INCLUDE_DIR = ../../googletest/googletest/include

# Set makefile directories
BUILD_DIR = build/$(NAME)
BIN_DIR = bin

# Set makefile targets
TARGET = $(BIN_DIR)/$(NAME)

# Create directories if they don't exist
$(shell mkdir -p $(BUILD_DIR))
$(shell mkdir -p $(BIN_DIR))

# Makefile rules
all: $(TARGET)

$(TARGET): $(TB_SOURCE)
	@echo "Compiling Verilog sources and C++ testbench..."
	$(VERILATOR) $(VERILATOR_FLAGS) \
		$(SOURCES) \
		-y $(INCLUDE_DIRS) \
		-Mdir $(BUILD_DIR) \
		--prefix $(NAME) \
		--exe $(realpath $(TB_SOURCE)) \
		-o $(TB_EXECUTABLE) \
		-LDFLAGS "-L$(GTEST_LIB_DIR) -lgtest -lpthread" \
		-CFLAGS "$(CXX_FLAGS)" \
		-CFLAGS "-I$(GTEST_INCLUDE_DIR)"
	make -C $(BUILD_DIR) -j 8 -f $(NAME).mk
	cp $(BUILD_DIR)/$(TB_EXECUTABLE) $(TARGET)

runtest: all $(TARGET)
	@echo "Running testbench..."
	$(TARGET)

coverage: runtest
	@echo "Generating coverage report..."
	verilator_coverage $(VERILATOR_COVERAGE_FLAGS) -write-info logs/merged.info logs/coverage_$(NAME).dat

genhtml: coverage
	@echo "Generating HTML report..."
	genhtml logs/merged.info --output-directory logs/html

gtest:
	@echo "Installing Google Test..."
	@./scripts/makegtest

clean:
	@echo "Cleaning up..."
	rm -rf $(BUILD_DIR)
	rm -rf $(BIN_DIR)

.PHONY: all clean